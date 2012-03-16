--[[

    A dumb farmer.

--]]

local function waterpumpTalk(npc, ch)
    npc_message(npc, ch, "How many water bottles would you like to fill?")
    local haveBottles = chr_inv_count(ch, true, true, "Empty Bottle")
    amount = npc_ask_integer(npc, ch, 0, haveBottles, 1)
    chr_inv_change(ch, "Empty Bottle", -amount, "Bottle of Water", amount)
end

local water_pump = npc_create("Water Pump", 203, GENDER_UNSPECIFIED,
                              tileToPixel(64), tileToPixel(41),
                              waterpumpTalk, nil)

