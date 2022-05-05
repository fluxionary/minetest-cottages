---------------------------------------------------------------------------------------
-- furniture
---------------------------------------------------------------------------------------
-- contains:
--  * a bed seperated into foot and head reagion so that it can be placed manually; it has
--    no other functionality than decoration!
--  * a sleeping mat - mostly for NPC that cannot afford a bet yet
--  * bench - if you don't have 3dforniture:chair, then this is the next best thing
--  * table - very simple one
--  * shelf - for stroring things; this one is 3d
--  * stovepipe - so that the smoke from the furnace can get away
--  * washing place - put it over a water source and you can 'wash' yourshelf
---------------------------------------------------------------------------------------
-- TODO: change the textures of the bed (make the clothing white, foot path not entirely covered with cloth)


cottages.furniture = {}

local prefix = cottages.modpath .. "/modules/furniture/"

dofile(prefix .. "api.lua")
dofile(prefix .. "nodes.lua")
dofile(prefix .. "crafts.lua")
