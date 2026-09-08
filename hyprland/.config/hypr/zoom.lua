local MAX_ZOOM = 3
local MIN_ZOOM = 1
local ZOOM_TOGGLE_FACTOR = 2
local ZOOM_STEP = 0.3

---@param offset number|nil
---@return nil
local function zoom(offset)
    local current = hl.get_config("cursor.zoom_factor")
    if offset ~= nil then
        current = current + offset
    elseif current ~= MIN_ZOOM then
        current = MIN_ZOOM
    else
        current = ZOOM_TOGGLE_FACTOR
    end
    current = math.max(MIN_ZOOM, math.min(MAX_ZOOM, current))
    hl.config({ cursor = { zoom_factor = current } })
end



-- Keybindings
hl.bind("SUPER + Z", zoom)
hl.bind("SUPER + KP_Enter", zoom)
hl.bind("SUPER + KP_ADD", function() zoom(0.5) end,{repeating = true})
hl.bind("SUPER + minus", function() zoom(-0.5) end,{repeating = true})
hl.bind("SUPER + KP_Subtract", function() zoom(-0.5) end,{repeating = true})

-- Mouse Scroll Bindings (Hold SUPER + CTRL + Scroll)
hl.bind("SUPER + CTRL + mouse_up", function() zoom(ZOOM_STEP) end)
hl.bind("SUPER + CTRL + mouse_down", function() zoom(-ZOOM_STEP) end)
