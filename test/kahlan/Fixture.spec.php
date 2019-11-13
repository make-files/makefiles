<?php

namespace Makefiles\Test;

describe('Fixture', function () {
    it('should be out of date when fixture files change', function () {
        expect(file_get_contents(dirname(__DIR__) . '/fixture'))->toBe("fixture\n");
    });
});
