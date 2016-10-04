#!/usr/bin/perl

# pastperfect-index.pl - stuff Past Perfect (Dublin Core) from PAHRC into Solr

# Eric Lease Morgan <emorgan@nd.edu>
# December 13, 2011 - first investigations; based on oai_dc-index.pl
# December 14, 2011 - added many fields; first functional implementation
# December 15, 2011 - added ability to harvest content; call it version 1.0
# January   4, 2012 - batch loaded documents and got huge speed boost
# February  7, 2012 - tweaked metadata mapping
# February  7, 2012 - tweaked metadata mapping
# March    12, 2012 - changed RECORDTYPE, added series and edition to solr doc
# March    14, 2012 - added DEFAULTURL
# April    18, 2012 - began adding call number
# January  18, 2013 - added callnumber as well as callnumber-a fields for indexing and display

# configure
use constant CODE           => 'pah';
use constant INSTITUTION    => 'Philadelphia Archdiocesan Historical Research Center (PAHRC)';
use constant LIBRARY        => 'PAHRC Library';
use constant RECORDTYPE     => 'pp';
use constant REMOTEURL      => 'http://crradrop.library.nd.edu/pah/library.xml';
use constant SOLR           => 'http://localhost:8081/solr/biblio';
use constant URLDESCRIPTION => 'Click here for more information about this item';
use constant DEFAULTURL     => 'http://www.pahrc.net';

# require
use LWP::UserAgent;
use strict;
use WebService::Solr;
use XML::XPath;
require '/opt/vufind/crra/crra-scripts/lib/subroutines.pl';

# initialize
binmode STDOUT, ':utf8';
my $solr   = WebService::Solr->new( SOLR, { autocommit => 1 });
my $prefix = CODE . RECORDTYPE . '_';

# get remote XML
print "Getting remote XML: " . REMOTEURL . "\n";
my $user_agent = LWP::UserAgent->new;
my $response   = $user_agent->request( HTTP::Request->new( GET => REMOTEURL ));
if ( $response->is_error ) { die "Can't GET " . REMOTEURL . ': ' . $response->status_line . " Call Eric.\n"; }

# delete old data
print "Deleting records of type $prefix...\n";
$solr->delete_by_query( "id:$prefix*" );

