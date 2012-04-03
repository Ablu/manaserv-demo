--[[

    A bomb with a small delay before it explodes

--]]

mana.get_item_class("TODO"):on("use", function(user)
    local name = mana.being_get_name(user)
    local x = mana.posX(user)
    local y = mana.posY(user)
    schedule_in(3, function()
        -- Search for user
        local beings = mana.get_beings_in_circle(x, y, TILESIZE * 10)
        local bombUser = nil
        for i, being in pairs(beings) do
            if mana.being_type(being) == TYPE_CHARACTER and
               mana.being_get_name(being) == name then
                bombUser = being
                break
            end
        end

        for i, being in pairs(beings) do
            local being_type = mana.being_type(being)
            local dist = mana.get_distance(x, y, mana.posX(being),
                                           mana.posY(being))
            if dist <= TILESIZE * 5 and (being_type == TYPE_MONSTER or
                    (being_type == TYPE_CHARACTER and
                     mana.map_get_pvp() == PVP_FREE)) then
                if being == bombUser then
                    mana.being_damage(being, 250, 50, 50, DAMAGE_PHYSICAL,
                                  ELEMENT_NEUTRAL)
                else
                    mana.being_damage(being, 250, 50, 50, DAMAGE_PHYSICAL,
                                  ELEMENT_NEUTRAL, bombUser, 110)
                end
            end
        end
    end)
end)
