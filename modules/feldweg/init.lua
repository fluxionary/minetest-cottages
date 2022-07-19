cottages.feldweg = {}

local mode = cottages.settings.feldweg.mode

if mode == "simple" then
    cottages.dofile("modules", "feldweg", "nodes_simple")

elseif mode == "flat" then
    cottages.dofile("modules", "feldweg", "nodes_flat")

elseif mode == "nodebox" then
    cottages.dofile("modules", "feldweg", "nodes_nodebox")

else
    cottages.dofile("modules", "feldweg", "nodes_mesh")
end

if cottages.has.stairs then
    cottages.dofile("modules", "feldweg", "compat_stairs")
end

cottages.dofile("modules", "feldweg", "crafts")
