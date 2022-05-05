
---------------------------------------------------------------------------------------
-- functions for sitting or sleeping
---------------------------------------------------------------------------------------

cottages.furniture.allow_sit = function(player)
    -- no check possible
    if (not (player.get_player_velocity)) then
        return true
    end
    local velo = player:get_player_velocity()
    if (not (velo)) then
        return false
    end
    local max_velo = 0.0001
    if (math.abs(velo.x) < max_velo
        and math.abs(velo.y) < max_velo
        and math.abs(velo.z) < max_velo) then
        return true
    end
    return false
end

cottages.furniture.sit_on_bench = function(pos, node, clicker, itemstack, pointed_thing)
    if (not (clicker) or not (default.player_get_animation) or not (cottages.allow_sit(clicker))) then
        return
    end

    local animation = default.player_get_animation(clicker)
    local pname = clicker:get_player_name()

    if (animation and animation.animation == "sit") then
        default.player_attached[pname] = false
        clicker:set_pos({x = pos.x, y = pos.y - 0.5, z = pos.z})
        clicker:set_eye_offset({x = 0, y = 0, z = 0}, {x = 0, y = 0, z = 0})
        clicker:set_physics_override(1, 1, 1)
        default.player_set_animation(clicker, "stand", 30)
    else
        -- the bench is not centered; prevent the player from sitting on air
        local p2 = {x = pos.x, y = pos.y, z = pos.z}
        if not (node) or node.param2 == 0 then
            p2.z = p2.z + 0.3
        elseif node.param2 == 1 then
            p2.x = p2.x + 0.3
        elseif node.param2 == 2 then
            p2.z = p2.z - 0.3
        elseif node.param2 == 3 then
            p2.x = p2.x - 0.3
        end

        clicker:set_eye_offset({x = 0, y = -7, z = 2}, {x = 0, y = 0, z = 0})
        clicker:set_pos(p2)
        default.player_set_animation(clicker, "sit", 30)
        clicker:set_physics_override(0, 0, 0)
        default.player_attached[pname] = true
    end
end

