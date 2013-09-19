-- institutions.sql - classify httpd according to whose records got viewed

-- Eric Lease Morgan <emorgan@nd.edu>
-- June 29, 2011 - first investigations

UPDATE httpd SET institution = 'Boston College - John M. Kelly Library'                        WHERE request LIKE '/Record/bcu%';
UPDATE httpd SET institution = 'Catholic University of America - University Libraries of CUA'  WHERE request LIKE '/Record/cua%';
UPDATE httpd SET institution = 'Dominican University - Rebecca Crown Library'                  WHERE request LIKE '/Record/dom%';
UPDATE httpd SET institution = 'Georgetown University - Lauinger Memorial Library'             WHERE request LIKE '/Record/gtu%';
UPDATE httpd SET institution = 'Loyola University Chicago - Cudahy Library'                    WHERE request LIKE '/Record/luc%';
UPDATE httpd SET institution = 'Marquette University - Raynor Memorial Libraries'              WHERE request LIKE '/Record/mar%';
UPDATE httpd SET institution = 'Seton Hall University - Walsh Library'                         WHERE request LIKE '/Record/shu%';
UPDATE httpd SET institution = 'St. Catherine University - St. Catherine University Libraries' WHERE request LIKE '/Record/stc%';
UPDATE httpd SET institution = 'St. Edward\'s University - Scarborough-Phillips Library'       WHERE request LIKE '/Record/sed%';
UPDATE httpd SET institution = 'University of Dayton - Marian Library'                         WHERE request LIKE '/Record/day%';
UPDATE httpd SET institution = 'University of Notre Dame - Hesburgh Libraries'                 WHERE request LIKE '/Record/und%';
UPDATE httpd SET institution = 'University of Notre Dame - University Archives'                WHERE request LIKE '/Record/una%';
UPDATE httpd SET institution = 'University of San Diego - Copley Library'                      WHERE request LIKE '/Record/usd%';
UPDATE httpd SET institution = 'University of Toronto - John M. Kelly Library'                 WHERE request LIKE '/Record/tor%';
UPDATE httpd SET institution = 'Villanova University - Falvey Memorial Library'                WHERE request LIKE '/Record/vil%';
