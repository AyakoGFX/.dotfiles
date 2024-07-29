-- Check if <Esc> is already mapped in normal mode
--
-- if vim.fn.maparg('<Esc>', 'n') == '' then
--   -- Define the mapping
--   vim.api.nvim_set_keymap('n', '<Esc>', ':nohlsearch<CR><C-R>=has("diff")?"<Bar>diffupdate":""<CR><CR><Esc>', { noremap = true, silent = true })
-- end

-- Map Ctrl + S to save in normal mode
vim.api.nvim_set_keymap('n', '<C-s>', ':w<CR>', { noremap = true, silent = true })
--
-- Keymap to close the current buffer with a description
vim.keymap.set('n', '<leader>bd', ':bd<CR>', { desc = 'Close current buffer', noremap = true, silent = true })

-- Keymap to close the current window with a description
vim.keymap.set('n', '<leader>wd', ':close<CR>', { desc = 'Close current window', noremap = true, silent = true })
--
-- -- Keymap to split the window vertically with a description
-- vim.keymap.set('n', '<leader>|', ':vsplit<CR>', { desc = 'Vertical split', noremap = true, silent = true })
--
-- -- Keymap to split the window horizontally with a description
-- vim.keymap.set('n', '<leader>-', ':split<CR>', { desc = 'Horizontal split', noremap = true, silent = true })

-- Resize window using <ctrl> arrow keys
vim.api.nvim_set_keymap("n", "<C-Up>", "<cmd>resize +2<CR>", { noremap = true, silent = true, desc = "Increase Window Height" })
vim.api.nvim_set_keymap("n", "<C-Down>", "<cmd>resize -2<CR>", { noremap = true, silent = true, desc = "Decrease Window Height" })
vim.api.nvim_set_keymap("n", "<C-Left>", "<cmd>vertical resize -2<CR>", { noremap = true, silent = true, desc = "Decrease Window Width" })
vim.api.nvim_set_keymap("n", "<C-Right>", "<cmd>vertical resize +2<CR>", { noremap = true, silent = true, desc = "Increase Window Width" })

-- Move Lines
vim.api.nvim_set_keymap("n", "<A-j>", "<cmd>m .+1<CR>==", { noremap = true, silent = true, desc = "Move Down" })
vim.api.nvim_set_keymap("n", "<A-k>", "<cmd>m .-2<CR>==", { noremap = true, silent = true, desc = "Move Up" })
vim.api.nvim_set_keymap("i", "<A-j>", "<Esc><cmd>m .+1<CR>==gi", { noremap = true, silent = true, desc = "Move Down" })
vim.api.nvim_set_keymap("i", "<A-k>", "<Esc><cmd>m .-2<CR>==gi", { noremap = true, silent = true, desc = "Move Up" })
vim.api.nvim_set_keymap("v", "<A-j>", ":m '>+1<CR>gv=gv", { noremap = true, silent = true, desc = "Move Down" })
vim.api.nvim_set_keymap("v", "<A-k>", ":m '<-2<CR>gv=gv", { noremap = true, silent = true, desc = "Move Up" })


-- Clear search with <esc>
vim.api.nvim_set_keymap("i", "<esc>", "<cmd>noh<CR><esc>", { noremap = true, silent = true, desc = "Escape and Clear hlsearch" })
vim.api.nvim_set_keymap("n", "<esc>", "<cmd>noh<CR><esc>", { noremap = true, silent = true, desc = "Escape and Clear hlsearch" })


-- better indenting
vim.api.nvim_set_keymap("v", "<", "<gv", { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", ">", ">gv", { noremap = true, silent = true })

-- split Window
vim.api.nvim_set_keymap("n", "<leader>-", "<C-W>s", { noremap = true, silent = true, desc = "Split Window Below" })
vim.api.nvim_set_keymap("n", "<leader>|", "<C-W>v", { noremap = true, silent = true, desc = "Split Window Right" })


-- put coursor  center and move page up and down
vim.api.nvim_set_keymap("n", "<C-d>", "<C-d>zz", { noremap = true })
vim.api.nvim_set_keymap("n", "<C-u>", "<C-u>zz", { noremap = true })

-- Remap U to redo
vim.api.nvim_set_keymap("n", "U", "<C-r>", { noremap = true, silent = true })

-- vim.api.nvim_set_keymap('n', '<Leader>y', '"+y', { noremap = true })
-- vim.api.nvim_set_keymap('n', '<Leader>p', '"+p', { noremap = true })
-- vim.api.nvim_set_keymap('n', '<Leader>Y', '"+y', { noremap = true })
-- vim.api.nvim_set_keymap('n', '<Leader>P', '"+p', { noremap = true })

-- Remap Ctrl-Backspace to delete the previous word in insert mode
-- vim.api.nvim_set_keymap("i", "<C-BS>", "<C-W>", { noremap = true, silent = true })
-- vim.api.nvim_set_keymap("c", "<C-W>", "<C-BS>", { noremap = true, silent = true })
-- Obsidian
--
-- vim.keymap.set("n", "<leader>oc", "<cmd>lua require('obsidian').util.toggle_checkbox()<CR>", { desc = "Obsidian Check Checkbox" })
-- vim.keymap.set("n", "<leader>ot", "<cmd>ObsidianTemplate<CR>", { desc = "Insert Obsidian Template" })
-- vim.keymap.set("n", "<leader>oo", "<cmd>ObsidianOpen<CR>", { desc = "Open in Obsidian App" })
-- vim.keymap.set("n", "<leader>ob", "<cmd>ObsidianBacklinks<CR>", { desc = "Show ObsidianBacklinks" })
-- vim.keymap.set("n", "<leader>ol", "<cmd>ObsidianLinks<CR>", { desc = "Show ObsidianLinks" })
-- vim.keymap.set("n", "<leader>on", "<cmd>ObsidianNew<CR>", { desc = "Create New Note" })
-- vim.keymap.set("n", "<leader>os", "<cmd>ObsidianSearch<CR>", { desc = "Search Obsidian" })
-- vim.keymap.set("n", "<leader>oq", "<cmd>ObsidianQuickSwitch<CR>", { desc = "Quick Switch" })
