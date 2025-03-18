# qfc.nvim

<img src="https://github.com/mei28/qfc.nvim/assets/51149822/2997f892-d2ba-40ae-9870-d52fdbc45deb" alt="qfc" width="500"/>

`qfc.nvim` is a Neovim plugin that automatically manages Quickfix windows. It closes the Quickfix window after a specified timeout when the window loses focus and deletes the buffer.

## Features

- This plugin automatically closes certain windows (by default, Quickfix) after leaving them for a specified timeout.  
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
      targets = {
          {
            buftype = "quickfix", -- Quickfix
            timeout = 3000,       -- ms
          },
      }
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
  targets = {
      {
        buftype = "quickfix", -- Quickfix
        timeout = 3000,       -- ms
      },
      {
        filetype = "qf",      -- Quickfix
        timeout = 3000,       -- ms
      }, 
      {
        filetype = "undotree",-- undotree
        timeout = 5000,       -- ms
      }, 
  }

})
```

### Configuration Options
* `timeout`: Specifies the timeout in milliseconds after which the Quickfix window will be automatically closed once it loses focus.
* `enabled`: Enables or disables the plugin. Set to true to enable or false to disable.
* `targets`: targets: A list of tables specifying which windows to close. You can match by:
    * `buftype` = "quickfix", "help", etc.
    * `filetype` = "undotree", "Outline", etc.
 
### Commands
* `:QFC enable` Enables the Quickfix autoclose feature.
* `:QFC disable` Disables the Quickfix autoclose feature.
* `:QFC toggle` toggle the Quickfix autoclose feature.

## License

MIT 
