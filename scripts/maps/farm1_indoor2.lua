--[[

    A dumb farmer.

--]]

require "scripts/npcs/walkingnpc"

local function hungoriTalk(npc, ch)
    stopRoute(npc, ch)
    mana.npc_message(npc, ch, "Hi")

    say("Hi, I am Hungory!")
    local gossipstrings = { "Any good story?", "What do I need to know as an adventurer?", "Any gossip?", "What's up?", "How are you?"}
    local queststrings  = { "May I help you? I am looking for adventurers work.", "Do you have a quest for me?", "Can I assist you in adventuring the world?", "I am a strong adventurer..."}
    local leavestrings  = { "Nevermind", "Bye", "See you", "I need to go.", "Have a nice day!"}

    choices =  { gossipstrings[math.random(#gossipstrings)],
                 queststrings[math.random(#queststrings)],
                 leavestrings[math.random(#leavestrings)] }

    res = do_choice(npc, ch, choices)

    if res == 1 then
        say("My game designers should invent more gossip, I could talk about!")
    elseif res == 2 then

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
