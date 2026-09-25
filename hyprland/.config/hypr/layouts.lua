hl.config({
    dwindle = { preserve_split = true },
    master  = { new_status = "master" },
    scrolling = {
        fullscreen_on_one_column = true,
        follow_focus             = true, -- was `tree` in original, likely a typo
        focus_fit_method         = 1,
        direction                = "right",
        explicit_column_widths   = "0.333, 0.5, 0.667, 0.950",
    },
})
