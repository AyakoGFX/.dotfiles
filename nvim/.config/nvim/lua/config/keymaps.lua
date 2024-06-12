local map = LazyVim.safe_keymap_set
-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
-- vim.api.nvim_set_keymap("n", "e", ":Explore<CR>", { noremap = true, silent = true })
-- Define a function to create key mappings
-- vim.api.nvim_set_keymap("n", "dd", '"_dd', { noremap = true, silent = true })

-- Move Lines
map("n", "<A-j>", "<cmd>m .+1<cr>==", { desc = "Move Down" })
map("n", "<A-k>", "<cmd>m .-2<cr>==", { desc = "Move Up" })
map("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move Down" })
map("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move Up" })
map("v", "<A-j>", ":m '>+1<cr>gv=gv", { desc = "Move Down" })
map("v", "<A-k>", ":m '<-2<cr>gv=gv", { desc = "Move Up" })
-- remap all del key
-- Send visually selected lines to the black hole register when deleted
-- vim.api.nvim_set_keymap("n", "dd", '"_dd', { noremap = true, silent = true })
-- vim.api.nvim_set_keymap("n", "dw", '"_dw', { noremap = true, silent = true })
-- vim.api.nvim_set_keymap("n", "d$", '"_d$', { noremap = true, silent = true })
-- vim.api.nvim_set_keymap("n", "d0", '"_d0', { noremap = true, silent = true })
-- vim.api.nvim_set_keymap("n", "diw", '"_diw', { noremap = true, silent = true })
-- vim.api.nvim_set_keymap("n", "di{", '"_di{', { noremap = true, silent = true })
-- vim.api.nvim_set_keymap("n", "di(", '"_di(', { noremap = true, silent = true })
-- vim.api.nvim_set_keymap("n", "di[", '"_di[', { noremap = true, silent = true })
-- vim.api.nvim_set_keymap("n", "dgg", '"_dgg', { noremap = true, silent = true })
-- vim.api.nvim_set_keymap("n", "dG", '"_dG', { noremap = true, silent = true })
-- vim.api.nvim_set_keymap("n", "d", '"_d', { noremap = true, silent = true })
-- vim.api.nvim_set_keymap("n", 'di"', '"_di"', { noremap = true, silent = true })
-- vim.api.nvim_set_keymap("n", "di'", '"_di', { noremap = true, silent = true })
-- vim.api.nvim_set_keymap("n", "C", '"_C', { noremap = true, silent = true })
-- vim.api.nvim_set_keymap("n", "cc", '"_cc', { noremap = true, silent = true })
-- vim.api.nvim_set_keymap("x", "d", '"_d', { noremap = true, silent = true })

-- put coursor  center and move page up and down
vim.api.nvim_set_keymap("n", "<C-d>", "<C-d>zz", { noremap = true })
vim.api.nvim_set_keymap("n", "<C-u>", "<C-u>zz", { noremap = true })

-- Remap U to redo
vim.api.nvim_set_keymap("n", "U", "<C-r>", { noremap = true, silent = true })

--- Navigate vim panes better
vim.keymap.set("n", "<c-k>", ":wincmd k<CR>")
vim.keymap.set("n", "<c-j>", ":wincmd j<CR>")
vim.keymap.set("n", "<c-h>", ":wincmd h<CR>")
vim.keymap.set("n", "<c-l>", ":wincmd l<CR>")

-- Remap Ctrl-Backspace to delete the previous word in insert mode
vim.api.nvim_set_keymap("i", "<C-BS>", "<C-W>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("c", "<C-W>", "<C-BS>", { noremap = true, silent = true })
-- Switch buffers
vim.api.nvim_set_keymap("n", "<Tab>", ":bnext<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-Tab>", ":bprevious<CR>", { noremap = true, silent = true })

-- Disable Ctrl+Z
vim.api.nvim_set_keymap("n", "<C-z>", "<Nop>", { noremap = true, silent = true })

-- -- floating terminal
-- local lazyterm = function() LazyVim.terminal(nil, { cwd = LazyVim.root() }) end
-- map("n", "<leader>ft", lazyterm, { desc = "Terminal (Root Dir)" })
-- map("n", "<leader>fT", function() LazyVim.terminal() end, { desc = "Terminal (cwd)" })
-- map("n", "<c-/>", lazyterm, { desc = "Terminal (Root Dir)" })
-- map("n", "<c-_>", lazyterm, { desc = "which_key_ignore" })
--
-- -- Terminal Mappings
-- map("t", "<esc><esc>", "<c-\\><c-n>", { desc = "Enter Normal Mode" })
-- map("t", "<C-h>", "<cmd>wincmd h<cr>", { desc = "Go to Left Window" })
-- map("t", "<C-j>", "<cmd>wincmd j<cr>", { desc = "Go to Lower Window" })
-- map("t", "<C-k>", "<cmd>wincmd k<cr>", { desc = "Go to Upper Window" })
-- map("t", "<C-l>", "<cmd>wincmd l<cr>", { desc = "Go to Right Window" })
-- map("t", "<C-/>", "<cmd>close<cr>", { desc = "Hide Terminal" })
-- map("t", "<c-_>", "<cmd>close<cr>", { desc = "which_key_ignore" })
--

-- local unmap = function(mode, lhs)
--   vim.api.nvim_set_keymap(mode, lhs, "", { noremap = true, silent = true })
-- end
--
-- Override the normal mode mappings
-- unmap("n", "<leader>ft")
-- unmap("n", "<leader>fT")
-- unmap("n", "<c-_>")

-- Override the terminal mode mappings
-- unmap("t", "<esc><esc>")
-- unmap("t", "<C-h>")
-- unmap("t", "<C-j>")
-- unmap("t", "<C-k>")
-- unmap("t", "<C-l>")
-- unmap("t", "<C-/>")
-- unmap("t", "<c-_>")
