-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
--

--off swap files
vim.opt.swapfile = false
--sudo pacman -S xclip
vim.opt.clipboard:append("unnamedplus")
-- sync system clipboard
--vim.opt.clipboard = 'unnamedplus'
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.softtabstop = 4
vim.o.expandtab = true

-- vim.api.nvim_create_autocmd("FileType", {
--   pattern = "cpp",
--   callback = function()
--     vim.bo.tabstop = 4
--     vim.bo.shiftwidth = 4
--     vim.bo.softtabstop = 4
--     vim.bo.expandtab = true
--   end,
-- })
