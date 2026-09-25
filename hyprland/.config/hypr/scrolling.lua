hl.config({
    general = {
        layout = "scrolling",
    },
    scrolling = {
        fullscreen_on_one_column = true,
        follow_focus             = tree, -- was `tree` in original, likely a typo
        focus_fit_method         = 1,
        direction                = "right",
        explicit_column_widths   = "0.333, 0.5, 0.667, 0.950",
    },
})

-- window/workspace focus HJKL
hl.bind(mainMod .. " + H",  hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + J",  hl.dsp.focus({ direction = "down" }))
hl.bind(mainMod .. " + K",    hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + L", hl.dsp.focus({ direction = "right" }))

-- scrolling layout navigation
hl.bind(mainMod .. " + mouse_down", hl.dsp.layout("focus l"))
hl.bind(mainMod .. " + mouse_up", hl.dsp.layout("focus r"))
hl.bind(mainMod .. " + SHIFT + H", hl.dsp.layout("swapcol l"))
hl.bind(mainMod .. " + SHIFT + L", hl.dsp.layout("swapcol r"))
hl.bind(mainMod .. " + CTRL + H", hl.dsp.layout("move -col"))
hl.bind(mainMod .. " + CTRL + L", hl.dsp.layout("move +col"))
hl.bind(mainMod .. " + minus", hl.dsp.layout("colresize -conf"))
hl.bind(mainMod .. " + equal", hl.dsp.layout("colresize +conf"))
hl.bind(mainMod .. " + comma", hl.dsp.layout("consume_or_expel prev"))
hl.bind(mainMod .. " + period", hl.dsp.layout("consume_or_expel next"))
hl.bind(mainMod .. " + SHIFT + K", hl.dsp.focus({ workspace = "e-1" }))
hl.bind(mainMod .. " + SHIFT + J", hl.dsp.focus({ workspace = "e+1" }))

