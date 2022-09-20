if vim.fn.has "nvim-0.7.0" ~= 1 then
  vim.api.nvim_err_writeln "gsearch requires at least nvim-0.7.0."
  return
end

if vim.g.loaded_gsearch == 1 then
  return
end
vim.g.loaded_gsearch = 1

local gsearch = require "gsearch.gsearch"
vim.api.nvim_create_user_command("Gsearch", gsearch.search, {})
