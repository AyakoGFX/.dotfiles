return {
  "catppuccin/nvim",
  lazy = false,
  priority = 1000,
  config = function()
    vim.cmd([[colorscheme catppuccin]])
  end,
  color_overrides = {
    mocha = {
      base = "#000000",
      mantle = "#000000",
      crust = "#000000",
    },
  },
}
