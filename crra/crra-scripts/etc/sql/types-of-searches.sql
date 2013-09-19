-- types-of-searches.sql - types of searches

-- Eric Lease Morgan <emorgan@nd.edu>
-- June 29, 2011 - first investigations

SELECT COUNT(searchtype) as c, searchtype
FROM httpd
WHERE hosttype <> 'robot'
GROUP BY searchtype
ORDER BY c DESC;


