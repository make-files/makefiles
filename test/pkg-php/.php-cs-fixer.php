<?php

$finder = PhpCsFixer\Finder::create()
    ->in(__DIR__)
    ->exclude([
        'vendor',
    ]);
$config = new PhpCsFixer\Config();

return $config
    ->setRules([
        '@PSR2' => true,
    ])
    ->setFinder($finder);
