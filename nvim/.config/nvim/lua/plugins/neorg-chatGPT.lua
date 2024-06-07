return {
  "nvim-neorg/neorg",
  dependencies = { "luarocks.nvim" },
  lazy = false, -- Disable lazy loading as some `lazy.nvim` distributions set `lazy = true` by default
  version = "*", -- Pin Neorg to the latest stable release
  -- config = true,
  config = function()
    require("neorg").setup({
      load = {
        ["core.defaults"] = {},
        ["core.concealer"] = {},
        ["core.integrations.nvim-cmp"] = {},
        ["core.dirman"] = {
          config = {

            workspaces = {
              -- manage workspaces
              main = "~/.config/nvim/neorg/main",
              UsefulPlugins = "~/.config/nvim/neorg/useful-plugins",
              notes = "~/.config/nvim/neorg/notes",
              scrap = "~/.config/nvim/neorg/scrap",
              javascript = "~/.config/nvim/neorg/javascript",
            },
            -- set default workspaces
            default_workspace = "main", --not file name the function name example  main = "~/newNotes" if u want to set this workspace as default u need to set main not newNotes
          },
        },
      },
    })
  end,
},
  require("nvim-treesitter.configs").setup({
    auto_install = true,
    -- ensure_installed = { "cpp", "c" }, -- Install the C++ parser
    highlight = {
      enable = true, -- Enable syntax highlighting
    },
  })
