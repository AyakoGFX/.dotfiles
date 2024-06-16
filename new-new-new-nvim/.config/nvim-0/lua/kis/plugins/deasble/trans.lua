return {
  {
    "xiyaowong/transparent.nvim",
    priority = 1000, -- Very high priority is required, luarocks.nvim should run as the first plugin in your config.

    config = true,
    lazy = false,
    -- Map <leader>ut to :TransparentToggle in normal mode
    vim.api.nvim_set_keymap("n", "<leader>ut", ":TransparentToggle<CR>", { noremap = true, silent = true }, { desc = "Toggle Transparent"}),
  },
}
