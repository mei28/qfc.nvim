local M = {}

-- Default configuration
M.config = {
  timeout = 3000, -- Default timeout of 3000 milliseconds
  enabled = true, -- Enable the plugin by default
}

-- Timer to handle auto close
local timer = vim.loop.new_timer()

-- Function to get the path for the config file
local function get_config_path()
  return vim.fn.stdpath('data') .. '/qfc_cache'
end

-- Function to save the current configuration to a file
local function save_config()
  local config_path = get_config_path()
  local file = io.open(config_path, "w")
  if file then
    file:write(M.config.enabled and "true" or "false")
    file:close()
  else
    vim.api.nvim_err_writeln("Failed to save config to " .. config_path)
  end
end

-- Function to load the configuration from a file
local function load_config()
  local config_path = get_config_path()
  local file = io.open(config_path, "r")
  if file then
    local content = file:read("*a")
    file:close()
    if content == "true" then
      M.config.enabled = true
    elseif content == "false" then
      M.config.enabled = false
    end
  else
    -- If the file does not exist, save the default configuration
    save_config()
  end
end

-- Function to start the timer
function M.start_qf_timer()
  if vim.bo.buftype == 'quickfix' and M.config.enabled then
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

-- Function to stop the timer
function M.stop_qf_timer()
  if timer:is_active() then
    timer:stop()
  end
end

-- Function to enable the plugin
function M.enable()
  M.config.enabled = true
  save_config()
end

-- Function to disable the plugin
function M.disable()
  M.config.enabled = false
  save_config()
end

-- Function to toggle the plugin
function M.toggle()
  M.config.enabled = not M.config.enabled
  save_config()
end

-- Setup function to allow user configuration
function M.setup(user_config)
  M.config = vim.tbl_deep_extend('force', M.config, user_config or {})
  load_config()

  -- Set up autocommands for quickfix window
  vim.api.nvim_create_autocmd('WinLeave', {
    pattern = '*',
    callback = function()
      if vim.bo.buftype == 'quickfix' then
        M.start_qf_timer()
      end
    end,
  })

  vim.api.nvim_create_autocmd('WinEnter', {
    pattern = '*',
    callback = function()
      if vim.bo.buftype == 'quickfix' then
        M.stop_qf_timer()
      end
    end,
  })

  -- Create user commands
  vim.api.nvim_create_user_command('EnableQFC', function() M.enable() end, {})
  vim.api.nvim_create_user_command('DisableQFC', function() M.disable() end, {})
  vim.api.nvim_create_user_command('ToggleQFC', function() M.toggle() end, {})
end

return M
