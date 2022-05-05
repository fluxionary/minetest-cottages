local settings = minetest.settings

cottages.settings = {
    enable = {
        anvil = settings:get_bool("cottages.anvil.enable", true),
        barrel = settings:get_bool("cottages.barrel.enable", true),
        doorlike = settings:get_bool("cottages.doorlike.enable", true),
        feldweg = settings:get_bool("cottages.feldweg.enable", true),
        furniture = settings:get_bool("cottages.furniture.enable", true),
        hay = settings:get_bool("cottages.hay.enable", true),
        historic = settings:get_bool("cottages.historic.enable", true),
        mining = settings:get_bool("cottages.mining.enable", true),
        pitchfork = settings:get_bool("cottages.pitchfork.enable", true),
        roof = settings:get_bool("cottages.roof.enable", true),
        straw = settings:get_bool("cottages.straw.enable", true),
        water = settings:get_bool("cottages.water.enable", true),
    },

    anvil = {
        disable_hammer_repair = settings:get_bool("cottages.anvil.disable_hammer_repair", false),
        hud_timeout = tonumber(settings:get("cottages.anvil.hud_timeout")) or 2,  -- seconds
    },

    handmill = {
        min_per_turn = tonumber(settings:get("cottages.handmill.min_per_turn")) or 0,
        max_per_turn = tonumber(settings:get("cottages.handmill.max_per_turn")) or 20,
    },

    feldweg = {
        mode = settings:get("cottages.feldweg.mode") or "mesh"
    }
}

-- supported modes:
-- * simple: only a straight dirt road; no curves, junctions etc.
-- * flat: each node is a full node; junction, t-junction and corner are included
-- * nodebox: like flat - except that each node has a nodebox that fits to that road node
-- * mesh: like nodebox - except that it uses a nice roundish model
if cottages.settings.feldweg.mode ~= "simple" and
    cottages.settings.feldweg.mode ~= "flat" and
    cottages.settings.feldweg.mode ~= "nodebox" then

    cottages.settings.feldweg.mode = "mesh"
    -- add the setting to the minetest.conf so that the player can set it there
    minetest.settings:set("cottages.feldweg.mode", "mesh")
end
