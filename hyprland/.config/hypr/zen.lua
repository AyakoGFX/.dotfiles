local zen = false

hl.bind(mainMod .. " + G", function()
    if zen then
        zen = false
        hl.exec_cmd("hyprctl reload")   -- restores all your real settings
    else
        zen = true
        hl.config({
            general = { gaps_in = 0, gaps_out = 0, border_size = 0 },
            animations = { enabled = false },
            decoration = {
                shadow = { enabled = false },
                blur = { enabled = false },
                rounding = 0,
            },
        })
    end
    hl.exec_cmd("noctalia msg bar-toggle")
end)
