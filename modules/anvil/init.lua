---------------------------------------------------------------------------------------
-- simple anvil that can be used to repair tools
---------------------------------------------------------------------------------------
-- * can be used to repair tools
-- * the hammer gets dammaged a bit at each repair step
---------------------------------------------------------------------------------------
-- License of the hammer picture: CC-by-SA; done by GloopMaster; source:
--   https://github.com/GloopMaster/glooptest/blob/master/glooptest/textures/glooptest_tool_steelhammer.png

cottages.anvil = {}

local prefix = cottages.modpath .. "/modules/anvil/"

dofile(prefix .. "api.lua")
dofile(prefix .. "tools.lua")
dofile(prefix .. "nodes.lua")
dofile(prefix .. "crafts.lua")
