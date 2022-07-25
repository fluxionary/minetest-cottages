local S = cottages.S

local cottages_formspec_treshing_floor = "size[8,8]" ..
	"image[1.5,0;1,1;" .. cottages.texture_stick .. "]" ..
	"image[0,1;1,1;farming_wheat.png]" ..
	"button_exit[6.8,0.0;1.5,0.5;public;" .. S("Public?") .. "]" ..
	"list[context;harvest;1,1;2,1;]" ..
	"list[context;straw;5,0;2,2;]" ..
	"list[context;seeds;5,2;2,2;]" ..
	"label[1,0.5;" .. S("Harvested wheat:") .. "]" ..
	"label[4,0.0;" .. S("Straw:") .. "]" ..
	"label[4,2.0;" .. S("Seeds:") .. "]" ..
	"label[0,-0.5;" .. S("Threshing floor") .. "]" ..
	"label[0,2.5;" .. S("Punch threshing floor with a stick") .. "]" ..
	"label[0,3.0;" .. S("to get straw and seeds from wheat.") .. "]" ..
	"list[current_player;main;0,4;8,4;]"

minetest.register_node("cottages:threshing_floor", {
	drawtype = "nodebox",
	description = S("threshing floor"),
	-- TODO: stone also looks pretty well for this
	tiles = {"cottages_junglewood.png^farming_wheat.png", "cottages_junglewood.png", "cottages_junglewood.png^" .. cottages.texture_stick},
	paramtype = "light",
	paramtype2 = "facedir",
	-- can be digged with axe and pick
	groups = {cracky = 2, choppy = 2},
	is_ground_content = false,
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
	on_construct = function(pos)
		local meta = minetest.get_meta(pos)
		meta:set_string("infotext", S("Public threshing floor"))
		local inv = meta:get_inventory()
		inv:set_size("harvest", 2)
		inv:set_size("straw", 4)
		inv:set_size("seeds", 4)
		meta:set_string("formspec", cottages_formspec_treshing_floor)
		meta:set_string("public", "public")
	end,

	after_place_node = function(pos, placer)
		local meta = minetest.get_meta(pos)
		meta:set_string("owner", placer:get_player_name() or "")
		meta:set_string("infotext", S("Private threshing floor (owned by %s)"):format(meta:get_string("owner") or ""))
		meta:set_string("formspec",
			cottages_formspec_treshing_floor ..
				"label[2.5,-0.5;" .. S("Owner: %s"):format(meta:get_string("owner") or "") .. "]")
		meta:set_string("public", "private")
	end,

	on_receive_fields = function(pos, formname, fields, sender)
		cottages.switch_public(pos, formname, fields, sender, "threshing floor")
	end,

	can_dig = function(pos, player)

		local meta = minetest.get_meta(pos)
		local inv = meta:get_inventory()
		local owner = meta:get_string("owner")

		if (not (inv:is_empty("harvest"))
			or not (inv:is_empty("straw"))
			or not (inv:is_empty("seeds"))
			or not (player)
			or (owner and owner ~= "" and player:get_player_name() ~= owner)) then

			return false
		end
		return true
	end,

	allow_metadata_inventory_move = function(pos, from_list, from_index, to_list, to_index, count, player)
		if not (cottages.player_can_use(pos, player)) then
			return 0
		end
		return count
	end,

	allow_metadata_inventory_put = function(pos, listname, index, stack, player)
		-- only accept input the threshing floor can use/process
		if (listname == "straw"
			or listname == "seeds"
			or (listname == "harvest" and stack and stack:get_name() ~= "farming:wheat")) then
			return 0
		end

		if not (cottages.player_can_use(pos, player)) then
			return 0
		end
		return stack:get_count()
	end,

	allow_metadata_inventory_take = function(pos, listname, index, stack, player)
		if not (cottages.player_can_use(pos, player)) then
			return 0
		end
		return stack:get_count()
	end,


	on_punch = function(pos, node, puncher)
		if not (pos) or not (node) or not (puncher) then
			return
		end
		-- only punching with a normal stick is supposed to work
		local wielded = puncher:get_wielded_item()
		if (not (wielded)
			or not (wielded:get_name())
			or not (minetest.registered_items[wielded:get_name()])
			or not (minetest.registered_items[wielded:get_name()].groups)
			or not (minetest.registered_items[wielded:get_name()].groups.stick)) then
			return
		end
		local name = puncher:get_player_name()

		local meta = minetest.get_meta(pos)
		local inv = meta:get_inventory()

		local input = inv:get_list("harvest")
		-- we have two input slots
		local stack1 = inv:get_stack("harvest", 1)
		local stack2 = inv:get_stack("harvest", 2)

		if ((stack1:is_empty() and stack2:is_empty())
			or (not (stack1:is_empty()) and stack1:get_name() ~= "farming:wheat")
			or (not (stack2:is_empty()) and stack2:get_name() ~= "farming:wheat")) then

			--			minetest.chat_send_player( name, "One of the input slots contains something else than wheat, or there is no wheat at all.")
			-- update the formspec
			meta:set_string("formspec",
				cottages_formspec_treshing_floor ..
					"label[2.5,-0.5;" .. S("Owner: %s"):format(meta:get_string("owner") or "") .. "]")
			return
		end

		-- on average, process 25 wheat at each punch (10..40 are possible)
		local anz_wheat = 10 + math.random(0, 30)
		-- we already made sure there is only wheat inside
		local found_wheat = stack1:get_count() + stack2:get_count()

		-- do not process more wheat than present in the input slots
		if found_wheat < anz_wheat then
			anz_wheat = found_wheat
		end

		local overlay1 = "^farming_wheat.png"
		local overlay2 = "^" .. cottages.straw_texture
		local overlay3 = "^" .. cottages.texture_wheat_seed

		-- this can be enlarged by a multiplicator if desired
		local anz_straw = anz_wheat
		local anz_seeds = anz_wheat

		if (inv:room_for_item("straw", "cottages:straw_mat " .. tostring(anz_straw))
			and inv:room_for_item("seeds", ci.seed_wheat .. " " .. tostring(anz_seeds))) then

			-- the player gets two kind of output
			inv:add_item("straw", "cottages:straw_mat " .. tostring(anz_straw))
			inv:add_item("seeds", ci.seed_wheat .. " " .. tostring(anz_seeds))
			-- consume the wheat
			inv:remove_item("harvest", "farming:wheat " .. tostring(anz_wheat))

			local anz_left = found_wheat - anz_wheat
			if anz_left > 0 then
				--				minetest.chat_send_player( name, S("You have threshed %s wheat (%s are left)."):format(anz_wheat,anz_left))
			else
				--				minetest.chat_send_player( name, S("You have threshed the last %s wheat."):format(anz_wheat))
				overlay1 = ""
			end
		end

		local hud0 = puncher:hud_add({
			hud_elem_type = "image",
			scale = {x = 38, y = 38},
			text = "cottages_junglewood.png^[colorize:#888888:128",
			position = {x = 0.5, y = 0.5},
			alignment = {x = 0, y = 0}
		})

		local hud1 = puncher:hud_add({
			hud_elem_type = "image",
			scale = {x = 15, y = 15},
			text = "cottages_junglewood.png" .. overlay1,
			position = {x = 0.4, y = 0.5},
			alignment = {x = 0, y = 0}
		})
		local hud2 = puncher:hud_add({
			hud_elem_type = "image",
			scale = {x = 15, y = 15},
			text = "cottages_junglewood.png" .. overlay2,
			position = {x = 0.6, y = 0.35},
			alignment = {x = 0, y = 0}
		})
		local hud3 = puncher:hud_add({
			hud_elem_type = "image",
			scale = {x = 15, y = 15},
			text = "cottages_junglewood.png" .. overlay3,
			position = {x = 0.6, y = 0.65},
			alignment = {x = 0, y = 0}
		})

		local hud4 = puncher:hud_add({
			hud_elem_type = "text",
			text = tostring(found_wheat - anz_wheat),
			number = 0x00CC00,
			alignment = {x = 0, y = 0},
			scale = {x = 100, y = 100}, -- bounding rectangle of the text
			position = {x = 0.4, y = 0.5},
		})
		if not (anz_straw) then
			anz_straw = "0"
		end
		if not (anz_seed) then
			anz_seed = "0"
		end
		local hud5 = puncher:hud_add({
			hud_elem_type = "text",
			text = "+ " .. tostring(anz_straw) .. " straw",
			number = 0x00CC00,
			alignment = {x = 0, y = 0},
			scale = {x = 100, y = 100}, -- bounding rectangle of the text
			position = {x = 0.6, y = 0.35},
		})
		local hud6 = puncher:hud_add({
			hud_elem_type = "text",
			text = "+ " .. tostring(anz_seed) .. " seeds",
			number = 0x00CC00,
			alignment = {x = 0, y = 0},
			scale = {x = 100, y = 100}, -- bounding rectangle of the text
			position = {x = 0.6, y = 0.65},
		})

		minetest.after(2, function()
			if puncher then
				if hud1 then
					puncher:hud_remove(hud1)
				end
				if hud2 then
					puncher:hud_remove(hud2)
				end
				if hud3 then
					puncher:hud_remove(hud3)
				end
				if hud4 then
					puncher:hud_remove(hud4)
				end
				if hud5 then
					puncher:hud_remove(hud5)
				end
				if hud6 then
					puncher:hud_remove(hud6)
				end
				if hud0 then
					puncher:hud_remove(hud0)
				end
			end
		end)
	end,
})
