<?php

namespace Makefiles\Test;

use PHPUnit\Framework\TestCase;

class IniTest extends TestCase
{
    public function testIni()
    {
        $this->assertSame('1', get_cfg_var('makefiles.dev.phpunit'));
    }
}
