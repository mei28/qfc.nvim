local config = require('qfc.config')
local timer = vim.loop.new_timer()

local M = {}

-- Function to start the timer
function M.start_qf_timer()
  if vim.bo.buftype == 'quickfix' and config.settings.enabled then
    local bufnr = vim.fn.bufnr()
    local winid = vim.fn.win_getid()
    timer:start(config.settings.timeout, 0, vim.schedule_wrap(function()
      -- Check if the window still exists and is a quickfix window
      if vim.fn.bufexists(bufnr) == 1 and vim.fn.win_gotoid(winid) == 1 then
        vim.cmd('cclose')
        -- Ensure the buffer is also deleted if it still exists
        if vim.fn.bufexists(bufnr) == 1 then
          vim.cmd('bdelete ' .. bufnr)
        end
      end
    end))
  end
end

-- Function to stop the timer
function M.stop_qf_timer()
  if timer:is_active() then
    timer:stop()
  end
end

return M
