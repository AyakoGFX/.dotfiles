hl.config({
    general = {
        layout = "master",
    },
    master = {
        orientation = "left",   -- Master on left, slaves on right
        new_status = "slave",   -- New windows open in the right-hand slave stack
        mfact = 0.55,           -- 55% screen width reserved for master
        new_on_top = false,     -- Append new windows to bottom of slave stack
    },
})

-- Stack Movement Keybindings (Awesome / dwm style)
hl.bind(mainMod .. " + SHIFT + J", hl.dsp.layout("swapnext"))  -- Move window down in stack
hl.bind(mainMod .. " + SHIFT + K", hl.dsp.layout("swapprev"))  -- Move window up in stack

-- Stack Focus Keybindings
hl.bind(mainMod .. " + J", hl.dsp.layout("cyclenext"))         -- Focus next window
hl.bind(mainMod .. " + K", hl.dsp.layout("cycleprev"))         -- Focus previous window

-- Adjust Master split ratio (mfact)
hl.bind(mainMod .. " + H", hl.dsp.layout("mfact -0.05"))  -- Shrink Master ratio
hl.bind(mainMod .. " + L", hl.dsp.layout("mfact +0.05"))  -- Expand Master ratio

-- Promote focused window to Master
hl.bind(mainMod .. "+ SHIFT + Return", hl.dsp.layout("swapwithmaster master"))
