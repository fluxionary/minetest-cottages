---------------------------------------------------------------------------------------
-- decoration and building material
---------------------------------------------------------------------------------------
-- * includes a wagon wheel that can be used as decoration on walls or to build (stationary) wagons
-- * dirt road - those are more natural in small old villages than cobble roads
-- * loam - no, old buildings are usually not built out of clay; loam was used
-- * straw - useful material for roofs
-- * glass pane - an improvement compared to fence posts as windows :-)
---------------------------------------------------------------------------------------
cottages.feldweg = {}

local prefix = cottages.modpath .. "/modules/feldweg/"

local mode = cottages.settings.feldweg.mode

if mode == "simple" then
    dofile(prefix .. "nodes_simple.lua")
elseif mode == "flat" then
    dofile(prefix .. "nodes_flat.lua")
elseif mode == "nodebox" then
    dofile(prefix .. "nodes_nodebox.lua")
else
    dofile(prefix .. "nodes_mesh.lua")
end

if cottages.has.stairs then
    dofile(prefix .. "compat_stairs.lua")
end

dofile(prefix .. "crafts.lua")
