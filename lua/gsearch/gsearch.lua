local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local conf = require("telescope.config").values
local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"

local M = {}

local function get_suggestions(query)
  local search = vim.fn["webapi#http#escape"](query)
  local url =
    "https://suggestqueries.google.com/complete/search?output=chrome&hl=en&q="
  local resp = vim.fn["webapi#http#get"](url .. search)
  local suggestions =
    vim.list_slice(vim.fn["webapi#json#decode"](resp["content"]), 2)[1]

  return suggestions
end

function M.search(opts)
  opts = opts or {}
  pickers
    .new(opts, {
      prompt_title = "Search Google",
      finder = finders.new_dynamic { fn = get_suggestions },
      sorter = conf.generic_sorter(opts),
      attach_mappings = function(prompt_bufnr)
        actions.select_default:replace(function()
          actions.close(prompt_bufnr)
          local selection = action_state.get_selected_entry()
          -- TODO: Handle empty selection by getting current value in prompt
          local command = "open -u https://google.com/search?q=" .. selection[1]
          os.execute(command)
        end)
        return true
      end,
    })
    :find()
end

M.search()

return M
