hl.bind(mainMod .. " + RETURN", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + Q", hl.dsp.window.close())
hl.bind(mainMod .. " + SHIFT + Q", hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'"))
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + D", hl.dsp.exec_cmd(ipc .. "panel-toggle launcher"))
hl.bind(mainMod .. " + M", hl.dsp.window.fullscreen())
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen())
hl.bind(mainMod .. " + C", hl.dsp.layout("center"))

-- screenshots
hl.bind("ALT + PRINT", hl.dsp.exec_cmd("noctalia msg screenshot-region"))
hl.bind("PRINT", hl.dsp.exec_cmd("noctalia msg screenshot-fullscreen"))
hl.bind(mainMod .. " + A", hl.dsp.exec_cmd("noctalia msg screenshot-annotate"))
hl.bind(mainMod .. " + PRINT", hl.dsp.exec_cmd("sh -c '~/.config/hypr/scripts/hypr-ocr'"))
hl.bind(mainMod .. " + P", hl.dsp.exec_cmd("hyprpicker --autocopy"))

-- handy
hl.bind(mainMod .. " + F1", hl.dsp.exec_cmd("pkill -USR2 -x handy"))

-- scrolling layout navigation
hl.bind(mainMod .. " + H", hl.dsp.layout("focus l"))
hl.bind(mainMod .. " + L", hl.dsp.layout("focus r"))
hl.bind(mainMod .. " + J", hl.dsp.layout("focus b"))
hl.bind(mainMod .. " + K", hl.dsp.layout("focus t"))
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

-- window/workspace focus
hl.bind(mainMod .. " + left",  hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up",    hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down",  hl.dsp.focus({ direction = "down" }))

for i = 1, 10 do
    local key = i % 10
    hl.bind(mainMod .. " + " .. key,         hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i, follow = false }))
end

hl.bind(mainMod .. " + S", hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))
hl.bind(mainMod .. " + SHIFT + K", hl.dsp.focus({ workspace = "e-1" }))
hl.bind(mainMod .. " + SHIFT + J", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + SHIFT + mouse_up", hl.dsp.focus({ workspace = "e-1" }))
hl.bind(mainMod .. " + SHIFT + mouse_down", hl.dsp.focus({ workspace = "e+1" }))

hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- brightness / volume
hl.bind(mainMod .. " + semicolon", hl.dsp.exec_cmd("brightnessctl --class=backlight set 5-%"), { repeating = true })
hl.bind(mainMod .. " + SHIFT + semicolon", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.02-"), { repeating = true })
hl.bind(mainMod .. " + apostrophe", hl.dsp.exec_cmd("brightnessctl --class=backlight set +5%"), { repeating = true })
hl.bind(mainMod .. " + SHIFT + apostrophe", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.02+"), { repeating = true })

-- media keys
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd(ipc .. "volume-up"))
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd(ipc .. "volume-down"))
hl.bind("XF86AudioMute", hl.dsp.exec_cmd(ipc .. "volume-mute"))
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd(ipc .. "brightness-up"))
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd(ipc .. "brightness-down"))
hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("playerctl next"),       { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("playerctl previous"),   { locked = true })
