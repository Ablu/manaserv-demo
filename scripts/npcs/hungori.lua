--[[

    Hungori, a maggot hunter in the basement of the tavern

--]]


require "scripts/npcs/walkingnpc"

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

local hungoriWay = {
        {x=tileToPixel(21), y=tileToPixel(26), wait=5},
        {x=tileToPixel(20), y=tileToPixel(30)},
        {x=tileToPixel(26), y=tileToPixel(28)},
        {x=tileToPixel(22), y=tileToPixel(27)} }


local hungori = npc_create("Hungori", 217, GENDER_MALE,
                           tileToPixel(21), tileToPixel(26),
                           hungoriTalk, nil)
setWaypoints(hungori, hungoriWay, 3, hungoriWaypointReached)
gotoNextWaypoint(hungori)
