local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local conf = require("telescope.config").values
local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"

local M = {}

local config = {
  enabled = true,
  open_raw_key = "<s-CR>",
}

--- Get suggestions for a given query
---@param query string
---@return string[]
local function get_suggestions(query)
  local search = vim.fn["webapi#http#escape"](query)
  local url =
    "https://suggestqueries.google.com/complete/search?output=chrome&hl=en&q="
  local resp = vim.fn["webapi#http#get"](url .. search)
  local suggestions =
    vim.list_slice(vim.fn["webapi#json#decode"](resp["content"]), 2)[1]
  return suggestions
end

--- Get the current text in the prompt box
---@param prompt_bufnr number
---@return string
local function get_prompt_val(prompt_bufnr)
  local picker = action_state.get_current_picker(prompt_bufnr)
  return picker.sorter._discard_state.prompt
end

local function is_macos()
  return vim.fn.has "mac" or vim.fn.has "macunix" or vim.fn.has "gui_mac"
end

--- Get the associated command for searching with google
---@param query string
---@return string
local function get_search_cmd(query)
  local search = vim.fn["webapi#http#escape"](query)
  local open_cmd = is_macos() and "open" or "xdg-open"
  local command = open_cmd .. " https://google.com/search?q=" .. search
  return command
end

function M.setup(opts)
  config = vim.tbl_deep_extend("force", config, opts or {})
end

function M.search(opts)
  if not config.enabled then
    return
  end
  opts = opts or {}
  pickers
    .new(opts, {
      prompt_title = "Search Google",
      finder = finders.new_dynamic { fn = get_suggestions },
      sorter = conf.generic_sorter(opts),
      attach_mappings = function(prompt_bufnr, map)
        map("i", config.open_raw_key, function()
          local prompt_val = get_prompt_val(prompt_bufnr)
          local command = get_search_cmd(prompt_val)
          actions.close(prompt_bufnr)
          os.execute(command)
        end)

        actions.select_default:replace(function()
          local prompt_val = get_prompt_val(prompt_bufnr)
          actions.close(prompt_bufnr)
          local selection = action_state.get_selected_entry()
          if selection == nil then
            selection = { prompt_val }
          end
          local command = get_search_cmd(selection[1])
          os.execute(command)
        end)

        return true
      end,
    })
    :find()
end

return M
