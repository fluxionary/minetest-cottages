local settings = minetest.settings

cottages.settings = {
	anvil = {
		enabled = settings:get_bool("cottages.anvil.enabled", true),

		disable_hammer_repair = settings:get_bool("cottages.anvil.disable_hammer_repair", false),
		hud_timeout = tonumber(settings:get("cottages.anvil.hud_timeout")) or 2, -- seconds
	},

	barrel = {
		enabled = settings:get_bool("cottages.barrel.enabled", true),
	},

	doorlike = {
		enabled = settings:get_bool("cottages.doorlike.enabled", true),
	},

	feldweg = {
		enabled = settings:get_bool("cottages.feldweg.enabled", true),

		mode = settings:get("cottages.feldweg.mode") or "mesh"
	},

	fences = {
		enabled = settings:get_bool("cottages.fences.enabled", true),
	},

	furniture = {
		enabled = settings:get_bool("cottages.furniture.enabled", true),
	},

	hay = {
		enabled = settings:get_bool("cottages.hay.enabled", true),
	},

	historic = {
		enabled = settings:get_bool("cottages.historic.enabled", true),
	},

	mining = {
		enabled = settings:get_bool("cottages.mining.enabled", true),
	},

	pitchfork = {
		enabled = settings:get_bool("cottages.pitchfork.enabled", true),
	},

	roof = {
		enabled = settings:get_bool("cottages.roof.enabled", true),

		use_farming_straw_stairs = (
			settings:get_bool("cottages.roof.use_farming_straw_stairs", false) and
			minetest.registered_nodes["stairs:stair_straw"]
		)
	},

	straw = {
		enabled = settings:get_bool("cottages.straw.enabled", true),

		quern_min_per_turn = tonumber(settings:get("cottages.straw.quern_min_per_turn")) or 1,
		quern_max_per_turn = tonumber(settings:get("cottages.straw.quern_min_per_turn")) or 5,

		threshing_min_per_punch = tonumber(settings:get("cottages.straw.threshing_min_per_punch")) or 10,
		threshing_max_per_punch = tonumber(settings:get("cottages.straw.threshing_max_per_punch")) or 40,
	},

	water = {
		enabled = settings:get_bool("cottages.water.enabled", true),

		well_fill_time = tonumber(settings:get("cotages.water.well_fill_time")) or 10
	},
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
