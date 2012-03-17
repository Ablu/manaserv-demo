--[[

    Script for the jimmy in the farm1 storage map

--]]

require "scripts/npcs/walkingnpc"

local function jimmyTalk(npc, ch)
    local function say(message)
        npc_message(npc, ch, message)
    end

    local bottles_sum = tonumber(chr_get_quest(ch, "JimmyBottles"))
    if (bottles_sum == nil) then
        bottles_sum = 0
    end

    if (bottles_sum > 20) then
        say("Hi! Thanks for bringing out the bottles.")
    else
        say("Hello! Can you give me a hand?")

        local choices =  { "Sure, what do you need?",
                     "Nah, I'm busy." }

        local res = npc_choice(npc, ch, choices)

        if res == 1 then
            say("I'm tidying up our storage here. This is trash, please bring it outside.")
            local bottles_amount = math.random(4)+1
            chr_inv_change(ch, "Empty Bottle", bottles_amount)
            bottles_sum = bottles_sum + bottles_amount
            chr_set_quest(ch, "JimmyBottles", tostring(bottles_sum))
        elseif res == 2 then
            say("Then don't stand in my way!")
        end
    end
end

local jimmy = npc_create("Jimmy", 218, GENDER_MALE,
                              tileToPixel(27), tileToPixel(29),
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
