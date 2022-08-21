local api = cottages.straw
local S = cottages.S

local player_can_use = cottages.util.player_can_use
local switch_public = cottages.util.switch_public

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
		local inv = meta:get_inventory()
		inv:set_size("harvest", 2)
		inv:set_size("straw", 4)
		inv:set_size("seeds", 4)
		api.update_threshing_infotext(pos)
		api.update_threshing_formspec(pos)
	end,

	after_place_node = function(pos, placer)
		local meta = minetest.get_meta(pos)
		meta:set_string("owner", placer:get_player_name() or "")
		api.update_threshing_infotext(pos)
		api.update_threshing_formspec(pos)
	end,

	on_receive_fields = function(pos, formname, fields, sender)
		if switch_public(pos, fields, sender, "threshing floor") then
			api.update_infotext(pos)
			api.update_formspec(pos)
		end
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
		if not player_can_use(pos, player) then
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
		if not player_can_use(pos, player) then
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
		api.update_threshing_infotext(pos)
		api.update_threshing_formspec(pos)
	end
})
