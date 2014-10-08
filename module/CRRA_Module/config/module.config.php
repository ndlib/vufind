<?php
namespace CRRA_Module\Module\Configuration;

$config = array('vufind' => array(
        'plugin_managers' => array(
	    'recommend' => array(
		'factories' => array(
		     'authorityrecommend' => 'CRRA_Module\Recommend\Factory::getAuthorityRecommend',
		),			
            ),	
	    'recorddriver' => array(
                'factories' => array(
                    'solrmarc' => function ($sm) {
                        $driver = new \CRRA_Module\RecordDriver\SolrMarc(
                            $sm->getServiceLocator()->get('VuFind\Config')->get('config'),
                            null,
                            $sm->getServiceLocator()->get('VuFind\Config')->get('searches')
                        );
                        $driver->attachILS(
                            $sm->getServiceLocator()->get('VuFind\ILSConnection'),
                            $sm->getServiceLocator()->get('VuFind\ILSHoldLogic'),
                            $sm->getServiceLocator()->get('VuFind\ILSTitleHoldLogic')
                        );
                        return $driver;
                    },
					'solread' => function ($sm) {
                        $driver = new \CRRA_Module\RecordDriver\SolrEad(
                            $sm->getServiceLocator()->get('VuFind\Config')->get('config'),
                            null,
                            $sm->getServiceLocator()->get('VuFind\Config')->get('searches')
                        );
						return $driver;	
                    },						
                    'solrpp' => function ($sm) {
                        $driver = new \CRRA_Module\RecordDriver\SolrPp(
                            $sm->getServiceLocator()->get('VuFind\Config')->get('config'),
                            null,
                            $sm->getServiceLocator()->get('VuFind\Config')->get('searches')
                        );
						return $driver;								
                    },
		    'solrauth' => function ($sm) {
					$driver = new \CRRA_Module\RecordDriver\SolrAuth(
                         $sm->getServiceLocator()->get('VuFind\Config')->get('config'),
                            null,
                            $sm->getServiceLocator()->get('VuFind\Config')->get('searches')
                        );
					$driver->attachILS(
                            $sm->getServiceLocator()->get('VuFind\ILSConnection'),
                            $sm->getServiceLocator()->get('VuFind\ILSHoldLogic'),
                            $sm->getServiceLocator()->get('VuFind\ILSTitleHoldLogic')
                        );
						return $driver;	
                    },
                )
            ),
	   'search_backend' => array(
                'factories' => array(
					'SolrAuth' => '\CRRA_Module\Search\Factory\SolrAuthBackendFactory'
		),
	   ), 
        ),
    ),
);

return $config;
