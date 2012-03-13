--[[

    Script for the bartender in the farm1 indoor map

--]]


require "scripts/npcs/walkingnpc"

local bartenderExplainingQuest = false -- is set to true during the whole basement showing and killing, until the player has finished the quest
local barTenderWaitingInBasement = false
local maggotskilled = 0
local bartenderKnowThePlayer = nil -- will contain a random variable, the player will also carry that variable to identify himself to the bartender again in the basement

local function bartenderTalk(npc, ch)
    -- either in  bar -> then talk normally
    -- on the way -> don't interrupt me!
    -- in the cellar -> I'll talk to you!
    local function say(message)
        do_message(npc, ch, message)
    end


    -- standing at the bar, normal talk
    if posX(npc) == tileToPixel(28) and posY(npc) == tileToPixel(18) then

        say("Welcome on our farm!")
        local tradestrings = { "Do you have some beer?", "I need some tools...", "Interested in doing a deal?", "Show me your stuff", "Would you mind selling me some stuff?" }
        local gossipstrings = { "Any good story?", "What do I need to know as an adventurer?", "Any gossip?", "What's up with the farmers round here?"}
        local queststrings = { "May I help you? I am looking for peons work.", "Do you have a quest for me?", "Can I assist you in adventuring the world?", "I am a strong adventurer..."}
        local leavestrings = { "Nevermind", "Bye", "See you", "I need to go.", "Have a nice day!"}
        res = do_choice(npc, ch,    tradestrings[math.random(#tradestrings)],
                                    gossipstrings[math.random(#gossipstrings)],
                                    queststrings[math.random(#queststrings)],
                                    leavestrings[math.random(#leavestrings)])

        if res == 1 then
            local buycase = npc_trade(npc, ch, false,
                                            { {"Beer", 10, 10} })
            if buycase == 0 then
                say("What do you want to buy?")
            elseif buycase == 1 then
                say("I've got no items to sell.")
            else
                say("Hmm, something went wrong... Ask a scripter to fix the buying mode!")
            end
            return
        end

        if res == 2 then
            say("gossip goes here: ")
            return
        end

        if res == 3 then
            say("Actually there is something you can do: \n" ..
                "It's about cleaning our basement again. \n " ..
                "So come with me I'll show you what to do! \n" ..
                "Are you ready?\n")
            res = do_choice(npc, ch, "Ok let's go!", "Cleaning! Are you fucking kidding me?")
            if res == 1 then
                bartenderKnowThePlayer = math.random()
                chr_set_quest(ch, "bartenderMaggotFight", bartenderKnowThePlayer)
                gotoNextWaypoint(npc)
            end
        end

        return

    -- standing in the basement waiting for the player to talk to me
    elseif posX(npc) == tileToPixel(22) and posY(npc) == tileToPixel(57) then
        if get_quest_var(ch, "bartenderMaggotFight") == bartenderKnowThePlayer then
            for i = 1,10 do
                mob = monster_create( id, x, y)
                on_remove(ch, function() monster_remove(mob) end)
                on_death(mob, function() maggotskilled = maggotskilled+1 end)
            end
            say("Ok, Do you see the maggots all over here?\n"..
                "Kill all maggots and I'll give you a reward!\n"..
                "I'll be waiting upstairs for you!")

            gotoNextWaypoint(npc)
        end
        return
    end

    -- somewhere walking
    being_say(npc, "I am busy, please wait a second!")
    --do_message(npc, ch, "you should not be reading this!")
    --stopRoute(npc, ch)
    --do_message(npc, ch, "Hello!")
    --do_choice(npc, ch, "Hi!") --let it here until bjorn fixed the do_message to be synchronous
    --continueRoute(npc, ch)
end

local function bartenderWaypointReached(npc)
    being_say(npc, "bartenderWaypointReached")
    if posX(npc) == tileToPixel(21) and posY(npc) == tileToPixel(23) then
    -- step down
        npc_warp(npc, tileToPixel(22), tileToPixel(53))
        gotoNextWaypoint(npc)
    elseif posX(npc) == tileToPixel(22) and posY(npc) == tileToPixel(53) then
    --step up
        npc_warp(npc, tileToPixel(21), tileToPixel(21))
        gotoNextWaypoint(npc)
    elseif posX(npc) == tileToPixel(22) and posY(npc) == tileToPixel(57) then
    -- end point in basement reached:
        -- wait a certain time until the player talks to me, else leave
        if barTenderWaitingInBasement == false then
            barTenderWaitingInBasement = true
            schedule_in(15, function() bartenderWaypointReached(npc) end)
        else
            --the player was not here talking to me, so leave again.
            gotoNextWaypoint(npc)
        end
    elseif posX(npc) == tileToPixel(28) and posY(npc) == tileToPixel(18) then
    -- usual standing point, do not walk away!
    else
    -- any other waypoint:
        gotoNextWaypoint(npc)
    end
end



local bar_tender = npc_create("Bar Tender", 216, GENDER_MALE,
                              tileToPixel(28), tileToPixel(18),
                              bartenderTalk, nil)

local bar_tender_way = {
    --first part (way down)
    { x=tileToPixel(26), y=tileToPixel(18) },
    { x=tileToPixel(26), y=tileToPixel(23.5) },
    { x=tileToPixel(23), y=tileToPixel(23.5) },
    { x=tileToPixel(23), y=tileToPixel(21) },
    { x=tileToPixel(21), y=tileToPixel(21) },
    { x=tileToPixel(21), y=tileToPixel(23) }, -- on the stairs in the bar
    { x=tileToPixel(22), y=tileToPixel(57) }, -- endpoint in basement
    { x=tileToPixel(22), y=tileToPixel(53) }, -- on stairs in basement
    { x=tileToPixel(21), y=tileToPixel(21) },
    { x=tileToPixel(23), y=tileToPixel(21) },
    { x=tileToPixel(23), y=tileToPixel(23) },
    { x=tileToPixel(26), y=tileToPixel(24) },
    { x=tileToPixel(26), y=tileToPixel(18) },
    --second part way up is reverse to way down
    { x=tileToPixel(28), y=tileToPixel(18) }}-- starting point reached again

setWaypoints(bar_tender, bar_tender_way, 4, bartenderWaypointReached)


