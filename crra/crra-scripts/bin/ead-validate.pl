#!/usr/bin/perl

# validate.pl - make sure an EAD file is well-formed, conforms to the DTD, and has an eadid url

# Eric Lease Morgan <emorgan@nd.edu>
# October   5, 2010 - see http://serials.infomotions.com/code4lib/archive/2008/200806/1039.html
# October  11, 2010 - made sure EAD file has a URL
# October   5, 2011 - validated against a schema as well as DTD (note the ironic change log dates)
# December 20, 2012 - added command line input


# define constants
use constant CACHE   => '/opt/vufind/crra/data/ead-incoming/' ;
use constant DB      => '/opt/vufind/crra/crra-scripts/etc/libraries.db';
use constant DTD     => '/opt/vufind/crra/crra-scripts/etc/ead.dtd';
use constant SCHEMA  => '/opt/vufind/crra/crra-scripts/etc/ead.xsd';
use constant GETURL  => '/opt/vufind/crra/crra-scripts/etc/geturl.xsl';
use constant INVALID => 'invalid/';
use constant NOURL   => 'nourl/';

# require
use File::Copy;
use strict;
use XML::LibXML;
use XML::LibXSLT;
require '/opt/vufind/crra/crra-scripts/lib/subroutines.pl';

# initilize
my $libraries = &read_institutions( DB, [ @ARGV ] );
my $xslt      = XML::LibXSLT->new;
my $parser    = XML::LibXML->new;

# initialize and check validity of DTD and schema
my $dtd = '';
eval { $dtd = XML::LibXML::Dtd->parse_string( &slurp( DTD )); };
if ( $@ ) {

	&valid( 'false', "Invalid DTD: $@" );
	exit;

}

my $schema = '';
eval { $schema = XML::LibXML::Schema->new( location => SCHEMA ); };
if ( $@ ) {

	&valid( 'false', "Invalid schema: $@" );
	exit;

}

# process each library
foreach my $key ( sort keys %$libraries ) {

	# sanity check
	my $library = $$libraries{ $key }->[ 1 ];
	my $root    = $$libraries{ $key }->[ 3 ];
	next if ( ! $root );

	# process everything in this library's cache
	opendir DIRECTORY, CACHE . $key or die "Can't open directory " .  CACHE . $key . ": $!\n";
	while ( my $filename = readdir( DIRECTORY )) {

		# only want xml files
		next if ( $filename !~ /xml$/ );

		# check for well-formedness of EAD
		print "Validating " . CACHE . "$key/$filename for well-formedness\n";
		my $ead = '';
		eval { $ead = XML::LibXML->new->parse_file( CACHE . "$key/$filename" ); };
		if ( $@ ) {

			# warn and move the file to an invalid directory
			print "Warning: ". CACHE . "$key/$filename is not well formed. Moving...\n";
			my $invalid = CACHE . "$key/" . INVALID;
			if ( ! -e $invalid ) { mkdir $invalid or die "Can't make directory $invalid: $!" }
			move( CACHE . "$key/$filename", "$invalid$filename" ) or die "Can't move file: $!\n";
			next;

		}


		# validate EAD
		eval { $ead->validate( $dtd ); };
		if ( $@ ) {

			eval { $schema->validate( $ead ); };
			if ( $@ ) {

				print "Error: $@\n";
				# warn and move the file to an invalid directory
				print "Warning: ". CACHE . "$key/$filename is does not validate. Moving...\n";
				my $invalid = CACHE . "$key/" . INVALID;
				if ( ! -e $invalid ) { mkdir $invalid or die "Can't make directory $invalid: $!" }
				move( CACHE . "$key/$filename", "$invalid$filename" ) or die "Can't move file: $!\n";
				next;

			}
			else { print "Validates against the Schema\n"; }

		}
		else { print "Validates against the DTD\n"; }

		# extract the url
		my $source     = $parser->parse_file( CACHE . "$key/$filename" ) or die "Can't load EAD: $!\n";
		my $style      = $parser->parse_file( GETURL )                   or die "Can't load XSL: $!\n";
		my $stylesheet = $xslt->parse_stylesheet( $style )               or die "Can't parse style: $!\n";
		my $results    = $stylesheet->transform( $source )               or die "Can't transform EAD: $!\n";

		# check for url
		if ( !  $stylesheet->output_string( $results )) {

			# warn and move the file to an no url directory
			print "Warning: ". CACHE . "$key/$filename has no URL. Moving...\n";
			my $nourl = CACHE . "$key/" . NOURL;
			if ( ! -e $nourl ) { mkdir $nourl or die "Can't make directory $nourl: $!" }
			move( CACHE . "$key/$filename", "$nourl$filename" ) or die "Can't move file: $!\n";

		}

	}
	closedir( DIRECTORY );

}

# done
exit;


sub valid {

	my $valid = shift;
	my $error = shift;
	print "Valid? $valid\n";
	print $error if $error;

}


sub slurp {

	# open a file named by the input and return its contents
	my $f = @_[0];
	my $r;
	open (F, "< $f");
	while (<F>) { $r .= $_ }
	close F;
	return $r;

}


