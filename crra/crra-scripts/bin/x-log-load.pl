#!/usr/bin/perl

# log-load.pl - parse Apache combined log files and stuff them into a flat database

# Eric Lease Morgan <emorgan@nd.edu>
# January   25, 2011 - first investigations
# May        6, 2011 - added date as command line input
# September 14, 2011 - added classification of requests, etc.; added multiple date processing
# September 16, 2011 - added more robots
# November  20, 2013 - Paths and database names changed - T. Hanstra
# 

# Note: the oldest logfile in the archive is dated 20110421


# configure
use constant ARCHIVE  => '/global/home/catholic/httpd_archive/2013/';
use constant DSN      => 'dbi:mysql:crra_transactions_pprd:dbpprd.library.nd.edu';
use constant ECHO     => 0;
use constant FILENAME => 'catholic_portal_access_log';
use constant GUNZIP   => '/bin/gunzip ';
use constant LOGFILE  => '/tmp/catholic_portal_access_log.';
use constant PASSWORD => 'devlP0rt@l';
use constant TMP      => '/tmp/';
use constant USERNAME => 'catholic';

# require
use Date::Calc qw( Today Add_Delta_Days );
use DBI;
use File::Copy;
use strict;

# calculate yesterday
my ( $year, $month, $day ) = Today();
( $year, $month, $day )    = Add_Delta_Days( $year, $month, $day, -1 );
if ( length( $month ) == 1 ) { $month = "0$month" }
if ( length( $day )   == 1 ) { $day   = "0$day" }
my $yesterday = "$year$month$day";

# initialize
my $start_date = $ARGV[ 0 ] ? $ARGV[ 0 ] : $yesterday;
my $end_date   = $ARGV[ 1 ] ? $ARGV[ 1 ] : $yesterday;
my $datestamp  = $start_date;
my $done       = 'false';
my $dbh        = DBI->connect( DSN, USERNAME, PASSWORD );

