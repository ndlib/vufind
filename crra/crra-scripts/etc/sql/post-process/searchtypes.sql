-- searchtypes.sql - classify httpd according to type of search

-- Eric Lease Morgan <emorgan@nd.edu>
-- June 29, 2011 - first investigations


UPDATE httpd SET searchtype = 'allfields'  WHERE requesttype = 'search' AND request LIKE '%type=AllFields%';
UPDATE httpd SET searchtype = 'title'      WHERE requesttype = 'search' AND request LIKE '%type=Title%';
UPDATE httpd SET searchtype = 'author'     WHERE requesttype = 'search' AND request LIKE '%type=Author%';
UPDATE httpd SET searchtype = 'subject'    WHERE requesttype = 'search' AND request LIKE '%type=Subject%';
UPDATE httpd SET searchtype = 'callnumber' WHERE requesttype = 'search' AND request LIKE '%type=CallNumber%';
UPDATE httpd SET searchtype = 'isn'        WHERE requesttype = 'search' AND request LIKE '%type=ISN%';
UPDATE httpd SET searchtype = 'tag'        WHERE requesttype = 'search' AND request LIKE '%type=tag%';
