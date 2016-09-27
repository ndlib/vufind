#!/usr/bin/perl

# rare-db2htm.pl - create interactive HTML table from saved data

# Eric Lease Morgan <emorgan@nd.edu>
# July 11, 2016 - first cut


# configure
use constant LIBRARIES => '/opt/vufind/crra/crra-scripts/etc/libraries.db';
use constant ETC       => '/opt/vufind/crra/data/html/data/rare';
use constant VUFIND    => 'http://www.catholicresearch.net/vufind/Search/Results?lookfor=id:';
use constant WORLDCAT  => 'http://www.worldcat.org/oclc/';

# require
use strict;
require '/opt/vufind/crra/crra-scripts/lib/subroutines.pl';

# initialize
my $libraries = &read_institutions( LIBRARIES, [ @ARGV ] );
my $vufind    = VUFIND;
my $worldcat  = WORLDCAT;

# process each given library
foreach my $library ( sort keys %$libraries ) {

	# re-initialize
	my $file  = ETC . "/$library.txt";
	my $db    = &readDB( $file );
	my $tbody = '';
	
	# process each record in the database
	foreach my $key ( sort keys %$db ) {

		# parse
		my $title       = $$db{ $key }->{ 'title' };
		my $author      = $$db{ $key }->{ 'author' };
		my $edition     = $$db{ $key }->{ 'edition' };
		my $publication = $$db{ $key }->{ 'publication' };
		my $total       = $$db{ $key }->{ 'total' };
		my $oclc        = $$db{ $key }->{ 'oclc' };

		# build a row
		my $row  = "<td><a href='$vufind$key'>$key</a></td>";
		$row    .= "<td>$title</td>";
		$row    .= "<td>$author</td>";
		$row    .= "<td>$edition</td>";
		$row    .= "<td>$publication</td>";
		$row    .= "<td><a href='$worldcat$oclc'>$oclc</a></td>";
		$row    .= "<td>$total</td>";
		
		# update the table
		$tbody .= "<tr>$row</tr>";

	}

	# finish the table
	$tbody   = "<tbody>$tbody</tbody>";
	
	# build the html
	my $html =  &db2table;
	$html    =~ s/##TITLE##/$library/eg;
	$html    =~ s/##TBODY##/$tbody/;

	# save
	$file = ETC . "/$library.htm";
	open HTM, " > $file " or die "Can't open $file ($!); Call Eric\n";
	print HTM $html;
	close HTM;
	
}

# done
exit;
