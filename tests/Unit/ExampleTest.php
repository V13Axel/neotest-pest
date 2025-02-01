<?php

test('example', function ($value, $value2) {
    expect($value)->toBeTrue();
})->with([
    ["some string", false],
    [[], true],
]);

// test("double quote example", function () {
//     expect(true)->toBeTrue();
// });
