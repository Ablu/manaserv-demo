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
    local speed = mana.being_get_modified_attribute(being,
                                                    ATTRIBUTE_MOVEMENT_SPEED)
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
    schedule_in(time, function() wp.callback(npc) end)
end
