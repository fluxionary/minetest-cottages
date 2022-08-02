local ci = cottages.craftitems

if ci.stick then
	minetest.register_craft({
		output = "cottages:pitchfork",
		recipe = {
			{ci.stick, ci.stick, ci.stick},
			{"", ci.stick, ""},
			{"", ci.stick, ""},
		}
	})
end
