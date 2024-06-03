require("config.lazy")
--add if facing error with transparent settings
require("ibl")
-- <leader> key
--vim.g.mapleader = ' '
-- added comment
-- require("vscode").load("light")
-- require("vscode").load("dark")
-- Set colorscheme when Neovim starts
--vim.cmd("colorscheme tokyonight-night")
-- vim.cmd("colorscheme catppuccin")
--vim.cmd("colorscheme tokyonight-night")
require("luarocks-nvim")
-- remap all del key
-- Send visually selected lines to the black hole register when deleted
vim.api.nvim_set_keymap("n", "dd", '"_dd', { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "dw", '"_dw', { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "d$", '"_d$', { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "d0", '"_d0', { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "diw", '"_diw', { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "di{", '"_di{', { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "di(", '"_di(', { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "di[", '"_di[', { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "dgg", '"_dgg', { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "dG", '"_dG', { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "d", '"_d', { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", 'di"', '"_di"', { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "di'", '"_di', { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "C", '"_C', { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "cc", '"_cc', { noremap = true, silent = true })
vim.api.nvim_set_keymap("x", "d", '"_d', { noremap = true, silent = true })

--off swap files
vim.opt.swapfile = false
-- move selected line up and down N & V mode {note} press shift and JK
vim.api.nvim_set_keymap("v", "K", ":'<,'>m '<-2<CR>gv=gv", { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "J", ":'<,'>m '>+1<CR>gv=gv", { noremap = true, silent = true })
--vim.api.nvim_set_keymap('n', 'K', ':m .-2<CR>==', { noremap = true, silent = true })
--vim.api.nvim_set_keymap('n', 'J', ':m .+1<CR>==', { noremap = true, silent = true })

-- put coursor  center and move page up and down
vim.api.nvim_set_keymap("n", "<C-d>", "<C-d>zz", { noremap = true })
vim.api.nvim_set_keymap("n", "<C-u>", "<C-u>zz", { noremap = true })

-- Remap U to redo
vim.api.nvim_set_keymap("n", "U", "<C-r>", { noremap = true, silent = true })

-- Disable Ctrl+Z
vim.api.nvim_set_keymap("n", "<C-z>", "<Nop>", { noremap = true, silent = true })
--vim-tmux-navator
-- save
--- Navigate vim panes better
vim.keymap.set("n", "<c-k>", ":wincmd k<CR>")
vim.keymap.set("n", "<c-j>", ":wincmd j<CR>")
vim.keymap.set("n", "<c-h>", ":wincmd h<CR>")
vim.keymap.set("n", "<c-l>", ":wincmd l<CR>")
-- -- enable trasparent
vim.api.nvim_set_hl(0, "normal", { bg = "none" })
vim.api.nvim_set_hl(0, "normalfloat", { bg = "none" })
vim.api.nvim_set_hl(0, "linenr", { bg = "none" })
vim.api.nvim_set_hl(0, "cursorlinenr", { bg = "none" })
-- end

-- Remap Ctrl-Backspace to delete the previous word in insert mode
vim.api.nvim_set_keymap("i", "<C-BS>", "<C-W>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("c", "<C-W>", "<C-BS>", { noremap = true, silent = true })
-- Switch buffers
vim.api.nvim_set_keymap("n", "<Tab>", ":bnext<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-Tab>", ":bprevious<CR>", { noremap = true, silent = true })

-- Keybinding to open dashboard-nvim when pressing <leader>rd
vim.api.nvim_set_keymap("n", "<leader>rd", ":Dashboard<CR>", { noremap = true, silent = true })
--vim.keymap.set({ 'n', 'v' }, 'j', 'h')
--vim.keymap.set({ 'n', 'v' }, 'k', 'j')
--vim.keymap.set({ 'n', 'v' }, 'l', 'k')
--vim.keymap.set({ 'n', 'v' }, ';', 'l')

-- Remap j to Ctrl-n and k to Ctrl-p in insert mode
--vim.api.nvim_set_keymap('i', 'j', '<C-n>', {noremap = true, silent = true})
---vim.api.nvim_set_keymap('i', 'k', '<C-p>', {noremap = true, silent = true})

-- repeat previous f, t, F or T movement KJJJJK
--vim.keymap.set('n', '\'', ';')

-- paste without overwriting
--vim.keymap.set('v', 'p', 'P')
-- clear search highlighting
--vim.keymap.set('n', '<Esc>', ':nohlsearch<cr>')

-- skip folds (down, up)
--vim.cmd('nmap k gj')
--vim.cmd('nmap l gk')

-- sync system clipboard
--vim.opt.clipboard = 'unnamedplus'

-- Set clipboard to use system clipboard lua
-- if not working install xclip
--sudo pacman -S xclip
vim.opt.clipboard:append("unnamedplus")

-- search ignoring case
--vim.opt.ignorecase = true

-- disable "ignorecase" option if the search pattern contains upper case characters
--vim.opt.smartcase = true
--

-- lua/config/keymaps.lua
if vim.g.neovide then
  -- Set the transparency level for floating windows
  vim.opt.winblend = 75
  -- Set the transparency level for popup menu
  vim.opt.pumblend = 75
  vim.g.neovide_refresh_rate = 144
  vim.g.neovide_refresh_rate_idle = 10
  vim.g.neovide_window_blurred = true
  vim.g.neovide_remember_window_size = true
  vim.g.neovide_fullscreen = true
  -- enables the profiler, which shows a frametime graph in the upper left corner.
  vim.g.neovide_profiler = false

  vim.g.neovide_floating_blur_amount_x = 4.0
  vim.g.neovide_floating_blur_amount_y = 4.0

  vim.g.neovide_floating_shadow = true
  vim.g.neovide_transparency = 0.6
  vim.g.neovide_floating_z_height = 10
  vim.g.neovide_light_angle_degrees = 45
  vim.g.neovide_light_radius = 5
  vim.g.neovide_cursor_smooth_blink = true

  -- Dynamically Change The Scale At Runtime?
  vim.g.neovide_scale_factor = 1.03
  local change_scale_factor = function(delta)
    vim.g.neovide_scale_factor = vim.g.neovide_scale_factor * delta
  end
  vim.keymap.set("n", "<C-=>", function()
    change_scale_factor(1.06)
  end)
  vim.keymap.set("n", "<C-->", function()
    change_scale_factor(1 / 1.06)
  end)
end
