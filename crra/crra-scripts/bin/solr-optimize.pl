#!/usr/bin/perl

# optimize.pl - compact the index

# Eric Lease Morgan <emorgan@nd.edu>
# July    16, 2010 - first investigations
# October 12, 2010 - switched from commit to optimize


# configure; no other editing should be necessary
use constant SOLR => 'http://localhost:8081/solr/biblio';

# require
use strict;
use WebService::Solr;

# initialize;
my $solr = WebService::Solr->new( SOLR );

# do the work
print "Optimizing...\n";
$solr->optimize;

# done
exit;
