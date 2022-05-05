
local S = cottages.S

-- a bed without functionality - just decoration
minetest.register_node("cottages:bed_foot", {
    description = S("Bed (foot region)"),
    drawtype = "nodebox",
    tiles = {"cottages_beds_bed_top_bottom.png", cottages.texture_furniture, "cottages_beds_bed_side.png", "cottages_beds_bed_side.png", "cottages_beds_bed_side.png", "cottages_beds_bed_side.png"},
    paramtype = "light",
    paramtype2 = "facedir",
    groups = {snappy = 1, choppy = 2, oddly_breakable_by_hand = 2, flammable = 3},
    sounds = cottages.sounds.wood,
    node_box = {
        type = "fixed",
        fixed = {
            -- bed
            {-0.5, 0.0, -0.5, 0.5, 0.3, 0.5},

            -- stützen
            {-0.5, -0.5, -0.5, -0.4, 0.5, -0.4},
            {0.4, -0.5, -0.5, 0.5, 0.5, -0.4},

            -- Querstrebe
            {-0.4, 0.3, -0.5, 0.4, 0.5, -0.4}
        }
    },
    selection_box = {
        type = "fixed",
        fixed = {
            {-0.5, -0.5, -0.5, 0.5, 0.3, 0.5},
        }
    },
    is_ground_content = false,
    on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)
        return cottages.sleep_in_bed(pos, node, clicker, itemstack, pointed_thing)
    end
})

-- the bed is split up in two parts to avoid destruction of blocks on placement
minetest.register_node("cottages:bed_head", {
    description = S("Bed (head region)"),
    drawtype = "nodebox",
    tiles = {"cottages_beds_bed_top_top.png", cottages.texture_furniture, "cottages_beds_bed_side_top_r.png", "cottages_beds_bed_side_top_l.png", cottages.texture_furniture, "cottages_beds_bed_side.png"},
    paramtype = "light",
    paramtype2 = "facedir",
    groups = {snappy = 1, choppy = 2, oddly_breakable_by_hand = 2, flammable = 3},
    sounds = cottages.sounds.wood,
    node_box = {
        type = "fixed",
        fixed = {
            -- bed
            {-0.5, 0.0, -0.5, 0.5, 0.3, 0.5},

            -- stützen
            {-0.5, -0.5, 0.4, -0.4, 0.5, 0.5},
            {0.4, -0.5, 0.4, 0.5, 0.5, 0.5},

            -- Querstrebe
            {-0.4, 0.3, 0.4, 0.4, 0.5, 0.5}
        }
    },
    selection_box = {
        type = "fixed",
        fixed = {
            {-0.5, -0.5, -0.5, 0.5, 0.3, 0.5},
        }
    },
    is_ground_content = false,
    on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)
        return cottages.sleep_in_bed(pos, node, clicker, itemstack, pointed_thing)
    end
})


-- the basic version of a bed - a sleeping mat
-- to facilitate upgrade path straw mat -> sleeping mat -> bed, this uses a nodebox
minetest.register_node("cottages:sleeping_mat", {
    description = S("sleeping mat"),
    drawtype = 'nodebox',
    tiles = {'cottages_sleepingmat.png'}, -- done by VanessaE
    wield_image = 'cottages_sleepingmat.png',
    inventory_image = 'cottages_sleepingmat.png',
    sunlight_propagates = true,
    paramtype = 'light',
    paramtype2 = "facedir",
    walkable = false,
    groups = {snappy = 3},
    sounds = cottages.sounds.leaves,
    selection_box = {
        type = "wallmounted",
    },
    node_box = {
        type = "fixed",
        fixed = {
            {-0.48, -0.5, -0.48, 0.48, -0.5 + 1 / 16, 0.48},
        }
    },
    selection_box = {
        type = "fixed",
        fixed = {
            {-0.48, -0.5, -0.48, 0.48, -0.5 + 2 / 16, 0.48},
        }
    },
    is_ground_content = false,
    on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)
        return cottages.sleep_in_bed(pos, node, clicker, itemstack, pointed_thing)
    end
})


