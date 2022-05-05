minetest.register_craft({
    output = "cottages:anvil",
    recipe = {
        {cottages.craftitem.steel, cottages.craftitem.steel, cottages.craftitem.steel},
        {"", cottages.craftitem.steel, ""},
        {cottages.craftitem.steel, cottages.craftitem.steel, cottages.craftitem.steel}},
})

minetest.register_craft({
    output = "cottages:hammer",
    recipe = {
        {cottages.craftitem.steel},
        {"cottages:anvil"},
        {cottages.craftitem.stick}}
})
