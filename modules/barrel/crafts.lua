

minetest.register_craft({
    output = "cottages:barrel",
    recipe = {
        {cottages.craftitem.wood, "", cottages.craftitem.wood},
        {cottages.craftitem.steel, "", cottages.craftitem.steel},
        {cottages.craftitem.wood, cottages.craftitem.wood, cottages.craftitem.wood},
    },
})

minetest.register_craft({
    output = "cottages:tub 2",
    recipe = {
        {"cottages:barrel"},
    },
})

minetest.register_craft({
    output = "cottages:barrel",
    recipe = {
        {"cottages:tub"},
        {"cottages:tub"},
    },
})