-- this one has a pillow for the head; thus, param2 becomes visible to the builder, and mobs may use it as a bed
minetest.register_node("cottages:sleeping_mat_head", {
    description = S("sleeping mat with pillow"),
    drawtype = 'nodebox',
    tiles = {'cottages_sleepingmat.png'}, -- done by VanessaE
    wield_image = 'cottages_sleepingmat.png',
    inventory_image = 'cottages_sleepingmat.png',
    sunlight_propagates = true,
    paramtype = 'light',
    paramtype2 = "facedir",
    groups = {snappy = 3},
    sounds = cottages.sounds.leaves,
    node_box = {
        type = "fixed",
        fixed = {
            {-0.48, -0.5, -0.48, 0.48, -0.5 + 1 / 16, 0.48},
            {-0.34, -0.5 + 1 / 16, -0.12, 0.34, -0.5 + 2 / 16, 0.34},
        }
    },
    selection_box = {
        type = "fixed",
        fixed = {
            {-0.48, -0.5, -0.48, 0.48, -0.5 + 2 / 16, 0.48},
        }
    },
    is_ground_content = false,
    on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)
        return cottages.sleep_in_bed(pos, node, clicker, itemstack, pointed_thing)
    end
})


-- furniture; possible replacement: 3dforniture:chair
minetest.register_node("cottages:bench", {
    drawtype = "nodebox",
    description = S("simple wooden bench"),
    tiles = {"cottages_minimal_wood.png", "cottages_minimal_wood.png", "cottages_minimal_wood.png", "cottages_minimal_wood.png", "cottages_minimal_wood.png", "cottages_minimal_wood.png"},
    paramtype = "light",
    paramtype2 = "facedir",
    groups = {snappy = 1, choppy = 2, oddly_breakable_by_hand = 2, flammable = 3},
    sounds = cottages.sounds.wood,
    node_box = {
        type = "fixed",
        fixed = {
            -- sitting area
            {-0.5, -0.15, 0.1, 0.5, -0.05, 0.5},

            -- stützen
            {-0.4, -0.5, 0.2, -0.3, -0.15, 0.4},
            {0.3, -0.5, 0.2, 0.4, -0.15, 0.4},
        }
    },
    selection_box = {
        type = "fixed",
        fixed = {
            {-0.5, -0.5, 0, 0.5, 0, 0.5},
        }
    },
    is_ground_content = false,
    on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)
        return cottages.sit_on_bench(pos, node, clicker, itemstack, pointed_thing)
    end,
})


-- a simple table; possible replacement: 3dforniture:table
local cottages_table_def = {
    description = S("table"),
    drawtype = "nodebox",
    -- top, bottom, side1, side2, inner, outer
    tiles = {"cottages_minimal_wood.png"},
    paramtype = "light",
    paramtype2 = "facedir",
    groups = {snappy = 2, choppy = 2, oddly_breakable_by_hand = 2},
    node_box = {
        type = "fixed",
        fixed = {
            {-0.1, -0.5, -0.1, 0.1, 0.3, 0.1},
            {-0.5, 0.48, -0.5, 0.5, 0.4, 0.5},
        },
    },
    selection_box = {
        type = "fixed",
        fixed = {
            {-0.5, -0.5, -0.5, 0.5, 0.4, 0.5},
        },
    },
    is_ground_content = false,
}


-- search for the workbench in AdventureTest
local workbench = minetest.registered_nodes["workbench:3x3"]
if (workbench) then
    cottages_table_def.tiles = {workbench.tiles[1], cottages_table_def.tiles[1]}
    cottages_table_def.on_rightclick = workbench.on_rightclick
end
-- search for the workbench from RealTEst
workbench = minetest.registered_nodes["workbench:work_bench_birch"]
if (workbench) then
    cottages_table_def.tiles = {workbench.tiles[1], cottages_table_def.tiles[1]}
    cottages_table_def.on_construct = workbench.on_construct
    cottages_table_def.can_dig = workbench.can_dig
    cottages_table_def.on_metadata_inventory_take = workbench.on_metadata_inventory_take
    cottages_table_def.on_metadata_inventory_move = workbench.on_metadata_inventory_move
    cottages_table_def.on_metadata_inventory_put = workbench.on_metadata_inventory_put
end

minetest.register_node("cottages:table", cottages_table_def)

