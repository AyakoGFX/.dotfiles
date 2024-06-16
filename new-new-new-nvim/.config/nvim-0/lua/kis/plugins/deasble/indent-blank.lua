return{
  "lukas-reineke/indent-blankline.nvim",
  event = "LazyFile",
    opts = {
    indent = {
      -- char = "┆",
      -- char = "•",
      char = "⸽",
      -- char = ".",

      tab_char = "⸽",
    },
    scope = { show_start = false, show_end = false },
    exclude = {
      filetypes = {
        "help",
        "alpha",
        "dashboard",
        "neo-tree",
        "Trouble",
        "trouble",
        "lazy",
        "mason",
        "notify",
        "toggleterm",
        "lazyterm",
      },
    },
  },
  main = "ibl",
}

      -- char = "│",
      -- tab_char = "│",
--such as: ⁞, ⋮, ┆, ┊, ┋, ┇, ︙,
-- ⸽
-- ⸽
-- ⸽
