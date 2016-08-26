#!/bin/bash
# build-ead.sh - re-build the "Catholic Portal's" EAD content

# Eric Lease Morgan <emorgan@nd.edu>
# October v8, 2010 - first cut
# October 11, 2010 - added indexing

cd /opt/vufind/crra/crra-scripts
echo
echo Harvesting EAD...
bin/ead-harvest.pl all
echo
echo Validating...
bin/ead-validate.pl all
echo
echo Transforming...
bin/ead-transform.pl all
echo
#echo Restarting...
#cd /usr/local/vufind
#./vufind.sh restart
#cd /home/emorgan/sandbox/crra/crra-scripts
#echo
#echo Sleeping...
#sleep 10
echo
echo Indexing...
bin/ead-index.pl all
echo
echo Done. Have a nice day.


