<?php

namespace Makefiles\Test;

use PHPUnit\Framework\TestCase;

class ClassATest extends TestCase
{
    public function testMethodA(): void
    {
        $this->assertSame('a', ClassA::methodA());
    }
}
