-- requests.sql - classify httpd according to request type

-- Eric Lease Morgan <emorgan@nd.edu>
-- January 25, 2011 - first investigations


UPDATE httpd SET requesttype = 'about'      WHERE request LIKE '/About%';
UPDATE httpd SET requesttype = 'admin'      WHERE request LIKE '/admin%';
UPDATE httpd SET requesttype = 'ajax'       WHERE request LIKE '/Search/AJAX%';
UPDATE httpd SET requesttype = 'bookcover'  WHERE request LIKE '/bookcover.php%';
UPDATE httpd SET requesttype = 'css'        WHERE request LIKE '%.css';
UPDATE httpd SET requesttype = 'image'      WHERE request LIKE '%.gif';
UPDATE httpd SET requesttype = 'image'      WHERE request LIKE '%.ico';
UPDATE httpd SET requesttype = 'image'      WHERE request LIKE '%.jpg';
UPDATE httpd SET requesttype = 'image'      WHERE request LIKE '%.png';
UPDATE httpd SET requesttype = 'javascript' WHERE request LIKE '%.js';
UPDATE httpd SET requesttype = 'record'     WHERE request LIKE '/Record/%';
UPDATE httpd SET requesttype = 'root'       WHERE request =    '/';
UPDATE httpd SET requesttype = 'search'     WHERE request LIKE '%?lookfor=%';
