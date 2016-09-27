# marc-build-all.sh - re-index all MARC data

# Eric Lease Morgan <emorgan@nd.edu>
# July     16, 2010 - first cut
# March     4, 2011 - moving to james
# December 20, 2012 - added command line input and logging
# September 7, 2016 - based on previous work; really does all MARC; paths are hard-coded!


# sanity
cd /opt/vufind/crra/crra-scripts

# harvest
echo
echo Harvesting...
bin/marc-harvest.pl all

# add codes
echo
echo Prepending codes...
bin/marc-add-code.pl all

# do the work
echo
echo Re-indexing...
bin/marc-index.pl all


