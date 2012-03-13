--[[

    Script for letting NPC automatically attack other beings

--]]

module("guard", package.seeall)

local guards = {}

local function isEnemy(npc, being)
    if guards[npc].filter ~= nil then
        return guards[npc].filter(npc, being)
    else
        return being_type(being) == TYPE_MONSTER
    end
end

function create(npc, x, y, strayRadius, damage, damageDelta, damageRange,
                damageAccurracy, damageType, damageElement, filter,
                attackCallback)
    guards[npc] = {
        x=x,
        y=y,
        strayRadius=strayRadius,
        damage=damage,
        damageDelta=damageDelta,
        damageRange=damageRange,
        damageAccuracy=damageAccurracy,
        damageType=damageType,
        damageElement=damageElement,
        filter=filter,
        attackCallback=attackCallback
    }
end

function lookForEnemy(npc)
    local guard = guards[npc]
    assert(guard ~= nil)
    local beings = get_beings_in_circle(guard.x, guard.y, guard.strayRadius)
    local closestDist = 0
    local closestBeing = nil
    for _, being in pairs(beings) do
        if isEnemy(npc, being) and
            (closestBeing == nil or get_distance(npc, being) < closestDist)
                then
            closestBeing = being
            closestDist = get_distance(npc, being)
        end
    end
    if closestBeing == nil then
        return false
    end

    if get_distance(npc, closestBeing) <= guard.damageRange then
        local hpLoss = being_damage(closestBeing, guard.damage,
          guard.damageDelta, guard.damageAccuracy, guard.damageType,
          guard.damageElement)
        being_set_action(npc, ACTION_ATTACK)
        if guard.attackCallback ~= nil then
            guard.attackCallback(hpLoss)
        end
    else
        local x, y = posX(closestBeing), posY(closestBeing)
        being_walk(npc, x, y, 6)
    end
end
