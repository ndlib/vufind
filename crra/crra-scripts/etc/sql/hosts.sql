-- hosts.sql - list top non-robot hosts accessing the portal

-- Eric Lease Morgan <emorgan@nd.edu>
-- January 25, 2011 - first investigations


SELECT COUNT(host) AS c, host
FROM httpd
WHERE hosttype <> 'robot' AND requesttype = 'search'
GROUP BY host
ORDER BY c DESC
LIMIT 100;

