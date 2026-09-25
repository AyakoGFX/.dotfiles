hl.config({
    input = {
        kb_options   = "caps:swapescape,ctrl:swap_ralt_rctl",
        follow_mouse = 1,
        repeat_delay = 250,
        repeat_rate  = 60,
        sensitivity  = 0,
        touchpad = { natural_scroll = true },
    },
})

hl.gesture({ fingers = 3, direction = "l", action = function() hl.dispatch(hl.dsp.focus({ direction = "l" })) end })
hl.gesture({ fingers = 3, direction = "r", action = function() hl.dispatch(hl.dsp.focus({ direction = "r" })) end })
hl.gesture({ fingers = 3, direction = "u", action = function() hl.dispatch(hl.dsp.focus({ direction = "u" })) end })
hl.gesture({ fingers = 3, direction = "d", action = function() hl.dispatch(hl.dsp.focus({ direction = "d" })) end })
hl.gesture({ fingers = 3, mods = "SUPER", direction = "vertical", action = "workspace" })
