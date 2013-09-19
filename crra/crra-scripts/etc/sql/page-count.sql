-- page-count.sql - list the number of pages viewed

-- Eric Lease Morgan <emorgan@nd.edu>
-- September 13, 2011 - first investigations

SELECT COUNT(request) AS "Page count"
FROM httpd
WHERE hosttype <> 'robot'
  AND ( requesttype = 'record' OR requesttype = 'about' OR requesttype = 'admin' OR requesttype = 'search' )
  AND datetime LIKE '2011-09-15 %';
