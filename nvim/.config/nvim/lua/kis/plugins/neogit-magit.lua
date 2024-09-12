return {
  "NeogitOrg/neogit",
  dependencies = {
    "nvim-lua/plenary.nvim",         -- required
    "sindrets/diffview.nvim",        -- optional - Diff integration
    "nvim-tree/nvim-web-devicons",
    -- Only one of these is needed, not both.
    "nvim-telescope/telescope.nvim", -- optional
    -- "ibhagwan/fzf-lua",              -- optional
  },
  config = true
},

-- Set up key mapping for Neogit
vim.api.nvim_set_keymap('n', '<Leader>gg', '<Cmd>Neogit<CR>', {
  noremap = true,
  silent = true,
  desc = "Open Neogit"
})
