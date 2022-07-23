



---------------------------------------------------------------------------------------
-- add the diffrent roof types
---------------------------------------------------------------------------------------
cottages.register_roof("straw",
	{cottages.straw_texture, cottages.straw_texture,
	 cottages.straw_texture, cottages.straw_texture,
	 cottages.straw_texture, cottages.straw_texture},
	"cottages:straw_mat", nil)
cottages.register_roof("reet",
	{"cottages_reet.png", "cottages_reet.png",
	 "cottages_reet.png", "cottages_reet.png",
	 "cottages_reet.png", "cottages_reet.png"},
	ci.papyrus, nil)
cottages.register_roof("wood",
	{cottages.textures_roof_wood, cottages.texture_roof_sides,
	 cottages.texture_roof_sides, cottages.texture_roof_sides,
	 cottages.texture_roof_sides, cottages.textures_roof_wood},
	ci.wood, nil)
cottages.register_roof("black",
	{"cottages_homedecor_shingles_asphalt.png", cottages.texture_roof_sides,
	 cottages.texture_roof_sides, cottages.texture_roof_sides,
	 cottages.texture_roof_sides, "cottages_homedecor_shingles_asphalt.png"},
	"homedecor:shingles_asphalt", ci.coal_lump)
cottages.register_roof("red",
	{"cottages_homedecor_shingles_terracotta.png", cottages.texture_roof_sides,
	 cottages.texture_roof_sides, cottages.texture_roof_sides,
	 cottages.texture_roof_sides, "cottages_homedecor_shingles_terracotta.png"},
	"homedecor:shingles_terracotta", ci.clay_brick)
cottages.register_roof("brown",
	{"cottages_homedecor_shingles_wood.png", cottages.texture_roof_sides,
	 cottages.texture_roof_sides, cottages.texture_roof_sides,
	 cottages.texture_roof_sides, "cottages_homedecor_shingles_wood.png"},
	"homedecor:shingles_wood", ci.dirt)
cottages.register_roof("slate",
	{"cottages_slate.png", cottages.texture_roof_sides,
	 "cottages_slate.png", "cottages_slate.png",
	 cottages.texture_roof_sides, "cottages_slate.png"},
	ci.stone, nil)


---------------------------------------------------------------------------------------
-- slate roofs are sometimes on vertical fronts of houses
---------------------------------------------------------------------------------------
minetest.register_node("cottages:slate_vertical", {
	description = S("Vertical Slate"),
	tiles = {"cottages_slate.png", cottages.texture_roof_sides, "cottages_slate.png", "cottages_slate.png", cottages.texture_roof_sides, "cottages_slate.png"},
	paramtype2 = "facedir",
	groups = {cracky = 2, stone = 1},
	sounds = cottages.sounds.stone,
	is_ground_content = false,
})

minetest.register_craft({
	output = "cottages:slate_vertical",
	recipe = {{ci.stone, ci.wood, ""}
	}
})

---------------------------------------------------------------------------------------
-- Reed might also be needed as a full block
---------------------------------------------------------------------------------------
minetest.register_node("cottages:reet", {
	description = S("Reet for thatching"),
	tiles = {"cottages_reet.png"},
	groups = {hay = 3, snappy = 3, choppy = 3, oddly_breakable_by_hand = 3, flammable = 3},
	sounds = cottages.sounds.leaves,
	is_ground_content = false,
})

minetest.register_craft({
	output = "cottages:reet",
	recipe = {{ci.papyrus, ci.papyrus},
	          {ci.papyrus, ci.papyrus},
	},
})
