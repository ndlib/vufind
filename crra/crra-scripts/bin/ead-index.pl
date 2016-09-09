#!/usr/bin/perl

# index-ead.pl - put EAD content into SOLR

# Eric Lease Morgan <emorgan@nd.edu>
# September 30, 2010 - first investigations
# October    4, 2010 - began extracting urls
# October   11, 2010 - processed all previously transformed EAD files
# October   12, 2010 - added optimize, autocommit, format, and intelligent language
# November  18, 2010 - added escape_entities and escaped title; "Happy Birthday, Douglas"
# March      9, 2011 - configured for james
# April      6, 2011 - tweaked for new location of EAD files
# January    4, 2012 - batch loaded documents and got huge speed boost
# October    4, 2012 - after a few days' work, started indexing EAD headers and full text indexing body; no more did-level indexing
# October   10, 2012 - dropped use of author2 for topics for persname and corpname, as per Kevin Cawley
# October   11, 2012 - as per Demian Katz, explicitly extracted all did's and stuffed them into title_alt
# November   5, 2012 - as per Kevin Cawley, used /ead/archdesc/did/unitdate for date; added md5 hashing for id based on filename
# December  20, 2012 - added command line input
# April      8, 2016 - escaped & characters in URLs


# configure
use constant VERBOSE     => 1;
use constant DB          => '/opt/vufind/crra/crra-scripts/etc/libraries.db';
use constant FORMAT      => 'Archival material';
use constant EAD         => '/opt/vufind/crra/data/html/data/ead/xml/';
use constant SOLR        => 'http://localhost:8081/solr/biblio';
use constant TYPE        => 'ead';
use constant WEBROOT     => 'http://www.catholicresearch.net/data/ead/html/';
use constant FULLRECORD  => "<record><url description='View finding aid at owning institution'>##REMOTEURL##</url><url description='View finding aid in Portal display'>##LOCALURL##</url></record>";
use constant CHARS       => ('a'..'z', 'A'..'Z', '0'..'9' );


# require
use strict;
use XML::XPath;
use WebService::Solr;
use Digest::MD5 qw( md5 );
require '/opt/vufind/crra/crra-scripts/lib/subroutines.pl';

# initialize
my $solr      = WebService::Solr->new( SOLR );
my $directory = EAD;

