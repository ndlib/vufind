#!/usr/bin/perl

# rare-search.pl - query WorldCat for OCLC numbers and return locations

# Eric Lease Morgan <eric_morgan@infomotions.com>
# April  9, 2016 - first cut; on my way to Nice (France)
# April 12, 2016 - added bibliographics to input as well as output
# July   2, 2016 - used database for I/O


# configure
use constant LOCATION  => 'usa';
use constant MAXIMUM   => '100';
use constant URL       => 'http://www.worldcat.org/webservices/catalog/content/libraries/##OCLC##?location=##LOCATION##&wskey=##WSKEY##&maximumLibraries=##MAXIMUM##';
use constant WSKEY     => 'B5knEV2iLFPICEx252SgkH5olsLecAvvLwBgWByQ51NAbdbwzPH0mSymOpoFjc7KTHuOSsJKNdS3VitD';
use constant LAST      => 0;
use constant LIBRARIES => '/opt/vufind/crra/crra-scripts/etc/libraries.db';
use constant ETC       => '/opt/vufind/crra/data/html/data/rare';

# require
use strict;
use XML::XPath;
use LWP::Simple;
require '/opt/vufind/crra/crra-scripts/lib/subroutines.pl';

# initialize
my $libraries = &read_institutions( LIBRARIES, [ @ARGV ] );
my $location  = LOCATION;
my $maximum   = MAXIMUM;
my $wskey     = WSKEY;
my $index     = 0;

# process each given library
foreach my $library ( sort keys %$libraries ) {

	# re-initialize
	my $file  = ETC . "/$library.txt";
	my $db    = &readDB( $file );
	my $count = keys %$db;
	
	# process each record in the database
	foreach my $key ( sort keys %$db ) {
	
		# get the OCLC number
		my $oclc = $$db{ $key }->{ 'oclc' };
		
		# increment
		$index++;
		
		# echo
		print "     item: $index of $count\n";
		print "      key: $key\n";
		print "     oclc: $oclc\n";
		
		# re-build the query
		my $query =  URL;
		$query    =~ s/##OCLC##/$oclc/e;
		$query    =~ s/##MAXIMUM##/$maximum/e;
		$query    =~ s/##LOCATION##/$location/e;
		$query    =~ s/##WSKEY##/$wskey/e;

		# evaluate
		my $xpath    = XML::XPath->new( xml => &get( $query ) );
		my $holdings = $xpath->find( '/holdings/holding' );
		my $total    = $holdings->size;
				
		# create a list of holding symbols
		my @symbols = ();
		foreach my $symbol ( $xpath->find( '/holdings/holding/institutionIdentifier/value')->get_nodelist ) {
    		
			push @symbols, $xpath->findvalue( '.', $symbol );
		
		}
		
		# build field of symbols
		my $symbols = join( ';', sort( @symbols ) );
		
		# echo
		print "    total: $total\n";
		print "  symbols: $symbols\n";
		print "\n";
		
		# update the database
		$$db{ $key }->{ 'total' }   = $total;
		$$db{ $key }->{ 'symbols' } = $symbols;
		
		# debug; limit output
		if ( LAST )	{
	
			if ( $index >= LAST ) { last }
	
		}
		
	}

	# save
	&writeDB( $file, $db );
					
}

# done
exit;
