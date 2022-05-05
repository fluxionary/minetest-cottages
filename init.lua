-- Version: 2.2
-- Autor:   Sokomine
-- License: GPLv3
--
-- Modified:
-- 2022-02-11 flux rewrote a lot of stuff
-- 11.03.19 Adjustments for MT 5.x
--          cottages_feldweg_mode is now a setting in minetest.conf
-- 27.07.15 Moved into its own repository.
--          Made sure textures and craft receipe indigrents are available or can be replaced.
--          Took care of "unregistered globals" warnings.
-- 23.01.14 Added conversion receipes in case of installed castle-mod (has its own anvil)
-- 23.01.14 Added hammer and anvil as decoration and for repairing tools.
--          Added hatches (wood and steel).
--          Changed the texture of the fence/handrail.
-- 17.01.13 Added alternate receipe for fences in case of interference due to xfences
-- 14.01.13 Added alternate receipes for roof parts in case homedecor is not installed.
--          Added receipe for stove pipe, tub and barrel.
--          Added stairs/slabs for dirt road, loam and clay
--          Added fence_small, fence_corner and fence_end, which are useful as handrails and fences
--          If two or more window shutters are placed above each other, they will now all close/open simultaneously.
--          Added threshing floor.
--          Added hand-driven mill.
local modname = minetest.get_current_modname()
local modpath = minetest.get_modpath(modname)

cottages = {
    modname = modname,
    modpath = modpath,
    S = minetest.get_translator(modname),

    log = function(level, messagefmt, ...)
        minetest.log(level, ("[%s] %s"):format(modname, messagefmt:format(...)))
    end,

    has = {
        default = minetest.get_modpath("default"),
        doors = minetest.get_modpath("doors"),
        farming = minetest.get_modpath("farming"),
        moreblocks = minetest.get_modpath("moreblocks"),
        stairs = minetest.get_modpath("stairs"),
        wool = minetest.get_modpath("wool"),
    }
}

dofile(modpath .. "/settings.lua")

dofile(modpath .. "/adaptions.lua")
dofile(modpath .. "/functions.lua")

dofile(modpath .. "/modules/init.lua")

