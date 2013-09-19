-- referrers-engines.sql - list referrers from search engines (google, yahoo, and bing)

-- Eric Lease Morgan <emorgan@nd.edu>
-- May 18, 2011 - first investigations


SELECT COUNT( referrer ) AS r, referrer
FROM httpd
WHERE ( referrer LIKE '%google%' OR referrer LIKE '%yahoo%' OR referrer LIKE '%bing%' )
AND referrer NOT LIKE '%www.catholicresearch.net%'
GROUP BY referrer
ORDER BY r DESC, referrer ASC;


