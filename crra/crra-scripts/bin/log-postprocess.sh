# log-postprocess.sh - update database

# Eric Lease Morgan <emorgan@nd.edu>
# June 29, 2011 - added institutions, recordtypes, and searchtypes
# May  17, 2011 - first cut; brain-dead

echo "Changing directories"
cd /shared/catholic_portal/data/crra-scripts/etc/sql/

echo "Classifying requests"
mysql -hmysql.library.nd.edu -ucatholic -pportal crra_transactions < post-process/requests.sql

echo "Updating robots"
mysql -hmysql.library.nd.edu -ucatholic -pportal crra_transactions < post-process/robots.sql

echo "Updating institutions"
mysql -hmysql.library.nd.edu -ucatholic -pportal crra_transactions < post-process/institutions.sql

echo "Updating record types"
mysql -hmysql.library.nd.edu -ucatholic -pportal crra_transactions < post-process/recordtypes.sql

echo "Updating search types"
mysql -hmysql.library.nd.edu -ucatholic -pportal crra_transactions < post-process/searchtypes.sql

echo "Done"
exit