# process each library in the database
my $libraries = &read_institutions( DB, [ @ARGV ] );
foreach my $key ( sort keys %$libraries ) {

	# sanity check; only process libraries with EAD files
	my $institution = $$libraries{ $key }->[ 0 ];
	my $library     = $$libraries{ $key }->[ 1 ];
	my $root        = $$libraries{ $key }->[ 3 ];
	next if ( ! $root );

	# delete old data
	print "Deleting EAD records for $institution...\n";
	$solr->delete_by_query( "id:$key" . TYPE . "_*" );

	# process each file in this library's EAD cache
	my $count = 0;
	my @docs  = ();
	opendir( DIRECTORY, $directory );
	while ( my $filename = readdir( DIRECTORY )) {

		# only want xml files, and files matching the current key
		next if ( $filename !~ /xml$/ );
		next if ( $filename !~ /^$key/ );

		# create the ead filename
		my $ead = "$directory$filename";
		print $ead, "\n";

		# (re-)initialize
		my $xpath   = XML::XPath->new( filename => $ead );

		# extract title
		my $titleproper          = $xpath->find( '/ead/eadheader/filedesc/titlestmt/titleproper' );
		$titleproper             = $titleproper->string_value;
		$titleproper             =~ s/^\W+//;
		$titleproper             =~ s/\W+$//;
		my $subtitle             = $xpath->find( '/ead/eadheader/filedesc/titlestmt/subtitle' );
		if ( $subtitle ) { $titleproper .= ": $subtitle" }
		my $title_auth           = $titleproper;
		my $title_full           = $titleproper;
		my $title_fullStr        = $titleproper;
		my $title_full_unstemmed = $titleproper;
		my $title_short          = $titleproper;
		my $title_sort           = $titleproper;

		# get alternate titles (did's)
		my @title_alts = ();
		my $dids       = $xpath->find( '//did' );
		foreach my $did ( $dids->get_nodelist ) {

			my $did = $xpath->find( '.', $did );
			$did =~ s/\W+/ /g;
			$did =~ s/^\W+//g;
			push @title_alts, $did;

		}


		# assign constants
		my $format = FORMAT;
		my $type   = TYPE;

		# extract "simple" metadata
		my $publisher            = $xpath->find( '/ead/eadheader/filedesc/publicationstmt/publisher' );
		my $publishdate          = $xpath->find( '/ead/archdesc/did/unitdate' );
		my $language             = $xpath->find( '/ead/eadheader/profiledesc/langusage/language' );
		$language    =~ s/\W+$//;
		my $description          = $xpath->find( '/ead/archdesc/did/abstract' );
		$description             =~ s/^\W+//;
		$description             =~ s/\W+$//;
		my $physical             = $xpath->find( '/ead/archdesc/did/physdesc' );
		$physical                =~ s/^\W+//;
		$physical                =~ s/\W+$//;

		# extract some cool EAD-specific metadata...
		my $crra_bioghist =  $xpath->find( '/ead/archdesc/bioghist' );
		$crra_bioghist    =~ s/\n+/ /g;
		$crra_bioghist    =~ s/\r+/ /g;
		$crra_bioghist    =~ s/ +/ /g;
		$crra_bioghist    =~ s/^\W+//;
		$crra_bioghist    =~ s/\W+$//;

		# ...again
		my $crra_scopecontent =  $xpath->find( '/ead/archdesc/scopecontent' );
		$crra_scopecontent    =~ s/\n/ /g;
		$crra_scopecontent    =~ s/ +/ /g;
		$crra_scopecontent    =~ s/^\W//;
		$crra_scopecontent    =~ s/\W$//;

		# subjects
		my @subjects = ();
		my $subjects = $xpath->find( '//subject' );
		foreach my $subject ( $subjects->get_nodelist ) { push @subjects, $xpath->find( '.', $subject ) }

		# personal names
		my @persnames = ();
		my $persnames = $xpath->find( '//persname' );
		foreach my $persname ( $persnames->get_nodelist ) {

			my $name = $xpath->find( '.', $persname );
			$name    =~ s/\n+/ /g;
			$name    =~ s/ +/ /g;
			$name    =~ s/^\W+//;
			$name    =~ s/\W+$//;

			push @persnames, $name;

		}

		# corporate names
		my @corpnames = ();
		my $corpnames = $xpath->find( '//corpname' );
		foreach my $corpname ( $corpnames->get_nodelist ) {

			my $name = $xpath->find( '.', $corpname );
			$name    =~ s/^\W+//;
			$name    =~ s/\W+$//;
			push @corpnames, $name;

		}

		# support full text search
		my $allfields =  $xpath->find( '.' );
		$allfields    =~ s/\n/ /g;
		$allfields    =~ s/ +/ /g;
		$allfields    =~ s/^ //g;
		$allfields    =~ s/ $//g;

		# unique id; a bit bogus, needs to be persistent
		my @CHARS   = CHARS;
		my $id      = '';
		my $integer = ( unpack( 'N', md5( $filename )))[ 0 ];

		# build the (hopefully) unique id; from http://search.cpan.org/dist/Algorithm-URL-Shorten/
		for ( my $j = 0; $j < 6; $j++ ) {

			$id      .= $CHARS[ 0x0000003D & $integer ];
			$integer  = $integer >> 5;

		}
		$id = $key . TYPE. '_' . $id;

		# urls
		my $fullrecord  =  FULLRECORD;
		my $remoteURL   =  $xpath->find( '/ead/eadheader/eadid/@url' );
		my $localURL    =  WEBROOT . $filename;
		$localURL       =~ s/xml$/html/;
		$fullrecord     =~ s|##REMOTEURL##|$remoteURL|e;
		$fullrecord     =~ s|##LOCALURL##|$localURL|e;
		$fullrecord     =~ s/&/&amp;/g;

		# echo
		if ( VERBOSE ) {

			print "             id: ", $id,   "\n";
			print "    titleproper: ", $titleproper,   "\n";
			print "       subtitle: ", $subtitle,      "\n";
			print "          title: ", $titleproper,   "\n";
			print "      publisher: ", $publisher,     "\n";
			print "           date: ", $publishdate,   "\n";
			print "       language: ", $language,      "\n";
			print "    description: ", $description,   "\n";
			print "       physical: ", $physical,      "\n";
			print "  crra bioghist: ", $crra_bioghist, "\n";
+			print "    full record: ", $fullrecord, "\n";
			foreach my $subject   ( @subjects )   { print "        subject: ", $subject,   "\n" }
			foreach my $persname  ( @persnames )  { print "       persname: ", $persname,  "\n" }
			foreach my $corpname  ( @corpnames )  { print "       corpname: ", $corpname,  "\n" }
			foreach my $title_alt ( @title_alts ) { print "      title_alt: ", $title_alt, "\n" }
			print "\n";

		}

		# populate solr fields
		my $solr_id                   = WebService::Solr::Field->new( 'id'                    => "$id" );
		my $solr_allfields            = WebService::Solr::Field->new( 'allfields'             => "$allfields" );
		my $solr_title                = WebService::Solr::Field->new( 'title'                 => "$titleproper" );
		my $solr_title_auth           = WebService::Solr::Field->new( 'title_auth'            => "$title_auth" );
		my $solr_title_full           = WebService::Solr::Field->new( 'title_full'            => "$title_full" );
		my $solr_title_fullStr        = WebService::Solr::Field->new( 'title_fullStr'         => "$title_fullStr" );
		my $solr_title_full_unstemmed = WebService::Solr::Field->new( 'title_full_unstemmed'  => "$title_full_unstemmed" );
		my $solr_title_short          = WebService::Solr::Field->new( 'title_short'           => "$title_short" );
		my $solr_title_sort           = WebService::Solr::Field->new( 'title_sort'            => "$title_sort" );
		my $solr_publisher            = WebService::Solr::Field->new( 'publisher'             => "$publisher" );
		my $solr_physical             = WebService::Solr::Field->new( 'physical'              => "$physical" );
		my $solr_date                 = WebService::Solr::Field->new( 'publishDate'           => "$publishdate" );
		my $solr_format               = WebService::Solr::Field->new( 'format'                => "$format" );
		my $solr_institution          = WebService::Solr::Field->new( 'institution'           => "$institution" );
		my $solr_building             = WebService::Solr::Field->new( 'building'              => "$library" );
		my $solr_fullrecord           = WebService::Solr::Field->new( 'fullrecord'            => "$fullrecord" );
		my $solr_type                 = WebService::Solr::Field->new( 'recordtype'            => "$type" );
		my $solr_language             = WebService::Solr::Field->new( 'language'              => "$language" );
		my $solr_description          = WebService::Solr::Field->new( 'description'           => "$description" );
		my $solr_crra_scopecontent    = WebService::Solr::Field->new( 'crra_scopecontent_str' => "$crra_scopecontent" );
		my $solr_crra_bioghist        = WebService::Solr::Field->new( 'crra_bioghist_str'     => "$crra_bioghist" );

		# fill a solr document with simple fields
		my $doc = WebService::Solr::Document->new;
		$doc->add_fields( $solr_physical, $solr_description, $solr_publisher, $solr_allfields, $solr_crra_bioghist, $solr_crra_scopecontent, $solr_id, $solr_title, $solr_title_auth, $solr_title_full, $solr_title_fullStr, $solr_title_full_unstemmed, $solr_title_short, $solr_title_sort, $solr_date, $solr_format, $solr_institution, $solr_building, $solr_fullrecord, $solr_type, $solr_language );

		# add alternative titles (did's)
		foreach ( @title_alts )  { $doc->add_fields(( WebService::Solr::Field->new( title_alt => "$_" ))) }

		# add topics and "added entries"
		foreach ( @subjects )  { $doc->add_fields(( WebService::Solr::Field->new( topic => "$_" ))) }
		foreach ( @persnames ) { $doc->add_fields(( WebService::Solr::Field->new( topic => "$_" ))) }
		foreach ( @corpnames ) { $doc->add_fields(( WebService::Solr::Field->new( topic => "$_" ))) }

		# add the doc to the list of docs
		push @docs, $doc;

		# debug/limit input
		$count++;
		#last if ( $count > 0 );

	}

	# do the work
	print "\n";
	closedir( DIRECTORY );
	$solr->add( \@docs );

}

# clean up and quit; done
print "Done.\n";
exit;

