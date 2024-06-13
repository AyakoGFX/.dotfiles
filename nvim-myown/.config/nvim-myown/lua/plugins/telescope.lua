return {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.6',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
        -- Setting up key mappings
        vim.api.nvim_set_keymap("n", "<leader>ff", "<cmd>Telescope find_files<CR>", { noremap = true, silent = true })
        vim.api.nvim_set_keymap("n", "<leader>fg", "<cmd>Telescope live_grep<CR>", { noremap = true, silent = true })
        vim.api.nvim_set_keymap("n", "<leader>b", "<cmd>Telescope buffers<CR>", { noremap = true, silent = true })
        vim.api.nvim_set_keymap("n", "<leader>fa", "<cmd>Telescope builtin<CR>", { noremap = true, silent = true })
        vim.api.nvim_set_keymap("n", "<leader>fk", "<cmd>Telescope keymaps<CR>", { noremap = true, silent = true })

        -- Additional telescope setup can go here
    end
}

