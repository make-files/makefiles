<?php

namespace Makefiles\Test;

describe('ClassA', function () {
    describe('methodA', function () {
        it('returns "a"', function () {
            expect(ClassA::methodA())->toBe('a');
        });
    });
});
