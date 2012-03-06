--[[

    A dumb farmer.

--]]

require "scripts/npcs/walkingnpc"

local function dumbFarmerTalk(npc, ch)
    --do_message(npc, ch, "Hello!")
end

local dumb_farmer_way = { 
        {x=27 * TILESIZE + TILESIZE / 2, y= 26 * TILESIZE + TILESIZE / 2}, 
        {x=45 * TILESIZE + TILESIZE / 2, y= 26 * TILESIZE + TILESIZE / 2}, 
        {x=45 * TILESIZE + TILESIZE / 2, y= 37 * TILESIZE + TILESIZE / 2}, 
        {x=44 * TILESIZE + TILESIZE / 2, y= 37 * TILESIZE + TILESIZE / 2}, 
        {x=44 * TILESIZE + TILESIZE / 2, y= 51 * TILESIZE + TILESIZE / 2}, 
        {x=35 * TILESIZE + TILESIZE / 2, y= 51 * TILESIZE + TILESIZE / 2}, 
        {x=27 * TILESIZE + TILESIZE / 2, y= 51 * TILESIZE + TILESIZE / 2}, 
        {x=27 * TILESIZE + TILESIZE / 2, y= 35 * TILESIZE + TILESIZE / 2}, 
        {x=27 * TILESIZE + TILESIZE / 2, y= 26 * TILESIZE + TILESIZE / 2}} 

local dumb_farmer = create_npc("Dumb Farmer", 215, GENDER_MALE,
                               26 * TILESIZE + TILESIZE / 2,
                               26 *           TILESIZE + TILESIZE / 2,
                               dumbFarmerTalk, nil)
setWaypoints(dumb_farmer, dumb_farmer_way, 3, gotoNextWaypoint)
gotoNextWaypoint(dumb_farmer)
