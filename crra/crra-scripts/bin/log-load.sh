# log-load.sh - copy HTTP transactions to database

# Eric Lease Morgan <emorgan@nd.edu>
# May 6, 2011 - first cut; brain-dead


echo "Processing $1"

echo "Changing directories"
cd /shared/catholic_portal/httpd/logs/archive/2011

echo "Copying file"
cp catholic_portal_access_log.$1.gz /shared/catholic_portal/tmp/

echo "Uncompressing"
gunzip /shared/catholic_portal/tmp/catholic_portal_access_log.$1.gz

echo "Loading"
/shared/catholic_portal/data/crra-scripts/bin/log-load.pl $1

echo "Cleaning up"
rm /shared/catholic_portal/tmp/catholic_portal_access_log.$1

echo "Done"
exit
