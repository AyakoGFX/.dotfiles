return {
  {
    "akinsho/toggleterm.nvim",
    config = true,
    cmd = "ToggleTerm",
    keys = {
      -- { [[<C-\>]] },
      -- { "<F4>", "<cmd>ToggleTerm<cr>", desc = "Toggle floating terminal" },
      { "<C-t>", "<cmd>ToggleTerm<cr>", desc = "Toggle floating terminal" },
    },
    opts = {
      -- open_mapping = [[<F4>]],
      open_mapping = [[<C-t>]],
      -- open_mapping = [[<c-\>]],
      -- direction = "float",
      -- direction = "tab",
      -- direction = "vertical",
      direction = "horizontal",
      shade_filetypes = {},
      hide_numbers = true,
      open_autoinsert = true,
      insert_mappings = true,
      terminal_mappings = true,
      start_in_insert = true,
      close_on_exit = true,
      -- vim.api.nvim_set_keymap("n", "<C-/>", "<cmd>ToggleTerm<cr>", { noremap = true, silent = true }),
    },
  },
}
