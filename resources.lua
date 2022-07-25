local has = cottages.has

local function check_exists(item)
	if minetest.registered_items[item] then
		return item
	end
end

cottages.craftitem = {}

cottages.craftitem.stick = "group:stick"
cottages.craftitem.wood = "group:wood"

if has.default then
	cottages.craftitem.chest_locked = check_exists("default:chest_locked")
	cottages.craftitem.clay_brick = check_exists("default:clay_brick")
	cottages.craftitem.clay = check_exists("default:clay")
	cottages.craftitem.coal_lump = check_exists("default:coal_lump")
	cottages.craftitem.dirt = check_exists("default:dirt")
	cottages.craftitem.fence = check_exists("default:fence_wood")
	cottages.craftitem.glass = check_exists("default:glass")
	cottages.craftitem.iron = check_exists("default:iron_lump")
	cottages.craftitem.junglewood = check_exists("default:junglewood")
	cottages.craftitem.ladder = check_exists("default:ladder")
	cottages.craftitem.papyrus = check_exists("default:papyrus")
	cottages.craftitem.rail = check_exists("default:rail")
	cottages.craftitem.sand = check_exists("default:sand")
	cottages.craftitem.steel = check_exists("default:steel_ingot")
	cottages.craftitem.stone = check_exists("default:stone")
end

if has.carts then
	cottages.craftitem.rail = check_exists("carts:rail")
end

if has.doors then
	cottages.craftitem.door = check_exists("doors:door_wood")
end

if has.farming then
	cottages.craftitem.cotton = check_exists("farming:cotton")
	cottages.craftitem.seed_wheat = check_exists("farming:seed_wheat")
	cottages.craftitem.string = check_exists("farming:string")
end

if has.stairsplus and has.default then
	cottages.craftitem.slab_wood = check_exists("default:slab_wood_8")

elseif has.moreblocks and minetest.registered_nodes["moreblocks:slab_wood"] then
	cottages.craftitem.slab_wood = check_exists("moreblocks:slab_wood")

elseif has.stairs then
	cottages.craftitem.slab_wood = check_exists("stairs:slab_wood")
end

if has.wool then
	cottages.craftitem.wool = check_exists("wool:white")
else
	cottages.craftitem.wool = "cottages:wool"
end

------ TEXTURES --------
cottages.texture = {}

if has.default then
	cottages.texture.furniture = "default_wood.png"
	cottages.texture.roof_sides = "default_wood.png"
	cottages.texture.stick = "default_stick.png"
	cottages.texture.roof_wood = "default_tree.png"
else
	cottages.texture.roof_sides = "cottages_minimal_wood.png"
	cottages.texture.furniture = "cottages_minimal_wood.png"
end

cottages.texture.straw = "cottages_darkage_straw.png"

if has.farming then
	cottages.texture.wheat_seed = "farming_wheat_seed.png"

	if cottages.settings.roof.use_farming_straw_stairs and minetest.registered_nodes["farming:straw"] then
		cottages.texture.straw = "farming_straw.png"
	end
end

------ SOUNDS --------
cottages.sounds = {}

if has.default then
	cottages.sounds.wood = default.node_sound_wood_defaults()
	cottages.sounds.dirt = default.node_sound_dirt_defaults()
	cottages.sounds.stone = default.node_sound_stone_defaults()
	cottages.sounds.leaves = default.node_sound_leaves_defaults()
	cottages.sounds.metal = default.node_sound_metal_defaults()

	cottages.sounds.tool_breaks = "default_tool_breaks"
end
