-- whose-records.sql - Whose records are being seen

-- Eric Lease Morgan <emorgan@nd.edu>
-- January 25, 2011 - first investigations

SELECT COUNT(institution) as c, institution
FROM httpd
WHERE hosttype <> 'robot' AND requesttype = 'record'
GROUP BY institution
ORDER BY c DESC;


