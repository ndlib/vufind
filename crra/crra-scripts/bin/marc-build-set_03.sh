# build-set_03.sh - re-build the Catholic Portal

# Eric Lease Morgan <emorgan@nd.edu>
# July     16, 2010 - first cut
# March     4, 2011 - moving to james
# December 20, 2012 - added command line input and logging


cd /opt/vufind/crra/crra-scripts
echo
echo Harvesting...
bin/marc-harvest.pl und usd vil > /opt/vufind/crra/crra-scripts/logs/set_03-marc-harvest.txt
echo
echo Prepending codes...
bin/marc-add-code.pl und usd vil > /opt/vufind/crra/crra-scripts/logs/set_03-marc-addcodes.txt
echo
echo Re-indexing...
bin/marc-index.pl und usd vil > /opt/vufind/crra/crra-scripts/logs/set_03-marc-index.txt
