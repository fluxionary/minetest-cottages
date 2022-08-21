local S = cottages.S
local api = cottages.anvil

local player_can_use = cottages.util.player_can_use
local switch_public = cottages.util.switch_public

minetest.register_node("cottages:anvil", {
	drawtype = "nodebox",
	description = S("anvil"),
	tiles = {"cottages_stone.png^[colorize:#000:192"},
	paramtype = "light",
	paramtype2 = "facedir",
	is_ground_content = false,
	groups = {cracky = 2},
	sounds = cottages.sounds.metal,

	-- the nodebox model comes from realtest
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.3, 0.5, -0.4, 0.3},
			{-0.35, -0.4, -0.25, 0.35, -0.3, 0.25},
			{-0.3, -0.3, -0.15, 0.3, -0.1, 0.15},
			{-0.35, -0.1, -0.2, 0.35, 0.1, 0.2},
		},
	},
	selection_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.3, 0.5, -0.4, 0.3},
			{-0.35, -0.4, -0.25, 0.35, -0.3, 0.25},
			{-0.3, -0.3, -0.15, 0.3, -0.1, 0.15},
			{-0.35, -0.1, -0.2, 0.35, 0.1, 0.2},
		}
	},

	on_receive_fields = function(pos, formname, fields, sender)
		if switch_public(pos, fields, sender, "anvil") then
			api.update_infotext(pos)
			api.update_formspec(pos)
		end
	end,

	on_construct = function(pos)
		local meta = minetest.get_meta(pos)
		local inv = meta:get_inventory()
		inv:set_size("input", 1)
		inv:set_size("hammer", 1)
		api.update_infotext(pos)
		api.update_formspec(pos)
	end,

	after_place_node = function(pos, placer, itemstack, pointed_thing)
		local item_meta = itemstack:get_meta()
		local node_meta = minetest.get_meta(pos)
		local shared = item_meta:get_int("shared")

		local owner
		if shared == 1 then
			owner = ""

		elseif shared == 2 then
			owner = " "

		else
			owner = placer:get_player_name()
		end

		node_meta:set_string("owner", owner)
		api.update_infotext(pos)
		api.update_formspec(pos)
	end,

	can_dig = function(pos, player)
		if not player_can_use(pos, player) then
			return false
		end

		local meta = minetest.get_meta(pos)
		local inv = meta:get_inventory()

		return inv:is_empty("input") and inv:is_empty("hammer")
	end,

	on_punch = function(pos, node, puncher)
		return api.use_anvil(pos, puncher)
	end,

	on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)
		return api.on_rightclick(pos, node, clicker, itemstack, pointed_thing)
	end,

	preserve_metadata = function(pos, oldnode, oldmeta, drops)
		return api.preserve_metadata(pos, oldnode, oldmeta, drops)
	end,

	allow_metadata_inventory_move = function(...) return api.allow_metadata_inventory_move(...) end,
	allow_metadata_inventory_put = function(...) return api.allow_metadata_inventory_put(...) end,
	allow_metadata_inventory_take = function(...) return api.allow_metadata_inventory_take(...) end,
	on_metadata_inventory_move = function(...) return api.on_metadata_inventory_move(...) end,
	on_metadata_inventory_put = function(...) return api.on_metadata_inventory_put(...) end,
	on_metadata_inventory_take = function(...) return api.on_metadata_inventory_take(...) end,
})

-- updates formspec/infotext when updating the mod or changing settings
minetest.register_lbm({
	name = "cottages:anvil_update_formspec",
	nodenames = {"cottages:anvil"},
	run_at_every_load = true,
	action = function(pos, node, active_object_count, active_object_count_wider)
		api.update_infotext(pos)
		api.update_formspec(pos)
	end
})
