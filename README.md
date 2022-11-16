# neotest-pest

[![Tests](https://github.com/theutz/neotest-pest/actions/workflows/ci.yml/badge.svg)](https://github.com/theutz/neotest-pest/actions/workflows/ci.yml)

This plugin provides a [Pest](https://pestphp.com) adapter for the [Neotest](https://github.com/nvim-neotest/neotest) framework.

:warning: _This plugin is still in the early stages of development. Please test against your Pest tests_ :warning:

## :package: Installation

Install the plugin using packer:

```lua
use({
  'nvim-neotest/neotest',
  requires = {
    ...,
    'theutz/neotest-pest',
  },
  config = function()
    require('neotest').setup({
      ...,
      adapters = {
        require('neotest-pest'),
      }
    })
  end
})
```

## :wrench: Configuration

The plugin may be configured as below:

```lua
adapters = {
  require('neotest-pest')({
    pest_cmd = function()
      return "vendor/bin/pest"
    end
  }),
}
```

## :rocket: Usage

#### Test single method

To test a single test, hover over the test and run `lua require('neotest').run.run()`

#### Test file

To test a file run `lua require('neotest').run.run(vim.fn.expand('%'))`

#### Test directory

To test a directory run `lua require('neotest').run.run("path/to/directory")`

#### Test suite

To test the full test suite run `lua require('neotest').run.run({ suite = true })`

## :gift: Contributing

This project is maintained by the Neovim PHP community. Please raise a PR if you are interested in adding new functionality or fixing any bugs. When submitting a bug, please include an example test that we can test against.

To trigger the tests for the adapter, run:

```sh
./scripts/test
```

## :clap: Prior Art

This package is _insanely_ reliant on the excellent efforts put into [olimorris/neotest-phpunit](https://github.com/olimorris/neotest-phpunit) by [@olimorris](https://github.com/olimorris).
