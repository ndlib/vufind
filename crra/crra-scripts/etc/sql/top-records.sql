-- top-records.sql - most frequently looked at records

-- Eric Lease Morgan <emorgan@nd.edu>
-- June 29, 2011 - first investigations

SELECT COUNT(request) as c, request
FROM httpd
WHERE hosttype <> 'robot' AND requesttype = 'record'
GROUP BY request
ORDER BY c DESC
LIMIT 50;


