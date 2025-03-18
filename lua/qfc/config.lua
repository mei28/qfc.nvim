local config = {}

config.settings = {
  timeout = 3000, -- default time to close(ms)
  enabled = true, -- enable auto close

  targets = {
    {
      buftype = "quickfix",
      timeout = 3000,
    },
  },
}

-- Path to save settings to file
local function get_config_path()
  return vim.fn.stdpath('data') .. '/qfc_cache'
end

-- save settings to file
local function save_config()
  local config_path = get_config_path()
  local file = io.open(config_path, "w")
  if file then
    file:write(config.settings.enabled and "true" or "false")
    file:close()
  else
    vim.api.nvim_err_writeln("Failed to save config to " .. config_path)
  end
end

-- load settings from setting file 
local function load_config()
  local config_path = get_config_path()
  local file = io.open(config_path, "r")
  if file then
    local content = file:read("*a")
    file:close()
    if content == "true" then
      config.settings.enabled = true
    elseif content == "false" then
      config.settings.enabled = false
    end
  else
    save_config()
  end
end

function config.setup(user_config)
  config.settings = vim.tbl_deep_extend('force', config.settings, user_config or {})
  load_config()
end

function config.enable()
  config.settings.enabled = true
  save_config()
end

function config.disable()
  config.settings.enabled = false
  save_config()
end

function config.toggle()
  config.settings.enabled = not config.settings.enabled
  save_config()
end

return config

