<?php

namespace Makefiles\Test;

use PHPUnit\Framework\TestCase;

class FixtureTest extends TestCase
{
    public function testFixture ()
    {
        $this->assertSame("fixture\n", file_get_contents(__DIR__ . '/fixture'));
    }
}
