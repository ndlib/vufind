#!/usr/bin/perl

# rare-marc2bibliography.pl - given a CRRA member code, read MARC file and output simple bibliography

# sample usage: rare-marc2bibliography.pl vil

# Eric Lease Morgan <eric_morgan@infomotions.com>
# April  9, 2016 - first cut; on my way to Nice (France)
# April 11, 2016 - extracted multiple 035 fields and limited to values containing OCoLC (weird!)
# April 12, 2016 - added "bibliography" to output
# May   23, 2016 - added ability to read codes from libraries database
# July   2, 2016 - stuffed data into a hash and configured output 
# July   3, 2016 - only grabbed first OCLC number out of 035$a


# configure
use constant MARC      => '/opt/vufind/crra/data/marc-updated';
use constant LIBRARIES => '/opt/vufind/crra/crra-scripts/etc/libraries.db';
use constant ETC       => '/opt/vufind/crra/data/html/data/rare';

# require
use MARC::Batch;
use strict;
require '/opt/vufind/crra/crra-scripts/lib/subroutines.pl';

# initialize
my $libraries = &read_institutions( LIBRARIES, [ @ARGV ] );
my %db        = ();
my $total     = '';
my $symbols   = '';
binmode( STDOUT, ":utf8" );

# process each library
foreach my $library ( sort keys %$libraries ) {

	# re-initialize
	my $file  = MARC . "/$library.mrc";
	print "MARC file: $file\n";
	
	my $batch = MARC::Batch->new( 'USMARC', $file );
	$batch->strict_off;
	$batch->warnings_off;
	
	# process each record
	while ( my $record = $batch->next ) {
	
		# get standard bibliographic data
		my $key         = $record->field( '001' )->as_string;
		my $title       = $record->title_proper;
		my $author      = $record->author;
		my $edition     = $record->edition;
		my $publication = $record->publication_date;
				
		# check for 035
		if ( $record->field( '035' ) ) { 
	
			# process each 035 field
			foreach my $_035 ( $record->field( '035' ) ) {
		
				# check for subfield a
				if ( $_035->subfield( 'a' ) ) {
				
					# re-initialize
					my $oclc = $_035->subfield( 'a' );
			
					# see if it is an OCLC number
					if ( $oclc =~ /OCoLC/ ) {
	
						# clean and print it
						$oclc =~ s/\D//g;
				
						# debug
						print "          key: $key\n";
						print "        title: $title\n";
						print "       author: $author\n";
						print "      edition: $edition\n";
						print "  publication: $publication\n";
						print "         oclc: $oclc\n";
						print "\n";
					
						# update the database
						$db{ $key } = {
									   'title'       => $title,
									   'author'      => $author,
									   'edition'     => $edition,
									   'publication' => $publication,
									   'oclc'        => $oclc,
									   'total'       => $total,
									   'symbols'     => $symbols
									 };
								 
						# only get the first oclc number
						last;
					   
					}
				
				}
			
			}
		
		}

	}
	
	# save database
	&writeDB( ETC . "/$library.txt", \%db );

}

# done
exit;
