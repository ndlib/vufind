#!/shared/perl/5.8.9/bin/perl

# oai_dc-index.pl - stuff OAI_DC records into Solr

# Eric Lease Morgan <emorgan@nd.edu>
# January 11, 2011 - first investigations; based on ead-index.pl
# January 13, 2011 - added creator, description, subject, publisher, and contributor
# August 12, 2011  - tweaked configuration and commented out deletion of records

# configure
use constant INSTITUTION    => 'Duquesne University';
use constant LIBRARY        => 'Gumberg Library';
use constant RECORDTYPE     => 'oaidc';
use constant SOLR           => 'http://localhost:8081/solr/biblio';
use constant URLDESCRIPTION => 'View online';
use constant DIRECTORY      => '/shared/catholic_portal/data/vufind/harvest/DUQ/';

# require
use strict;
use WebService::Solr;
use XML::XPath;

# initialize
my $solr  = WebService::Solr->new( SOLR, { autocommit => 1 });
binmode STDOUT, ':utf8';

# delete old data
$solr->delete_by_query( "id:duqoai*" );

# process each file in the harvested cache
opendir( DIR, DIRECTORY );
while ( my $filename = readdir DIR ) {

	# only want xml files
	next if ( $filename !~ /xml$/ );
	
	# parse
	my $xpath = XML::XPath->new( filename => DIRECTORY . "/$filename" );
	my $id                   =  $xpath->findvalue( '/oai_dc:dc/id' );
	   $id                   =~ s/\///;
	my $all_fields           =  $xpath->findvalue( '//oai_dc:dc' );
	   $all_fields           =~ s/\s+/ /g;
	   $all_fields           =~ s/^\s//g;
	   $all_fields           =~ s/\s$//g;
	my $title                =  $xpath->findvalue( '/oai_dc:dc/dc:title' );
	my $title_auth           =  $title;
	my $title_full           =  $title;
	my $title_fullStr        =  $title;
	my $title_full_unstemmed =  $title;
	my $title_short          =  $title;
	my $title_sort           =  $title;
	   $title_sort           =~ s/^A //;
	   $title_sort           =~ s/^An //;
	   $title_sort           =~ s/^The //;
	my $topic                =  $xpath->findvalue( '/oai_dc:dc/dc:subject' );
	my $description          =  $xpath->findvalue( '/oai_dc:dc/dc:description' );
	my $author               =  $xpath->findvalue( '/oai_dc:dc/dc:creator' );
	my $author_letter        =  $author;
	my $publisher            =  $xpath->findvalue( '/oai_dc:dc/dc:publisher' );
	my $author2              =  $xpath->findvalue( '/oai_dc:dc/dc:contributor' );
	my $date                 =  $xpath->findvalue( '/oai_dc:dc/dc:date' );
	my $type                 =  $xpath->findvalue( '/oai_dc:dc/dc:type' );
	my $format               =  $xpath->findvalue( '/oai_dc:dc/dc:format' );
	my $language             =  $xpath->findvalue( '/oai_dc:dc/dc:language' );
	my $url                  =  $xpath->findvalue( '/oai_dc:dc/dc:identifier' );
	my $institution          =  INSTITUTION;
	my $library              =  LIBRARY;
	my $fullrecord           =  "<record><id>$id</id><recordtype>" . RECORDTYPE . "</recordtype><title>$title</title><topic>$topic</topic><description>$description</description><publisher>$publisher</publisher><author2>$author2</author2><date>$date</date><type>$type</type><format>$format</format><language>$language</language><url description='" . URLDESCRIPTION . "'>$url</url><institution>$institution</institution><library>$library</library><author>$author</author><author_letter>$author_letter</author_letter></record>";
	
	# echo
	print "     filename = $filename\n";
	print "           id = $id\n";
	print "   all fields = $all_fields\n";
	print "        title = $title\n";
	print "   sort title = $title_sort\n";
	print "        topic = $topic\n";
	print "  description = $description\n";
	print "       author = $author\n";
	print "    publisher = $publisher\n";
	print "      author2 = $author2\n";
	print "         date = $date\n";
	print "         type = $type\n";
	print "       format = $format\n";
	print "     language = $language\n";
	print "          url = $url\n";
	print "  full record = $fullrecord\n";
	print "\n";
	
	# populate solr fields
	my $solr_id                   = WebService::Solr::Field->new( 'id'                   => "$id" );
	my $solr_title                = WebService::Solr::Field->new( 'title'                => "$title" );
	my $solr_title_auth           = WebService::Solr::Field->new( 'title_auth'           => "$title_auth" );
	my $solr_title_full           = WebService::Solr::Field->new( 'title_full'           => "$title_full" );
	my $solr_title_fullStr        = WebService::Solr::Field->new( 'title_fullStr'        => "$title_fullStr" );
	my $solr_title_full_unstemmed = WebService::Solr::Field->new( 'title_full_unstemmed' => "$title_full_unstemmed" );
	my $solr_title_short          = WebService::Solr::Field->new( 'title_short'          => "$title_short" );
	my $solr_title_sort           = WebService::Solr::Field->new( 'title_sort'           => "$title_sort" );
	my $solr_date                 = WebService::Solr::Field->new( 'publishDate'          => "$date" );
	my $solr_format               = WebService::Solr::Field->new( 'format'               => "$format" );
	my $solr_institution          = WebService::Solr::Field->new( 'institution'          => "$institution" );
	my $solr_building             = WebService::Solr::Field->new( 'building'             => "$library" );
	my $solr_fullrecord           = WebService::Solr::Field->new( 'fullrecord'           => "$fullrecord" );
	my $solr_type                 = WebService::Solr::Field->new( 'recordtype'           => RECORDTYPE );
	my $solr_language             = WebService::Solr::Field->new( 'language'             => "$language" );
	my $solr_author               = WebService::Solr::Field->new( 'author'               => "$author" );
	my $solr_author_letter        = WebService::Solr::Field->new( 'author-letter'        => "$author_letter" );
	my $solr_author2              = WebService::Solr::Field->new( 'author2'              => "$author2" );
	my $solr_description          = WebService::Solr::Field->new( 'description'          => "$description" );
	my $solr_publisher            = WebService::Solr::Field->new( 'publisher'            => "$publisher" );
	my $solr_all_fields           = WebService::Solr::Field->new( 'allfields'            => "$all_fields" );
	my $solr_topic                = WebService::Solr::Field->new( 'topic'                => "$topic" );
	
	# fill a solr document with simple fields
	my $doc = WebService::Solr::Document->new;
	$doc->add_fields( $solr_id, $solr_title, $solr_title_auth, $solr_title_full, $solr_title_fullStr, $solr_title_full_unstemmed, $solr_title_short, $solr_title_sort, $solr_date, $solr_format, $solr_institution, $solr_building, $solr_fullrecord, $solr_type, $solr_language, $solr_author, $solr_author_letter, $solr_description, $solr_publisher, $solr_all_fields, $solr_author2, $solr_topic );
	
	# save; our reasone de exitance
	$solr->add( $doc );

}

# done
exit;
