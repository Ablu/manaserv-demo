--[[

    Script for the bartender in the farm1 indoor map

--]]

require "scripts/npcs/walkingnpc"

local bartenderNeedsWater = 0

local function bartenderTalk(npc, ch)
    -- either in  bar -> then talk normally
    -- on the way -> don't interrupt me!
    -- in the cellar -> I'll talk to you!
    local function say(message)
        npc_message(npc, ch, message)
    end

    stopRoute(npc, ch)

    say("Welcome on our farm!")
    local tradestrings  = { "Do you have some beer?", "I need some tools...", "Interested in doing a deal?", "Show me your stuff", "Would you mind selling me some stuff?" }
    local gossipstrings = { "Any good story?", "What do I need to know as an adventurer?", "Any gossip?", "What's up?"}
    local queststrings  = { "May I help you? I am looking for adventurers work.", "Do you have a quest for me?", "Can I assist you in adventuring the world?", "I am a strong adventurer..."}
    local leavestrings  = { "Nevermind", "Bye", "See you", "I need to go.", "Have a nice day!"}

    local waterquest = 0
    choices =  { tradestrings[math.random(#tradestrings)],
                 gossipstrings[math.random(#gossipstrings)],
                 queststrings[math.random(#queststrings)] }

    if chr_get_quest(ch, "bartenderNeedsWater") == "true" then
        table.insert(choices, 4, "I have a bottle of water!")
        waterquest = #choices
    end

    table.insert(choices, leavestrings[math.random(#leavestrings)])

    res = npc_choice(npc, ch, choices)

    if res == 1 then
        local buycase = npc_trade(npc, ch, false,
                                        { {"Beer", 3, 10}, {"Empty Bottle", 5, 5} })
        if buycase == 0 then
            say("What do you want to buy?")
        elseif buycase == 1 then
            say("I've got no items to sell.")
        else
            say("Hmm, something went wrong... Ask a scripter to fix the buying mode!")
        end
    elseif res == 2 then
        say("My game designers should invent more gossip, I could talk about!")
    elseif res == 3 then
        say("Actually there is something you can do:")
        if bartenderNeedsWater > 0 then
            say("I need a bottle of water to keep my flowers alive. Could you bring me a bottle of water?")
            chr_set_quest(ch, "bartenderNeedsWater", "true")
            bartenderNeedsWater = bartenderNeedsWater - 1
        else
            say("Actually there is something you can do: \n" ..
                "It's about cleaning our basement again. \n " ..
                "So Hungori started already, maybe you should go down in the basement! \n" ..
                "Are you ready?\n")
            res = npc_choice(npc, ch, "Erm? I'll have a look there!", "Cleaning! Are you fucking kidding me?")
        end
    elseif res > 0 then
        if res == waterquest then
            say("Very kind of you to help me with the water for my flower")
            chr_give_exp(ch, "Crafts_Farming", 1)
        end
    end
    continueRoute(npc, ch)
end


local function bartenderWaypointReached(npc, id)
    if id == "flowers" and math.random() < 0.25 then
        being_say(npc, "Oo! I should water the flower again!")
        bartenderNeedsWater = 3
    end
    gotoNextWaypoint(npc)
end


local bar_tender = npc_create("Bar Tender", 216, GENDER_MALE,
                              tileToPixel(28), tileToPixel(18),
                              bartenderTalk, nil)

local bar_tender_way = {
    { x=tileToPixel(26), y=tileToPixel(18), wait=1 },
    { x=tileToPixel(26), y=tileToPixel(23), wait=2 },
    { x=tileToPixel(23), y=tileToPixel(24), wait=1 },
    { x=tileToPixel(23), y=tileToPixel(20), wait=3 },
    { x=tileToPixel(24), y=tileToPixel(24), wait=2 },
    { x=tileToPixel(34), y=tileToPixel(22), wait=4 },
    { x=tileToPixel(34), y=tileToPixel(19), wait=0 },
    { x=tileToPixel(34), y=tileToPixel(19), wait=15, id="flowers" },
    { x=tileToPixel(32), y=tileToPixel(21), wait=2 },
    { x=tileToPixel(26), y=tileToPixel(23), wait=1 },
    { x=tileToPixel(26), y=tileToPixel(17), wait=3 },
    { x=tileToPixel(28), y=tileToPixel(17), wait=-0.1 },
    { x=tileToPixel(28), y=tileToPixel(18), wait=60, id="standard" },
    { x=tileToPixel(28), y=tileToPixel(16), wait=1 },
    { x=tileToPixel(26), y=tileToPixel(16), wait=2 },
    { x=tileToPixel(26), y=tileToPixel(20), wait=1 },
    { x=tileToPixel(31), y=tileToPixel(21), wait=3 },
    { x=tileToPixel(28), y=tileToPixel(23), wait=2 },
    { x=tileToPixel(26), y=tileToPixel(21), wait=4 },
    { x=tileToPixel(28), y=tileToPixel(17), wait=1 },
    { x=tileToPixel(28), y=tileToPixel(17), wait=2 },
    { x=tileToPixel(28), y=tileToPixel(18), wait=60, id="standard" } }

setWaypoints(bar_tender, bar_tender_way, 4, bartenderWaypointReached)
gotoNextWaypoint(bar_tender)

