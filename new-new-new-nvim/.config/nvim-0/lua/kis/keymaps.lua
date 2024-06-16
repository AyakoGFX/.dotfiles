-- Check if <Esc> is already mapped in normal mode
if vim.fn.maparg('<Esc>', 'n') == '' then
  -- Define the mapping
  vim.api.nvim_set_keymap('n', '<Esc>', ':nohlsearch<CR><C-R>=has("diff")?"<Bar>diffupdate":""<CR><CR><Esc>', { noremap = true, silent = true })
end
