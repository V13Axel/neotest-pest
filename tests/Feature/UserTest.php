<?php

/**
 * @var mixed $this
 */

use TestProject\User;

uses()->group('file group');

$makeUser = fn () => new User(18, 'John');

beforeEach(function () use ($makeUser) {
    $this->sut = $makeUser();
});

test('class constructor')
    ->expect($makeUser)
    ->name->toBe('John')
    ->age->toBe(18)
    ->favorite_movies->toBeEmpty();

test('tellName', function () {
    expect($this->sut)
        ->tellName()->toBeString()->toContain('John');
})
    ->group('special tests');

it('throws', function () {
    throw new \Exception('oops!');
});

it('is skipped')->skip();

it('can tellAge')
    ->expect($makeUser)
    ->tellAge()->toBeString()->toContain('18');

it('is false')->expect(true)->toBeFalse();

test('addFavoriteMovie')
    ->expect($makeUser)
    ->addFavoriteMovie('Avengers')
    ->toBeTrue()
    ->favorite_movies->toContain('Avengers')->toHaveLength(1);

test('removeFavoriteMovie')
    ->expect($makeUser)
    ->addFavoriteMovie('Avengers')->toBeTrue()
    ->addFavoriteMovie('Justice League')->toBeTrue()
    ->removeFavoriteMovie('Avengers')->toBeTrue()
    ->favorite_movies->not->toContain('Avengers')->toHaveLength(1);
