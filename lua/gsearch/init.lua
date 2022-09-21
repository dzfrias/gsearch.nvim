local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local conf = require("telescope.config").values
local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"
local curl = require "plenary.curl"

local M = {}

local config = {
  enabled = true,
  raw_included = true,
  open_raw_key = "<s-CR>",
  open_cmd = "",
}

--- Encode the string as a url
---@param str string
local function url_encode(str)
  str = string.gsub(str, "([^0-9a-zA-Z !'()*._~-])", function(c)
    return string.format("%%%02X", string.byte(c))
  end)
  str = string.gsub(str, " ", "+")
  return str
end

--- Get the current text in the prompt box
---@param prompt_bufnr number
---@return string
local function get_prompt_val(prompt_bufnr)
  local picker = action_state.get_current_picker(prompt_bufnr)
  return picker.sorter._discard_state.prompt
end

--- Get suggestions for a given query
---@param search string
---@return string[]
local function get_suggestions(search, bufnr)
  if search == "" then
    return {}
  end
  local url =
    "https://suggestqueries.google.com/complete/search?output=chrome&hl=en&q="
  local resp = curl.request {
    url = url .. url_encode(search),
    method = "GET",
  }
  local suggestions = vim.list_slice(vim.fn.json_decode(resp.body), 2)[1]
  if config.raw_included then
    table.insert(suggestions, get_prompt_val(bufnr))
  end
  return suggestions
end

local function is_macos()
  return vim.fn.has "mac" or vim.fn.has "macunix" or vim.fn.has "gui_mac"
end

--- Get the associated command for searching with google
---@param query string
---@return string
local function get_search_cmd(query)
  local open_cmd = is_macos() and "open" or "xdg-open"
  if config.open_cmd ~= "" then
    open_cmd = config.open_cmd
  end
  local command = open_cmd
    .. " https://google.com/search?q="
    .. url_encode(query)
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
      finder = finders.new_dynamic {
        fn = function(search)
          return get_suggestions(search, vim.fn.bufnr())
        end,
      },
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
