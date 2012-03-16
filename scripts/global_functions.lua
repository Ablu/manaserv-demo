--[[

    Global accessible functions or constants

--]]

-- Attributes:
ATTRIBUTE_MOVEMENT_SPEED = 16

-- Helper functions
function tileToPixel(v)
    return v * TILESIZE + TILESIZE / 2
end

function monster_area_spawn(id, x, y, w, h, n)
    local monsters = {}
    while n > 0 do
        local r_x = math.random(x, x + w)
        local r_y = math.random(y, y + h)
        if is_walkable(r_x, r_y) then
            table.insert(monsters, monster_create(id, r_x, r_y))
            n = n - 1
        end
    end
    return monsters
end
