-- robots.sql - classify some httpd as robot entries

-- Eric Lease Morgan <emorgan@nd.edu>
-- January 25, 2011 - first investigations
-- September 16, 2011 - added more robots


UPDATE httpd SET hosttype = 'robot' WHERE host LIKE '%.crawl.yahoo.net';
UPDATE httpd SET hosttype = 'robot' WHERE host LIKE '%.googlebot.com';
UPDATE httpd SET hosttype = 'robot' WHERE host LIKE 'baiduspider-%.crawl.baidu.com';
UPDATE httpd SET hosttype = 'robot' WHERE host LIKE 'crawl-%.cuil.com';
UPDATE httpd SET hosttype = 'robot' WHERE host LIKE 'crawl%.dotnetdotcom.org';
UPDATE httpd SET hosttype = 'robot' WHERE host LIKE 'msnbot-%.search.msn.com';
UPDATE httpd SET hosttype = 'robot' WHERE host LIKE 'spider%.yandex.ru';
UPDATE httpd SET hosttype = 'robot' WHERE host LIKE '212.113.37.105';
UPDATE httpd SET hosttype = 'robot' WHERE host LIKE '119.63.196.%';
UPDATE httpd SET hosttype = 'robot' WHERE host LIKE '180.76.5.%';
UPDATE httpd SET hosttype = 'robot' WHERE host =    '208-115-111-66-reverse.wowrack.com';
UPDATE httpd SET hosttype = 'robot' WHERE host =    'ec2-184-73-41-173.compute-1.amazonaws.com';
UPDATE httpd SET hosttype = 'robot' WHERE host =    'st-19-96-205-91.2dayhost.com';
UPDATE httpd SET hosttype = 'robot' WHERE host =    'fa.5.85ae.static.theplanet.com';
UPDATE httpd SET hosttype = 'robot' WHERE host =    'sr324.2dayhost.com';
