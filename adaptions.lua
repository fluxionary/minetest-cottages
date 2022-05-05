local has = cottages.has

------ CRAFTITEMS --------
cottages.craftitem = {}

cottages.craftitem.stick = "group:stick"
cottages.craftitem.wood = "group:wood"

if has.default then
    cottages.craftitem.steel = "default:steel_ingot"
    cottages.craftitem.stone = "default:stone"
    cottages.craftitem.fence = "default:fence_wood"
    cottages.craftitem.clay = "default:clay"
    cottages.craftitem.iron = "default:iron_lump"
    cottages.craftitem.dirt = "default:dirt"
    cottages.craftitem.sand = "default:sand"
    cottages.craftitem.glass = "default:glass"
    cottages.craftitem.papyrus = "default:papyrus"
    cottages.craftitem.coal_lump = "default:coal_lump"
    cottages.craftitem.clay_brick = "default:clay_brick"
    cottages.craftitem.junglewood = "default:junglewood"
    cottages.craftitem.chest_locked = "default:chest_locked"
end

if has.doors then
    cottages.craftitem.door = "doors:door_wood"
end

if has.farming then
    cottages.craftitem.seed_wheat = "farming:seed_wheat"
end

if has.moreblocks and minetest.registered_nodes["moreblocks:slab_wood"] then
    cottages.craftitem.slab_wood = "moreblocks:slab_wood"
elseif has.stairs then
    cottages.craftitem.slab_wood = "stairs:slab_wood"
end

if has.wool then
    cottages.craftitem.wool = "wool:white"
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

if has.farming then
    cottages.texture.wheat_seed = "farming_wheat_seed.png"
end

cottages.texture.straw = "cottages_darkage_straw.png"

------ SOUNDS --------
cottages.sounds = {}

if has.default then
    cottages.sounds.wood = default.node_sound_wood_defaults()
    cottages.sounds.dirt = default.node_sound_dirt_defaults()
    cottages.sounds.stone = default.node_sound_stone_defaults()
    cottages.sounds.leaves = default.node_sound_leaves_defaults()
    cottages.sounds.metal = default.node_sound_metal_defaults()
end



