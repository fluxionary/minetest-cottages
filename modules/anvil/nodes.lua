local S = cottages.S
local util = cottages.util

local hud_timeout = cottages.settings.anvil.hud_timeout

local hud_info_by_puncher_name = {}

local anvil_formspec = ([[
    size[8,8]
    image[7,3;1,1;cottages_tool_steelhammer.png]
    list[context;input;2.5,1.5;1,1;]
    list[context;hammer;5,3;1,1;]
    label[2.5,1.0;%s]
    label[6.0,2.7;%s]
    label[6.0,3.0;%s]
    label[6.0,3.3;%s]
    label[0,0.0;%s]
    label[0,3.0;%s]
    label[0,3.3;%s]
    list[current_player;main;0,4;8,4;]
    listring[context;hammer]
    listring[current_player;main]
    listring[context;input]
    listring[current_player;main]
]]):format(
	S("Workpiece:"),
	S("Optional"),
	S("storage for"),
	S("your hammer"),
	S("Anvil"),
	S("Punch anvil with hammer to"),
	S("repair tool in workpiece-slot.")
)

local function allow_metadata_inventory_put(pos, listname, index, stack, player)
	if not util.player_can_use(pos, player) then
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
	if util.player_can_use(pos, player) then
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

local function get_hud_image(tool)
	local tool_def = tool:get_definition()
	if tool_def then
		if tool_def.inventory_image then
			return tool_def.inventory_image
		elseif tool_def.textures then
			if type(tool_def.textures) == "string" then
				return tool_def.textures
			elseif type(tool_def.textures) == "table" then
				return tool_def.textures[1]
			end
		end
	end
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

	on_construct = function(pos)
		local meta = minetest.get_meta(pos)
		meta:set_string("infotext", S("Anvil"))
		local inv = meta:get_inventory()
		inv:set_size("input", 1)
		inv:set_size("hammer", 1)
		meta:set_string("formspec", anvil_formspec)
	end,

	after_place_node = function(pos, placer)
		local meta = minetest.get_meta(pos)
		local owner = placer:get_player_name()
		meta:set_string("owner", owner)
		meta:set_string("infotext", S("Anvil (owned by @1)", owner))
		meta:set_string("formspec",
			anvil_formspec ..
				"label[2.5,0.0;" .. S("Owner: @1", owner) .. "]")
	end,

	can_dig = function(pos, player)
		if not player and player.get_player_name then
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
		if not pos or not node or not puncher then
			return
		end

		-- only punching with the hammer is supposed to work
		local wielded = puncher:get_wielded_item()
		local wielded_name = wielded:get_name()

		if wielded_name ~= "cottages:hammer" then
			return
		end

		local puncher_name = puncher:get_player_name()
		local meta = minetest.get_meta(pos)
		local inv = meta:get_inventory()
		local tool = inv:get_stack("input", 1)
		local tool_name = tool:get_name()
		local owner = meta:get_string("owner")

		if tool:is_empty() then
			meta:set_string("formspec",
				anvil_formspec,
				"label[2.5,0.0;" .. S("Owner: @1", owner) .. "]")
			return
		end

		-- just to make sure that it really can't get repaired if it should not
		-- (if the check of placing the item in the input slot failed somehow)
		if not cottages.anvil.can_repair(tool) then
			minetest.chat_send_player(puncher_name, S("@1 is not repairable by the anvil", tool_name))
			return
		end

		local damage_state = 40 - math.floor(40 * tool:get_wear() / 65535)
		local hud_image = get_hud_image(tool)

		if tool:get_wear() > 0 then
			local hud1, hud1_def, hud2, hud3, hud3_def

			if hud_info_by_puncher_name[puncher_name] then
				hud1, hud2, hud3, _ = unpack(hud_info_by_puncher_name[puncher_name])
				hud1_def = puncher:hud_get(hud1)
				hud3_def = puncher:hud_get(hud3)
			end

			if hud1_def and hud1_def.name == "anvil_image" and hud3_def and hud3_def.name == "anvil_foreground" then
				puncher:hud_change(hud1, "text", hud_image)
				puncher:hud_change(hud3, "number", damage_state)

			else
				hud1 = puncher:hud_add({
					name = "anvil_image",
					hud_elem_type = "image",
					scale = {x = 15, y = 15},
					text = hud_image,
					position = {x = 0.5, y = 0.5},
					alignment = {x = 0, y = 0}
				})
				hud2 = puncher:hud_add({
					name = "anvil_background",
					hud_elem_type = "statbar",
					text = "default_cloud.png^[colorize:#ff0000:256",
					number = 40,
					direction = 0, -- left to right
					position = {x = 0.5, y = 0.65},
					alignment = {x = 0, y = 0},
					offset = {x = -320, y = 0},
					size = {x = 32, y = 32},
				})
				hud3 = puncher:hud_add({
					name = "anvil_foreground",
					hud_elem_type = "statbar",
					text = "default_cloud.png^[colorize:#00ff00:256",
					number = damage_state,
					direction = 0, -- left to right
					position = {x = 0.5, y = 0.65},
					alignment = {x = 0, y = 0},
					offset = {x = -320, y = 0},
					size = {x = 32, y = 32},
				})
			end

			hud_info_by_puncher_name[puncher_name] = {hud1, hud2, hud3, os.time() + hud_timeout}
		end

		-- tell the player when the job is done
		if tool:get_wear() == 0 then
			-- but only once
			if meta:get_int("informed") > 0 then
				return
			end

			meta:set_int("informed", 1)

			local tool_desc
			local meta_description = tool:get_meta():get_string("description")
			if meta_description ~= "" then
				tool_desc = meta_description
			elseif minetest.registered_items[tool_name] and minetest.registered_items[tool_name].description then
				tool_desc = minetest.registered_items[tool_name].description
			else
				tool_desc = tool_name
			end
			minetest.chat_send_player(puncher_name, S("Your @1 has been repaired successfully.", tool_desc))
			return
		end

		-- do the actual repair
		tool:add_wear(-4369)
		inv:set_stack("input", 1, tool)

		-- damage the hammer slightly
		wielded:add_wear(100)
		puncher:set_wielded_item(wielded)
	end,
})

-- clear hud info
minetest.register_globalstep(function()
	local now = os.time()

	for puncher_name, hud_info in pairs(hud_info_by_puncher_name) do
		local hud1, hud2, hud3, hud_expire_time = unpack(hud_info)
		if now > hud_expire_time then
			local puncher = minetest.get_player_by_name(puncher_name)
			if puncher then
				local hud1_def = puncher:hud_get(hud1)
				if hud1_def and hud1_def.name == "anvil_image" then
					puncher:hud_remove(hud1)
				end

				local hud2_def = puncher:hud_get(hud2)
				if hud2_def and hud2_def.name == "anvil_background" then
					puncher:hud_remove(hud2)
				end

				local hud3_def = puncher:hud_get(hud3)
				if hud3_def and hud3_def.name == "anvil_foreground" then
					puncher:hud_remove(hud3)
				end
			end

			hud_info_by_puncher_name[puncher_name] = nil
		end
	end
end)