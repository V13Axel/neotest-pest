# neotest-pest

This plugin provides a [Pest](https://pestphp.com) adapter for the [Neotest](https://github.com/nvim-neotest/neotest) framework.

This is a fork of `neotest-pest` originally by [@theutz](https://github.com/theutz/neotest-pest), with some fixes and updates:
- Updated to work with [Pest](https://pestphp.com) 2.0
- Support for (and automatic detection of) Laravel Sail
  - Note: This also moves junit output files into `storage/app/`

:warning: _Ive only focused on making this work for me. Please test against your Pest tests_ :warning:

## :package: Installation

Install the plugin using packer:

```lua
use({
  'nvim-neotest/neotest',
  requires = {
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

## :gift: Contributing

This fork is maintained by one guy, in my spare time and when I can get to it. Please raise a PR if you are interested in adding new functionality or fixing any bugs. When submitting a bug, please include an example test that I can test against.

To trigger the tests for the adapter, run:

```sh
./scripts/test
```

## :clap: Prior Art

This package is a fork of [neotest-pest](https://github.com/theutz/neotest-pest) by [@theutz](https://github.com/olimorris), which relied _heavily_ on [olimorris/neotest-phpunit](https://github.com/olimorris/neotest-phpunit) by [@olimorris](https://github.com/olimorris).
