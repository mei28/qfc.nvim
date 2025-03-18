local config = require('qfc.config')

local M = {}

-- the table to hold timers for each winid
M.timers = {}

-- close the window if it is still open
local function close_window(winid, bufnr)
  -- ウィンドウが有効かどうかチェック
  if vim.api.nvim_win_is_valid(winid) then
    -- Quickfixだけは cclose、それ以外は nvim_win_close
    local wbufnr = vim.api.nvim_win_get_buf(winid)
    local wbt = vim.api.nvim_buf_get_option(wbufnr, 'buftype')
    if wbt == 'quickfix' then
      vim.cmd('cclose')
    else
      pcall(vim.api.nvim_win_close, winid, true) -- force=true
    end
  end

  -- バッファが残っていれば削除
  if vim.api.nvim_buf_is_valid(bufnr) and vim.api.nvim_buf_is_loaded(bufnr) then
    pcall(vim.api.nvim_buf_delete, bufnr, { force = true })
  end
end
-- start timer for the window
function M.start_timer(winid, bufnr, timeout)
  -- if the timer exists, stop it and close the window
  if M.timers[winid] then
    if M.timers[winid]:is_active() then
      M.timers[winid]:stop()
    end
    M.timers[winid]:close()
    M.timers[winid] = nil
  end

  local uv_timer = vim.loop.new_timer()
  M.timers[winid] = uv_timer

  -- 第1引数が delay, 第2引数が repeat
  uv_timer:start(timeout, 0, vim.schedule_wrap(function()
    close_window(winid, bufnr)
    uv_timer:stop()
    uv_timer:close()
    M.timers[winid] = nil
  end))
end

-- stop the timer for the window
function M.stop_timer(winid)
  local uv_timer = M.timers[winid]
  if uv_timer and uv_timer:is_active() then
    uv_timer:stop()
    uv_timer:close()
  end
  M.timers[winid] = nil
end

return M
