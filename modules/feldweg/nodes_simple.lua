local S = cottages.S

minetest.register_node("cottages:feldweg", {
    description = S("dirt road"),
    tiles = {"cottages_feldweg.png", "default_dirt.png", "default_dirt.png^default_grass_side.png"},
    paramtype2 = "facedir",
    legacy_facedir_simple = true,
    groups = {crumbly = 3},
    sounds = cottages.sounds.dirt,
    is_ground_content = false,
})
