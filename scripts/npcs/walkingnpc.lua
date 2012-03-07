--[[

    Script for letting npcs walk defined routes

    To use create an npc and call:
      setWaypoints(npc, points, walkspeed, callback)
    being: being which should walk
    walkspeed: walkingspeed in tiles per second
    callback: function that should get called as soon the being reaches a point

--]]

local waypoints = {}

local function getWalkTime(being, x, y)
    local speed = mana.being_get_modified_attribute(being, ATTRIBUTE_MOVEMENT_SPEED)
    local dist = mana.get_distance(mana.posX(being), mana.posY(being),
                                   x, y) / TILESIZE
    return dist / speed
end

function setWaypoints(npc, points, walkspeed, callback)
    assert(npc ~= nil, "nil npc handle")
    assert(points ~= nil, "nil point table")
    waypoints[npc] = {}
    waypoints[npc].data = points
    waypoints[npc].currentIndex = 1
    waypoints[npc].callback = callback
    mana.being_set_base_attribute(npc, ATTRIBUTE_MOVEMENT_SPEED, walkspeed)
end

function gotoNextWaypoint(npc)
    assert(waypoints[npc] ~= nil, "nil npc handle")
    local wp = waypoints[npc]
    wp.currentIndex = (wp.currentIndex % #wp.data) + 1
    mana.being_walk(npc, wp.data[wp.currentIndex].x, wp.data[wp.currentIndex].y,
                    mana.being_get_modified_attribute(being,
                                                      ATTRIBUTE_MOVEMENT_SPEED))

    local time = getWalkTime(npc,  wp.data[wp.currentIndex].x,
                             wp.data[wp.currentIndex].y)
    schedule_in(time, function() walkingCallback(npc) end)
end

function stopWalking(npc)
    mana.being_set_action(npc, ACTION_STAND)
    mana.being_walk(npc, mana.posX(npc), mana.posY(npc))
end

function continueWalking(npc)
    assert(waypoints[npc] ~= nil, "nil npc handle")
    local wp = waypoints[npc]
    mana.being_walk(npc, wp.data[wp.currentIndex].x, wp.data[wp.currentIndex].y,
                mana.being_get_modified_attribute(being,
                                                  ATTRIBUTE_MOVEMENT_SPEED))

    local time = getWalkTime(npc,  wp.data[wp.currentIndex].x,
                             wp.data[wp.currentIndex].y)
    schedule_in(time, function() walkingCallback(npc) end)
end

function walkingCallback(npc)
    local wp = waypoints[npc]
    if wp.data[wp.currentIndex].x == mana.posX(npc)
            and wp.data[wp.currentIndex].y == mana.posY(npc) then
        wp.callback(npc)
    end
end
