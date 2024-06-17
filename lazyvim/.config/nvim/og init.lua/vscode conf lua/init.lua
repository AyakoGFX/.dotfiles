-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
-- <leader> key
vim.g.mapleader = ' '
-- open config
vim.cmd('nmap <leader>c :e ~/.config/nvim/init.lua<cr>')

-- save
vim.cmd('nmap <leader>s :w<cr>')

-- motion keys (left, down, up, right)
--vim.keymap.set({ 'n', 'v' }, 'j', 'h')
--vim.keymap.set({ 'n', 'v' }, 'k', 'j')
--vim.keymap.set({ 'n', 'v' }, 'l', 'k')
--vim.keymap.set({ 'n', 'v' }, ';', 'l')

-- Remap j to Ctrl-n and k to Ctrl-p in insert mode
--vim.api.nvim_set_keymap('i', 'j', '<C-n>', {noremap = true, silent = true})
---vim.api.nvim_set_keymap('i', 'k', '<C-p>', {noremap = true, silent = true})

-- move selected line up and down N & V mode {note} press shift and JK


--vim.api.nvim_set_keymap('n', 'k', ':m .-2<cr>==', { noremap = true, silent = true })
--vim.api.nvim_set_keymap('n', 'j', ':m .+1<cr>==', { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "K", ":'<,'>m '<-2<cr>gv=gv", { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "J", ":'<,'>m '>+1<cr>gv=gv", { noremap = true, silent = true })

-- repeat previous f, t, f or t movement kjjjjk
--vim.keymap.set('n', '\'', ';')

-- paste without overwriting
vim.keymap.set('v', 'p', 'p')

vim.api.nvim_set_keymap("n", "<c-d>", "<c-d>zz", { noremap = true })
vim.api.nvim_set_keymap("n", "<c-u>", "<c-u>zz", { noremap = true })

-- redo
vim.keymap.set("n", "u", "<c-r>")

--lua api redo
-- remap u to redo
-- vim.api.nvim_set_keymap("n", "u", "<c-f>", { noremap = true, silent = true })
-- vim.api.nvim_set_keymap("n", "u", "<c-r>", { noremap = true, silent = true })

-- disable ctrl+z
-- svim.api.nvim_set_keymap("n", "<C-z>", "<Nop>", { noremap = true, silent = true })
-- clear search highlighting
vim.keymap.set('n', '<Esc>', ':nohlsearch<cr>')

-- skip folds (down, up)
-- vim.cmd('nmap k gj')
-- vim.cmd('nmap l gk')
--
-- Remap "/" to "s" in normal mode
--vim.api.nvim_set_keymap('n', 's', '/', { noremap = true })

--neovim ui
vim.api.nvim_exec([[
    " THEME CHANGER
    function! SetCursorLineNrColorInsert(mode)
        " Insert mode: blue
        if a:mode == "i"
            call VSCodeNotify('nvim-theme.insert')

        " Replace mode: red
        elseif a:mode == "r"
            call VSCodeNotify('nvim-theme.replace')
        endif
    endfunction

    augroup CursorLineNrColorSwap
        autocmd!
        autocmd ModeChanged *:[vV\x16]* call VSCodeNotify('nvim-theme.visual')
        autocmd ModeChanged *:[R]* call VSCodeNotify('nvim-theme.replace')
        autocmd InsertEnter * call SetCursorLineNrColorInsert(v:insertmode)
        autocmd InsertLeave * call VSCodeNotify('nvim-theme.normal')
        autocmd CursorHold * call VSCodeNotify('nvim-theme.normal')
        autocmd ModeChanged [vV\x16]*:* call VSCodeNotify('nvim-theme.normal')
    augroup END
]], false)



-- Set clipboard to use system clipboard lua
vim.opt.clipboard:append("unnamedplus")

-- search ignoring case
vim.opt.ignorecase = true

-- disable "ignorecase" option if the search pattern contains upper case characters
vim.opt.smartcase = true
