<?php

namespace CRRA_Module\Recommend;
use VuFindSearch\Backend\Exception\RequestErrorException,
    Zend\Http\Request, Zend\StdLib\Parameters;

class AuthorityRecommend extends \VuFind\Recommend\AuthorityRecommend
{
/**
     * Current user search
     *
     * @var \VuFind\Search\Base\Results
     */
    protected $resultsForSeeAlso;
	protected $resultsForUseFor;

    /**
     * Generated recommendations
     *
     * @var array
     */
    protected $recommendationsForSeeAlso = array();
	protected $recommendationsForUseFor = array();

    /**
     * Results plugin manager
     *
     * @var \VuFind\Search\Results\PluginManager
     */
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
		//SEE Also Recommendation
        // Build an advanced search request that prevents Solr from retrieving
        // records that would already have been retrieved by a search of the biblio
        // core, i.e. it only returns results where $lookfor IS found in in the
        // "SeeAlso" search and IS NOT found in the "MainHeading" search defined
        // in authsearchspecs.yaml.
        $requestForSeeAlso = new Parameters(
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
			$this->resultsForSeeAlso = $this->results;
            $authResults = $this->resultsManager->get('SolrAuth');
            $authParams = $authResults->getParams();
            $authParams->initFromRequest($requestForSeeAlso);
            foreach ($this->filters as $filter) {
                $authParams->getOptions()->addHiddenFilter($filter);
            }
            $resultsForSeeAlso = $authResults->getResults();
        } catch (RequestErrorException $e) {
            return;
        }

        // loop through records and assign id and headings to separate arrays defined
        // above
        foreach ($resultsForSeeAlso as $result) {
            // Extract relevant details:
            $recordArray = array(
                'id' => $result->getUniqueID(),
                'heading' => $result->getBreadcrumb(),
				'BibCount' => $result->getBibCount()
            );
		
            // check for duplicates before adding record to recordSet
            if (!$this->inArrayR($recordArray['heading'], $this->recommendations)) {
                $this->recommendationsForSeeAlso = $this->recommendations;
				array_push($this->recommendationsForSeeAlso, $recordArray);
            } else {
                continue;
            }
        }
	print_r ("$this->recommendationsForSeeAlso");	
		// UseFor Recommendation
        // Build an advanced search request that prevents Solr from retrieving
        // records that would already have been retrieved by a search of the biblio
        // core, i.e. it only returns results where $lookfor IS found in in the
        // "UseFor" search and IS NOT found in the "MainHeading" search defined
        // in authsearchspecs.yaml.
        $requestForUseFor = new Parameters(
            array(
                'join' => 'AND',
                'bool0' => array('AND'),
                'lookfor0' => array($this->lookfor),
                'type0' => array('UseFor'),
                'bool1' => array('NOT'),
                'lookfor1' => array($this->lookfor),
                'type1' => array('MainHeading')
            )
        );

        // Initialise and process search (ignore Solr errors -- no reason to fail
        // just because search syntax is not compatible with Authority core):
        try {
			$this->resultsForUseFor = $this->results;
            $authResults = $this->resultsManager->get('SolrAuth');
            $authParams = $authResults->getParams();
            $authParams->initFromRequest($requestForUseFor);
            foreach ($this->filters as $filter) {
                $authParams->getOptions()->addHiddenFilter($filter);
            }
            $resultsForUseFor = $authResults->getResults();
        } catch (RequestErrorException $e) {
            return;
        }

        // loop through records and assign id and headings to separate arrays defined
        // above
        foreach ($resultsForUseFor as $result) {
            // Extract relevant details:
            $recordArray = array(
                'id' => $result->getUniqueID(),
                'heading' => $result->getBreadcrumb(),
				'BibCount' => $result->getBibCount()
            );
			
            // check for duplicates before adding record to recordSet
            if (!$this->inArrayR($recordArray['heading'], $this->recommendations)) {
                $this->recommendationsForUseFor = $this->recommendations;
				array_push($this->recommendationsForUseFor, $recordArray);
            } else {
                continue;
            }
        }
    }
	/**
     * Get recommendations (for use in the view).
     *
     * @return array
     */
    public function getRecommendationsSeeAlso()
    {
        return $this->recommendationsForSeeAlso;
    }
	 public function getRecommendationsUseFor()
    {
        return $this->recommendationsForUseFor;
    }

    /**
     * Get results stored in the object.
     *
     * @return \VuFind\Search\Base\Results
     */
    public function getResultsSeeAlso()
    {
        return $this->resultsForSeeAlso;
    }
	public function getResultsUseFor()
    {
        return $this->resultsForUseFor;
    }
}

