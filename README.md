# gsearch.nvim
gsearch is a Telescope-powered tool to allow you to use Google from neovim.

<!-- panvimdoc-ignore-start -->

You can alternatively view this all in vim by running `:help gsearch`.

<!-- panvimdoc-ignore-end -->

https://user-images.githubusercontent.com/96022404/191351709-2ab8254f-1543-4118-baa7-a8e0cf4286fa.mov

<!-- panvimdoc-ignore-start -->

## Table of Contents
- [Getting Started](#getting-started)
- [Usage](#usage)
- [Setup](#setup)
- [License](#license)

<!-- panvimdoc-ignore-end -->

## Getting Started
How to get gsearch in your neovim configuration.

### Requirements:
- [Telescope](https://github.com/nvim-telescope/telescope.nvim)
- macOS or Linux

### Installation:
With [vim-plug](https://github.com/junegunn/vim-plug)
```vim
Plug "nvim-telescope/telescope.nvim", { "tag": "0.1.0" }
Plug "dzfrias/gsearch.nvim"
```

With [packer.nvim](https://github.com/wbthomason/packer.nvim)
```lua
use {
  "dzfrias/gsearch.nvim",
  requires = { { "nvim-telescope/telescope.nvim", tag = "0.1.0" } },
}
```

## Usage
To use the lua api, run:
```lua
require("gsearch").search()
```

There is also a vim command, `Gsearch`, so you can alternatively run `:Gsearch`
to achieve the same thing as the option above.

You can also pass in Telescope options to the `search` command.

## Setup
Below are the default options for the setup function.
```lua
require("gsearch").setup {
  -- Set to false to disable the plugin
  enabled = true,
  -- Whether to include what's in your Telescope prompt in the list of
  -- suggestions
  raw_included = true,
  -- The key to use to Google search for what's in your Telescope prompt
  -- without using one of the suggestions. Note that the <s-CR> keybinding may
  -- not work on all terminals/operating systems.
  open_raw_key = "<s-CR>",
  -- The shell command to use to open the URL. As an empty string, it
  -- defaults to your OS defaults ("open" for macOS, "xdg-open" for Linux)
  open_cmd = "",
}
```
No default mappings are  provided.


## License
This plugin is licensed under the MIT license.
