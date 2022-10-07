cottages.feldweg = {}

local mode = cottages.settings.feldweg.mode

if mode == "simple" then
	cottages.dofile("modules", "feldweg", "api_simple")

elseif mode == "flat" then
	cottages.dofile("modules", "feldweg", "api_flat")

elseif mode == "nodebox" then
	cottages.dofile("modules", "feldweg", "api_nodebox")

else
	cottages.dofile("modules", "feldweg", "api_mesh")
end

if cottages.has.default then
	cottages.dofile("modules", "feldweg", "compat_default")
end

if cottages.has.ethereal then
	cottages.dofile("modules", "feldweg", "compat_ethereal")
end

if cottages.has.stairs then
	cottages.dofile("modules", "feldweg", "compat_stairs")
end
