-- query-strings.sql - find all the queries

-- Eric Lease Morgan <emorgan@nd.edu>
-- August 15, 2011 - first investigations

SELECT request
FROM httpd
WHERE requesttype = 'search' AND hosttype <> 'robot'

