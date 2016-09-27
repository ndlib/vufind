#!/usr/bin/perl

# harvest.pl - save the contents of a URL to a local file

# Eric Lease Morgan <emorgan@nd.edu>
# July     13, 2010 - just a hack
# July     14, 2010 - added Accept header
# July     15, 2010 - added database
# July     16, 2010 - moved subroutine to a library
# August   24, 2010 - added :utf8 as a part of the output process
# April     6, 2011 - migrating to james
# December 20, 2012 - added command line input

# configure
use constant AGENT  => 'MARCGetter';
use constant ACCEPT => 'text/plain, text/html, text/xml';
use constant DB     => '/opt/vufind/crra/crra-scripts/etc/libraries.db';
use constant NEW    => '/opt/vufind/crra/data/marc-incoming/' ;

# require
use strict;
use LWP::UserAgent;
#use Encode qw(encode decode);
require '/opt/vufind/crra/crra-scripts/lib/subroutines.pl';

# initilize
my $libraries = &read_institutions( DB, [ @ARGV ] );
my $ua        = LWP::UserAgent->new( agent => AGENT );
$ua->default_header( 'ACCEPT' => ACCEPT );

# process each library
foreach my $key ( sort keys %$libraries ) {
	
	# sanity check
	my $institution = $$libraries{ $key }->[ 0 ];
	my $library     = $$libraries{ $key }->[ 1 ];
	my $marc        = $$libraries{ $key }->[ 2 ];
	next if ( ! $marc );

	# get the data
	print "Getting $institution ($library)...\n";
	my $response = $ua->get( $marc );
	if ( ! $response->is_success ) { die $response->status_line }
		
	# save it
	# changed file name to .mrc as vufind-2.1 only accepts mrc format.(vufind-2.1)	
	open OUTPUT, " > " . NEW . "$key.mrc" or die "Can't open ", NEW . "$key.mrc: $!\n";
	print OUTPUT $response->content;
	#print OUTPUT encode( 'UTF-8', $response->content );
	close OUTPUT;

}

# done
print "Done.\n";
exit;



