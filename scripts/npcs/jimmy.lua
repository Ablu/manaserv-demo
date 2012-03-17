--[[

    Script for the jimmy in the farm1 storage map

--]]

require "scripts/npcs/walkingnpc"

local function jimmyTalk(npc, ch)
    local function say(message)
        npc_message(npc, ch, message)
    end

    say("Hello! Can you give me a hand?")

    choices =  { "Sure, what do you need?",
                 "Nah, I'm busy." }

    res = npc_choice(npc, ch, choices)

    if res == 1 then
        say("I'm tidying up our storage here. This is trash, please bring it outside.")
        chr_inv_change(ch, "Empty Bottle", math.random(4)+1)
    elseif res == 2 then
        say("Then don't stand in my way!")
    end
end

local jimmy = npc_create("Jimmy", 218, GENDER_MALE,
                              tileToPixel(28), tileToPixel(18),
                              jimmyTalk, nil)

local jimmy_way = {
    { x=tileToPixel(27), y=tileToPixel(29), wait=2 },
    { x=tileToPixel(25), y=tileToPixel(29), wait=1 },
    { x=tileToPixel(26), y=tileToPixel(29), wait=4 },
    { x=tileToPixel(26), y=tileToPixel(30), wait=1 },
    { x=tileToPixel(27), y=tileToPixel(30), wait=2 },
    { x=tileToPixel(27), y=tileToPixel(29), wait=1 }
}

setWaypoints(jimmy, jimmy_way, 4, gotoNextWaypoint)
gotoNextWaypoint(jimmy)
