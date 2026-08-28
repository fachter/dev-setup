-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- Herdr prefix+e writes pane scrollback to a temp file like
-- herdr-scrollback-<pid>-<nanos>-<attempt>.txt
vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
  group = vim.api.nvim_create_augroup("herdr_scrollback", { clear = true }),
  pattern = "*/herdr-scrollback-*.txt",
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = true
  end,
})
