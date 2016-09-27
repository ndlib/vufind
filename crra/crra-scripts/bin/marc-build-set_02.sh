# build-set_02.sh - re-build the Catholic Portal

# Eric Lease Morgan <emorgan@nd.edu>
# July     16, 2010 - first cut
# March     4, 2011 - moving to james
# December 20, 2012 - added command line input and logging


cd /opt/vufind/crra/crra-scripts
echo
echo Harvesting...
bin/marc-harvest.pl lmu luc luw mar pah sed shu stc una > /opt/vufind/crra/crra-scripts/logs/set_02-marc-harvest.txt
echo
echo Prepending codes...
bin/marc-add-code.pl lmu luc luw mar pah sed shu stc una > /opt/vufind/crra/crra-scripts/logs/set_02-marc-addcodes.txt
echo
echo Re-indexing...
bin/marc-index.pl lmu luc luw mar pah sed shu stc una > /opt/vufind/crra/crra-scripts/logs/set_02-marc-index.txt
