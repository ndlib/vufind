#!/usr/bin/perl

# rare-report.pl - summarize the "rarity" of items in the collection

# Eric Lease Morgan <eric_morgan@infomotions.com>
# July 7, 2016 - first investigations


# configure
use constant LIBRARIES => '/opt/vufind/crra/crra-scripts/etc/libraries.db';
use constant ETC       => '/opt/vufind/crra/data/html/data/rare';
use constant RARE      => 30;

# require
use strict;
require '/opt/vufind/crra/crra-scripts/lib/subroutines.pl';

# initialize
my $libraries = &read_institutions( LIBRARIES, [ @ARGV ] );
my %report    = ();

# process each given library
foreach my $library ( sort keys %$libraries ) {

	# re-initialize
	my $file  = ETC . "/$library.txt";
	
	# sanity check
	next if ( ! -e $file );
	
	# get a dataset
	my $db = &readDB( $file );
	
	# process each record in the dataset
	foreach my $key ( sort keys %$db ) {
	
		# get the total
		my $count = $$db{ $key }->{ 'total' };
		
		# update the counts	
		$report{ $library }->{ $count }++;
		$report{ $library }->{ 'total' }++;
		
		# update rare, if necessary
		if ( $count > 0 and $count <= RARE ) { $report{ $library }->{ 'rare' }++ }

	}
			
}

# output header
print "library\ttotal\trare";
for ( my $i = 0; $i <= 100; $i++ ) { print "\t$i" }
print "\n";

# output summary of each library
foreach my $library ( sort keys %report ) {
	
	# initialize
	my $total = $report{ $library }->{ 'total' };
	my $rare  = $report{ $library }->{ 'rare' };
	
	# calculate percentage of rareness
	my $percentage = int( $rare * 100 / $total );
	
	# output
	print "$library\t$total\t$percentage%";
	for ( my $i = 0; $i <= 100; $i++ ) { print "\t", $report{ $library }->{ $i } }
	print "\n";
	
}


# done
exit;
