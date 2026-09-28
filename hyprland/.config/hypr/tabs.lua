-- Group (tabbed) keybinds

hl.bind(mainMod .. " + U", hl.dsp.group.toggle())
hl.bind(mainMod .. " + I", hl.dsp.group.lock_active({ action = "toggle" }))

hl.bind(mainMod .. " + bracketleft", hl.dsp.group.prev())   -- was ALT + H
hl.bind(mainMod .. " + bracketright", hl.dsp.group.next())  -- was ALT + L
hl.bind(mainMod .. " + SHIFT + bracketleft",  hl.dsp.group.move_window({ forward = false }))  -- move tab left
hl.bind(mainMod .. " + SHIFT + bracketright", hl.dsp.group.move_window({ forward = true }))   -- move tab right


hl.bind(mainMod .. " + ALT + U", hl.dsp.window.move({ out_of_group = true }))
hl.bind(mainMod .. " + ALT + H", hl.dsp.window.move({ into_group = "l" }))
hl.bind(mainMod .. " + ALT + L", hl.dsp.window.move({ into_group = "r" }))
hl.bind(mainMod .. " + ALT + K", hl.dsp.window.move({ into_group = "u" }))
hl.bind(mainMod .. " + ALT + J", hl.dsp.window.move({ into_group = "d" }))

hl.animation({ leaf = "fadeSwitch", enabled = false })

-- Group config (colors handled by Noctalia)
hl.config({
    group = {
        auto_group = true,
        drag_into_group = 1,
        focus_removed_window = true,
        group_on_movetoworkspace = false,
        insert_after_current = true,
        merge_floated_into_tiled_on_groupbar = false,
        merge_groups_on_drag = true,
        merge_groups_on_groupbar = true,

        groupbar = {
            enabled = true,
            blur = false,
            disable_when_only = false,
            font_size = 14,
            gaps_in = 1,
            gaps_out = 1,
            gradients = true,
            height = 14,
            indicator_height = 4,
            render_titles = true,
            rounding = 1,
            scrolling = true,
            stacked = false,
        },
    },
})
