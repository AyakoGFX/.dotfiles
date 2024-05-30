local M = {}

function M.setup()
    -- Using plugin manager
    -- Using Lazy:
    require("lazy").setup({
        { "Jezda1337/cmp_bootstrap" }
    })

    -- Setup
    -- Enable plugin
    require'cmp'.setup {
        sources = {
            { name = 'bootstrap' },
        },
    }

    -- Configuration
    require("bootstrap-cmp.config"):setup({
        file_types = { 'html', 'css' },
        url = "..."
    })
end

return M

