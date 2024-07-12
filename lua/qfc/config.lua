local config = {}

config.settings = {
  timeout = 3000, -- Default timeout of 3000 milliseconds
  enabled = true, -- Enable the plugin by default
}

-- Function to get the path for the config file
local function get_config_path()
  return vim.fn.stdpath('data') .. '/qfc_cache'
end

-- Function to save the current configuration to a file
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

-- Function to load the configuration from a file
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
    -- If the file does not exist, save the default configuration
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
