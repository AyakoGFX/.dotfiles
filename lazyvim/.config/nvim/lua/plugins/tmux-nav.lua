-- return {
--   "alexghergh/nvim-tmux-navigation",
--   config = function()
--     require("nvim-tmux-navigation").setup({})
--     vim.keymap.set("n", "<C-h>", "<Cmd>NvimTmuxNavigateLeft<CR>", {})
--     vim.keymap.set("n", "<C-j>", "<Cmd>NvimTmuxNavigateDown<CR>", {})
--     vim.keymap.set("n", "<C-k>", "<Cmd>NvimTmuxNavigateUp<CR>", {})
--     vim.keymap.set("n", "<C-l>", "<Cmd>NvimTmuxNavigateRight<CR>", {})
--   end,
-- }
return {
   "christoomey/vim-tmux-navigator",
   event = "VimEnter",
   keys = {
      { "<C-\\>", "<cmd>TmuxNavigatePrevious<cr>", desc = "Go to the previous pane" },
      { "<C-h>", "<cmd>TmuxNavigateLeft<cr>", desc = "Go to the left pane" },
      { "<C-j>", "<cmd>TmuxNavigateDown<cr>", desc = "Go to the down pane" },
      { "<C-k>", "<cmd>TmuxNavigateUp<cr>", desc = "Go to the up pane" },
      { "<C-l>", "<cmd>TmuxNavigateRight<cr>", desc = "Go to the right pane" },
   },
}
