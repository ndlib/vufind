#!/usr/bin/perl

# log-pagecount.pl - calculate the number of hits gotten in a day

# Eric Lease Morgan <emorgan@nd.edu>
# September 16, 2011 - first cut

# Note: the oldest logfile in the archive is dated 2011-04-21


# configure
use constant DSN      => 'dbi:mysql:crra_transactions:mysql.library.nd.edu';
use constant PASSWORD => 'portal';
use constant USERNAME => 'catholic';

# require
use Date::Calc qw( Today Add_Delta_Days );
use DBI;
use strict;

# calculate yesterday
my ( $year, $month, $day ) = Today();
( $year, $month, $day )    = Add_Delta_Days( $year, $month, $day, -1 );
if ( length( $month ) == 1 ) { $month = "0$month" }
if ( length( $day )   == 1 ) { $day   = "0$day" }
my $yesterday = "$year-$month-$day";

# initialize
my $start_date = $ARGV[ 0 ] ? $ARGV[ 0 ] : $yesterday;
my $end_date   = $ARGV[ 1 ] ? $ARGV[ 1 ] : $yesterday;
my $datestamp  = $start_date;
my $done       = 'false';
my $dbh        = DBI->connect( DSN, USERNAME, PASSWORD );
$|             = 1;

do {

	# build the sql
	my $sql = "SELECT COUNT(request) FROM httpd WHERE hosttype <> 'robot' AND ( requesttype = 'record' OR requesttype = 'about' OR requesttype = 'admin' OR requesttype = 'search' ) AND datetime LIKE '$datestamp %'";
	
	# debug
	#print "$sql\n";
	
	# do the work
	print "$datestamp\t" . $dbh->selectrow_array( $sql ) . "\n";

	# parse datestamp
	my ( $year, $month, $day ) = split /-/, $datestamp;
	
	# add a day and rebuild datestamp
	( $year, $month, $day ) = Add_Delta_Days( $year, $month, $day, 1 );
	if ( length( $month ) == 1 ) { $month = "0$month" }
	if ( length( $day )   == 1 ) { $day = "0$day" }
	$datestamp = "$year-$month-$day";

	# check 
	if ( $datestamp gt $end_date ) { $done = 'true' }

} until ( $done eq 'true' );

# done
exit;
