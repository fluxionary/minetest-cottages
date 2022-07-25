local ci = cottages.craftitem

minetest.register_craft({
	output = "cottages:straw_mat 6",
	recipe = {
		{ci.stone, "", ""},
		{"farming:wheat", "farming:wheat", "farming:wheat", },
	},
	replacements = {{ci.stone, ci.seed_wheat .. " 3"}},
})

-- this is a better way to get straw mats
minetest.register_craft({
	output = "cottages:threshing_floor",
	recipe = {
		{ci.junglewood, ci.chest_locked, ci.junglewood, },
		{ci.junglewood, ci.stone, ci.junglewood, },
	},
})

-- and a way to turn wheat seeds into flour
minetest.register_craft({
	output = "cottages:quern",
	recipe = {
		{ci.stick, ci.stone, "", },
		{"", ci.steel, "", },
		{"", ci.stone, "", },
	},
})

minetest.register_craft({
	output = "cottages:straw_bale",
	recipe = {
		{"cottages:straw_mat"},
		{"cottages:straw_mat"},
		{"cottages:straw_mat"},
	},
})

minetest.register_craft({
	output = "cottages:straw",
	recipe = {
		{"cottages:straw_bale"},
	},
})

minetest.register_craft({
	output = "cottages:straw_bale",
	recipe = {
		{"cottages:straw"},
	},
})

minetest.register_craft({
	output = "cottages:straw_mat 3",
	recipe = {
		{"cottages:straw_bale"},
	},
})
