local M = {}

local resp =
  vim.fn["webapi#http#get"] "https://suggestqueries.google.com/complete/search?output=chrome&hl=en&q=hi"
local suggestions =
  vim.list_slice(vim.fn["webapi#json#decode"](resp["content"]), 2)[1]

print(vim.inspect(suggestions))

return M
