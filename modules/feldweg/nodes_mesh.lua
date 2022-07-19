local S = cottages.S

-- a nice dirt road for small villages or paths to fields
minetest.register_node("cottages:feldweg", {
	description = S("dirt road"),
	paramtype2 = "facedir",
	legacy_facedir_simple = true,
	groups = {crumbly = 3},
	sounds = cottages.sounds.dirt,
	is_ground_content = false,
	tiles = {"cottages_feldweg_end.png", "default_dirt.png^default_grass_side.png",
	         "default_dirt.png", "default_grass.png",
	         "cottages_feldweg_surface.png",
	         "cottages_feldweg_surface.png^cottages_feldweg_edges.png"},
	paramtype = "light",
	drawtype = "mesh",
	mesh = "feldweg.obj",
})

minetest.register_node("cottages:feldweg_crossing", {
	description = S("dirt road crossing"),
	paramtype2 = "facedir",
	legacy_facedir_simple = true,
	groups = {crumbly = 3},
	sounds = cottages.sounds.dirt,
	is_ground_content = false,
	tiles = {"cottages_feldweg_end.png", "default_dirt.png",
	         "default_grass.png", "cottages_feldweg_surface.png",
	         "cottages_feldweg_surface.png^cottages_feldweg_edges.png"},
	paramtype = "light",
	drawtype = "mesh",
	mesh = "feldweg-crossing.obj",
})

minetest.register_node("cottages:feldweg_t_junction", {
	description = S("dirt road t junction"),
	paramtype2 = "facedir",
	legacy_facedir_simple = true,
	groups = {crumbly = 3},
	sounds = cottages.sounds.dirt,
	is_ground_content = false,
	tiles = {"cottages_feldweg_end.png", "default_dirt.png^default_grass_side.png", "default_dirt.png",
	         "default_grass.png", "cottages_feldweg_surface.png",
	         "cottages_feldweg_surface.png^cottages_feldweg_edges.png"},
	paramtype = "light",
	drawtype = "mesh",
	mesh = "feldweg-T-junction.obj",
})

minetest.register_node("cottages:feldweg_curve", {
	description = S("dirt road curve"),
	paramtype2 = "facedir",
	legacy_facedir_simple = true,
	groups = {crumbly = 3},
	sounds = cottages.sounds.dirt,
	is_ground_content = false,
	tiles = {"default_dirt.png^default_grass_side.png", "default_grass.png",
	         "default_dirt.png^default_grass_side.png", "cottages_feldweg_surface.png",
	         "default_dirt.png", "cottages_feldweg_surface.png^cottages_feldweg_edges.png"},
	paramtype = "light",
	drawtype = "mesh",
	mesh = "feldweg-curve.obj",
})

minetest.register_node("cottages:feldweg_end", {
	description = S("dirt road end"),
	paramtype2 = "facedir",
	legacy_facedir_simple = true,
	groups = {crumbly = 3},
	sounds = cottages.sounds.dirt,
	is_ground_content = false,
	tiles = {"cottages_feldweg_end.png", "default_dirt.png^default_grass_side.png",
	         "default_dirt.png", "default_grass.png",
	         "cottages_feldweg_surface.png^cottages_feldweg_edges.png",
	         "cottages_feldweg_surface.png"},
	paramtype = "light",
	drawtype = "mesh",
	mesh = "feldweg_end.obj",
})
local box_slope = {
	type = "fixed",
	fixed = {
		{-0.5, -0.5, -0.5, 0.5, -0.25, 0.5},
		{-0.5, -0.25, -0.25, 0.5, 0, 0.5},
		{-0.5, 0, 0, 0.5, 0.25, 0.5},
		{-0.5, 0.25, 0.25, 0.5, 0.5, 0.5}
	}}

local box_slope_long = {
	type = "fixed",
	fixed = {
		{-0.5, -0.5, -1.5, 0.5, -0.10, 0.5},
		{-0.5, -0.25, -1.3, 0.5, -0.25, 0.5},
		{-0.5, -0.25, -1.0, 0.5, 0, 0.5},
		{-0.5, 0, -0.5, 0.5, 0.25, 0.5},
		{-0.5, 0.25, 0, 0.5, 0.5, 0.5}
	}}

minetest.register_node("cottages:feldweg_slope", {
	description = S("dirt road slope"),
	paramtype2 = "facedir",
	legacy_facedir_simple = true,
	groups = {crumbly = 3},
	sounds = cottages.sounds.dirt,
	is_ground_content = false,
	tiles = {"cottages_feldweg_end.png", "default_dirt.png^default_grass_side.png",
	         "default_dirt.png", "default_grass.png",
	         "cottages_feldweg_surface.png",
	         "cottages_feldweg_surface.png^cottages_feldweg_edges.png"},
	paramtype = "light",
	drawtype = "mesh",
	mesh = "feldweg_slope.obj",

	collision_box = box_slope,
	selection_box = box_slope,
})

minetest.register_node("cottages:feldweg_slope_long", {
	description = S("dirt road slope long"),
	paramtype2 = "facedir",
	legacy_facedir_simple = true,
	groups = {crumbly = 3},
	sounds = cottages.sounds.dirt,
	is_ground_content = false,
	tiles = {"cottages_feldweg_end.png", "default_dirt.png^default_grass_side.png",
	         "default_dirt.png", "default_grass.png",
	         "cottages_feldweg_surface.png",
	         "cottages_feldweg_surface.png^cottages_feldweg_edges.png"},
	paramtype = "light",
	drawtype = "mesh",
	mesh = "feldweg_slope_long.obj",
	collision_box = box_slope_long,
	selection_box = box_slope_long,
})
