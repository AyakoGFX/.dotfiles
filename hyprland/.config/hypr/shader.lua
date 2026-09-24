local eink_path = "~/.config/hypr/shaders/eink.glsl"
local invert_path = "~/.config/hypr/shaders/invert.glsl"

local eink_enabled = false
local invert_enabled = false

local function apply_shader()
    local path = ""
    if invert_enabled then
        path = invert_path
    elseif eink_enabled then
        path = eink_path
    end
    hl.config({
        decoration = {
            screen_shader = path,
        },
    })
end

hl.bind("SUPER + W", function()
    eink_enabled = not eink_enabled
    if eink_enabled then invert_enabled = false end
    apply_shader()
end)

hl.bind("SUPER + I", function()
    invert_enabled = not invert_enabled
    if invert_enabled then eink_enabled = false end
    apply_shader()
end)
