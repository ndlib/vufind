# build.sh - produce rudimentary reports against the statistics database

# Eric Lease Morgan <emorgan@nd.edu>
# August 15, 2011 - brain-dead, like all of my shell scripts


cd /shared/catholic_portal/data/crra-scripts/etc/sql

# hosts
echo hosts
cat hosts.sql > ~/data/tmp/hosts.txt
mysql -hmysql.library.nd.edu -ucatholic -pportal crra_transactions < hosts.sql >> ~/data/tmp/hosts.txt

# all referrers
echo referrers
cat referrers-all.sql > ~/data/tmp/referrers-all.txt
mysql -hmysql.library.nd.edu -ucatholic -pportal crra_transactions < referrers-all.sql >> ~/data/tmp/referrers-all.txt

# search engines
echo engines
cat referrers-engines.sql > ~/data/tmp/referrers-engines.txt
mysql -hmysql.library.nd.edu -ucatholic -pportal crra_transactions < referrers-engines.sql  >> ~/data/tmp/referrers-engines.txt

# about tabs
echo tabs
cat tabs.sql > ~/data/tmp/tabs.txt
mysql -hmysql.library.nd.edu -ucatholic -pportal crra_transactions < tabs.sql >> ~/data/tmp/tabs.txt

# top records
echo top records
cat top-records.sql > ~/data/tmp/top-records.txt
mysql -hmysql.library.nd.edu -ucatholic -pportal crra_transactions < top-records.sql >> ~/data/tmp/top-records.txt

# types of searches
cat types-of-searches.sql > ~/data/tmp/types-of-searches.txt
mysql -hmysql.library.nd.edu -ucatholic -pportal crra_transactions < types-of-searches.sql >> ~/data/tmp/types-of-searches.txt

# whose records
echo whose records
cat whose-records.sql > ~/data/tmp/whose-records.txt
mysql -hmysql.library.nd.edu -ucatholic -pportal crra_transactions < whose-records.sql >> ~/data/tmp/whose-records.txt

# queries
echo queries
cat query-strings.sql > ~/data/tmp/query-strings.txt
mysql -hmysql.library.nd.edu -ucatholic -pportal crra_transactions < query-strings.sql > /shared/catholic_portal/tmp/queries.txt
/shared/catholic_portal/data/crra-scripts/bin/log-parse-queries.pl >> ~/data/tmp/query-strings.txt

# done
echo done
