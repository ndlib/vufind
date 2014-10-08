<?php

namespace CRRA_Module\Recommend;
use VuFindSearch\Backend\Exception\RequestErrorException,
    Zend\Http\Request, Zend\StdLib\Parameters;

class AuthorityRecommend extends \VuFind\Recommend\AuthorityRecommend
{

    /**
     * Constructor
     *
     * @param \VuFind\Search\Results\PluginManager $results Results plugin manager
     */
    public function __construct(\VuFind\Search\Results\PluginManager $results)
    {
		 $this->resultsManager = $results;
		 array_push($this->filters, "{!frange l=1}bibCount") ;
		
    }
	/**
     * process
     *
     * Called after the Search Results object has performed its main search.  This
     * may be used to extract necessary information from the Search Results object
     * or to perform completely unrelated processing.
     *
     * @param \VuFind\Search\Base\Results $results Search results object
     *
     * @return void
     */
	public function process($results)
    {
        $this->results = $results;

        // function will return blank on Advanced Search
        if ($results->getParams()->getSearchType()== 'advanced') {
            return;
        }

        // check result limit before proceeding...
        if ($this->resultLimit > 0
            && $this->resultLimit < $results->getResultTotal()
        ) {
            return;
        }

        // Build an advanced search request that prevents Solr from retrieving
        // records that would already have been retrieved by a search of the biblio
        // core, i.e. it only returns results where $lookfor IS found in in the
        // "Heading" search and IS NOT found in the "MainHeading" search defined
        // in authsearchspecs.yaml.
        $request = new Parameters(
            array(
                'join' => 'AND',
                'bool0' => array('AND'),
                'lookfor0' => array($this->lookfor),
                'type0' => array('SeeAlso'),
                'bool1' => array('NOT'),
                'lookfor1' => array($this->lookfor),
                'type1' => array('MainHeading')
            )
        );

        // Initialise and process search (ignore Solr errors -- no reason to fail
        // just because search syntax is not compatible with Authority core):
        try {
            $authResults = $this->resultsManager->get('SolrAuth');
            $authParams = $authResults->getParams();
            $authParams->initFromRequest($request);
            foreach ($this->filters as $filter) {
                $authParams->getOptions()->addHiddenFilter($filter);
            }
            $results = $authResults->getResults();
        } catch (RequestErrorException $e) {
            return;
        }

        // loop through records and assign id and headings to separate arrays defined
        // above
        foreach ($results as $result) {
            // Extract relevant details:
            $recordArray = array(
                'id' => $result->getUniqueID(),
                'heading' => $result->getBreadcrumb(),
				'BibCount' => $result->getBibCount()
            );

            // check for duplicates before adding record to recordSet
            if (!$this->inArrayR($recordArray['heading'], $this->recommendations)) {
                array_push($this->recommendations, $recordArray);
            } else {
                continue;
            }
        }
    }
}

