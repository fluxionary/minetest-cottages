local S = cottages.S
local F = minetest.formspec_escape
local FS = function(...) return F(S(...)) end

local api = cottages.anvil

local hud_timeout = cottages.settings.anvil.hud_timeout
local repair_amount = cottages.settings.anvil.repair_amount
local hammer_wear = cottages.settings.anvil.hammer_wear

local hud_info_by_puncher_name = {}

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


function api.make_unrepairable(itemstring)
	local def = minetest.registered_items[itemstring]
	local groups = table.copy(def.groups or {})
	groups.not_repaired_by_anvil = 1
	minetest.override_item(itemstring, {groups = groups})
end

function api.can_repair(tool_stack)
	if type(tool_stack) == "string" then
		tool_stack = ItemStack(tool_stack)
	end
	return tool_stack:is_known() and minetest.get_item_group(tool_stack:get_name(), "not_repaired_by_anvil") == 0
end

function api.update_infotext(pos)
	local meta = minetest.get_meta(pos)
	local owner = meta:get("owner")

	if not owner then
		meta:set_string("infotext", S("Anvil (public)"))
	elseif owner == " " then
		meta:set_string("infotext", S("Anvil (protected)"))
	else
		meta:set_string("infotext", S("Anvil (owned by @1)", owner))
	end
end

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
	button[6.8,0.0;1.5,0.5;public;%s]
]]):format(
	FS("Workpiece:"),
	FS("Optional"),
	FS("storage for"),
	FS("your hammer"),
	FS("Anvil"),
	FS("Punch anvil with hammer to"),
	FS("repair tool in workpiece-slot."),
	FS("Public?")
)

function api.update_formspec(pos)
	local meta = minetest.get_meta(pos)
	local owner = meta:get("owner")

	if owner and owner ~= " " then
		meta:set_string("formspec", ("%slabel[2.5,0.0;%s]"):format(anvil_formspec, FS("Owner: @1", owner)))

	else
		meta:set_string("formspec", anvil_formspec)
	end
end

function api.use_anvil(pos, puncher)
	if not (pos and minetest.is_player(puncher)) then
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

	if tool:is_empty() then
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
	tool:add_wear(-repair_amount)
	inv:set_stack("input", 1, tool)

	-- damage the hammer slightly
	wielded:add_wear(hammer_wear)
	puncher:set_wielded_item(wielded)
end
