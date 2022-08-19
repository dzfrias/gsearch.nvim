local M = {}

local function get_suggestions(search)
  local resp = vim.fn["webapi#http#get"] "https://suggestqueries.google.com/complete/search?output=chrome&hl=en&q="
    .. vim.fn["webapi#http#escape"](search)
  local suggestions =
    vim.list_slice(vim.fn["webapi#json#decode"](resp["content"]), 2)[1]

  return suggestions
end

return M