# process each Dublin Core Record
my $count   = 0;
my @docs    = ();
my $xpath   = XML::XPath->new( xml => $response->content );
my $results = $xpath->find( '//dc-record' );
foreach my $node ( $results->get_nodelist ) {

	# increment
	$count++;

	# catch-all field
	my $all_fields =  $xpath->find( '.', $node );
	   $all_fields =~ s/\s+/ /g;
	   $all_fields =~ s/^\s//g;
	   $all_fields =~ s/\s$//g;

	# identifiers; bogus because we're assuming a particular order
	my $identifiers = $xpath->find( './/identifier', $node );
	my $id = $identifiers->get_node( 1 );
	my $call_number = $id->string_value;
	   $id = $prefix . $id->string_value;
	my $url = DEFAULTURL;
	if ( $identifiers->get_node( 2 ) ) {

		$url = $identifiers->get_node( 2 );
		$url = $url->string_value;

	}

	# other good metadata
	my $title                =  $xpath->find( './title', $node );
	my $title_auth           =  $title;
	my $title_full           =  $title;
	my $title_fullStr        =  $title;
	my $title_full_unstemmed =  $title;
	my $title_short          =  $title;
	my $title_sort           =  $title;
	my $title_sort           =  $title;
	   $title_sort           =~ s/^A //;
	   $title_sort           =~ s/^An //;
	   $title_sort           =~ s/^The //;
	my $format               =  $xpath->find( './format', $node );
	my $edition              =  $xpath->find( './coverage', $node );
	my $series               =  $xpath->find( './relation', $node );
	my $author               =  $xpath->find( './creator', $node );
	my $author_sort          =  $author;
	my $language             =  $xpath->find( './language', $node );
	my $institution          =  INSTITUTION;
	my $library              =  LIBRARY;

	# publisher stuff; bogus, again, because we're assuming a particular order
	my $date            =  $xpath->find( './date', $node );
	my $publishers      = $xpath->find( './/publisher', $node );
	my $publisher_place = $publishers->get_node( 1 );
	if ( $publisher_place ) { $publisher_place = $publisher_place->string_value }
	else { $publisher_place = '' }
	my $publisher       = $publishers->get_node( 2 );
	if ( $publisher ) { $publisher = $publisher->string_value }
	else { $publisher = '' }
	if ( $publisher and $publisher_place ) { $publisher = "$publisher_place: $publisher " }

	# topics (subjects); a bit bogus too
	my @topics = ();
	my $topics = $xpath->find( './/subject', $node );
	if ( $topics ) { foreach ( my $i = 1; $i <= $topics->size; $i++ ) { push @topics, $topics->get_node( $i )->string_value } }

	# everything for display; note topic is not included!
	my $fullrecord =  "<record><id>" . &escape_entities( $id )."</id><recordtype>" . RECORDTYPE . "</recordtype><title>" . &escape_entities( $title ) . "</title><publisher>" . &escape_entities( $publisher ) . "</publisher><publisherStr>" . &escape_entities( $publisher ) . "</publisherStr><series2>" . &escape_entities( $series ) . "</series2><series>" . &escape_entities( $series )."</series><date>" . &escape_entities( $date )."</date><format>" . &escape_entities( $format )."</format><language>" . &escape_entities( $language)."</language><url description='" . URLDESCRIPTION . "'>" . &escape_entities( $url )."</url><institution>" . &escape_entities( $institution )."</institution><library>" . &escape_entities( $library )."</library><author>" . &escape_entities( $author )."</author><author_sort>" . &escape_entities( $author_sort )."</author_sort></record>";

	# echo
	print "         count = $count\n";
	print "            id = $id\n";
	print "   call number = $call_number\n";
	print "           url = $url\n";
	# print "    all fields = $all_fields\n";
	print "         title = $title\n";
	print "    sort title = $title_sort\n";
	print "        author = $author\n";
	print "          date = $date\n";
	print "        format = $format\n";
	print "     publisher = $publisher\n";
	print "  publisherStr = $publisher\n";
	print "        series = $series\n";
	print "       edition = $edition\n";
	print "      language = $language\n";
	foreach my $topic ( @topics ) { print "         topic = $topic\n" }
	# print "   full record = $fullrecord\n";
	print "\n";

	# populate solr fields
	my $solr_id                   = WebService::Solr::Field->new( 'id'                   => "$id" );
	# my $solr_call_number          = WebService::Solr::Field->new( 'callnumber'           => "$call_number" );
	my $solr_call_number_raw      = WebService::Solr::Field->new( 'callnumber-raw'       => "$call_number" );
	my $solr_title                = WebService::Solr::Field->new( 'title'                => "$title" );
	my $solr_title_auth           = WebService::Solr::Field->new( 'title_auth'           => "$title_auth" );
	my $solr_title_full           = WebService::Solr::Field->new( 'title_full'           => "$title_full" );
	my $solr_title_fullStr        = WebService::Solr::Field->new( 'title_fullStr'        => "$title_fullStr" );
	my $solr_title_full_unstemmed = WebService::Solr::Field->new( 'title_full_unstemmed' => "$title_full_unstemmed" );
	my $solr_title_short          = WebService::Solr::Field->new( 'title_short'          => "$title_short" );
	my $solr_title_sort           = WebService::Solr::Field->new( 'title_sort'           => "$title_sort" );
	my $solr_date                 = WebService::Solr::Field->new( 'publishDate'          => "$date" );
	my $solr_edition              = WebService::Solr::Field->new( 'edition'              => "$edition" );
	my $solr_series               = WebService::Solr::Field->new( 'series'               => "$series" );
	my $solr_seriess              = WebService::Solr::Field->new( 'series2'              => "$series" );
	my $solr_format               = WebService::Solr::Field->new( 'format'               => "$format" );
	my $solr_institution          = WebService::Solr::Field->new( 'institution'          => "$institution" );
	my $solr_building             = WebService::Solr::Field->new( 'building'             => "$library" );
	my $solr_fullrecord           = WebService::Solr::Field->new( 'fullrecord'           => "$fullrecord" );
	my $solr_type                 = WebService::Solr::Field->new( 'recordtype'           => RECORDTYPE );
	my $solr_language             = WebService::Solr::Field->new( 'language'             => "$language" );
	my $solr_author               = WebService::Solr::Field->new( 'author'               => "$author" );
	# my $solr_author-letter        = WebService::Solr::Field->new( 'author-letter'        => "$author_sort" );
	my $solr_author_sort          = WebService::Solr::Field->new( 'author_sort'          => "$author_sort" );
	my $solr_publisher            = WebService::Solr::Field->new( 'publisher'            => "$publisher" );
	my $solr_publisherStr         = WebService::Solr::Field->new( 'publisherStr'         => "$publisher" );
	my $solr_all_fields           = WebService::Solr::Field->new( 'allfields'            => "$all_fields" );

	# fill a solr document with simple fields
	my $doc = WebService::Solr::Document->new;
	# $doc->add_fields( $solr_id, $solr_call_number, $solr_call_number_a, $solr_title, $solr_title_auth, $solr_title_full, $solr_title_fullStr, $solr_title_full_unstemmed, $solr_title_short, $solr_title_sort, $solr_date, $solr_format, $solr_institution, $solr_building, $solr_fullrecord, $solr_type, $solr_language, $solr_author, $solr_author_sort, $solr_publisher, $solr_publisherStr, $solr_edition, $solr_series, $solr_seriess, $solr_all_fields );
	$doc->add_fields( $solr_id, $solr_call_number_raw, $solr_title, $solr_title_auth, $solr_title_full, $solr_title_fullStr, $solr_title_full_unstemmed, $solr_title_short, $solr_title_sort, $solr_date, $solr_format, $solr_institution, $solr_building, $solr_fullrecord, $solr_type, $solr_language, $solr_author, $solr_publisher, $solr_publisherStr, $solr_edition, $solr_series, $solr_seriess, $solr_all_fields );

	# add topics
	foreach ( @topics ) { $doc->add_fields(( WebService::Solr::Field->new( topic => $_ )))}

	# add the doc to the list of docs
	push @docs, $doc;

}

# save; our reasone de exitance
print "Adding documents...\n";
$solr->add( \@docs );

# done
exit;
