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
