<?php
/**
 * Model for Past Perfect records in Solr.
 *
 * PHP version 5
 *
 * Copyright (C) Villanova University 2010.
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 2,
 * as published by the Free Software Foundation.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 *
 * @category VuFind2
 * @package  RecordDrivers
 * @author   Demian Katz <demian.katz@villanova.edu>
 * @license  http://opensource.org/licenses/gpl-2.0.php GNU General Public License
 * @link     http://vufind.org/wiki/vufind2:record_drivers Wiki
 */
namespace CRRA_Module\RecordDriver;
/**
 * CRRA Past perfect Record Driver
 *
 * This class is designed to handle CRRA EAD records. Much of its functionality
 * is inherited from the default index-based driver.
 *
 * @category VuFind2
 * @package  RecordDrivers
 * @author   Demian Katz <demian.katz@villanova.edu>
 * @license  http://opensource.org/licenses/gpl-2.0.php GNU General Public License
 * @link     http://vufind.org/wiki/vufind2:record_drivers Wiki
 */
class SolrPp extends \VuFind\RecordDriver\SolrDefault
{
    /**
     * Extract the urls from the full record.
     *
     * @return array
     */
    public function getURLs()
    {
        // initialize
        $urls = [];
        $dom = new \DOMDocument();
        if ($doc = $dom::loadXML($this->fields['fullrecord'])) {
            $parser = new \DOMXPath($doc);

            // process all the urls
            $results = $parser->query('//url');
            foreach ($results as $result) {
                $urls[] = [
                    'url' => $result->nodeValue,
                    'desc' => $result->getAttribute('description')
                ];
            }
        }

        // done
        return $urls;
    }

    /**
     * Get all subject headings associated with this record.  Each heading is
     * returned as an array of chunks, increasing from least specific to most
     * specific.
     *
     * @return array
     */
    public function getAllSubjectHeadings()
    {
        $headings = parent::getAllSubjectHeadings();
        for ($i = 0; $i < count($headings); $i++) {
            $headings[$i] = explode('--', $headings[$i][0]);
        }
        return $headings;
    }

    /**
     * Get library name for the CRRA Past Perfect record.
     *
     * @return string
     */
    public function getCRRALibrary()
    {
        return $this->fields['building'][0];
    }

    /**
     * Get institution name for the CRRA Past Perfect record.
     *
     * @return string
     */
    public function getCRRAInstitution()
    {
        return $this->fields['institution'][0];
    }

    /**
     * Get the unique id for the CRRA Past Perfect record.
     *
     * @return id
     */
    public function getCRRAKey()
    {
        return substr($this->fields['id'], 0, 3);
    }
}
