#!/shared/perl/current/bin/perl

# re-index.pl - delete old records and add new ones to a Solr index

# Eric Lease Morgan <emorgan@nd.edu>
# July     16, 2010 - first investigations
# October   8, 2010 - added type
# March     4, 2011 - reconfiguring for james 
# December 20, 2012 - added command line input; redirected STDERR to a STDIN

# configure
use constant CMD        => 'C:\vufind-2.1\import-marc.bat';
use constant DB         => 'C:\Users\psinghvi\Desktop\vufind\CRRA_Pragya\crra-scripts\etc\libraries.db';
use constant PROPERTIES => 'C:\vufind-2.1\import\marc.properties';
use constant SOLR       => 'http://localhost:8080/solr/biblio';
use constant TEMPLATE   => 'C:\Users\psinghvi\Desktop\vufind\CRRA_Pragya\crra-scripts\etc\template.txt';
use constant UPDATED    => 'C:\Users\psinghvi\Desktop\vufind\CRRA_Pragya\marc-updated\\';
use constant LOGS       => 'C:\Users\psinghvi\Desktop\vufind\CRRA_Pragya\crra-scripts\logs\\';
use constant TYPE       => 'marc';

# require
use strict;
use WebService::Solr;
require 'C:\Users\psinghvi\Desktop\vufind\CRRA_Pragya\crra-scripts\lib\subroutines.pl';

# initilize
my $libraries = &read_institutions( DB, [ @ARGV ] );
my $solr      = WebService::Solr->new( SOLR );
my $type      = TYPE;

# process each library
foreach my $key ( sort keys %$libraries ) {

	# delete the old records; cool!
	print "Deleting records whose id starts with $key...\n";
	$solr->delete_by_query( "id:$key$type" . "_*" );
	$solr->commit;
		
	# re-create and save a marc.properties file
	print "Creating $key properties...\n";
	my $template = &slurp( TEMPLATE );
	$template =~ s/##INSTITUTION##/$$libraries{ $key }->[ 0 ]/;
	$template =~ s/##LIBRARY##/$$libraries{ $key }->[ 1 ]/;
	open OUT, " > ", PROPERTIES or die "Can't open " . PROPERTIES . ": $!\n";
	print OUT $template;
	close OUT;
	
	# build the indexing command
	print "Indexing $key...\n";
	my $marc = UPDATED . "$key.mrc";
	my $cmd  = CMD;
	#$cmd =~ s/##MARC##/$marc/e;
	#$cmd =~ s/##LOG##/LOGS . $key . "-indexing.log"/e;
	
	# do the work
	print "$cmd\n";
	system $cmd $marc;
		
}

# done
exit;

