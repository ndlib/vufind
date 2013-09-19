-- recordtypes.sql - classify httpd according to type of record displayed

-- Eric Lease Morgan <emorgan@nd.edu>
-- June 29, 2011 - first investigations


UPDATE httpd SET recordtype = 'marc' WHERE requesttype = 'record' AND request LIKE '%marc_%';
UPDATE httpd SET recordtype = 'ead'  WHERE requesttype = 'record' AND request LIKE '%ead_%';
