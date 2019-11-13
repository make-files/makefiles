<?php

namespace Makefiles\Test;

describe('INI file', function () {
    it('should read the correct file', function () {
        expect(get_cfg_var('makefiles.dev.kahlan'))->toBe('1');
    });
});
