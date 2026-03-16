# neotest-pest

This plugin provides a [Pest](https://pestphp.com) adapter for the [Neotest](https://github.com/nvim-neotest/neotest) framework.

This is a fork of `neotest-pest` originally by [@theutz](https://github.com/theutz/neotest-pest), with fixes and updates:

- Support for Pest 2, 3, and 4 (PHPUnit 10, 11, and 12)
- Parameterized test support (`->with()` datasets, named datasets, `->repeat()`)
- `describe()` block support (including nested describe blocks)
- Support for (and automatic detection of) Laravel Sail
  - Note: This also moves junit output files into `storage/app/`
- Parallel testing support
- Compact output printer support

## :package: Installation

Install the plugin using your favorite package manager.

Here's an example using lazy.nvim:

```lua
{
    'nvim-neotest/neotest',
    dependencies = {
        ...,
        'V13Axel/neotest-pest',
    },
    config = function()
        require('neotest').setup({
            ...,
            adapters = {
                require('neotest-pest'),
            }
        })
    end
}
```

## :wrench: Configuration

> [!TIP]
> Any of these options can be set to a lua function that returns the desired result. For example, wanna run tests in parallel, one for each CPU core?
> `parallel = function() return #vim.loop.cpu_info() end,`

```lua
adapters = {
    require('neotest-pest')({
        -- Ignore these directories when looking for tests
        -- -- Default: { "vendor", "node_modules" }
        ignore_dirs = { "vendor", "node_modules" }

        -- Ignore any projects containing "phpunit-only.tests"
        -- -- Default: {}
        root_ignore_files = { "phpunit-only.tests" },

        -- Specify suffixes for files that should be considered tests
        -- -- Default: { "Test.php" }
        test_file_suffixes = { "Test.php", "_test.php", "PestTest.php" },

        -- Sail not properly detected? Explicitly enable it.
        -- -- Default: function() that checks for sail presence
        sail_enabled = function() return false end,

        -- Custom sail executable. Not running in Sail, but running bare Docker?
        -- Set `sail_enabled` = true and `sail_executable` to { "docker", "exec", "[somecontainer]" }
        -- -- Default: "vendor/bin/sail"
        sail_executable = "vendor/bin/sail",

        -- Custom sail project root path.
        -- -- Default: "/var/www/html"
        sail_project_path = "/var/www/html",

        -- Custom pest binary.
        -- -- Default: function that checks for sail presence
        pest_cmd = "vendor/bin/pest",

        -- Run N tests in parallel, <=1 doesn't pass --parallel to pest at all
        -- -- Default: 0
        parallel = 16

        -- Enable ["compact" output printer](https://pestphp.com/docs/optimizing-tests#content-compact-printer)
        -- -- Default: false
        compact = false,

        -- Set a custom path for the results XML file, parsed by this adapter
        --
        ------------------------------------------------------------------------------------
        -- NOTE: This must be a path accessible by both your test runner AND your editor! --
        ------------------------------------------------------------------------------------
        --
        -- -- Default: function that checks for sail presence.
        -- --      - If no sail: Numbered file in randomized /tmp/ directory (using async.fn.tempname())
        -- --      - If sail: "storage/app/" .. os.date("junit-%Y%m%d-%H%M%S")
        results_path = function() "/some/accessible/path" end,
    }),
}
```

## :rocket: Usage

#### Test single method

To test a single test, hover over the test and run `lua require('neotest').run.run()`.

As an example, I have mine setup with <leader>t(est)n(earest) as such:

```lua
vim.keymap.set('n', '<leader>tn', function() require('neotest').run.run() end)
```

#### Test file

To test a file run `lua require('neotest').run.run(vim.fn.expand('%'))`

Example - <leader>t(est)f(ile):

```lua
vim.keymap.set('n', '<leader>tf', function() require('neotest').run.run(vim.fn.expand('%')) end)
```

#### Test directory

To test a directory run `lua require('neotest').run.run("path/to/directory")`

#### Test suite

To test the full test suite run `lua require('neotest').run.run({ suite = true })`

## Supported test types

The adapter supports the following Pest test patterns:

```php
// Basic tests
it('does something', function () { ... });
test('does something', function () { ... });

// Parameterized tests with datasets
it('handles values', function (int $value) { ... })->with([1, 2, 3]);

// Named datasets
it('handles values', function (int $value) { ... })->with([
    'small' => 1,
    'large' => 100,
]);

// Repeated tests
it('is consistent', function () { ... })->repeat(3);

// Describe blocks
describe('Feature', function () {
    it('works', function () { ... });
});

// Nested describe blocks
describe('Outer', function () {
    describe('Inner', function () {
        it('works', function () { ... });
    });
});

// Parameterized tests inside describe blocks
describe('Math', function () {
    it('adds', function (int $a, int $b, int $expected) { ... })->with([
        [1, 2, 3],
        [4, 5, 9],
    ]);
});
```

Running "nearest test" on a `describe()` line will run all tests inside that block, for example.

## :gift: Contributing

I'm just one guy, maintaining this in my spare time and when I can get to it. Please raise a PR if you are interested in adding new functionality or fixing any bugs. When submitting a bug, please include an example test that I can test against.

To trigger the tests for the adapter, run:

```sh
./scripts/test
```

## :clap: Prior Art

This package is a fork of [neotest-pest](https://github.com/theutz/neotest-pest) by [@theutz](https://github.com/olimorris), which relied _heavily_ on [olimorris/neotest-phpunit](https://github.com/olimorris/neotest-phpunit) by [@olimorris](https://github.com/olimorris).
