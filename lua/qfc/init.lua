local M = {}

local config = require('qfc.config')
local timer = require('qfc.timer')
local commands = require('qfc.commands')

-- detect if filetype / buftype matches the targets in the config, and return the timeout if matched
local function match_target(filetype, buftype)
  if not config.settings.enabled then
    return nil
  end

  for _, t in ipairs(config.settings.targets) do
    local matchFile = (t.filetype and t.filetype == filetype)
    local matchBuf  = (t.buftype and t.buftype == buftype)
    if matchFile or matchBuf then
      local timeout = t.timeout or config.settings.timeout
      return timeout
    end
  end

  return nil
end

function M.setup(user_config)
  -- load settings from setting file
  config.setup(user_config)

  -- hook all WinLeave
  vim.api.nvim_create_autocmd('WinLeave', {
    pattern = '*',
    callback = function()
      local ft = vim.bo.filetype
      local bt = vim.bo.buftype
      local bufnr = vim.fn.bufnr()
      local winid = vim.fn.win_getid()

      local matched_timeout = match_target(ft, bt)
      if matched_timeout then
        timer.start_timer(winid, bufnr, matched_timeout)
      end
    end,
  })

  -- hook all WinEnter
  vim.api.nvim_create_autocmd('WinEnter', {
    pattern = '*',
    callback = function()
      local ft = vim.bo.filetype
      local bt = vim.bo.buftype
      local winid = vim.fn.win_getid()

      local matched_timeout = match_target(ft, bt)
      if matched_timeout then
        timer.stop_timer(winid)
      end
    end,
  })
end

return M
