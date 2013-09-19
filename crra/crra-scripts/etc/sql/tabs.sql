-- tabs.sql - how often where the tabs clicked

-- Eric Lease Morgan <emorgan@nd.edu>
-- June 29, 2011 - first investigations

SELECT COUNT(request) as c, request
FROM httpd
WHERE hosttype <> 'robot' AND requesttype = 'about'
GROUP BY request
ORDER BY c DESC
LIMIT 25;


