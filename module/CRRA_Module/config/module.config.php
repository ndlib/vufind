<?php
namespace CRRA_Module\Module\Configuration;

$config = [
    'vufind' => [
        'plugin_managers' => [
            'recorddriver' => [
                'factories' => [
                    'solrmarc' => 'CRRA_Module\RecordDriver\Factory::getSolrMarc',
                    'solread' => 'CRRA_Module\RecordDriver\Factory::getSolrEAD',
                    'solrpp' => 'CRRA_Module\RecordDriver\Factory::getSolrPP'
                ]
            ]
        ]
    ]
];

return $config;
