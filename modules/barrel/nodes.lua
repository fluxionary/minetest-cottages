local S = cottages.S

local api = cottages.barrel

local player_can_use = cottages.util.player_can_use
local switch_public = cottages.util.switch_public

minetest.register_node("cottages:barrel", {
	description = S("Barrel (Closed)"),
	drawtype = "mesh",
	paramtype = "light",
	paramtype2 = "facedir",
	mesh = "cottages_barrel_closed.obj",
	tiles = {"cottages_barrel.png"},
	is_ground_content = false,
	groups = {
		snappy = 1,
		choppy = 2,
		oddly_breakable_by_hand = 1,
		flammable = 2
	},

	on_receive_fields = function(pos, formname, fields, sender)
		if switch_public(pos, fields, sender, "barrel") then
			api.update_infotext(pos)
			api.update_formspec(pos)
		end
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
		if not player_can_use(pos, player) then
			return 0
		end

		local meta = minetest.get_meta(pos)
		local inv = meta:get_inventory()
		local to_stack = inv:get_stack(to_list, to_index)

		if not to_stack:is_empty() then
			return 0
		end

		local from_stack = inv:get_stack(from_list, from_index)
		local item = from_stack:get_name()

		if to_list == "input" then
			if api.can_drain(pos, item) then
				return 1
			end

		elseif to_list == "output" then
			if api.can_fill(pos, item) then
				return 1
			end
		end

		return 0
	end,

	allow_metadata_inventory_put = function(pos, listname, index, stack, player)
		if not player_can_use(pos, player) then
			return 0
		end

		local item = stack:get_name()

		if listname == "input" then
			if api.can_drain(pos, item) then
				return 1
			end

		elseif listname == "output" then
			if api.can_fill(pos, item) then
				return 1
			end
		end

		return 0
	end,

	on_metadata_inventory_put = function(pos, listname, index, stack, player)
		local meta = minetest.get_meta(pos)
		local inv = meta:get_inventory()
		local item = stack:get_name()

		if listname == "input" then
			local empty = api.add_barrel_liquid(pos, item)
			inv:set_stack(listname, index, empty)

		elseif listname == "output" then
			local full = api.drain_barrel_liquid(pos, item)
			inv:set_stack(listname, index, full)
		end

		api.update_formspec(pos)
		api.update_infotext(pos)
	end,

	allow_metadata_inventory_take = function(pos, listname, index, stack, player)
		if player_can_use(pos, player) then
			return 1
		end

		return 0
	end,
})

-- this barrel is opened at the top
minetest.register_node("cottages:barrel_open", {
	description = S("Barrel (Open)"),
	drawtype = "mesh",
	paramtype = "light",
	paramtype2 = "facedir",
	mesh = "cottages_barrel.obj",
	tiles = {"cottages_barrel.png"},
	is_ground_content = false,
	groups = {
		snappy = 1,
		choppy = 2,
		oddly_breakable_by_hand = 1,
		flammable = 2,
	},
})

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
