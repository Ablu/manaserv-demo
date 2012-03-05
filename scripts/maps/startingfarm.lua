--[[

    The starting map.

--]]

require "scripts/npcs/walkingnpc"

function initfunction()
    local dumb_farmer = create_npc("Dumb Farmer", 215, GENDER_MALE, 26 * TILESIZE + TILESIZE / 2, 26 * TILESIZE + TILESIZE / 2, talkToDumbFarmer, updateDumbFarmer)
    local farmers_way = {
            {x=27 * TILESIZE + TILESIZE / 2, y= 26 * TILESIZE + TILESIZE / 2},
            {x=45 * TILESIZE + TILESIZE / 2, y= 26 * TILESIZE + TILESIZE / 2},
            {x=45 * TILESIZE + TILESIZE / 2, y= 37 * TILESIZE + TILESIZE / 2},
            {x=44 * TILESIZE + TILESIZE / 2, y= 37 * TILESIZE + TILESIZE / 2},
            {x=44 * TILESIZE + TILESIZE / 2, y= 51 * TILESIZE + TILESIZE / 2},
            {x=35 * TILESIZE + TILESIZE / 2, y= 51 * TILESIZE + TILESIZE / 2},
            {x=27 * TILESIZE + TILESIZE / 2, y= 51 * TILESIZE + TILESIZE / 2},
            {x=27 * TILESIZE + TILESIZE / 2, y= 35 * TILESIZE + TILESIZE / 2},
            {x=27 * TILESIZE + TILESIZE / 2, y= 26 * TILESIZE + TILESIZE / 2}}
    setWaypoints(dumb_farmer, farmers_way, 3, gotoNextWaypoint)
    gotoNextWaypoint(dumb_farmer)
end

atinit(initfunction)

