<?php

namespace Tests\Unit;

use PHPUnit\Framework\Attributes\Test;
use PHPUnit\Framework\TestCase;

class ExamplePhpunitTest extends TestCase
{
    public function testBasicTest(): void
    {
        $this->assertTrue(true);
    }
    
    /** @test */
    public function itAssertsTrue(): void
    {
        $this->assertTrue(true);
    }
    
    #[Test]
    public function itAssertsTrueAgain(): void
    {
        $this->assertTrue(true);
    }
}
