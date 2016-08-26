#!/usr/bin/perl

# add-code.pl - prepend library code to 001 fields of MARC records

# Eric Lease Morgan <emorgan@nd.edu>
# July     16, 2010 - initial investigations
# August   24, 2010 - added :utf8 as a part of the output process
# October   8, 2010 - added TYPE
# December 20, 2012 - added command line input

# configure
use constant DB      => '/opt/vufind/crra/crra-scripts/etc/libraries.db';
use constant NEW     => '/opt/vufind/crra/data/marc-incoming/';
use constant UPDATED => '/opt/vufind/crra/data/marc-updated/';
use constant TYPE    => 'marc';

# require
use strict;
use MARC::Batch;
use Encode qw( encode decode );
require '/opt/vufind/crra/crra-scripts/lib/subroutines.pl';

# initilize
my $libraries = &read_institutions( DB, [ @ARGV ] );
my $type = TYPE;

# process each library
foreach my $key ( sort keys %$libraries ) {
	
	# echo
	# changed file name to .mrc as vufind-2.1 only accepts mrc format.(vufind-2.1)	
	print 'Processing ', NEW . "$key.mrc\n";
	
	# slurp (sloppy)
	# changed file name to .mrc as vufind-2.1 only accepts mrc format.(vufind-2.1)	
	my $batch = MARC::Batch->new( 'USMARC', NEW . "$key.mrc" );
	$batch->strict_off;
	$batch->warnings_off;
	
	# change file name to .mrc as vufind-2.1 only accepts mrc format.(vufind-2.1)
	# initialize output
	open OUT, ' > ' . UPDATED . "$key.mrc" or die "Can't open ", UPDATED . "$key.mrc: $!\n";
	binmode( OUT, ":utf8" );
	
	# process each record
	my $errors = 0;
	while ( my $marc = $batch->next ) {
	
		# get the 001
		my $_001 = $marc->field( '001' );
		
		# sanity check
		if ( ! $marc->field( '001' )) {
		
			#print $marc->as_formatted, "\n";
			print "No 001 field\n";
			print '   title: ' . $marc->title  . "\n";
			print '  author: ' . $marc->author . "\n";
			print "\n";
			$errors++;
			next;
		
		}
		
		else {
		
			print $_001->as_string, "\n";
		
		}
		

		# do the work
		$_001->update( $key . $type . "_" . $_001->as_string );
		print $_001->as_string, "\n";
		#print OUT encode( 'UTF-8', $marc->as_usmarc );
		print OUT $marc->as_usmarc;
		
	}
	
	# clean up
	print "Number of records without 001 fields: $errors\n";
	close OUT;
	
}

# done
exit;



