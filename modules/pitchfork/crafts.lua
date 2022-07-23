local ci = cottages.craftitem

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
