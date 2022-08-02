local has = cottages.has

local sounds = {}

if has.default then
	sounds.wood = default.node_sound_wood_defaults()
	sounds.dirt = default.node_sound_dirt_defaults()
	sounds.stone = default.node_sound_stone_defaults()
	sounds.leaves = default.node_sound_leaves_defaults()
	sounds.metal = default.node_sound_metal_defaults()

	sounds.water_empty = "default_water_footstep"
	sounds.water_fill = "default_water_footstep"

	sounds.tool_breaks = "default_tool_breaks"
end

if has.env_sounds then
	sounds.water_fill = "env_sounds_water"
end

cottages.sounds = sounds
