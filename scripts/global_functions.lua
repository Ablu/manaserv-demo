--[[

    Global accessible functions or constants

--]]

-- Attributes:
ATTRIBUTE_MOVEMENT_SPEED = 16

-- Helper functions
function tileToPixel(v)
    return v * TILESIZE + TILESIZE / 2
end
