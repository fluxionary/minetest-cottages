local S = cottages.S

local api = cottages.anvil

local player_can_use = cottages.util.player_can_use
local switch_public = cottages.util.switch_public


local function allow_metadata_inventory_put(pos, listname, index, stack, player)
	if not player_can_use(pos, player) then
		return 0
	end

	local stack_name = stack:get_name()

	if listname == "hammer" and stack_name ~= "cottages:hammer" then
		return 0
	end

	if listname == "input" then
		local player_name = player and player:get_player_name()

		if stack:get_wear() == 0 or not stack:is_known() then
			minetest.chat_send_player(player:get_player_name(), S("The workpiece slot is for damaged tools only."))
			return 0
		end

		if not cottages.anvil.can_repair(stack) then
			local description = stack:get_short_description() or stack:get_description()
			minetest.chat_send_player(player_name, S("@1 cannot be repaired with an anvil.", description))
			return 0
		end
	end

	return stack:get_count()
end

local function allow_metadata_inventory_take(pos, listname, index, stack, player)
	if player_can_use(pos, player) then
		return stack:get_count()
	end

	return 0
end

local function allow_metadata_inventory_move(pos, from_list, from_index, to_list, to_index, count, player)
	local meta = minetest.get_meta(pos)
	local inv = meta:get_inventory()
	local from_stack = inv:get_stack(from_list, from_index)

	if allow_metadata_inventory_take(pos, from_list, from_index, from_stack, player) > 0
		and allow_metadata_inventory_put(pos, to_list, to_index, from_stack, player) > 0 then
		return count
	end

	return 0
end

minetest.register_node("cottages:anvil", {
	drawtype = "nodebox",
	description = S("anvil"),
	tiles = {"cottages_stone.png"},
	paramtype = "light",
	paramtype2 = "facedir",
	is_ground_content = false,
	groups = {cracky = 2},

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
		switch_public(pos, formname, fields, sender, "anvil")
	end,

	on_construct = function(pos)
		local meta = minetest.get_meta(pos)
		local inv = meta:get_inventory()
		inv:set_size("input", 1)
		inv:set_size("hammer", 1)
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
		local owner = meta:get_string("owner")
		local player_name = player:get_player_name()

		return inv:is_empty("input") and inv:is_empty("hammer") and owner == player_name
	end,

	allow_metadata_inventory_move = allow_metadata_inventory_move,

	on_metadata_inventory_move = function(pos, from_list, from_index, to_list, to_index, count, player)
		if to_list == "input" then
			local meta = minetest.get_meta(pos)
			meta:set_int("informed", 0)
		end
	end,

	allow_metadata_inventory_put = allow_metadata_inventory_put,

	on_metadata_inventory_put = function(pos, listname, index, stack, player)
		if listname == "input" then
			local meta = minetest.get_meta(pos)
			meta:set_int("informed", 0)
		end
	end,

	allow_metadata_inventory_take = allow_metadata_inventory_take,

	on_punch = function(pos, node, puncher)
		api.use_anvil(pos, puncher)
	end,
})
