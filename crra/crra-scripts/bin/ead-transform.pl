#!/usr/bin/perl

# transform.pl - modify EAD files and make HTML files from cache

# Eric Lease Morgan <emorgan@nd.edu>
# October   6, 2010 - first investigations
# October   8, 2010 - saved transformed files for indexing purposes
# March     9, 2011 - configured for james  
# April     6, 2011 - moved location of processed EAD files; added utf8 as output
# April     4, 2012 - added strip namespace to accomodate schema-based EAD files
# December 20, 2012 - added command line input


# define constants
use constant ADDUNITID => '/opt/vufind/crra/crra-scripts/etc/addunitid.xsl';
use constant STRIPNS   => '/opt/vufind/crra/crra-scripts/etc/strip-namespaces.xsl';
use constant CACHE     => '/opt/vufind/crra/data/ead-incoming/' ;
use constant DB        => '/opt/vufind/crra/crra-scripts/etc/libraries.db';
use constant HTML      => '/opt/vufind/crra/data/html/data/ead/html/';
use constant EAD2HTML  => '/opt/vufind/crra/crra-scripts/etc/ead2html.xsl';
use constant EAD       => '/opt/vufind/crra/data/html/data/ead/xml/';

# require
use strict;
use XML::LibXML;
use XML::LibXSLT;
require '/opt/vufind/crra/crra-scripts/lib/subroutines.pl';
$| = 1;

# process each library
my $libraries = &read_institutions( DB, [ @ARGV ] );
foreach my $key ( sort keys %$libraries ) {

	# sanity check
	my $library = $$libraries{ $key }->[ 1 ];
	my $root    = $$libraries{ $key }->[ 3 ];
	next if ( ! $root );

	# process everything in this library's cache
	opendir( DIRECTORY, CACHE . $key ) or die "Can't open directory " .  CACHE . $key . ": $!\n";
	while ( my $filename = readdir( DIRECTORY )) {
	
		# only want xml files
		next if ( $filename !~ /xml$/ );
		
		# strip namespace; a hack?
		my $cachedfile = CACHE . "$key/$filename";
		print "Processing $cachedfile...\n";
		my $parser     = XML::LibXML->new;
		my $xslt       = XML::LibXSLT->new;
		my $source     = $parser->parse_file( $cachedfile ) or die "Can't parse original EAD: $!\n";
		my $style      = $parser->parse_file( STRIPNS )     or die "Can't parse STRIPNS XSL: $!\n";
		my $stylesheet = $xslt->parse_stylesheet( $style )  or die "Can't parse STRIPNS XSL: $!\n";
		my $results    = $stylesheet->transform( $source )  or die "Can't transform original EAD: $!\n";	
		#my $ead        = $stylesheet->output_string( $results );

		# add unitid
		$source     = $parser->parse_string( $stylesheet->output_string( $results )) or die "Can't parse EAD: $!\n";
		$style      = $parser->parse_file( ADDUNITID )   or die "Can't parse ADDUNITID XSL: $!\n";
		$stylesheet = $xslt->parse_stylesheet( $style )  or die "Can't parse ADDUNITID XSL: $!\n";
		$results    = $stylesheet->transform( $source )  or die "Can't transform ADDUNITID EAD: $!\n";	
		my $ead        = $stylesheet->output_string( $results );
				
		# save ead for indexing purposes
		my $directory = EAD;
		my $file      = "$directory$key-$filename";
		open XML, " > $file" or die "Can't open $file: $!\n";
		print XML $ead;
		close XML;

		# transform into html
		$parser     = XML::LibXML->new;
		$xslt       = XML::LibXSLT->new;
		$source     = $parser->parse_string( $ead )     or die "Can't parse EAD: $!\n";
		$style      = $parser->parse_file( EAD2HTML )   or die "Can't parse XSL: $!\n";
		$stylesheet = $xslt->parse_stylesheet( $style ) or die "Can't parse XSL: $!\n";
		$results    = $stylesheet->transform( $source ) or die "Can't transform EAD: $!\n";

		# munge the filename and save
		$filename =~ s/xml$/html/;
		open OUTPUT, " > " . HTML . "$key-$filename" or die "Can't open " . HTML . "$key-$filename: $!\n";
		binmode( OUTPUT, ":utf8" );
		print OUTPUT $stylesheet->output_string( $results );
		close OUTPUT;
				
	}
	closedir( DIRECTORY );
	
}

# done
exit;