cottages.furniture.sleep_in_bed = function(pos, node, clicker, itemstack, pointed_thing)
    if (not (clicker) or not (node) or not (node.name) or not (pos) or not (cottages.allow_sit(clicker))) then
        return
    end

    local animation = default.player_get_animation(clicker)
    local pname = clicker:get_player_name()

    local p_above = minetest.get_node({x = pos.x, y = pos.y + 1, z = pos.z})
    if (not (p_above) or not (p_above.name) or p_above.name ~= 'air') then
        minetest.chat_send_player(pname, "This place is too narrow for sleeping. At least for you!")
        return
    end

    local place_name = 'place'
    -- if only one node is present, the player can only sit
    -- sleeping requires a bed head+foot or two sleeping mats
    local allow_sleep = false
    local new_animation = 'sit'

    -- let players get back up
    if (animation and animation.animation == "lay") then
        default.player_attached[pname] = false
        clicker:set_pos({x = pos.x, y = pos.y - 0.5, z = pos.z})
        clicker:set_eye_offset({x = 0, y = 0, z = 0}, {x = 0, y = 0, z = 0})
        clicker:set_physics_override(1, 1, 1)
        default.player_set_animation(clicker, "stand", 30)
        minetest.chat_send_player(pname, 'That was enough sleep for now. You stand up again.')
        return
    end

    local second_node_pos = {x = pos.x, y = pos.y, z = pos.z}
    -- the node that will contain the head of the player
    local p = {x = pos.x, y = pos.y, z = pos.z}
    -- the player's head is pointing in this direction
    local dir = node.param2
    -- it would be odd to sleep in half a bed
    if (node.name == 'cottages:bed_head') then
        if (node.param2 == 0) then
            second_node_pos.z = pos.z - 1
        elseif (node.param2 == 1) then
            second_node_pos.x = pos.x - 1
        elseif (node.param2 == 2) then
            second_node_pos.z = pos.z + 1
        elseif (node.param2 == 3) then
            second_node_pos.x = pos.x + 1
        end
        local node2 = minetest.get_node(second_node_pos)
        if (not (node2) or not (node2.param2) or not (node.param2)
            or node2.name ~= 'cottages:bed_foot'
            or node2.param2 ~= node.param2) then
            allow_sleep = false
        else
            allow_sleep = true
        end
        place_name = 'bed'

        -- if the player clicked on the foot of the bed, locate the head
    elseif (node.name == 'cottages:bed_foot') then
        if (node.param2 == 2) then
            second_node_pos.z = pos.z - 1
        elseif (node.param2 == 3) then
            second_node_pos.x = pos.x - 1
        elseif (node.param2 == 0) then
            second_node_pos.z = pos.z + 1
        elseif (node.param2 == 1) then
            second_node_pos.x = pos.x + 1
        end
        local node2 = minetest.get_node(second_node_pos)
        if (not (node2) or not (node2.param2) or not (node.param2)
            or node2.name ~= 'cottages:bed_head'
            or node2.param2 ~= node.param2) then
            allow_sleep = false
        else
            allow_sleep = true
        end
        if (allow_sleep == true) then
            p = {x = second_node_pos.x, y = second_node_pos.y, z = second_node_pos.z}
        end
        place_name = 'bed'

    elseif (node.name == 'cottages:sleeping_mat' or node.name == 'cottages:straw_mat' or node.name == 'cottages:sleeping_mat_head') then
        place_name = 'mat'
        dir = node.param2
        allow_sleep = false
        -- search for a second mat right next to this one
        local offset = {{x = 0, z = -1}, {x = -1, z = 0}, {x = 0, z = 1}, {x = 1, z = 0}}
        for i, off in ipairs(offset) do
            node2 = minetest.get_node({x = pos.x + off.x, y = pos.y, z = pos.z + off.z})
            if (node2.name == 'cottages:sleeping_mat' or node2.name == 'cottages:straw_mat' or node.name == 'cottages:sleeping_mat_head') then
                -- if a second mat is found, sleeping is possible
                allow_sleep = true
                dir = i - 1
            end
        end
    end

    -- set the right height for the bed
    if (place_name == 'bed') then
        p.y = p.y + 0.4
    end
    if (allow_sleep == true) then
        -- set the right position (middle of the bed)
        if (dir == 0) then
            p.z = p.z - 0.5
        elseif (dir == 1) then
            p.x = p.x - 0.5
        elseif (dir == 2) then
            p.z = p.z + 0.5
        elseif (dir == 3) then
            p.x = p.x + 0.5
        end
    end

    if (default.player_attached[pname] and animation.animation == "sit") then
        -- just changing the animation...
        if (allow_sleep == true) then
            default.player_set_animation(clicker, "lay", 30)
            clicker:set_eye_offset({x = 0, y = -14, z = 2}, {x = 0, y = 0, z = 0})
            minetest.chat_send_player(pname, 'You lie down and take a nap. A right-click will wake you up.')
            return
            -- no sleeping on this place
        else
            default.player_attached[pname] = false
            clicker:set_pos({x = pos.x, y = pos.y - 0.5, z = pos.z})
            clicker:set_eye_offset({x = 0, y = 0, z = 0}, {x = 0, y = 0, z = 0})
            clicker:set_physics_override(1, 1, 1)
            default.player_set_animation(clicker, "stand", 30)
            minetest.chat_send_player(pname, 'That was enough sitting around for now. You stand up again.')
            return
        end
    end

    clicker:set_eye_offset({x = 0, y = -7, z = 2}, {x = 0, y = 0, z = 0})
    clicker:set_pos(p)
    default.player_set_animation(clicker, new_animation, 30)
    clicker:set_physics_override(0, 0, 0)
    default.player_attached[pname] = true

    if (allow_sleep == true) then
        minetest.chat_send_player(pname, 'Aaah! What a comftable ' .. place_name .. '. A second right-click will let you sleep.')
    else
        minetest.chat_send_player(pname, 'Comftable, but not good enough for a nap. Right-click again if you want to get back up.')
    end
end
