
local S = cottages.S

minetest.register_node("cottages:barrel", {
    description = S("Barrel (Closed)"),
    drawtype = "mesh",
    paramtype = "light",
    paramtype2 = "facedir",
    mesh = "cottages_barrel_closed.obj",
    tiles = {"cottages_barrel.png"},
    is_ground_content = false,
    drop = "cottages:barrel",
    groups = {
        snappy = 1,
        choppy = 2,
        oddly_breakable_by_hand = 1,
        flammable = 2
    },
    on_rightclick = function(pos, node, puncher)
        if minetest.is_protected(pos, puncher) then
            minetest.record_protection_violation(pos, puncher)
        else
            node.name = "cottages:barrel_open"
            minetest.swap_node(pos, node)
        end
    end,
})

-- this barrel is opened at the top
minetest.register_node("cottages:barrel_open", {
    description = S("Barrel (Open)"),
    drawtype = "mesh",
    paramtype = "light",
    paramtype2 = "facedir",
    mesh = "cottages_barrel.obj",
    tiles = {"cottages_barrel.png"},
    is_ground_content = false,
    drop = "cottages:barrel",
    groups = {
        snappy = 1,
        choppy = 2,
        oddly_breakable_by_hand = 1,
        flammable = 2,
        not_in_creative_inventory = 1,
    },
    on_rightclick = function(pos, node, puncher)
        if minetest.is_protected(pos, puncher) then
            minetest.record_protection_violation(pos, puncher)
        else
            node.name = "cottages:barrel"
            minetest.swap_node(pos, node)
        end
    end,
})

-- let's hope "tub" is the correct english word for "bottich"
minetest.register_node("cottages:tub", {
    description = S("tub"),
    paramtype = "light",
    drawtype = "mesh",
    mesh = "cottages_tub.obj",
    tiles = {"cottages_barrel.png"},
    selection_box = {
        type = "fixed",
        fixed = {
            {-0.5, -0.5, -0.5, 0.5, -0.1, 0.5},
        }},
    collision_box = {
        type = "fixed",
        fixed = {
            {-0.5, -0.5, -0.5, 0.5, -0.1, 0.5},
        }},
    groups = {
        snappy = 1,
        choppy = 2,
        oddly_breakable_by_hand = 1,
        flammable = 2
    },
    is_ground_content = false,
})
