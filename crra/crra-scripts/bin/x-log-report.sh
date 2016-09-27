# log-report.sh - output sample report

# Eric Lease Morgan <emorgan@nd.edu>
# June 29, 2011 - first cut; brain-dead

# change directories
cd /shared/catholic_portal/data/crra-scripts/etc

echo
echo
echo "Whose records are being seen"
echo
mysql -hmysql.library.nd.edu -ucatholic -pportal crra_transactions < whose-records.sql

echo
echo 
echo "Hosts"
echo
mysql -hmysql.library.nd.edu -ucatholic -pportal crra_transactions < hosts.sql

echo
echo 
echo "Types of searches"
echo
mysql -hmysql.library.nd.edu -ucatholic -pportal crra_transactions < types-of-searches.sql

echo
echo 
echo "Top records"
echo
mysql -hmysql.library.nd.edu -ucatholic -pportal crra_transactions < top-records.sql

echo
echo 
echo "Tabs"
echo
mysql -hmysql.library.nd.edu -ucatholic -pportal crra_transactions < tabs.sql

echo
echo
echo "Done"
exit
