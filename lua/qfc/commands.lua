local config = require('qfc.config')

-- Subcommand implementations and completions
---@class QFCSubcommand
---@field impl fun(args:string[], opts: table) The command implementation
---@field complete? fun(subcmd_arg_lead: string): string[] (optional) Command completions callback, taking the lead of the subcommand's arguments

---@type table<string, QFCSubcommand>
local subcommand_tbl = {
  enable = {
    impl = function(args, opts)
      config.enable()
      vim.notify("QFC: enabled", vim.log.levels.INFO)
    end,
  },
  disable = {
    impl = function(args, opts)
      config.disable()
      vim.notify("QFC: disabled", vim.log.levels.INFO)
    end,
  },
  toggle = {
    impl = function(args, opts)
      config.toggle()
      vim.notify("QFC: toggled (now " .. tostring(config.settings.enabled) .. ")", vim.log.levels.INFO)
    end,
  },
}

-- Main command implementation
---@param opts table
local function qfc_cmd(opts)
  local fargs = opts.fargs
  local subcommand_key = fargs[1]
  local args = #fargs > 1 and vim.list_slice(fargs, 2, #fargs) or {}
  local subcommand = subcommand_tbl[subcommand_key]
  if not subcommand then
    vim.notify("QFC: Unknown command: " .. (subcommand_key or ""), vim.log.levels.ERROR)
    return
  end
  subcommand.impl(args, opts)
end

-- Register main command with completions
vim.api.nvim_create_user_command("QFC", qfc_cmd, {
  nargs = "+",
  desc = "Quickfix (and other windows) timer control",
  complete = function(arg_lead, cmdline, _)
    local subcmd_key, subcmd_arg_lead = cmdline:match("^['<,'>]*QFC[!]*%s(%S+)%s(.*)$")
    if subcmd_key
        and subcmd_arg_lead
        and subcommand_tbl[subcmd_key]
        and subcommand_tbl[subcmd_key].complete
    then
      return subcommand_tbl[subcmd_key].complete(subcmd_arg_lead)
    end
    if cmdline:match("^['<,'>]*QFC[!]*%s+%w*$") then
      local subcommand_keys = vim.tbl_keys(subcommand_tbl)
      return vim.iter(subcommand_keys)
          :filter(function(key)
            return key:find(arg_lead) ~= nil
          end)
          :totable()
    end
  end,
  bang = true,
})

return {}

