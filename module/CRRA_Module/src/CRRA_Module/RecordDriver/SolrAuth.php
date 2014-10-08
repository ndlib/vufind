<?php

namespace CRRA_Module\RecordDriver;
    
class SolrAuth extends \VuFind\RecordDriver\SolrAuth
{
   
    public function getBibCount()
    {
	  return isset($this->fields['bibCount']) ? $this->fields['bibCount'] : '';
    }
	
}
?>
