local F = minetest.formspec_escape
local S = cottages.S
local FS = function(...) return F(S(...)) end

local switch_public = cottages.util.switch_public

local cottages_formspec_treshing_floor = ([[
	size[8,8]
	image[1.5,0;1,1;%s]
	image[0,1;1,1;%s]
	button[6.8,0.0;1.5,0.5;public;%s]
	list[context;harvest;1,1;2,1;]
	list[context;straw;5,0;2,2;]
	list[context;seeds;5,2;2,2;]
	label[1,0.5;%s]
	label[4,0.0;%s]
	label[4,2.0;%s]
	label[0,0;%s]
	label[0,2.5;%s]
	label[0,3.0;%s]
	list[current_player;main;0,4;8,4;]
	listring[current_player;main]
	listring[context;harvest]
	listring[current_player;main]
	listring[context;straw]
	listring[current_player;main]
	listring[context;seeds]
]]):format(
	F(cottages.textures.stick),
	F(cottages.textures.wheat),
	FS("Public?"),
	FS("Input:"),
	FS("Output1:"),
	FS("Output2:"),
	FS("Threshing Floor"),
	FS("Punch threshing floor with a stick"),
	FS("to get straw and seeds from wheat.")
)

local function update_formspec(pos)
	local meta = minetest.get_meta(pos)
	local owner = meta:get_string("owner")
	if owner == "" then
		meta:set_string("formspec", cottages_formspec_treshing_floor)

	else
		meta:set_string("formspec", cottages_formspec_treshing_floor ..
			("label[2.5,0;%s]"):format(FS("Owner: @1", owner)))
	end
end

minetest.register_node("cottages:threshing_floor", {
	description = S("threshing floor\npunch with a stick to operate"),
	short_description = S("threshing floor"),
	tiles = {
		"cottages_junglewood.png^farming_wheat.png",
		"cottages_junglewood.png",
		"cottages_junglewood.png^" .. cottages.textures.stick
	},
	groups = {cracky = 2, choppy = 2},
	is_ground_content = false,

	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.50, -0.5, -0.50, 0.50, -0.40, 0.50},

			{-0.50, -0.4, -0.50, -0.45, -0.20, 0.50},
			{0.45, -0.4, -0.50, 0.50, -0.20, 0.50},

			{-0.45, -0.4, -0.50, 0.45, -0.20, -0.45},
			{-0.45, -0.4, 0.45, 0.45, -0.20, 0.50},
		}
	},
	selection_box = {
		type = "fixed",
		fixed = {
			{-0.50, -0.5, -0.50, 0.50, -0.20, 0.50},
		}
	},
	sounds = cottages.sounds.wood,

	on_construct = function(pos)
		local meta = minetest.get_meta(pos)
		meta:set_string("infotext", S("Public threshing floor"))
		local inv = meta:get_inventory()
		inv:set_size("harvest", 2)
		inv:set_size("straw", 4)
		inv:set_size("seeds", 4)
		update_formspec(pos)
	end,

	after_place_node = function(pos, placer)
		local meta = minetest.get_meta(pos)
		local owner = meta:get_string("owner")
		meta:set_string("owner", placer:get_player_name() or "")
		meta:set_string("infotext", S("Private threshing floor (owned by @1)", owner))
		update_formspec(pos)
	end,

	on_receive_fields = function(pos, formname, fields, sender)
		switch_public(pos, fields, sender, "threshing floor")
	end,

	can_dig = function(pos, player)
		local meta = minetest.get_meta(pos)
		local inv = meta:get_inventory()
		local owner = meta:get_string("owner")
		local player_name = player:get_player_name()

		return (
			(player_name == "" or player_name == owner) and
			inv:is_empty("harvest") and
			inv:is_empty("straw") and
			inv:is_empty("seeds")
		)
	end,

	allow_metadata_inventory_move = function(pos, from_list, from_index, to_list, to_index, count, player)
		return 0
	end,

	allow_metadata_inventory_put = function(pos, listname, index, stack, player)
		if not cottages.util.player_can_use(pos, player) then
			return 0
		end

		if listname == "straw" or listname == "seeds" then
			return 0
		end

		if not cottages.straw.registered_threshing_crafts[stack:get_name()] then
			return 0
		end

		return stack:get_count()
	end,

	allow_metadata_inventory_take = function(pos, listname, index, stack, player)
		if not cottages.util.player_can_use(pos, player) then
			return 0
		end

		return stack:get_count()
	end,


	on_punch = function(pos, node, puncher)
		cottages.straw.use_threshing_floor(pos, puncher)
	end,
})

minetest.register_lbm({
	name = "cottages:update_threshing_formspec",
	label = "update threshing formspec",
	nodenames = {"cottages:threshing_floor"},
	run_at_every_load = false,
	action = function(pos)
		update_formspec(pos)
	end
})
