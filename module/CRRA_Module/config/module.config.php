<?php
namespace CRRA_Module\Module\Configuration;

$config = ['vufind' => [
        'plugin_managers' => [
            'recorddriver' => [
                'factories' => [
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
                ]
            ],
        ],
    ],
];

return $config;
