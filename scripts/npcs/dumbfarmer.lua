--[[

    A dumb farmer.

--]]

require "scripts/npcs/walkingnpc"

local function dumbFarmerTalk(npc, ch)
    --do_message(npc, ch, "Hello!")
end

local dumb_farmer_way = { 
        {x=tileToPixel(27), y=tileToPixel(26)}, 
        {x=tileToPixel(45), y=tileToPixel(26)}, 
        {x=tileToPixel(45), y=tileToPixel(37)}, 
        {x=tileToPixel(44), y=tileToPixel(37)}, 
        {x=tileToPixel(44), y=tileToPixel(51)}, 
        {x=tileToPixel(35), y=tileToPixel(51)}, 
        {x=tileToPixel(27), y=tileToPixel(51)}, 
        {x=tileToPixel(27), y=tileToPixel(35)}, 
        {x=tileToPixel(27), y=tileToPixel(26)}} 

local dumb_farmer = create_npc("Dumb Farmer", 215, GENDER_MALE,
                               tileToPixel(26), tileToPixel(26),
                               dumbFarmerTalk, nil)
setWaypoints(dumb_farmer, dumb_farmer_way, 3, gotoNextWaypoint)
gotoNextWaypoint(dumb_farmer)
