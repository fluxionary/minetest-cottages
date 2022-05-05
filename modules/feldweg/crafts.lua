

minetest.register_craft({
    output = "cottages:feldweg_crossing 5",
    recipe = {
        {"", "cottages:feldweg", ""},
        {"cottages:feldweg", "cottages:feldweg", "cottages:feldweg"},
        {"", "cottages:feldweg", ""},
    },
})

minetest.register_craft({
    output = "cottages:feldweg_t_junction 5",
    recipe = {
        {"", "cottages:feldweg", ""},
        {"", "cottages:feldweg", ""},
        {"cottages:feldweg", "cottages:feldweg", "cottages:feldweg"}
    },
})

minetest.register_craft({
    output = "cottages:feldweg_curve 5",
    recipe = {
        {"cottages:feldweg", "", ""},
        {"cottages:feldweg", "", ""},
        {"cottages:feldweg", "cottages:feldweg", "cottages:feldweg"}
    },
})

if minetest.registered_items["cottages:feldweg_end"] then
    minetest.register_craft({
        output = "cottages:feldweg_end 5",
        recipe = {
            {"cottages:feldweg", "", "cottages:feldweg"},
            {"cottages:feldweg", "cottages:feldweg", "cottages:feldweg"}
        },
    })
end

if minetest.registered_items["cottages:feldweg_slope"] then
    minetest.register_craft({
        output = "cottages:feldweg_slope 3",
        recipe = {
            {"cottages:feldweg", "", ""},
            {"cottages:feldweg", "cottages:feldweg", ""}
        },
    })
end

if minetest.registered_items["cottages:feldweg_slope_long"] then
    minetest.register_craft({
        output = "cottages:feldweg_slope_long 4",
        recipe = {
            {"cottages:feldweg", "", ""},
            {"cottages:feldweg", "cottages:feldweg", "cottages:feldweg"}
        },
    })
end