do {

	# re-initialize
	my $archive = ARCHIVE . FILENAME . ".$datestamp.gz";
	my $tmp     = TMP     . FILENAME . ".$datestamp.gz";
	my $cmd     = GUNZIP  . $tmp;
	my $logfile = TMP     . FILENAME . ".$datestamp";
	
	# echo
	print "  date stamp: $datestamp\n";
	print "     archive: $archive\n";
	print "         tmp: $tmp\n";
	print "     command: $cmd\n";
	print "     logfile: $logfile\n";
	print "\n";
	
	# copy and uncompress
	copy $archive, $tmp or die "Can't copy $archive to $tmp: $!  Call Eric.\n";
	system $cmd;

	# open the log and process every entry
	open INPUT, ' < ' . $logfile or die "Can't open $logfile: $!  Call Eric.\n";
	while ( <INPUT> ) {
			
		# parse
		my ( $host, $username, $password, $day, $month, $year, $hour, $minute, $second, $timezone, $method, $request, $protocol, $statuscode, $bytessent, $referrer, $useragent ) = /^(\S+) (\S+) (\S+) \[(\S+)\/(\S+)\/(\S+):(\S+):(\S+):(\S+) (\S+)\] \"(\S+) (\S+) (\S+)\" (\S+) (\S+) \"?([^"]*)\"? \"([^"]*)\"/;
		
		# map the month
		if    ( $month eq 'Jan' ) { $month = '01' }
		elsif ( $month eq 'Feb' ) { $month = '02' }
		elsif ( $month eq 'Mar' ) { $month = '03' }
		elsif ( $month eq 'Apr' ) { $month = '04' }
		elsif ( $month eq 'May' ) { $month = '05' }
		elsif ( $month eq 'Jun' ) { $month = '06' }
		elsif ( $month eq 'Jul' ) { $month = '07' }
		elsif ( $month eq 'Aug' ) { $month = '08' }
		elsif ( $month eq 'Sep' ) { $month = '09' }
		elsif ( $month eq 'Oct' ) { $month = '10' }
		elsif ( $month eq 'Nov' ) { $month = '11' }
		elsif ( $month eq 'Dec' ) { $month = '12' }
		else  { 
		
			# error
			print "Unknown value for month: $month. ($_) Call Eric.\n";
			next;
			
		}
		
		# build datetime
		my $datetime = "$year-$month-$day $hour:$minute:$second";
		
		# filter for robots; should employ a database look-up here!
		my $hosttype = '';
		if ( $host =~ /.*\.crawl\.yahoo\.net/                        or 
			 $host =~ /.*\.googlebot\.com/                           or
			 $host =~ /baiduspider-.*\.crawl\.baidu\.com/            or
			 $host =~ /crawl-.*\.cuil\.com/                          or
			 $host =~ /crawl.*\.dotnetdotcom\.org/                   or
			 $host =~ /msnbot-.*\.search\.msn\.com/                  or
			 $host =~ /spider.*\.yandex\.ru/                         or
			 $host =~ /119\.63\.196\..*/                             or
			 $host =~ /180\.76\.5\..*/                               or
			 $host =~ /208-115-111-66-reverse\.wowrack\.com/         or
			 $host =~ /ec2-184-73-41-173\.compute-1\.amazonaws\.com/ or
			 $host =~ /st-19-96-205-91\.2dayhost\.com/               or
			 $host =~ /fa.5.85ae\.static\.theplanet\.com/            or
			 $host =~ /sr324\.2dayhost\.com/                         or
			 $host =~ /212\.113\.37\.105/  ) { $hosttype = 'robot' }
	
		# determine type of request
		my $requesttype = 'unknown';
		if ( $request =~ /\/About.*/ )          { $requesttype = 'about' }
		if ( $request =~ /\/admin.*/ )          { $requesttype = 'admin' }
		if ( $request =~ /\/Search\/AJAX.*/ )   { $requesttype = 'ajax' }
		if ( $request =~ /\/bookcover\.php.*/ ) { $requesttype = 'bookcover' }
		if ( $request =~ /.*\.css/ )            { $requesttype = 'css' }
		if ( $request =~ /.*\.gif/ )            { $requesttype = 'image' }
		if ( $request =~ /.*\.ico/ )            { $requesttype = 'image' }
		if ( $request =~ /.*\.jpg/ )            { $requesttype = 'image' }
		if ( $request =~ /.*\.png/ )            { $requesttype = 'javascript' }
		if ( $request =~ /\/Record\.*/ )        { $requesttype = 'record' }
		if ( $request eq '/' )                  { $requesttype = 'root' }
		if ( $request =~ /.*\?lookfor=.*/ )     { $requesttype = 'search' }
	
		# determine type of search
		my $searchtype = '';
		if ( $requesttype eq 'search' ) {
			
			if    ( $request =~ /.*type=AllFields.*/ )  { $searchtype = 'allfields' }
			elsif ( $request =~ /.*type=Title.*/ )      { $searchtype = 'title' }
			elsif ( $request =~ /.*type=Author.*/ )     { $searchtype = 'author' }
			elsif ( $request =~ /.*type=Subject.*/ )    { $searchtype = 'subject' }
			elsif ( $request =~ /.*type=CallNumber.*/ ) { $searchtype = 'callnumber' }
			elsif ( $request =~ /.*type=ISN.*/ )        { $searchtype = 'isn' }
			elsif ( $request =~ /.*type=tag.*/ )        { $searchtype = 'tag' }
			else                                        { $searchtype = 'unknown' } 
			
		}
		
		# determine record type
		my $recordtype = '';
		if ( $requesttype eq 'record' ) {
		
			if    ( $request =~ /.*marc_.*/ ) { $recordtype = 'marc' }
			elsif ( $request =~ /.*ead_.*/ )  { $recordtype = 'ead' }
			else                              { $recordtype = 'unknown' }
	
		}
	
		# determine whose records are being seen; should employ a database look-up here!
		my $institution = '';
		if ( $requesttype eq 'record' ) {
		
			if    ( $request =~ /\/Record\/bcu.*/ ) { $institution = "Boston College - John M. Kelly Library" }
			elsif ( $request =~ /\/Record\/cua.*/ ) { $institution = "Catholic University of America - University Libraries of CUA" }
			elsif ( $request =~ /\/Record\/dom.*/ ) { $institution = "Dominican University - Rebecca Crown Library" }
			elsif ( $request =~ /\/Record\/gtu.*/ ) { $institution = "Georgetown University - Lauinger Memorial Library" }
			elsif ( $request =~ /\/Record\/luc.*/ ) { $institution = "Loyola University Chicago - Cudahy Library" }
			elsif ( $request =~ /\/Record\/mar.*/ ) { $institution = "Marquette University - Raynor Memorial Libraries" }
			elsif ( $request =~ /\/Record\/shu.*/ ) { $institution = "Seton Hall University - Walsh Library" }
			elsif ( $request =~ /\/Record\/stc.*/ ) { $institution = "St. Catherine University - St. Catherine University Libraries" }
			elsif ( $request =~ /\/Record\/sed.*/ ) { $institution = "St. Edward's University - Scarborough-Phillips Library" }
			elsif ( $request =~ /\/Record\/day.*/ ) { $institution = "University of Dayton - Marian Library" }
			elsif ( $request =~ /\/Record\/und.*/ ) { $institution = "University of Notre Dame - Hesburgh Libraries" }
			elsif ( $request =~ /\/Record\/una.*/ ) { $institution = "University of Notre Dame - University Archives" }
			elsif ( $request =~ /\/Record\/usd.*/ ) { $institution = "University of San Diego - Copley Library" }
			elsif ( $request =~ /\/Record\/tor.*/ ) { $institution = "University of Toronto - John M. Kelly Library" }
			elsif ( $request =~ /\/Record\/vil.*/ ) { $institution = "Villanova University - Falvey Memorial Library" }
			else                                    { $institution = "unknown" }
			
		}
	
		# echo
		if ( ECHO ) {
		
			print "          host: $host\n";
			print "     host type: $hosttype\n";
			print "     user name: $username\n";
			print "      password: $password\n";
			print "     date/time: $datetime\n";
			print "     time zone: $timezone\n";
			print "        method: $method\n";
			print "       request: $request\n";
			print "  request type: $requesttype\n";
			print "   record type: $recordtype\n";
			print "   search type: $searchtype\n";
			print "   institution: $institution\n";
			print "      protocol: $protocol\n";
			print "   status code: $statuscode\n";
			print "     byte sent: $bytessent\n";
			print "      referrer: $referrer\n";
			print "    user agent: $useragent\n";
			print "\n";
			
		}
	
		# update database
		$dbh->do( qq(INSERT INTO `httpd` ( `host`,  `hosttype`,  `username`,  `password`,  `datetime`,  `timezone`,  `method`,  `request`,  `requesttype`,  `searchtype`,   `institution`,  `recordtype`, `protocol`,  `statuscode`,  `bytessent`,  `referrer`,  `useragent`)
										 VALUES ('$host', '$hosttype', '$username', '$password', '$datetime', '$timezone', "$method", "$request", "$requesttype", "$searchtype",  "$institution", "$recordtype", "$protocol", "$statuscode", "$bytessent", "$referrer", "$useragent")) );	
		
	}
	
	# delete the temporary file
	unlink $logfile or die "Can't unlink $logfile: $!  Call Eric.\n";
	
	# parse datestamp
	my $year  = substr( $datestamp, 0, 4 );
	my $month = substr( $datestamp, 4, 2 );
	my $day   = substr( $datestamp, 6, 2 );
	
	# add a day and rebuild datestamp
	( $year, $month, $day ) = Add_Delta_Days( $year, $month, $day, 1 );
	if ( length( $month ) == 1 ) { $month = "0$month" }
	if ( length( $day )   == 1 ) { $day = "0$day" }
	$datestamp = "$year$month$day";
	
	# check 
	if ( $datestamp gt $end_date ) { $done = 'true' }

} until ( $done eq 'true' );

# done
close INPUT;
exit;
