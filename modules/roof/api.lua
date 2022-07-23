local S = cottages.S

function cottages.roof.register_roof(name, tiles, basic_material, homedecor_alternative)
	minetest.register_node("cottages:roof_" .. name, {
		description = S("Roof " .. name),
		drawtype = "nodebox",
		tiles = tiles,
		paramtype = "light",
		paramtype2 = "facedir",
		groups = {snappy = 2, choppy = 2, oddly_breakable_by_hand = 2},
		node_box = {
			type = "fixed",
			fixed = {
				{-0.5, -0.5, -0.5, 0.5, 0, 0},
				{-0.5, 0, 0, 0.5, 0.5, 0.5},
			},
		},
		selection_box = {
			type = "fixed",
			fixed = {
				{-0.5, -0.5, -0.5, 0.5, 0, 0},
				{-0.5, 0, 0, 0.5, 0.5, 0.5},
			},
		},
		is_ground_content = false,
	})

	-- TODO: what is cottages.use_farming_straw_stairs
	if name == "straw" and minetest.registered_nodes["stairs:stair_straw"] and cottages.use_farming_straw_stairs then
		minetest.register_alias("cottages:roof_connector_straw", "stairs:stair_straw")

	else
		minetest.register_node("cottages:roof_connector_" .. name, {
			description = S("Roof connector " .. name),
			drawtype = "nodebox",
			-- top, bottom, side1, side2, inner, outer
			tiles = tiles,
			paramtype = "light",
			paramtype2 = "facedir",
			groups = {snappy = 2, choppy = 2, oddly_breakable_by_hand = 2},
			node_box = {
				type = "fixed",
				fixed = {
					{-0.5, -0.5, -0.5, 0.5, 0, 0.5},
					{-0.5, 0, 0, 0.5, 0.5, 0.5},
				},
			},
			selection_box = {
				type = "fixed",
				fixed = {
					{-0.5, -0.5, -0.5, 0.5, 0, 0.5},
					{-0.5, 0, 0, 0.5, 0.5, 0.5},
				},
			},
			is_ground_content = false,
		})
	end

	-- this one is the slab version of the above roof
	if name ~= "straw" or not (minetest.registered_nodes["stairs:slab_straw"]) or not (cottages.use_farming_straw_stairs) then
		minetest.register_node("cottages:roof_flat_" .. name, {
			description = S("Roof (flat) " .. name),
			drawtype = "nodebox",
			-- top, bottom, side1, side2, inner, outer
			-- this one is from all sides - except from the underside - of the given material
			tiles = {tiles[1], tiles[2], tiles[1], tiles[1], tiles[1], tiles[1]},
			paramtype = "light",
			paramtype2 = "facedir",
			groups = {snappy = 2, choppy = 2, oddly_breakable_by_hand = 2},
			node_box = {
				type = "fixed",
				fixed = {
					{-0.5, -0.5, -0.5, 0.5, 0, 0.5},
				},
			},
			selection_box = {
				type = "fixed",
				fixed = {
					{-0.5, -0.5, -0.5, 0.5, 0, 0.5},
				},
			},
			is_ground_content = false,
		})
	else
		minetest.register_alias("cottages:roof_flat_straw", "stairs:slab_straw")
	end

	if (not (homedecor_alternative)
		or (minetest.get_modpath("homedecor") ~= nil)) then

		minetest.register_craft({
			output = "cottages:roof_" .. name .. " 6",
			recipe = {
				{"", "", basic_material},
				{"", basic_material, ""},
				{basic_material, "", ""}
			}
		})
	end

	-- make those roof parts that use homedecor craftable without that mod
	if homedecor_alternative then
		basic_material = "cottages:roof_wood"

		minetest.register_craft({
			output = "cottages:roof_" .. name .. " 3",
			recipe = {
				{homedecor_alternative, "", basic_material},
				{"", basic_material, ""},
				{basic_material, "", ""}
			}
		})
	end

	minetest.register_craft({
		output = "cottages:roof_connector_" .. name,
		recipe = {
			{"cottages:roof_" .. name},
			{ci.wood},
		}
	})

	minetest.register_craft({
		output = "cottages:roof_flat_" .. name .. " 2",
		recipe = {
			{"cottages:roof_" .. name, "cottages:roof_" .. name},
		}
	})

	-- convert flat roofs back to normal roofs
	minetest.register_craft({
		output = "cottages:roof_" .. name,
		recipe = {
			{"cottages:roof_flat_" .. name, "cottages:roof_flat_" .. name}
		}
	})

end -- of cottages.register_roof( name, tiles, basic_material )
