std = "lua51+luajit+minetest+cottages"
unused_args = false
max_line_length = 120

stds.minetest = {
	read_globals = {
		"DIR_DELIM",
		"minetest",
		"core",
		"dump",
		"vector",
		"nodeupdate",
		"VoxelManip",
		"VoxelArea",
		"PseudoRandom",
		"ItemStack",
		"default",
		"table",
		"math",
		"string",
	}
}

stds.cottages = {
	globals = {
		"cottages",
	},
	read_globals = {
		"default",
		"node_entity_queue",
		"stamina",
		"unified_inventory",

	},
}
