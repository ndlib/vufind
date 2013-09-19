-- referrers-all.sql - list where hits came from

-- Eric Lease Morgan <emorgan@nd.edu>
-- May 18, 2011 - first investigations


SELECT COUNT(referrer) AS r, referrer
FROM httpd
WHERE referrer NOT like '%catholicresearch%' AND referrer != '-'
GROUP BY referrer
ORDER BY r DESC, referrer ASC;

