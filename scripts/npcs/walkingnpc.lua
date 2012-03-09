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
    waypoints[npc].stoppedBy = {}
    mana.being_set_base_attribute(npc, ATTRIBUTE_MOVEMENT_SPEED, walkspeed)
end

function gotoNextWaypoint(npc)
    assert(waypoints[npc] ~= nil, "nil npc handle")
    local wp = waypoints[npc]
    wp.currentIndex = (wp.currentIndex % #wp.data) + 1
    mana.being_walk(npc, wp.data[wp.currentIndex].x, wp.data[wp.currentIndex].y,
                    mana.being_get_modified_attribute(npc,
                                                      ATTRIBUTE_MOVEMENT_SPEED))

    local addtime = 0
    if wp.data[wp.currentIndex].wait then
        addtime = wp.data[wp.currentIndex].wait
    end

    local time = addtime + getWalkTime(npc, wp.data[wp.currentIndex].x,
                                             wp.data[wp.currentIndex].y)

    schedule_in(time, function() walkingCallback(npc) end)
end


--- Makes an npc stop walking on its route
--
-- @param npc Which npc should stop walking
-- @param ch optional character pointer. If a character is given multiple
--           pairs of stopWalking and continueWalking can be issues at
--           the same time. The npc will only continueWalking if all
--           characters have issued to continueWalking or have disconnected

function stopRoute(npc, ch)
    local wp = waypoints[npc]
    if ch then
        on_remove(ch, function() continueRoute(npc, ch) end)
        wp.stoppedBy[ch] = true
    end
    mana.being_walk(npc, mana.posX(npc), mana.posY(npc))
end

--- Makes an npc continue walking
-- continues to walk on the predefined walking route.
--
-- @param npc Which npc should stop walking
-- @param ch optional character pointer. If a character is given multiple
--           pairs of stopWalking and continueWalking can be issues at
--           the same time. The npc will only continueWalking if all
--           characters have issued to continueWalking or have disconnected

function continueRoute(npc, ch)
    assert(waypoints[npc] ~= nil, "nil npc handle")
    local wp = waypoints[npc]

    if ch then
        wp.stoppedBy[ch] = nil
        if next(wp.stoppedBy) then
            return
        end
    end

    mana.being_walk(npc, wp.data[wp.currentIndex].x, wp.data[wp.currentIndex].y,
                mana.being_get_modified_attribute(being, ATTRIBUTE_MOVEMENT_SPEED))

    local time = getWalkTime(npc,  wp.data[wp.currentIndex].x,
                             wp.data[wp.currentIndex].y)
    schedule_in(time, function() walkingCallback(npc) end)
end

function walkingCallback(npc)
    local wp = waypoints[npc]
    if wp.data[wp.currentIndex].x == mana.posX(npc)
            and wp.data[wp.currentIndex].y == mana.posY(npc)
            and not next(wp.stoppedBy) then
        wp.callback(npc)
    end
end
