local S = cottages.S

minetest.register_node("cottages:feldweg", {
    description = S("dirt road"),
    tiles = {"cottages_feldweg_orig.png", "default_dirt.png", "default_dirt.png^default_grass_side.png"},
    paramtype2 = "facedir",
    legacy_facedir_simple = true,
    groups = {crumbly = 3},
    sounds = cottages.sounds.dirt,
    is_ground_content = false,
    drawtype = "nodebox",
    -- top, bottom, side1, side2, inner, outer
    paramtype = "light",
    node_box = {
        type = "fixed",
        fixed = {
            {-0.5, -0.5, -0.5, 0.5, 0.5 - 2 / 16, 0.5},
            -- Rasenkanten
            {-0.5, 0.5 - 2 / 16, -0.5, -0.5 + 3 / 16, 0.5, 0.5},
            {0.5 - 3 / 16, 0.5 - 2 / 16, -0.5, 0.5, 0.5, 0.5},
            -- uebergang zwischen Wagenspur und Rasenkante
            {-0.5 + 3 / 16, 0.5 - 2 / 16, -0.5, -0.5 + 4 / 16, 0.5 - 1 / 16, 0.5},
            {0.5 - 4 / 16, 0.5 - 2 / 16, -0.5, 0.5 - 3 / 16, 0.5 - 1 / 16, 0.5},
        },
    },
    selection_box = {
        type = "fixed",
        fixed = {
            {-0.5, -0.5, -0.5, 0.5, 0.5, 0.5},
        },
    },
})

minetest.register_node("cottages:feldweg_crossing", {
    description = S("dirt road crossing"),
    tiles = {"cottages_feldweg_kreuzung.png", "default_dirt.png", "default_dirt.png^default_grass_side.png"},
    paramtype2 = "facedir",
    legacy_facedir_simple = true,
    groups = {crumbly = 3},
    sounds = cottages.sounds.dirt,
    is_ground_content = false,

    drawtype = "nodebox",
    -- top, bottom, side1, side2, inner, outer
    paramtype = "light",
    node_box = {
        type = "fixed",
        fixed = {
            {-0.5, -0.5, -0.5, 0.5, 0.5 - 2 / 16, 0.5},
            -- Rasenkanten
            {-0.5, 0.5 - 2 / 16, -0.5, -0.5 + 3 / 16, 0.5, -0.5 + 3 / 16},
            {0.5 - 3 / 16, 0.5 - 2 / 16, -0.5, 0.5, 0.5, -0.5 + 3 / 16},
            {-0.5, 0.5 - 2 / 16, 0.5 - 3 / 16, -0.5 + 3 / 16, 0.5, 0.5},
            {0.5 - 3 / 16, 0.5 - 2 / 16, 0.5 - 3 / 16, 0.5, 0.5, 0.5},
            -- uebergang zwischen Wagenspur und Rasenkante
            {-0.5 + 3 / 16, 0.5 - 2 / 16, -0.5, -0.5 + 4 / 16, 0.5 - 1 / 16, -0.5 + 4 / 16},
            {0.5 - 4 / 16, 0.5 - 2 / 16, -0.5, 0.5 - 3 / 16, 0.5 - 1 / 16, -0.5 + 4 / 16},
            {-0.5 + 3 / 16, 0.5 - 2 / 16, 0.5 - 4 / 16, -0.5 + 4 / 16, 0.5 - 1 / 16, 0.5},
            {0.5 - 4 / 16, 0.5 - 2 / 16, 0.5 - 4 / 16, 0.5 - 3 / 16, 0.5 - 1 / 16, 0.5},
            {-0.5, 0.5 - 2 / 16, -0.5 + 3 / 16, -0.5 + 3 / 16, 0.5 - 1 / 16, -0.5 + 4 / 16},
            {0.5 - 3 / 16, 0.5 - 2 / 16, -0.5 + 3 / 16, 0.5, 0.5 - 1 / 16, -0.5 + 4 / 16},
            {-0.5, 0.5 - 2 / 16, 0.5 - 4 / 16, -0.5 + 3 / 16, 0.5 - 1 / 16, 0.5 - 3 / 16},
            {0.5 - 3 / 16, 0.5 - 2 / 16, 0.5 - 4 / 16, 0.5, 0.5 - 1 / 16, 0.5 - 3 / 16},
        },
    },
    selection_box = {
        type = "fixed",
        fixed = {
            {-0.5, -0.5, -0.5, 0.5, 0.5, 0.5},
        },
    },
})

minetest.register_node("cottages:feldweg_t_junction", {
    description = S("dirt road t junction"),
    tiles = {"cottages_feldweg_t-kreuzung.png^[transform2", "default_dirt.png", "default_dirt.png^default_grass_side.png"},
    paramtype2 = "facedir",
    legacy_facedir_simple = true,
    groups = {crumbly = 3},
    sounds = cottages.sounds.dirt,
    is_ground_content = false,

    drawtype = "nodebox",
    -- top, bottom, side1, side2, inner, outer
    paramtype = "light",
    node_box = {
        type = "fixed",
        fixed = {
            {-0.5, -0.5, -0.5, 0.5, 0.5 - 2 / 16, 0.5},
            -- Rasenkanten
            {-0.5, 0.5 - 2 / 16, -0.5, -0.5 + 3 / 16, 0.5, -0.5 + 3 / 16},
            {-0.5, 0.5 - 2 / 16, 0.5 - 3 / 16, -0.5 + 3 / 16, 0.5, 0.5},
            -- Rasenkante seitlich durchgehend
            {0.5 - 3 / 16, 0.5 - 2 / 16, -0.5, 0.5, 0.5, 0.5},
            -- uebergang zwischen Wagenspur und Rasenkante
            {-0.5 + 3 / 16, 0.5 - 2 / 16, -0.5, -0.5 + 4 / 16, 0.5 - 1 / 16, -0.5 + 4 / 16},
            {-0.5 + 3 / 16, 0.5 - 2 / 16, 0.5 - 4 / 16, -0.5 + 4 / 16, 0.5 - 1 / 16, 0.5},
            {-0.5, 0.5 - 2 / 16, -0.5 + 3 / 16, -0.5 + 3 / 16, 0.5 - 1 / 16, -0.5 + 4 / 16},
            {-0.5, 0.5 - 2 / 16, 0.5 - 4 / 16, -0.5 + 3 / 16, 0.5 - 1 / 16, 0.5 - 3 / 16},
            -- Ueberganng seitlich durchgehend
            {0.5 - 4 / 16, 0.5 - 2 / 16, -0.5, 0.5 - 3 / 16, 0.5 - 1 / 16, 0.5},
        },
    },
    selection_box = {
        type = "fixed",
        fixed = {
            {-0.5, -0.5, -0.5, 0.5, 0.5, 0.5},
        },
    },
})

