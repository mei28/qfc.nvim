local M = {}

-- Default configuration
M.config = {
  timeout = 3000,   -- Default timeout of 2000 milliseconds
  autoclose = true, -- Enable autoclose by default
}

-- Function to start a timer to auto close Quickfix
local timer = vim.loop.new_timer()
function M.start_qf_timer()
  if vim.bo.buftype == 'quickfix' and M.config.autoclose then
    local bufnr = vim.fn.bufnr()
    local winid = vim.fn.win_getid()
    timer:start(M.config.timeout, 0, vim.schedule_wrap(function()
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

-- Setup function to allow user configuration
function M.setup(user_config)
  M.config = vim.tbl_deep_extend('force', M.config, user_config or {})

  -- Set up autocommands for quickfix window
  vim.api.nvim_create_autocmd('WinLeave', {
    pattern = '*',
    callback = function()
      M.start_qf_timer()
    end,
  })
end

return M

