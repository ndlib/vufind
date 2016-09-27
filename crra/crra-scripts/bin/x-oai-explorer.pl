#!/shared/perl/current/bin/perl

# oai-explorer.pl - browse OAI repositories

# Eric Lease Morgan <emorgan@nd.edu>
# May      10, 2012 - first investigations; sorta brain dead
# November 13, 2012 - added some intelligence; "Thanks Rob, and Happy Birthday Steve!"


# configure; season to taste
use constant ROOT => 'http://contentdm.cr.duq.edu/cgi-bin/oai.exe';
use constant SET  => 'spiritan-prs';
use constant SETS => ( "cdm-ad", "cdm-antholog", "cdm-duqsps", "cdm-id", "cdm-memspir", "cdm-spcong", "cdm-spiritan", "cdm-spoprin", "missao", "slst", "sphorizons", "spiritan-articles", "spiritan-prs", "spiritanbook", "spnews" );
use constant META => 'oai_dc';
#use constant ROOT => 'http://newspapers.bc.edu/cgi-bin/bostonsh-oaiserver';
#use constant SET  => 'bostonsh:BOSTONSH18930819-01-logical-sections';
#use constant META => 'gsdl_qdc';

# require
use Data::Dumper;
use Net::OAI::Harvester;
use strict;

# initialize
my $harvester = Net::OAI::Harvester->new( 'baseURL' => ROOT );
binmode STDOUT, ":utf8";

# metadata formats
#my $list = $harvester->listMetadataFormats();
#print "archive supports metadata prefixes: ", join( ',', $list->prefixes ), "\n";
#exit;

# list sets
#my $sets = $harvester->listSets;
#foreach ( $sets->setSpecs ) {
#
#	print "  set spec: $_\n";
#	print "  set name: ", $sets->setName( $_ ), "\n";
#	print "\n";
#	
#}

## done
#exit;

# process each set
my @sets = SETS;
foreach my $set ( @sets ) {

	# echo
	print "Set: $set\n\n";

	# get the records in this set
	my $records   = $harvester->listRecords( metadataPrefix => META, set => $set );
	my $count     = 0;

	# process each record in this set
	while ( my $record = $records->next ) {
	
		# increment
		$count++;
		
		# get the goodness
		my $header     = $record->header;
		my $identifier = $header->identifier;
		my $metadata   = $record->metadata;
	
		# (brute force) echo
		#print Dumper( $header ), "\n";
		#print Dumper( $metadata ), "\n";
		
		# echo metadata
		print "       Item: $count\n";
		print " Identifier: $identifier\n";
		foreach my $key ( sort keys %{$metadata} ) {
		
			print "    * $key -";
			my @elements = $metadata->$key;
			foreach ( @elements ) {
			
				s/;$//;
				print " $_;"
				
			}
			print "\n";
			
		}
		print "\n";
		
		# poison pill
		#last if ( $count > 9 );
	
	}

}

# done
exit;