minetest.register_node("cottages:feldweg_curve", {
    description = S("dirt road curve"),
    tiles = {"cottages_feldweg_ecke.png^[transform2", "default_dirt.png", "default_dirt.png^default_grass_side.png"},
    paramtype2 = "facedir",
    legacy_facedir_simple = true,
    groups = {crumbly = 3},
    sounds = cottages.sounds.dirt,
    is_ground_content = false,

    drawtype = "nodebox",
    -- top, bottom, side1, side2, inner, outer
    paramtype = "light",
    node_box = {
        type = "fixed",
        fixed = {
            {-0.5, -0.5, -0.5, 0.5, 0.5 - 2 / 16, 0.5},
            -- Rasenkante vorne durchgehend
            {-0.5, 0.5 - 2 / 16, -0.5, 0.5 - 3 / 16, 0.5, -0.5 + 3 / 16},
            -- Rasenkanten
            {-0.5, 0.5 - 2 / 16, 0.5 - 3 / 16, -0.5 + 3 / 16, 0.5, 0.5},
            -- Rasenkante seitlich durchgehend
            {0.5 - 3 / 16, 0.5 - 2 / 16, -0.5, 0.5, 0.5, 0.5},
            -- uebergang zwischen Wagenspur und Rasenkante
            {-0.5 + 3 / 16, 0.5 - 2 / 16, 0.5 - 4 / 16, -0.5 + 4 / 16, 0.5 - 1 / 16, 0.5},
            -- Uebergang vorne durchgehend
            {-0.5, 0.5 - 2 / 16, -0.5 + 3 / 16, 0.5 - 3 / 16, 0.5 - 1 / 16, -0.5 + 4 / 16},
            {-0.5, 0.5 - 2 / 16, 0.5 - 4 / 16, -0.5 + 3 / 16, 0.5 - 1 / 16, 0.5 - 3 / 16},
            -- Ueberganng seitlich durchgehend
            {0.5 - 4 / 16, 0.5 - 2 / 16, -0.5, 0.5 - 3 / 16, 0.5 - 1 / 16, 0.5},
        },
    },
    selection_box = {
        type = "fixed",
        fixed = {
            {-0.5, -0.5, -0.5, 0.5, 0.5, 0.5},
        },
    },
})
local box_slope = {
    type = "fixed",
    fixed = {
        {-0.5, -0.5, -0.5, 0.5, -0.25, 0.5},
        {-0.5, -0.25, -0.25, 0.5, 0, 0.5},
        {-0.5, 0, 0, 0.5, 0.25, 0.5},
        {-0.5, 0.25, 0.25, 0.5, 0.5, 0.5}
    }
}

local box_slope_long = {
    type = "fixed",
    fixed = {
        {-0.5, -0.5, -1.5, 0.5, -0.10, 0.5},
        {-0.5, -0.25, -1.3, 0.5, -0.25, 0.5},
        {-0.5, -0.25, -1.0, 0.5, 0, 0.5},
        {-0.5, 0, -0.5, 0.5, 0.25, 0.5},
        {-0.5, 0.25, 0, 0.5, 0.5, 0.5}
    }
}

minetest.register_node("cottages:feldweg_slope", {
    description = S("dirt road slope"),
    paramtype2 = "facedir",
    legacy_facedir_simple = true,
    groups = {crumbly = 3},
    sounds = cottages.sounds.dirt,
    is_ground_content = false,
    tiles = {
        "cottages_feldweg_end.png",
        "default_dirt.png^default_grass_side.png",
        "default_dirt.png",
        "default_grass.png",
        "cottages_feldweg_surface.png",
        "cottages_feldweg_surface.png^cottages_feldweg_edges.png"
    },
    paramtype = "light",
    drawtype = "mesh",
    mesh = "feldweg_slope.obj",

    collision_box = box_slope,
    selection_box = box_slope,
})

minetest.register_node("cottages:feldweg_slope_long", {
    description = S("dirt road slope long"),
    paramtype2 = "facedir",
    legacy_facedir_simple = true,
    groups = {crumbly = 3},
    sounds = cottages.sounds.dirt,
    is_ground_content = false,
    tiles = {
        "cottages_feldweg_end.png",
        "default_dirt.png^default_grass_side.png",
        "default_dirt.png",
        "default_grass.png",
        "cottages_feldweg_surface.png",
        "cottages_feldweg_surface.png^cottages_feldweg_edges.png"
    },
    paramtype = "light",
    drawtype = "mesh",
    mesh = "feldweg_slope_long.obj",
    collision_box = box_slope_long,
    selection_box = box_slope_long,
})
