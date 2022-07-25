local S = cottages.S

local cottages_quern_formspec = "size[8,8]" ..
	"image[0,1;1,1;" .. cottages.texture.wheat_seed .. "]" ..
	"button_exit[6.0,0.0;1.5,0.5;public;" .. S("Public?") .. "]" ..
	"list[context;seeds;1,1;1,1;]" ..
	"list[context;flour;5,1;2,2;]" ..
	"label[0,0.5;" .. S("Input:") .. "]" ..
	"label[4,0.5;" .. S("Output:") .. "]" ..
	"label[0,-0.3;" .. S("Quern") .. "]" ..
	"label[0,2.5;" .. S("Punch this hand-driven quern") .. "]" ..
	"label[0,3.0;" .. S("to grind suitable items.") .. "]" ..
	"list[current_player;main;0,4;8,4;]"

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

	on_construct = function(pos)
		local meta = minetest.get_meta(pos)
		meta:set_string("infotext", S("Public quern, powered by punching"))
		local inv = meta:get_inventory()
		inv:set_size("seeds", 1)
		inv:set_size("flour", 4)
		meta:set_string("formspec", cottages_quern_formspec)
		meta:set_string("public", "public")
	end,

	after_place_node = function(pos, placer)
		local meta = minetest.get_meta(pos)
		local owner = placer:get_player_name()
		meta:set_string("owner", owner or "")
		meta:set_string("infotext", S("Private quern, powered by punching (owned by @1)", owner))
		meta:set_string("formspec", cottages_quern_formspec ..
				"label[2.5,-0.5;" .. S("Owner: @1", owner) .. "]")
		meta:set_string("public", "private")
	end,

	on_receive_fields = function(pos, formname, fields, sender)
		cottages.switch_public(pos, formname, fields, sender, "quern, powered by punching")
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
		if not cottages.player_can_use(pos, player) then
			return 0
		end

		return count
	end,

	allow_metadata_inventory_put = function(pos, listname, index, stack, player)
		if not cottages.player_can_use(pos, player) then
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
		if not cottages.player_can_use(pos, player) then
			return 0
		end

		return stack:get_count()
	end,

	on_punch = function(pos, node, puncher)
		cottages.straw.use_quern(pos, puncher)
	end,
})
