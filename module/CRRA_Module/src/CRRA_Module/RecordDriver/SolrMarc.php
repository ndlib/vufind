<?php
/**
 * Model for MARC records in Solr.
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
 * Model for MARC records in Solr for CRRA_Module.
 *
 * @category VuFind2
 * @package  RecordDrivers
 * @author   Demian Katz <demian.katz@villanova.edu>
 * @license  http://opensource.org/licenses/gpl-2.0.php GNU General Public License
 * @link     http://vufind.org/wiki/vufind2:record_drivers Wiki
 */
    
class SolrMarc extends \VuFind\RecordDriver\SolrMarc
{
    /**    
     * Get library name for the CRRA Marc record.
     *
     * @return string
     */
    public function getCRRALibrary()
    {
        return $this->fields['building'][0];
    }
    
    /**
     * Get institution name for the CRRA Marc record.
     *
     * @return string
     */
    public function getCRRAInstitution()
    {
        return $this->fields['institution'][0];

    }
    
    /**
     * Get the unique id for the CRRA Marc record.
     *
     * @return id
     */
    public function getCRRAKey()
    {
        return substr($this->fields['id'], 0, 3);

    }
    
    /**
     * Turn off the Ajax status for CRRA portal.
     * 
     * @return false
     */
    public function supportsAjaxStatus()
    {
        return false;
    }
}
