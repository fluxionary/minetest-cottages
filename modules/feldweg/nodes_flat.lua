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

minetest.register_node("cottages:feldweg_crossing", {
	description = S("dirt road crossing"),
	tiles = {"cottages_feldweg_kreuzung.png", "default_dirt.png", "default_dirt.png^default_grass_side.png"},
	paramtype2 = "facedir",
	legacy_facedir_simple = true,
	groups = {crumbly = 3},
	sounds = cottages.sounds.dirt,
	is_ground_content = false,
})

minetest.register_node("cottages:feldweg_t_junction", {
	description = S("dirt road t junction"),
	tiles = {"cottages_feldweg_t-kreuzung.png^[transform2", "default_dirt.png", "default_dirt.png^default_grass_side.png"},
	paramtype2 = "facedir",
	legacy_facedir_simple = true,
	groups = {crumbly = 3},
	sounds = cottages.sounds.dirt,
	is_ground_content = false,
})

minetest.register_node("cottages:feldweg_curve", {
	description = S("dirt road curve"),
	tiles = {"cottages_feldweg_ecke.png^[transform2", "default_dirt.png", "default_dirt.png^default_grass_side.png"},
	paramtype2 = "facedir",
	legacy_facedir_simple = true,
	groups = {crumbly = 3},
	sounds = cottages.sounds.dirt,
	is_ground_content = false,
})
