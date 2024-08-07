local function augroup(name)
  return vim.api.nvim_create_augroup("lazyvim_" .. name, { clear = true })
end

-- vim.api.nvim_set_keymap('n', '<Leader>cc', ':@g<CR>', {noremap = true, silent = true, desc = "Compile Code"})

local api = vim.api
local fn = vim.fn

api.nvim_create_augroup("WorkingDirectory", { clear = true })
api.nvim_create_autocmd({"BufEnter"}, {
  pattern = {"*.*",".git","CMakeLists.txt"},
  callback = function()
    local path = fn.expand('%:h')..'/'
    path = "cd "..path
    api.nvim_command(path)
  end,
  group = "WorkingDirectory",
})

-- function RunFileAutocmds()
  vim.cmd([[
    augroup run_file
    autocmd!
    autocmd TermEnter * nnoremap <buffer> q :q<CR>
    autocmd BufEnter *.java let @g=":w\<CR>:vsp | terminal java %\<CR>i"
    autocmd BufEnter *.py let @g=":w\<CR>:vsp | terminal python %\<CR>i"
    autocmd BufEnter *.asm let @g=":w\<CR>:!nasm -f elf64 -o out.o % && ld out.o -o a.out\<CR>:vsp | terminal ./a.out\<CR>i"
    autocmd BufEnter *.cpp let @g=":w\<CR>:!g++ %\<CR>:vsp | terminal ./a.out\<CR>i"
    " autocmd BufEnter *.cpp let @g=":w\<CR>:!gcc %\<CR>:vsp | terminal ./a.out\<CR>i"
    autocmd BufEnter *.c let @g=":w\<CR>:!gcc %\<CR>:vsp | terminal ./a.out\<CR>i"
    autocmd BufEnter *.go let @g=":w\<CR>:vsp | terminal go run %\<CR>i"
    autocmd BufEnter *.js let @g=":w\<CR>:vsp | terminal node %\<CR>i"
    autocmd BufEnter *.html let @g=":w\<CR>:silent !chromium %\<CR>"
    augroup end
    ]])
-- end

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
  group = augroup("highlight_yank"),
  callback = function()
    vim.highlight.on_yank()
  end,
})


-- resize splits if window got resized
vim.api.nvim_create_autocmd({ "VimResized" }, {
  group = augroup("resize_splits"),
  callback = function()
    local current_tab = vim.fn.tabpagenr()
    vim.cmd("tabdo wincmd =")
    vim.cmd("tabnext " .. current_tab)
  end,
})

-- go to last loc when opening a buffer
vim.api.nvim_create_autocmd("BufReadPost", {
  group = augroup("last_loc"),
  callback = function(event)
    local exclude = { "gitcommit" }
    local buf = event.buf
    if vim.tbl_contains(exclude, vim.bo[buf].filetype) or vim.b[buf].lazyvim_last_loc then
      return
    end
    vim.b[buf].lazyvim_last_loc = true
    local mark = vim.api.nvim_buf_get_mark(buf, '"')
    local lcount = vim.api.nvim_buf_line_count(buf)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})



-- close some filetypes with <q>
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("close_with_q"),
  pattern = {
    "PlenaryTestPopup",
    "help",
    "lspinfo",
    "notify",
    "qf",
    "query",
    "spectre_panel",
    "startuptime",
    "tsplayground",
    "neotest-output",
    "checkhealth",
    "neotest-summary",
    "neotest-output-panel",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
  end,
})


-- Auto create dir when saving a file, in case some intermediate directory does not exist
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  group = augroup("auto_create_dir"),
  callback = function(event)
    if event.match:match("^%w%w+:[\\/][\\/]") then
      return
    end
    local file = vim.uv.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
  end,
})

-- wrap and check for spell in text filetypes
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("wrap_spell"),
  pattern = { "gitcommit", "markdown" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
  end,
})

-- make it easier to close man-files when opened inline
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("man_unlisted"),
  pattern = { "man" },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
  end,
})
