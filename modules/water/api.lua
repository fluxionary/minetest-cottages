local F = minetest.formspec_escape
local S = cottages.S
local FS = function(...) return F(S(...)) end

local ci = cottages.craftitems
local s = cottages.sounds

local player_can_use = cottages.util.player_can_use

local settings = cottages.settings.water

local api = cottages.water

local formspec = ([[
	size[8,9]
	label[3.0,0.0;%s]
	label[1.5,0.7;%s]
	label[1.5,1.0;%s]
	label[1.5,1.3;%s]
	label[1.0,2.9;%s]
	item_image[0.2,0.7;1.0,1.0;%s]
	item_image[0.2,1.7;1.0,1.0;%s]
	label[1.5,1.9;%s]
	list[context;main;1,3.3;8,1;]
	list[current_player;main;0,4.85;8,4;]
	listring[]
	button[6.0,0.0;2,0.5;public;%s]
]]):format(
	FS("Tree trunk well"),
	FS("Punch the well while wielding an empty bucket."),
	FS("Your bucket will slowly be filled with river water."),
	FS("Punch again to get the bucket back when it is full."),
	FS("Internal bucket storage (passive storage only):"),
	F(ci.bucket),
	F(ci.bucket_filled),
	FS("Punch well with full water bucket in order to empty bucket."),
	FS("Public?")
)

function api.update_formspec(pos)
	local parts = {formspec}

	local meta = minetest.get_meta(pos)
	local owner = meta:get("owner")

	if not owner then
		table.insert(parts, ("label[6,1;%s]"):format(FS("(Public)")))

	elseif owner == " " then
		table.insert(parts, ("label[6,1;%s]"):format(FS("(Protected)")))

	else
		table.insert(parts, ("label[6,1;%s]"):format(FS("Owner: @1", owner)))
	end

	meta:set_string("formspec", table.concat(parts, ""))
end

function api.update_infotext(pos)
	local meta = minetest.get_meta(pos)
	local owner = meta:get("owner")
	if owner then
		meta:set_string("infotext", S("Tree trunk well (owned by @1)", owner))
	else
		meta:set_string("infotext", S("Public tree trunk well"))
	end
end

local sound_handles_by_pos = {}
local particlespawner_ids_by_pos = {}

local function add_filling_effects(pos)
	local entity_pos = vector.add(pos, vector.new(0, 1/4, 0))

	local spos = minetest.pos_to_string(pos)

	local previous_handle = sound_handles_by_pos[spos]
	if previous_handle then
		minetest.sound_stop(previous_handle)
	end
	sound_handles_by_pos[spos] = minetest.sound_play(
		{name = s.water_fill},
		{pos = entity_pos, loop = true, gain = 0.5, pitch = 2.0}
	)

	local previous_id = particlespawner_ids_by_pos[spos]
	if previous_id then
		minetest.delete_particlespawner(previous_id)
	end
	local particle_pos = vector.add(pos, vector.new(0, 1/2 + 1/16, 0))
	particlespawner_ids_by_pos[spos] = minetest.add_particlespawner({
		amount = 10,
		time = 0,
		collisiondetection = false,
		texture = "bubble.png",
		minsize = 1,
		maxsize = 1,
		minexptime = 0.4,
		maxexptime = 0.4,
		minpos = particle_pos,
		maxpos = particle_pos,
		minvel = vector.new(-0.1, -0.2, -0.01),
		maxvel = vector.new(0.1, -0.2, 0.1),
		minacc = vector.new(0, -2, 0),
		maxacc = vector.new(0, -2, 0),
	})
end

function api.use_well(pos, puncher)
	local player_name = puncher:get_player_name()
	local meta = minetest.get_meta(pos)
	local owner = meta:get_string("owner")

	if not player_can_use(pos, puncher) then
		minetest.chat_send_player(player_name, S("This tree trunk well is owned by @1. You can't use it.", owner))
		return
	end

	local pinv = puncher:get_inventory()
	local bucket = meta:get("bucket")

	local entity_pos = vector.add(pos, vector.new(0, 1/4, 0))

	if not bucket then
		local wielded = puncher:get_wielded_item()
		local wielded_name = wielded:get_name()
		if wielded_name == ci.bucket then
			meta:set_string("bucket", wielded_name)

			minetest.add_entity(entity_pos, "cottages:bucket_entity")

			pinv:remove_item("main", "bucket:bucket_empty")

			local timer = minetest.get_node_timer(pos)
			timer:start(settings.well_fill_time)

			add_filling_effects(pos)

		elseif wielded_name == ci.bucket_filled then
			-- empty a bucket
			pinv:remove_item("main", ci.bucket_filled)
			pinv:add_item("main", ci.bucket)

			minetest.sound_play(
				{name = s.water_empty},
				{pos = entity_pos, gain = 0.5, pitch = 2.0},
				true
			)
		end

	elseif bucket == ci.bucket then
		minetest.chat_send_player(player_name, S("Please wait until your bucket has been filled."))
		local timer = minetest.get_node_timer(pos)
		if not timer:is_started() then
			timer:start(settings.well_fill_time)
			add_filling_effects(pos)
		end

	elseif bucket == ci.bucket_filled then
		meta:set_string("bucket", "")

		for _, obj in ipairs(minetest.get_objects_inside_radius(entity_pos, .1)) do
			local ent = obj:get_luaentity()
			if ent and ent.name == "cottages:bucket_entity" then
				obj:remove()
			end
		end

		pinv:add_item("main", ci.bucket_filled)
	end
end

function api.fill_bucket(pos)
	local entity_pos = vector.add(pos, vector.new(0, 1/4, 0))

	for _, obj in ipairs(minetest.get_objects_inside_radius(entity_pos, .1)) do
		local ent = obj:get_luaentity()
		if ent and ent.name == "cottages:bucket_entity" then
			local props = obj:get_properties()
			props.wield_item = ci.bucket_filled
			obj:set_properties(props)
		end
	end

	local meta = minetest.get_meta(pos)
	meta:set_string("bucket", ci.bucket_filled)

	local spos = minetest.pos_to_string(pos)
	local handle = sound_handles_by_pos[spos]
	if handle then
		minetest.sound_stop(handle)
	end
	local id = particlespawner_ids_by_pos[spos]
	if id then
		minetest.delete_particlespawner(id)
	end
end

function api.initialize_entity(pos)
	local meta = minetest.get_meta(pos)
	local bucket = meta:get("bucket")
	if bucket then
		local entity_pos = vector.add(pos, vector.new(0, 1/4, 0))
		local obj = minetest.add_entity(entity_pos, "cottages:bucket_entity")
		local props = obj:get_properties()
		props.wield_item = bucket
		obj:set_properties(props)

		if bucket == ci.bucket then
			local timer = minetest.get_node_timer(pos)
			if not timer:is_started() then
				timer:start(settings.well_fill_time)
			end
			add_filling_effects(pos)
		end
	end
end
