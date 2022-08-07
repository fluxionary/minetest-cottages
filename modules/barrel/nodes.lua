local S = cottages.S

local api = cottages.barrel

local player_can_use = cottages.util.player_can_use
local switch_public = cottages.util.switch_public
local table_set_all = cottages.util.table_set_all

local barrel_def = {
	description = S("Barrel (Closed)"),
	drawtype = "mesh",
	paramtype = "light",
	paramtype2 = "facedir",
	mesh = "cottages_barrel_closed.obj",
	tiles = {"cottages_barrel.png"},
	is_ground_content = false,
	drop = "cottages:barrel",
	groups = {
		snappy = 1,
		choppy = 2,
		oddly_breakable_by_hand = 1,
		flammable = 2
	},

	on_rightclick = function(pos, node, puncher)
		if not player_can_use(pos, puncher) then
			minetest.record_protection_violation(pos, puncher)
			return

		elseif node.name == "cottages:barrel" then
			node.name = "cottages:barrel_open"
			minetest.swap_node(pos, node)

		elseif node.name == "cottages:barrel_open" then
			node.name = "cottages:barrel"
			minetest.swap_node(pos, node)
		end
	end,

	on_receive_fields = function(pos, formname, fields, sender)
		switch_public(pos, formname, fields, sender, "anvil")
	end,

	on_construct = function(pos)
		local meta = minetest.get_meta(pos)
		local inv = meta:get_inventory()
		inv:set_size("input", 1)
		inv:set_size("output", 1)
		api.update_infotext(pos)
		api.update_formspec(pos)
	end,

	after_place_node = function(pos, placer)
		local meta = minetest.get_meta(pos)
		local owner = placer:get_player_name()
		meta:set_string("owner", owner)
		api.update_infotext(pos)
		api.update_formspec(pos)
	end,

	can_dig = function(pos, player)
		if not player_can_use(pos, player) then
			return false
		end

		local meta = minetest.get_meta(pos)
		local inv = meta:get_inventory()
		local liquid_amount = meta:get_int("liquid_amount")

		return inv:is_empty("input") and inv:is_empty("output") and liquid_amount
	end,

	allow_metadata_inventory_move = function(pos, from_list, from_index, to_list, to_index, count, player)
		return false
	end,

	allow_metadata_inventory_put = function(pos, listname, index, stack, player)
		if listname == "input" then
		elseif listname == "output" then

		end
		error()
	end,

	on_metadata_inventory_put = function(pos, listname, index, stack, player)
		error()
	end,

	allow_metadata_inventory_take = function(pos, listname, index, stack, player)
		error()
	end,
}

minetest.register_node("cottages:barrel", barrel_def)
local barrel_open_def = table.copy(barrel_def)
table_set_all(barrel_open_def, {
	description = S("Barrel (Open)"),
	mesh = "cottages_barrel.obj",
	drop = "cottages:barrel",
	groups = {
		snappy = 1,
		choppy = 2,
		oddly_breakable_by_hand = 1,
		flammable = 2,
		not_in_creative_inventory = 1,
	},

})

-- this barrel is opened at the top
minetest.register_node("cottages:barrel_open", barrel_open_def)

-- let's hope "tub" is the correct english word for "bottich"
minetest.register_node("cottages:tub", {
	description = S("tub"),
	paramtype = "light",
	drawtype = "mesh",
	mesh = "cottages_tub.obj",
	tiles = {"cottages_barrel.png"},
	selection_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.5, 0.5, -0.1, 0.5},
		}},
	collision_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.5, 0.5, -0.1, 0.5},
		}},
	groups = {
		snappy = 1,
		choppy = 2,
		oddly_breakable_by_hand = 1,
		flammable = 2
	},
	is_ground_content = false,
})
