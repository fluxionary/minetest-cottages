local ci = cottages.craftitems

if ci.steel then
	minetest.register_craft({
		output = "cottages:anvil",
		recipe = {
			{ci.steel, ci.steel, ci.steel},
			{"", ci.steel, ""},
			{ci.steel, ci.steel, ci.steel}},
	})

	minetest.register_craft({
		output = "cottages:hammer",
		recipe = {
			{ci.steel},
			{"cottages:anvil"},
			{ci.stick}}
	})
end
