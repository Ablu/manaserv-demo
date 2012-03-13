--[[

    A dumb farmer.

--]]

require "scripts/npcs/walkingnpc"

local function dumbFarmerTalk(npc, ch)
    stopRoute(npc, ch)
    do_message(npc, ch, "Hello!")
    do_choice(npc, ch, "Hi!") -- TODO let it here until bjorn fixed the do_message to be synchronous
    continueRoute(npc, ch)
end

local function dumbFarmerWaypointReached(npc)
    --being_set_direction(npc, math.random (1,4))
    gotoNextWaypoint(npc)
end

local dumb_farmer_way = {
        {x=tileToPixel(27), y=tileToPixel(26), wait=5},
        {x=tileToPixel(36), y=tileToPixel(26)},
        {x=tileToPixel(45), y=tileToPixel(26)},
        {x=tileToPixel(45), y=tileToPixel(37)},
        {x=tileToPixel(44), y=tileToPixel(37)},
        {x=tileToPixel(44), y=tileToPixel(51)},
        {x=tileToPixel(35), y=tileToPixel(51)},
        {x=tileToPixel(27), y=tileToPixel(51)},
        {x=tileToPixel(27), y=tileToPixel(35), wait=3},
        {x=tileToPixel(27), y=tileToPixel(26)}}

local dumb_farmer = mana.npc_create("Dumb Farmer", 215, GENDER_MALE,
                               tileToPixel(26), tileToPixel(26),
                               dumbFarmerTalk, nil)
setWaypoints(dumb_farmer, dumb_farmer_way, 3, dumbFarmerWaypointReached)

gotoNextWaypoint(dumb_farmer)
