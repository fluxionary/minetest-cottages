
---------------------------------------------------------------------------------------
-- crafting receipes
---------------------------------------------------------------------------------------
minetest.register_craft({
    output = "cottages:bed_foot",
    recipe = {
        {cottages.craftitem_wool, "", "", },
        {cottages.craftitem_wood, "", "", },
        {cottages.craftitem_stick, "", "", }
    }
})

minetest.register_craft({
    output = "cottages:bed_head",
    recipe = {
        {"", "", cottages.craftitem_wool, },
        {"", cottages.craftitem_stick, cottages.craftitem_wood, },
        {"", "", cottages.craftitem_stick, }
    }
})

minetest.register_craft({
    output = "cottages:sleeping_mat 3",
    recipe = {
        {"cottages:wool_tent", "cottages:straw_mat", "cottages:straw_mat"}
    }
})

minetest.register_craft({
    output = "cottages:sleeping_mat_head",
    recipe = {
        {"cottages:sleeping_mat", "cottages:straw_mat"}
    }
})

minetest.register_craft({
    output = "cottages:table",
    recipe = {
        {"", cottages.craftitem_slab_wood, "", },
        {"", cottages.craftitem_stick, ""}
    }
})

minetest.register_craft({
    output = "cottages:bench",
    recipe = {
        {"", cottages.craftitem_wood, "", },
        {cottages.craftitem_stick, "", cottages.craftitem_stick, }
    }
})

minetest.register_craft({
    output = "cottages:shelf",
    recipe = {
        {cottages.craftitem_stick, cottages.craftitem_wood, cottages.craftitem_stick, },
        {cottages.craftitem_stick, cottages.craftitem_wood, cottages.craftitem_stick, },
        {cottages.craftitem_stick, "", cottages.craftitem_stick}
    }
})

minetest.register_craft({
    output = "cottages:washing 2",
    recipe = {
        {cottages.craftitem_stick, },
        {cottages.craftitem_clay, },
    }
})

minetest.register_craft({
    output = "cottages:stovepipe 2",
    recipe = {
        {cottages.craftitem_steel, '', cottages.craftitem_steel},
    }
})
