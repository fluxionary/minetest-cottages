local S = cottages.S

local max_velo = 0.0001

local attached_to = {}

function cottages.furniture.allow_sit(player)
    -- no check possible
    if not minetest.is_player(player) then
        return false
    end

    local velo = player:get_player_velocity()
    if not velo then
        return false
    end

    return vector.length(velo) < max_velo
end

function cottages.furniture.get_up(pos, player)
    local player_name = player:get_player_name()

    if cottages.has.player_monoids then
        player_monoids.speed:del_change(player, "cottages:furniture")
        player_monoids.jump:del_change(player, "cottages:furniture")
        player_monoids.gravity:del_change(player, "cottages:furniture")

    else
        player:set_physics_override(1, 1, 1)
    end

    player_api.player_attached[player_name] = nil
    player_api.set_animation(player, "stand")

    player:set_pos({x = pos.x, y = pos.y - 0.5, z = pos.z})
    player:set_eye_offset({x = 0, y = 0, z = 0}, {x = 0, y = 0, z = 0})
end

function cottages.furniture.stop_moving(player)
    if cottages.has.player_monoids then
        player_monoids.speed:add_change(player, 0, "cottages:furniture")
        player_monoids.jump:add_change(player, 0, "cottages:furniture")
        player_monoids.gravity:add_change(player, 0, "cottages:furniture")

    else
        player:set_physics_override(0, 0, 0)
    end
end

function cottages.furniture.sit_on_bench(pos, node, player)
    if not (cottages.has.player_api and cottages.furniture.allow_sit(player)) then
        return
    end

    local animation = player_api.get_animation(player)
    local player_name = player:get_player_name()

    if animation.animation == "sit" then
        cottages.furniture.get_up(pos, player)

    else
        -- the bench is not centered; prevent the player from sitting on air
        local player_pos = {x = pos.x, y = pos.y, z = pos.z}
        if not (node) or node.param2 == 0 then
            player_pos.z = player_pos.z + 0.3
        elseif node.param2 == 1 then
            player_pos.x = player_pos.x + 0.3
        elseif node.param2 == 2 then
            player_pos.z = player_pos.z - 0.3
        elseif node.param2 == 3 then
            player_pos.x = player_pos.x - 0.3
        end

        cottages.furniture.stop_moving(player)

        player_api.set_animation(player, "sit")
        player_api.player_attached[player_name] = true

        player:set_eye_offset({x = 0, y = -7, z = 2}, {x = 0, y = 0, z = 0})
        player:set_pos(player_pos)
    end
end

function cottages.furniture.is_head(node_name)
    return node_name == "cottages:bed_head" or node_name == "cottages:sleeping_mat_head"
end

function cottages.furniture.is_bed(node_name)
    return node_name == "cottages:bed_head" or node_name == "cottages:bed_foot"
end

function cottages.furniture.is_mat(node_name)
    return node_name == "cottages:sleeping_mat_head" or node_name == "cottages:sleeping_mat"
end

function cottages.furniture.is_head_of(foot_name, head_name)
    if foot_name == "cottages:bed_foot" then
        return head_name == "cottages:bed_head"
    elseif foot_name == "cottages:sleeping_mat" then
        return head_name == "cottages:sleeping_mat_head"
    end
end

function cottages.furniture.is_foot_of(head_name, foot_name)
    if head_name == "cottages:bed_head" then
        return foot_name == "cottages:bed_foot"
    elseif head_name == "cottages:sleeping_mat_head" then
        return foot_name == "cottages:sleeping_mat"
    end
end

function cottages.furniture.is_valid_bed(pos, node)
    local head_pos = vector.copy(pos)
    local foot_pos = vector.copy(pos)

    if cottages.furniture.is_head(node.name) then
        if node.param2 == 0 then
            foot_pos.z = foot_pos.z - 1
        elseif node.param2 == 1 then
            foot_pos.x = foot_pos.x - 1
        elseif node.param2 == 2 then
            foot_pos.z = foot_pos.z + 1
        elseif node.param2 == 3 then
            foot_pos.x = foot_pos.x + 1
        end

        local foot_node = minetest.get_node(foot_pos)

        if cottages.furniture.is_foot_of(node.name, foot_node.name) and node.param2 == foot_node.param2 then
            return head_pos, foot_pos
        end

    else
        if node.param2 == 2 then
            head_pos.z = pos.z - 1
        elseif node.param2 == 3 then
            head_pos.x = pos.x - 1
        elseif node.param2 == 0 then
            head_pos.z = pos.z + 1
        elseif node.param2 == 1 then
            head_pos.x = pos.x + 1
        end

        local head_node = minetest.get_node(head_pos)

        if cottages.furniture.is_head_of(node.name, head_node.name) and node.param2 == head_node.param2 then
            return head_pos, foot_pos
        end
    end
end

function cottages.furniture.sleep_in_bed(pos, node, player)
    if not (cottages.has.player_api and cottages.furniture.allow_sit(player) and pos and node and node.name) then
        return
    end

    local player_name = player:get_player_name()
    local animation = assert(player_api.get_animation(player), ("%s has no animation?!"):format(player_name))

    if animation.animation == "lay" then
        cottages.furniture.get_up(pos, player)
        minetest.chat_send_player(player_name, "That was enough sleep for now. You stand up again.")
        return
    end

    local bed_type = cottages.furniture.is_bed(node.name) and "bed" or "mat"
    local head_pos, foot_pos = cottages.furniture.is_valid_bed(pos, node)

    for _, p in ipairs({head_pos, foot_pos}) do
        if p then
            for y = 1, 2 do
                local node_above = minetest.get_node(vector.add(p, {x = 0, y = y, z = 0}))

                if node_above.name ~= "air" then
                    minetest.chat_send_player(
                            player_name,
                            S("This place is too narrow for sleeping. At least for you!")
                    )
                    return
                end
            end
        end
    end

    if player_api.player_attached[player_name] and animation.animation == "sit" then
        if head_pos and foot_pos then
            player_api.set_animation(player, "lay")
            player:set_eye_offset({x = 0, y = -14, z = 2}, {x = 0, y = 0, z = 0})
            minetest.chat_send_player(player_name, S("You lie down and take a nap. A right-click will wake you up."))

        else
            cottages.furniture.get_up(pos, player)
            minetest.chat_send_player(player_name, S("That was enough sitting around for now. You stand up again."))
        end

    else
        cottages.furniture.stop_moving(player)

        player_api.set_animation(player, "sit")
        player_api.player_attached[player_name] = true

        local sleep_pos = vector.copy(pos)

        if bed_type == "bed" then
            -- set the right height for the bed
            sleep_pos.y = sleep_pos.y + 0.4
        elseif bed_type == "mat" then
            sleep_pos.y = sleep_pos.y - 0.4
        end

        if head_pos and foot_pos then
            sleep_pos.x = (head_pos.x + foot_pos.x) / 2
            sleep_pos.z = (head_pos.z + foot_pos.z) / 2
        end

        player:set_eye_offset({x = 0, y = -7, z = 2}, {x = 0, y = 0, z = 0})
        player:set_pos(sleep_pos)

        if head_pos and foot_pos then
            minetest.chat_send_player(
                player_name,
                S("Aaah! What a comfortable @1. A second right-click will let you sleep.", bed_type)
            )
        else
            minetest.chat_send_player(
                player_name,
                S("Comfortable, but not good enough for a nap. Right-click again if you want to get back up.")
            )
        end
    end
end