-- looks better than two slabs impersonating a shelf; also more 3d than a bookshelf
-- the infotext shows if it's empty or not
minetest.register_node("cottages:shelf", {
    description = S("open storage shelf"),
    drawtype = "nodebox",
    -- top, bottom, side1, side2, inner, outer
    tiles = {"cottages_minimal_wood.png"},
    paramtype = "light",
    paramtype2 = "facedir",
    groups = {snappy = 2, choppy = 2, oddly_breakable_by_hand = 2},
    node_box = {
        type = "fixed",
        fixed = {

            {-0.5, -0.5, -0.3, -0.4, 0.5, 0.5},
            {0.4, -0.5, -0.3, 0.5, 0.5, 0.5},

            {-0.5, -0.2, -0.3, 0.5, -0.1, 0.5},
            {-0.5, 0.3, -0.3, 0.5, 0.4, 0.5},
        },
    },
    selection_box = {
        type = "fixed",
        fixed = {
            {-0.5, -0.5, -0.5, 0.5, 0.5, 0.5},
        },
    },

    on_construct = function(pos)

        local meta = minetest.get_meta(pos)

        local spos = pos.x .. "," .. pos.y .. "," .. pos.z
        meta:set_string("formspec",
            "size[8,8]" ..
                "list[current_name;main;0,0;8,3;]" ..
                "list[current_player;main;0,4;8,4;]" ..
                "listring[nodemeta:" .. spos .. ";main]" ..
                "listring[current_player;main]")
        meta:set_string("infotext", S("open storage shelf"))
        local inv = meta:get_inventory()
        inv:set_size("main", 24)
    end,

    can_dig = function(pos, player)
        local meta = minetest.get_meta(pos)
        local inv = meta:get_inventory()
        return inv:is_empty("main")
    end,

    on_metadata_inventory_put = function(pos, listname, index, stack, player)
        local meta = minetest.get_meta(pos)
        meta:set_string('infotext', S('open storage shelf (in use)'))
    end,
    on_metadata_inventory_take = function(pos, listname, index, stack, player)
        local meta = minetest.get_meta(pos)
        local inv = meta:get_inventory()
        if (inv:is_empty("main")) then
            meta:set_string('infotext', S('open storage shelf (empty)'))
        end
    end,
    is_ground_content = false,


})

-- so that the smoke from a furnace can get out of a building
minetest.register_node("cottages:stovepipe", {
    description = S("stovepipe"),
    drawtype = "nodebox",
    tiles = {"cottages_steel_block.png"},
    paramtype = "light",
    paramtype2 = "facedir",
    groups = {snappy = 2, choppy = 2, oddly_breakable_by_hand = 2},
    node_box = {
        type = "fixed",
        fixed = {
            {0.20, -0.5, 0.20, 0.45, 0.5, 0.45},
        },
    },
    selection_box = {
        type = "fixed",
        fixed = {
            {0.20, -0.5, 0.20, 0.45, 0.5, 0.45},
        },
    },
    is_ground_content = false,
})


-- this washing place can be put over a water source (it is open at the bottom)
minetest.register_node("cottages:washing", {
    description = S("washing place"),
    drawtype = "nodebox",
    -- top, bottom, side1, side2, inner, outer
    tiles = {"cottages_clay.png"},
    paramtype = "light",
    paramtype2 = "facedir",
    groups = {snappy = 2, choppy = 2, oddly_breakable_by_hand = 2},
    node_box = {
        type = "fixed",
        fixed = {
            {-0.5, -0.5, -0.5, 0.5, -0.2, -0.2},

            {-0.5, -0.5, -0.2, -0.4, 0.2, 0.5},
            {0.4, -0.5, -0.2, 0.5, 0.2, 0.5},

            {-0.4, -0.5, 0.4, 0.4, 0.2, 0.5},
            {-0.4, -0.5, -0.2, 0.4, 0.2, -0.1},

        },
    },
    selection_box = {
        type = "fixed",
        fixed = {
            {-0.5, -0.5, -0.5, 0.5, 0.2, 0.5},
        },
    },
    on_rightclick = function(pos, node, player)
        -- works only with water beneath
        local node_under = minetest.get_node({x = pos.x, y = (pos.y - 1), z = pos.z})
        if (not (node_under) or node_under.name == "ignore" or (node_under.name ~= 'default:water_source' and node_under.name ~= 'default:water_flowing')) then
            minetest.chat_send_player(player:get_player_name(), S("Sorry. This washing place is out of water. Please place it above water!"))
        else
            minetest.chat_send_player(player:get_player_name(), S("You feel much cleaner after some washing."))
        end
    end,
    is_ground_content = false,

})
