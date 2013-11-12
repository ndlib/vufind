#!/shared/perl/current/bin/perl

# re-index.pl - delete old records and add new ones to a Solr index

# Eric Lease Morgan <emorgan@nd.edu>
# July     16, 2010 - first investigations
# October   8, 2010 - added type
# March     4, 2011 - reconfiguring for james 
# December 20, 2012 - added command line input; redirected STDERR to a STDIN

# configure
# changed command parameter as per vufind-2.1 and rather than changing import properties, changes are dine in marc_local_properties.Changed the template.txt file as per marc_local.properties. (vufind-2.1)
use constant CMD        => "\"C:\\Program Files\\Java\\jdk1.7.0_25\\bin\\java\" -Xms512m -Xmx512m -Duser.timezone=UTC -Dsolr.core.name=biblio -Dsolr.path=REMOTE -Dsolr.solr.home=C:\\vufind-2.1\\solr -Dsolrmarc.path=C:\\vufind-2.1\\import -jar C:\\vufind-2.1\\import\\SolrMarc.jar C:\\vufind-2.1\\local\\import\\import.properties ##MARC## 2> ##LOG##";
use constant DB         => '/usr/local/vufind2/crra/crra-scripts/etc/libraries.db';
use constant PROPERTIES => '/usr/local/vufind2/local/import/marc_local.properties';
use constant SOLR       => 'http://localhost:8080/solr/biblio';
use constant TEMPLATE   => '/usr/local/vufind2/local/import/template.txt';
use constant UPDATED    => '/usr/local/vufind2/crra/data/marc-updated/';
use constant LOGS       => '/usr/local/vufind2/crra/crra-scripts/logs/';
use constant TYPE       => 'marc';

# require
use strict;
use WebService::Solr;
require '/usr/local/vufind2/crra/crra-scripts/lib/subroutines.pl';

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
	# changed file name to .mrc as vufind-2.1 only accepts mrc format.(vufind-2.1)
	print "Indexing $key...\n";
	my $marc = UPDATED . "$key.mrc";
	my $cmd  = CMD;
	$cmd =~ s/##MARC##/$marc/e;
	$cmd =~ s/##LOG##/LOGS . $key . "-indexing.log"/e;
	
	# do the work
	print "$cmd\n";
	system $cmd;
		
}

# done
exit;

