<?php

namespace Makefiles\Test;

use PHPUnit\Framework\TestCase;

class ClassATest extends TestCase
{
    public function testMethodA ()
    {
        $this->assertSame('a', ClassA::methodA());
    }
}
