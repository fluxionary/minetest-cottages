local has = cottages.has

local check_exists = cottages.util.check_exists

local ci = {}

ci.stick = "group:stick"
ci.wood = "group:wood"
ci.tree = "group:tree"

if has.default then
	ci.chest_locked = check_exists("default:chest_locked")
	ci.clay_brick = check_exists("default:clay_brick")
	ci.clay = check_exists("default:clay")
	ci.coal_lump = check_exists("default:coal_lump")
	ci.dirt = check_exists("default:dirt")
	ci.fence = check_exists("default:fence_wood")
	ci.glass = check_exists("default:glass")
	ci.iron = check_exists("default:iron_lump")
	ci.junglewood = check_exists("default:junglewood")
	ci.ladder = check_exists("default:ladder")
	ci.paper = check_exists("default:paper")
	ci.papyrus = check_exists("default:papyrus")
	ci.rail = check_exists("default:rail")
	ci.sand = check_exists("default:sand")
	ci.steel = check_exists("default:steel_ingot")
	ci.stone = check_exists("default:stone")
end

if has.bucket then
	ci.bucket = check_exists("bucket:bucket_empty")
	ci.bucket_filled = check_exists("bucket:bucket_river_water")
end

if has.carts then
	ci.rail = check_exists("carts:rail")
end

if has.doors then
	ci.door = check_exists("doors:door_wood")
end

if has.farming then
	ci.barley = check_exists("farming:barley")
	ci.cotton = check_exists("farming:cotton")
	ci.flour = check_exists("farming:flour")
	ci.oat = check_exists("farming:oat")
	ci.rice = check_exists("farming:rice")
	ci.rice_flour = check_exists("farming:rice_flour")
	ci.rye = check_exists("farming:rye")
	ci.seed_barley = check_exists("farming:seed_barley")
	ci.seed_oat = check_exists("farming:seed_oat")
	ci.seed_rye = check_exists("farming:seed_rye")
	ci.seed_wheat = check_exists("farming:seed_wheat")
	ci.string = check_exists("farming:string")
	ci.wheat = check_exists("farming:wheat")
end

if has.stairsplus and has.default then
	ci.slab_wood = check_exists("default:slab_wood_8")

elseif has.moreblocks and check_exists("moreblocks:slab_wood") then
	ci.slab_wood = check_exists("moreblocks:slab_wood")

elseif has.stairs then
	ci.slab_wood = check_exists("stairs:slab_wood")
end

if has.wool then
	ci.wool = check_exists("wool:white")
else
	ci.wool = "cottages:wool"
end

ci.straw_mat = "cottages:straw_mat"

cottages.craftitems = ci
