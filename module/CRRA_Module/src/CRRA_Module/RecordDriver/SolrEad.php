<?php
namespace CRRA_Module\RecordDriver;
class SolrEad extends \VuFind\RecordDriver\SolrDefault
{
	


	// extract the urls from the full record
	public function getURLs()
	{

		// initialize
		$urls   = array();
		$parser = new \DOMXPath( \DOMDocument::loadXML( $this->fields[ 'fullrecord' ]));
		
		// process all the urls
		$results = $parser->query( '//url' );
		foreach ($results as $result) {
			$urls[] = array(
				'url' => $result->nodeValue,
                'desc' => $result->getAttribute( 'description' )
			);
		}
		
		// done
		return $urls;

	}

	/**
	 * Assign necessary Smarty variables and return a template name to 
	 * load in order to display holdings extracted from the base record 
	 * (i.e. URLs in MARC 856 fields) and, if necessary, the ILS driver.
	 * Returns null if no data is available.
	 *
	 * @access  public
	 * @return  string              Name of Smarty template file to display.
	 */
   
   /**
    * Get all subject headings associated with this record.  Each heading is
    * returned as an array of chunks, increasing from least specific to most
    * specific.
    *
    * @return array
    * @access protected
    */
   public function getAllSubjectHeadings()
   {
       $retVal = array();
       if (isset($this->fields['topic'])) {
           foreach ($this->fields['topic'] as $current) {
               $retVal[] = explode('--', $current);
           }
       }
       return $retVal;
   }


	public function getScopeContent()
    {
        // added by ELM (October 4, 2012)
		 return isset($this->fields['crra_scopecontent_str'])
            ? $this->fields['crra_scopecontent_str'] : '';
     //   return $this->fields['crra_scopecontent_str'];
    }

   public function getBiogHist()
   {
        // added by ELM (October 3, 2012)
        return isset($this->fields['crra_bioghist_str'])
            ? $this->fields['crra_bioghist_str'] : '';
		//return $this->fields['crra_bioghist_str'];
    }
 public function getCRRALibrary()
    {
        return $this->fields['building'][0];
    }
    
    public function getCRRAInstitution()
    {
        return $this->fields['institution'][0];

    }

	public function getCRRAKey()
    {
        return substr ($this->fields['id'], 0, 3 );

    }

	public function supportsAjaxStatus()
    {
        return false;
    }

}
?>