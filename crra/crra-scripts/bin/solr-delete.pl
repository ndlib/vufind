#!/usr/bin/perl

# solr-delete.pl - remove data from the index; dangerous!

# Eric Lease Morgan <emorgan@nd.edu>
# October 13, 2010 - switched from commit to optimize


# configure; no other editing should be necessary
use constant SOLR => 'http://localhost:8080/solr/biblio';

# require
use strict;
use WebService::Solr;

# initialize;
my $solr = WebService::Solr->new( SOLR );

# do the work
print "Deleting records...\n";
$solr->delete_by_query( 'id:slu*' );
#print "Optimizing...";
#$solr->optimize;

# done
print "Done.\n";
exit;
