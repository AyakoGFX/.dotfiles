-- vim.api.nvim_set_keymap("n", "<leader>t", "<cmd><CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "<leader>tf", "<cmd>Telescope find_files<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "<leader>tg", "<cmd>:Telescope live_grep<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "<leader>to", "<cmd>:Telescope oldfiles<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "<leader>tR", "<cmd>:Telescope registers<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "<leader>tC", "<cmd>Telescope commands<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "<leader>tc", "<cmd>:Telescope colorscheme<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "<leader>tb", "<cmd>:Telescope buffers<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "<leader>ta", "<cmd>:Telescope builtin<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "<leader>tk", "<cmd>:Telescope keymaps<CR>", { noremap = true })

vim.keymap.set("n", "<leader>tM", ":Telescope file_browser path=%:p:h select_buffer=true<CR>")
vim.keymap.set("n", "<leader>tm", ":Telescope file_browser<CR>")

-- TODO
-- Telescope commands
-- :Telescope find_files
--:Telescope projects
-- :Telescope live_grep
-- :Telescope buffers
-- :Telescope help_tags
-- :Telescope oldfiles
-- :Telescope git_files
-- :Telescope commands
-- :Telescope keymaps
-- :Telescope command_history
-- :Telescope current_buffer_fuzzy_find
-- :Telescope marks
-- :Telescope git_status
-- :Telescope git_branches
-- :Telescope registers
-- :Telescope colorscheme
-- :Telescope quickfix
-- :Telescope loclist
-- :Telescope lsp_references
-- :Telescope lsp_document_symbols
-- :Telescope lsp_workspace_symbols