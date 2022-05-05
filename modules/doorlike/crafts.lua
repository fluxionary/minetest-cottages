-----------------------------------------------------------------------------------------------------------
-- and now the crafting receipes:
-----------------------------------------------------------------------------------------------------------

-- transform opend and closed shutters into each other for convenience
minetest.register_craft({
    output = "cottages:window_shutter_open",
    recipe = {
        {"cottages:window_shutter_closed"},
    }
})

minetest.register_craft({
    output = "cottages:window_shutter_closed",
    recipe = {
        {"cottages:window_shutter_open"},
    }
})

minetest.register_craft({
    output = "cottages:window_shutter_open",
    recipe = {
        {cottages.craftitem.wood, "", cottages.craftitem.wood},
    }
})

-- transform one half door into another
minetest.register_craft({
    output = "cottages:half_door",
    recipe = {
        {"cottages:half_door_inverted"},
    }
})

minetest.register_craft({
    output = "cottages:half_door_inverted",
    recipe = {
        {"cottages:half_door"},
    }
})

minetest.register_craft({
    output = "cottages:half_door 2",
    recipe = {
        {"", cottages.craftitem.wood, ""},
        {"", cottages.craftitem.door, ""},
    }
})

-- transform open and closed versions into into another for convenience
minetest.register_craft({
    output = "cottages:gate_closed",
    recipe = {
        {"cottages:gate_open"},
    }
})

minetest.register_craft({
    output = "cottages:gate_open",
    recipe = {
        {"cottages:gate_closed"},
    }
})

minetest.register_craft({
    output = "cottages:gate_closed",
    recipe = {
        {cottages.craftitem.stick, cottages.craftitem.stick, cottages.craftitem.wood},
    }
})
