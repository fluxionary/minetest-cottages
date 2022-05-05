---------------------------------------------------------------------
-- a barrel and a tub - plus a function that makes 'round' objects
---------------------------------------------------------------------
-- IMPORTANT NOTE: The barrel requires a lot of nodeboxes. That may be
--                 too much for weak hardware!
---------------------------------------------------------------------
-- Functionality: right-click to open/close a barrel
--                punch a barrel to change between vertical/horizontal
---------------------------------------------------------------------
-- Changelog:
-- 24.03.13 Can no longer be opended/closed on rightclick because that is now used for a formspec
--          instead, it can be filled with liquids.
--          Filled barrels will always be closed, while empty barrels will always be open.

-- pipes: table with the following entries for each pipe-part:
--    f: radius factor; if 1, it will have a radius of half a nodebox and fill the entire nodebox
--    h1, h2: height at witch the nodebox shall start and end; usually -0.5 and 0.5 for a full nodebox
--    b: make a horizontal part/shelf
-- horizontal: if 1, then x and y coordinates will be swapped

cottages.barrel = {}

local prefix = cottages.modpath .. "/modules/barrel/"

dofile(prefix .. "nodes.lua")
dofile(prefix .. "crafts.lua")
dofile(prefix .. "convert.lua")

