local modname = minetest.get_current_modname()
local modpath = minetest.get_modpath(modname)

local S = minetest.get_translator(modname)

cottages = {
	modname = modname,
	modpath = modpath,
	S = S,

	has = {
		default = minetest.get_modpath("default"),
		doors = minetest.get_modpath("doors"),
		farming = minetest.get_modpath("farming"),
		moreblocks = minetest.get_modpath("moreblocks"),
		player_api = minetest.get_modpath("player_api"),
		player_monoids = minetest.get_modpath("player_monoids"),
		stairs = minetest.get_modpath("stairs"),
		stairsplus = minetest.get_modpath("stairsplus"),
		wool = minetest.get_modpath("wool"),
	},

	log = function(level, messagefmt, ...)
		return minetest.log(level, ("[%s] %s"):format(modname, messagefmt:format(...)))
	end,

	dofile = function(...)
		return dofile(table.concat({modpath, ...}, DIR_DELIM) .. ".lua")
	end,
}

cottages.dofile("settings")
cottages.dofile("util")
cottages.dofile("resources")
cottages.dofile("modules", "init")
