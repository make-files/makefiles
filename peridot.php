<?php

use Evenement\EventEmitterInterface;
use Peridot\Console\Environment;
use Peridot\Reporter\CodeCoverageReporters;
use Peridot\Reporter\CodeCoverage\CodeCoverageReporter;
use Peridot\Reporter\Dot\DotReporterPlugin;

error_reporting(-1);

return function (EventEmitterInterface $emitter) {
    new DotReporterPlugin($emitter);

    // set the default path
    $emitter->on('peridot.start', function (Environment $environment) {
        $environment->getDefinition()->getArgument('path')->setDefault('test/peridot');
    });

    $emitter->on('code-coverage.start', function (CodeCoverageReporter $reporter) {
        $reporter->addDirectoryToWhitelist(__DIR__ . '/src');
    });

    $coverage = new CodeCoverageReporters($emitter);
    $coverage->register();
};
