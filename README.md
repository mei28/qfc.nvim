# qfc.nvim

`qfc.nvim` is a Neovim plugin that automatically manages Quickfix windows. It closes the Quickfix window after a specified timeout when the window loses focus and deletes the buffer.

## Features

- Automatically closes the Quickfix window a specified time after it loses focus.
- Deletes the Quickfix buffer after closing the window.

## Installation

```
{
  'mei28/qfc.nvim',
  config = function()
    require('qfc').setup({
      timeout = 3000,   -- Timeout setting in milliseconds
      autoclose = true, -- Enable/disable autoclose feature
    })
  end
}
```

## Configuration

```lua
require('qfc').setup({
  timeout = 2000,   -- Timeout setting in milliseconds
  autoclose = true, -- Enable/disable autoclose feature
})
```

### Configuration Options

- timeout: Specifies the timeout in milliseconds after which the Quickfix window will be automatically closed once it loses focus.
- autoclose: Enables or disables the autoclose feature. Set to true to enable or false to disable.

## License

MIT 
