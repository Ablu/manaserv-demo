--[[

    Hungori, a maggot hunter in the basement of the tavern

--]]


require "scripts/npcs/walkingnpc"

require "scripts/npcs/fightingnpc"

local function hungoriTalk(npc, ch)

    local function getNumberOfMobs()
        local beings = get_beings_in_rectangle(tileToPixel(16), tileToPixel(16), tileToPixel(16), tileToPixel(16))
        local mobcount=0
        for i=1,#beings do
            if being_type(beings[i]) == TYPE_MONSTER then
                mobcount=mobcount+1
            end
        end
        return mobcount
    end

    local function say(message)
        npc_message(npc, ch, message)
    end

    stopRoute(npc, ch)

    say("Hi, I am Hungory!")
    local gossipstrings = { "Any good story?", "What do I need to know as an adventurer?", "Any gossip?", "What's up?", "How are you?"}
    local queststrings  = { "May I help you? I am looking for adventurers work.", "Do you have a quest for me?", "Can I assist you in adventuring the world?", "I am a strong adventurer..."}
    local leavestrings  = { "Nevermind", "Bye", "See you", "I need to go.", "Have a nice day!"}

    local choices =  { gossipstrings[math.random(#gossipstrings)],
                 queststrings[math.random(#queststrings)] }

    local maggotquest=0
    if chr_get_quest(ch, "HungoriMaggots") == "Hunting" then
        table.insert(choices, 3, "I cannot see any maggots any more!")
        maggotquest = #choices
    end

    table.insert(choices, leavestrings[math.random(#leavestrings)])

    local res = npc_choice(npc, ch, choices)

    if res == 1 then
        say("My game designers should invent more gossip, I could talk about!")
    elseif res == 2 then
        for i=1,10-getNumberOfMobs() do
            local mob = monster_create("Maggot",tileToPixel(21),tileToPixel(25))
            on_remove(ch, function() monster_remove(mob) end)
            on_death(mob, function() being_say(npc, "Whoot!") end)
        end
        on_remove(ch, function() chr_set_quest(ch, "HungoriMaggots", "") end)

        chr_set_quest(ch, "HungoriMaggots", "Hunting")
        say("Just help me killing all maggots!")
    elseif res > 0 and res==maggotquest then
        if getNumberOfMobs() > 0 then
            say("But there is still one! Over there")
        else
            say("Mission accomplished! Well done young lad!")
            chr_set_quest(ch, "HungoriMaggots", "Done")
        end
    end

    continueRoute(npc, ch)
end

local function hungoriWaypointReached(npc)
    gotoNextWaypoint(npc)
end

local timer = 0
local function hungoriUpdate(npc)

    local function getNumberOfMobs()
        local beings = get_beings_in_rectangle(tileToPixel(16), tileToPixel(16), tileToPixel(16), tileToPixel(16))
        local mobcount=0
        for i=1,#beings do
            if being_type(beings[i]) == TYPE_MONSTER then
                mobcount=mobcount+1
            end
        end
        return mobcount
    end

    if timer > 10 then
        timer = 0
        --if getNumberOfMobs() > 7 then
            --guard.lookForEnemy(npc)
        --end
    else
        timer = timer + 1
    end
end

local hungoriWay = {
        {x=tileToPixel(21), y=tileToPixel(26), wait=7},
        {x=tileToPixel(20), y=tileToPixel(30), wait=15},
        {x=tileToPixel(26), y=tileToPixel(28), wait=32},
        {x=tileToPixel(22), y=tileToPixel(27), wait=17} }


local hungori = npc_create("Hungori", 217, GENDER_MALE,
                           tileToPixel(21), tileToPixel(26),
                           hungoriTalk, hungoriUpdate)

being_set_base_attribute(hungori, ATTRIBUTE_MOVEMENT_SPEED, 5)

--guard.create(hungori, posX(hungori), posY(hungori),
--             5 * 32, 50, 25, 16, 999, DAMAGE_PHYSICAL,
--             ELEMENT_NEUTRAL, nil, nil)

setWaypoints(hungori, hungoriWay, 2, hungoriWaypointReached)
gotoNextWaypoint(hungori)
