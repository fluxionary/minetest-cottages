local S = cottages.S
local t = cottages.textures
local api = cottages.water
local ci = cottages.craftitems

local player_can_use = cottages.util.player_can_use
local switch_public = cottages.util.switch_public

minetest.register_node("cottages:water_gen", {
	description = S("Tree Trunk Well"),
	tiles = {t.tree_top, ("%s^[transformR90"):format(t.tree), ("%s^[transformR90"):format(t.tree)},
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",

	is_ground_content = false,
	groups = {choppy = 2, cracky = 1, flammable = 2},
	sounds = cottages.sounds.wood,

	node_box = {
		type = "fixed",
		fixed = {
			-- floor of water bassin
			{-0.5, -0.5 + (3 / 16), -0.5, 0.5, -0.5 + (4 / 16), 0.5},
			-- walls
			{-0.5, -0.5 + (3 / 16), -0.5, 0.5, (4 / 16), -0.5 + (2 / 16)},
			{-0.5, -0.5 + (3 / 16), -0.5, -0.5 + (2 / 16), (4 / 16), 0.5},
			{0.5, -0.5 + (3 / 16), 0.5, 0.5 - (2 / 16), (4 / 16), -0.5},
			{0.5, -0.5 + (3 / 16), 0.5, -0.5 + (2 / 16), (4 / 16), 0.5 - (2 / 16)},
			-- feet
			{-0.5 + (3 / 16), -0.5, -0.5 + (3 / 16), -0.5 + (6 / 16), -0.5 + (3 / 16), 0.5 - (3 / 16)},
			{0.5 - (3 / 16), -0.5, -0.5 + (3 / 16), 0.5 - (6 / 16), -0.5 + (3 / 16), 0.5 - (3 / 16)},
			-- real pump
			{0.5 - (4 / 16), -0.5, -(2 / 16), 0.5, 0.5 + (4 / 16), (2 / 16)},
			-- water pipe inside wooden stem
			{0.5 - (8 / 16), 0.5 + (1 / 16), -(1 / 16), 0.5, 0.5 + (3 / 16), (1 / 16)},
			-- where the water comes out
			{0.5 - (15 / 32), 0.5, -(1 / 32), 0.5 - (12 / 32), 0.5 + (1 / 16), (1 / 32)},
		},
	},
	selection_box = {
		type = "fixed",
		fixed = {-0.5, -0.5, -0.5, 0.5, 0.5 + (4 / 16), 0.5}
	},

	on_construct = function(pos)
		local meta = minetest.get_meta(pos)
		local inv = meta:get_inventory()
		inv:set_size("main", 6)
		api.update_formspec(pos)
		api.update_infotext(pos)
	end,

	after_place_node = function(pos, placer)
		local meta = minetest.get_meta(pos)
		meta:set_string("owner", placer:get_player_name())
		meta:set_string("bucket", "")
		api.update_formspec(pos)
		api.update_infotext(pos)
	end,

	can_dig = function(pos, player)
		local meta = minetest.get_meta(pos)
		local inv = meta:get_inventory()
		return (
			inv:is_empty("main") and
			player_can_use(pos, player) and
			not meta:get("bucket")
		)
	end,

	allow_metadata_inventory_move = function(pos, from_list, from_index, to_list, to_index, count, player)
		return 0
	end,

	allow_metadata_inventory_put = function(pos, listname, index, stack, player)
		if not player_can_use(pos, player) then
			return 0
		end

		local sname = stack:get_name()
		if sname ~= ci.bucket and sname ~= ci.bucket_filled then
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

	on_blast = function()
	end,

	on_receive_fields = function(pos, formname, fields, sender)
		if switch_public(pos, fields, sender, "well") then
			api.update_infotext(pos)
			api.update_formspec(pos)
		end
	end,

	on_timer = function(pos, elapsed)
		api.fill_bucket(pos)
	end,

	on_punch = function(pos, node, puncher, pointed_thing)
		api.use_well(pos, puncher)
	end,
})

minetest.register_lbm({
	name = "cottages:add_well_entity",
	label = "Initialize entity to cottages well",
	nodenames = {"cottages:water_gen"},
	run_at_every_load = true,
	action = function(pos, node)
		api.initialize_entity(pos)
	end
})
