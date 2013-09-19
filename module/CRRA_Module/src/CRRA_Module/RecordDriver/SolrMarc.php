<?php
namespace CRRA_Module\RecordDriver;
class SolrMarc extends \VuFind\RecordDriver\SolrMarc
{
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