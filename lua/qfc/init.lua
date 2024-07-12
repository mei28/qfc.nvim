local M = {}

local config = require('qfc.config')
local timer = require('qfc.timer')
local commands = require('qfc.commands')

M.config = config

-- Setup function to allow user configuration
function M.setup(user_config)
  config.setup(user_config)

  -- Set up autocommands for quickfix window
  vim.api.nvim_create_autocmd('WinLeave', {
    pattern = '*',
    callback = function()
      if vim.bo.buftype == 'quickfix' then
        timer.start_qf_timer()
      end
    end,
  })

  vim.api.nvim_create_autocmd('WinEnter', {
    pattern = '*',
    callback = function()
      if vim.bo.buftype == 'quickfix' then
        timer.stop_qf_timer()
      end
    end,
  })
end

return M
