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
        -- ["core.tempus"] = {},
        -- ["core.keybinds"] = {
        --   config = {
        --     default_keybinds = true, -- Enable default keybindings
        --     -- neorg_leader = "<Leader>o", -- Set leader key for Neorg
        --     hook = function(keybinds)
        --       -- Add custom keybindings here
        --       keybinds.map(
        --         "norg",
        --         "n",
        --         "<Leader>on",
        --         "<Cmd>Neorg workspace notes<CR>",
        --         { desc = "Open notes workspace" }
        --       ) -- Add more custom keybindings as needed
        --     end,
        --   },
        -- },

        ["core.dirman"] = {
          config = {

            workspaces = {
              -- manage workspaces
              main = "~/.config/nvim/neorg/main",
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
}
