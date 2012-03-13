--[[

    Just an example for fighting npc to help debugging

--]]
require "scripts/npcs/fightingnpc"

local function fightTestTalk(npc, ch)
end

local timer = 0
local function fightTestUpdate(npc)
    if timer > 10 then
        timer = 0
        guard.lookForEnemy(npc)
    else
        timer = timer + 1
    end
end

local fightTest = npc_create("Fight Test", 215, GENDER_MALE,
                             tileToPixel(27), tileToPixel(26),
                             fightTestTalk, fightTestUpdate)
guard.create(fightTest, posX(fightTest), posY(fightTest),
             5 * 32, 50, 25, 2 * 32, 999, DAMAGE_PHYSICAL,
             ELEMENT_NEUTRAL, function(npc, b) return npc ~= b end)
