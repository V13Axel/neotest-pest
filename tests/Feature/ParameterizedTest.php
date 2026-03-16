<?php

// Single dataset entry
it('handles a single dataset entry', function (string $value) {
    expect($value)->toBeString();
})->with(['only one']);

// Two string datasets (original test)
it('handles parameterized values', function (string $param, string $param2) {
    expect($param)->toBeString();
    expect($param2)->toBeString();
})->with([
    ['parameter 1.1', 'parameter 1.2'],
    ['parameter 2.2', 'parameter 2.2'],
]);

// Integer inputs
it('handles integer datasets', function (int $num) {
    expect($num)->toBeInt();
})->with([1, 2, 42, -7, 0]);

// Mixed scalar types
it('handles mixed scalar types', function (mixed $value) {
    expect($value)->not->toBeNull();
})->with([
    'a string',
    42,
    3.14,
    true,
]);

// Array inputs
it('handles array datasets', function (array $input) {
    expect($input)->toBeArray()->not->toBeEmpty();
})->with([
    [[1, 2, 3]],
    [['a', 'b', 'c']],
    [['nested' => ['deeply' => 'value']]],
]);

// Named datasets
it('handles named datasets', function (int $value) {
    expect($value)->toBeGreaterThan(0);
})->with([
    'small number' => 1,
    'medium number' => 50,
    'large number' => 1000,
]);

// Multi-argument datasets
it('handles multi-argument datasets', function (string $name, int $age, bool $active) {
    expect($name)->toBeString();
    expect($age)->toBeInt();
    expect($active)->toBeBool();
})->with([
    ['Alice', 30, true],
    ['Bob', 25, false],
    ['Charlie', 0, true],
]);

// Object/stdClass input
it('handles object datasets', function (object $obj) {
    expect($obj)->toBeObject();
})->with([
    (object) ['name' => 'Alice'],
    (object) ['name' => 'Bob', 'age' => 30],
]);

// Large number of datasets (30 entries)
it('handles many datasets', function (int $num) {
    expect($num)->toBeInt()->toBeGreaterThanOrEqual(1)->toBeLessThanOrEqual(30);
})->with(range(1, 30));

// One failing dataset among passing ones
it('has a failing parameterized test', function (int $num) {
    expect($num)->toBe(1); // This will fail for the second parameter
})->with([1, 2]);

// Using test() instead of it()
test('handles datasets with test()', function (string $value) {
    expect($value)->toBeString();
})->with(['alpha', 'beta', 'gamma']);

// Empty string and whitespace edge cases
it('handles edge case strings', function (string $value) {
    expect($value)->toBeString();
})->with([
    '',
    ' ',
    'string with "quotes"',
    "string with 'single quotes'",
    "line1\nline2",
]);

// Null values in datasets
it('handles nullable datasets', function (?string $value) {
    expect(true)->toBeTrue();
})->with([
    null,
    'not null',
]);

// Repeated tests
it('runs repeatedly', function () {
    expect(true)->toBeTrue();
})->repeat(3);

// Test with "with" in the name but no ->with() (regression check for issue #3)
it('works with normal assertions', function () {
    expect(true)->toBeTrue();
});

// Describe block (issue #19)
describe('Describe Block', function () {
    it('should work inside describe', function () {
        expect(true)->toBeTrue();
    });

    it('should also work inside describe', function () {
        expect(1)->toBe(1);
    });

    // Parameterized test inside describe
    it('adds numbers', function (int $a, int $b, int $expected) {
        expect($a + $b)->toBe($expected);
    })->with([
        [1, 2, 3],
        [4, 5, 9],
    ]);
});

// Nested describe blocks
describe('Outer', function () {
    describe('Inner', function () {
        it('works when nested', function () {
            expect(true)->toBeTrue();
        });
    });

    it('works at outer level', function () {
        expect(true)->toBeTrue();
    });
});

// Describe block with a failing test
describe('Failing Describe', function () {
    it('passes inside failing describe', function () {
        expect(true)->toBeTrue();
    });

    it('fails inside failing describe', function () {
        expect(false)->toBeTrue();
    });
});
