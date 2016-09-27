#!/bin/bash

# rare-build.sh - brain-dead shell script to determine the "rarity" of CRRA holdings

# Eric Lease Morgan <emorgan@nd.edu>
# May 23, 2016 - first cut


# configure
MARC2BIBLIOGRAPHY='/opt/vufind/crra/crra-scripts/bin/rare-marc2bibliography.pl'
SEARCH='/opt/vufind/crra/crra-scripts/bin/rare-search.pl'
RARE='/opt/vufind/crra/data/html/data/rare/'
DB='/opt/vufind/crra/crra-scripts/etc/libraries.db';

# process each record in my DB
while IFS=$'\t' read -r -a db
do
	
	# get the key
	KEY="${db[0]}"
	
	# make sure it is a key
	if [[ "${db[0]}" =~ ^[a-z] ]]; then

		# initialize a database, and then do the work
		echo "Working against $KEY."
		$MARC2BIBLIOGRAPHY $KEY 
		$SEARCH $KEY

	fi
	
done < $DB

# done
exit
