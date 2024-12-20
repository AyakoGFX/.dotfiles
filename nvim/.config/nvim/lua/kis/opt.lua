-- Set <space> as the leader key
vim.opt.conceallevel = 2
vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.opt.cursorline = true
-- Set highlight on search
vim.o.hlsearch = true
vim.opt.spelllang = 'en_us'
vim.opt.spell = true

-- Ask for confirmation when trying to exit Neovim
vim.o.confirm = true

-- Make line numbers default
vim.wo.number = true
--
-- Set relative line numbers
vim.wo.relativenumber = true

-- Enable mouse mode
vim.o.mouse = "a"

-- Sync clipboard between OS and Neovim.
vim.o.clipboard = "unnamedplus"

-- Enable break indent
vim.o.breakindent = true

-- No swap files
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.writebackup = false
-- Save undo history
vim.o.undofile = true
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"

-- Case-insensitive searching UNLESS \C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
-- vim.wo.signcolumn = "yes"

-- Decrease update time
vim.o.updatetime = 250
vim.o.timeoutlen = 300

-- Set completeopt to have a better completion experience
vim.o.completeopt = "menuone,noselect"

-- NOTE: You should make sure your terminal supports this
vim.o.termguicolors = true

-- -- Don't show modes (insert/visual)
-- vim.opt.showmode = false
-- " Open splits on the right and below
vim.opt.inccommand = "split"
vim.opt.splitbelow = true
vim.opt.splitright = true

-- " update vim after file update from outside
vim.opt.autoread = true
-- vim.o.tabline = 0
-- " Indentation
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.smarttab = true
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.showtabline = 0
-- " Always use spaces insted of tabs
vim.opt.expandtab = true

-- " Don't wrap lines
vim.opt.wrap = false
-- " Wrap lines at convenient points
vim.opt.linebreak = false
--
-- " Start scrolling when we'are 8 lines aways from borders
vim.opt.scrolloff = 11
vim.opt.sidescrolloff = 15
vim.opt.sidescroll = 7

-- " This makes vim act like all other editors, buffers can
-- " exist in the background without being in a window.
vim.opt.hidden = true

-- " Add the g flag to search/replace by default
vim.opt.gdefault = true

-- -- Lazy redraw
-- vim.o.lazyredraw = true
--
-- -- enable trasparent
-- vim.api.nvim_set_hl(0, "normal", { bg = "none" })
-- vim.api.nvim_set_hl(0, "normalfloat", { bg = "none" })
-- vim.api.nvim_set_hl(0, "linenr", { bg = "none" })
-- vim.api.nvim_set_hl(0, "cursorlinenr", { bg = "none" })
--
vim.g.autoformat = true -- globally
-- vim.b.autoformat = false -- buffer-local
--
--
---- vim.api.nvim_create_autocmd("FileType", {
--   pattern = "cpp",
--   callback = function()
--     vim.bo.tabstop = 2
--     vim.bo.shiftwidth = 2
--     vim.bo.softtabstop = 2
--     vim.bo.expandtab = true
--   end,
-- })
