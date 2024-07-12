# qfc.nvim

<img src="https://github.com/mei28/qfc.nvim/assets/51149822/2997f892-d2ba-40ae-9870-d52fdbc45deb" alt="qfc" width="500"/>

`qfc.nvim` is a Neovim plugin that automatically manages Quickfix windows. It closes the Quickfix window after a specified timeout when the window loses focus and deletes the buffer.

## Features

- Automatically closes the Quickfix window a specified time after it loses focus.
- Deletes the Quickfix buffer after closing the window.
- Retains the plugin state between Neovim sessions.

## Installation

```lua
{
  'mei28/qfc.nvim',
  config = function()
    require('qfc').setup({
      timeout = 3000,   -- Timeout setting in milliseconds
      enabled = true, -- Enable/disable autoclose feature
    }),
   -- ft = 'qf', -- for lazy load
   -- cmd = {'QFC'} -- for lazy load 
  end
}
```


## Configuration

```lua
require('qfc').setup({
  timeout = 2000,   -- Timeout setting in milliseconds
  enabled = true, -- Enable/disable autoclose feature

})
```

### Configuration Options
* `timeout`: Specifies the timeout in milliseconds after which the Quickfix window will be automatically closed once it loses focus.
* `enabled`: Enables or disables the plugin. Set to true to enable or false to disable.
 
### Commands
* `:QFC enable` Enables the Quickfix autoclose feature.
* `:QFC disable` Disables the Quickfix autoclose feature.
* `:QFC toggle` toggle the Quickfix autoclose feature.

## License

MIT 
