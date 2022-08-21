local S = cottages.S
local api = cottages.straw

local player_can_use = cottages.util.player_can_use
local switch_public = cottages.util.switch_public

minetest.register_node("cottages:quern", {
	description = S("quern-stone\npunch to operate"),
	short_description = S("quern-stone"),
	drawtype = "mesh",
	mesh = "cottages_quern.obj",
	tiles = {"cottages_stone.png"},
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {cracky = 2},
	is_ground_content = false,
	selection_box = {
		type = "fixed",
		fixed = {
			{-0.50, -0.5, -0.50, 0.50, 0.25, 0.50},
		}
	},
	collision_box = {
		type = "fixed",
		fixed = {
			{-0.50, -0.5, -0.50, 0.50, 0.25, 0.50},
		}
	},
	sounds = cottages.sounds.stone,

	on_construct = function(pos)
		local meta = minetest.get_meta(pos)
		local inv = meta:get_inventory()
		inv:set_size("seeds", 1)
		inv:set_size("flour", 4)
		api.update_quern_infotext(pos)
		api.update_quern_formspec(pos)
	end,

	after_place_node = function(pos, placer)
		local meta = minetest.get_meta(pos)
		local owner = placer:get_player_name()
		meta:set_string("owner", owner or "")
		api.update_quern_infotext(pos)
		api.update_quern_formspec(pos)
	end,

	on_receive_fields = function(pos, formname, fields, sender)
		if switch_public(pos, fields, sender, "quern") then
			api.update_infotext(pos)
			api.update_formspec(pos)
		end
	end,

	can_dig = function(pos, player)
		if not minetest.is_player(player) then
			return false
		end

		local meta = minetest.get_meta(pos)
		local inv = meta:get_inventory()

		if not (inv:is_empty("flour") and inv:is_empty("seeds")) then
			return false
		end

		local player_name = player:get_player_name()
		local owner = meta:get_string("owner")

		return owner == "" or owner == player_name
	end,

	allow_metadata_inventory_move = function(pos, from_list, from_index, to_list, to_index, count, player)
		return 0
	end,

	allow_metadata_inventory_put = function(pos, listname, index, stack, player)
		if not player_can_use(pos, player) then
			return 0
		end

		if listname == "flour" then
			return 0
		end

		if listname == "seeds" and not cottages.straw.registered_quern_crafts[stack:get_name()] then
			return 0
		end

		return stack:get_count()
	end,

	allow_metadata_inventory_take = function(pos, listname, index, stack, player)
		if not player_can_use(pos, player) then
			return 0
		end

		return stack:get_count()
	end,

	on_punch = function(pos, node, puncher)
		api.use_quern(pos, puncher)
	end,
})

minetest.register_lbm({
	name = "cottages:update_quern_formspec",
	label = "update quern formspec",
	nodenames = {"cottages:quern"},
	run_at_every_load = false,
	action = function(pos)
		api.update_quern_formspec(pos)
	end
})
