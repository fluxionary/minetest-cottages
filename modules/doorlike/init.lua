-----------------------------------------------------------------------------------------------------------
-- These nodes are all like doors in a way:
--  * window shutters (they open on right-click and when it turns day; they close at night)
--  * a half-door where the top part can be opened seperately from the bottom part
--  * a gate that drops to the floor when opened
--
-----------------------------------------------------------------------------------------------------------
-- IMPORTANT NOTICE: If you have a very slow computer, it might be wise to increase the rate at which the
--                   abm that opens/closes the window shutters is called. Anything less than 10 minutes
--                   (600 seconds) ought to be ok.
-----------------------------------------------------------------------------------------------------------
cottages.doorlike = {}

local prefix = cottages.modpath .. "/modules/doorlike/"

dofile(prefix .. "api.lua")
dofile(prefix .. "nodes.lua")
dofile(prefix .. "crafts.lua")
dofile(prefix .. "abms.lua")
