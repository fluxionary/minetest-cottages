local S = cottages.S
local F = minetest.formspec_escape
local FS = function(...) return F(S(...)) end

local api = cottages.straw

local textures = cottages.textures
local s = cottages.sounds

local has_ui = cottages.has.unified_inventory

local quern_min_per_turn = cottages.settings.straw.quern_min_per_turn
local quern_max_per_turn = cottages.settings.straw.quern_max_per_turn

local threshing_min_per_punch = cottages.settings.straw.threshing_min_per_punch
local threshing_max_per_punch = cottages.settings.straw.threshing_max_per_punch

if has_ui then
	unified_inventory.register_craft_type("cottages:quern", {
		description = S("quern-stone"),
		icon = "cottages:quern",
		width = 1,
		height = 1,
		uses_crafting_grid = false,
	})

	unified_inventory.register_craft_type("cottages:threshing", {
		description = S("threshing floor"),
		icon = "cottages:threshing_floor",
		width = 1,
		height = 1,
		uses_crafting_grid = false,
	})
end

api.registered_quern_crafts = {}

function api.register_quern_craft(recipe)
	api.registered_quern_crafts[recipe.input] = recipe.output

	if has_ui then
		unified_inventory.register_craft({
			output = recipe.output,
			type = "cottages:quern",
			items = {recipe.input},
			width = 1,
		})
	end
end

local function get_quern_results(input)
	local item = input:get_name()
	local output_def = api.registered_quern_crafts[item]
	if type(output_def) == "string" then
		return {ItemStack(output_def)}

	elseif type(output_def) == "table" and #output_def > 0 then
		local outputs = {}
		for _, output_item in ipairs(output_def) do
			if type(output_item) == "string" then
				table.insert(outputs, ItemStack(output_item))

			elseif type(output_item) == "table" then
				local chance
				output_item, chance = unpack(output_item)
				if math.random() <= chance then
					table.insert(outputs, ItemStack(output_item))
				end
			end
		end

		return outputs

	elseif type(output_def) == "function" then
		return output_def()
	end
end

local quern_formspec = ([[
	size[8,8]
	image[0,1;1,1;%s]
	button[6.0,0.0;1.5,0.5;public;%s]
	list[context;seeds;1,1;1,1;]
	list[context;flour;5,1;2,2;]
	label[0,0.5;%s]
	label[4,0.5;%s]
	label[0,-0.3;%s]
	label[0,2.5;%s]
	label[0,3.0;%s]
	list[current_player;main;0,4;8,4;]
	listring[current_player;main]
	listring[context;seeds]
	listring[current_player;main]
	listring[context;flour]
]]):format(
	F(cottages.textures.wheat_seed),
	FS("Public?"),
	FS("Input:"),
	FS("Output:"),
	FS("Quern"),
	FS("Punch this hand-driven quern"),
	FS("to grind suitable items.")
)

function api.update_quern_formspec(pos)
	local meta = minetest.get_meta(pos)
	local owner = meta:get_string("owner")
	if owner == "" then
		meta:set_string("formspec", quern_formspec)

	else
		meta:set_string("formspec", quern_formspec ..
			("label[2.5,0;%s]"):format(FS("Owner: @1", owner)))
	end
end

function api.update_quern_infotext(pos)
	local meta = minetest.get_meta(pos)
	local owner = meta:get("owner")
	if not owner then
		meta:set_string("infotext", S("Public quern, powered by punching"))

	elseif owner == " " then
		meta:set_string("infotext", S("Protected quern, powered by punching"))

	else
		meta:set_string("infotext", S("Private quern, powered by punching (owned by @1)", owner))
	end
end

function api.use_quern(pos, puncher)
	if not (pos and puncher and cottages.util.player_can_use(pos, puncher)) then
		return
	end

	local name = puncher:get_player_name()

	local meta = minetest.get_meta(pos)
	local inv = meta:get_inventory()
	local input = inv:get_stack("seeds", 1)

	if input:is_empty() then
		minetest.chat_send_player(name, S("nothing happens..."))
		return
	end

	local input_count = input:get_count()
	local input_description = input:get_short_description() or input:get_description()
	local number_to_process = math.min(math.random(quern_min_per_turn, quern_max_per_turn), input_count)

	for _ = 1, number_to_process do
		local results = get_quern_results(input:take_item(1))

		for _, result in ipairs(results) do
			local leftovers = inv:add_item("flour", result)
			if not leftovers:is_empty() then
				minetest.add_item(pos, leftovers)
			end
		end
	end

	inv:set_stack("seeds", 1, input)

	minetest.chat_send_player(name, S("ground @1 @2 (@3 are left)",
		number_to_process,
		input_description,
		input_count - number_to_process
	))

	local node = minetest.get_node(pos)
	node.param2 = (node.param2 + 1) % 4
	minetest.swap_node(pos, node)

	minetest.add_particlespawner({
		amount = 30,
		time = 0.1,
		collisiondetection = true,
		texture = textures.dust,
		minsize = 1,
		maxsize = 1,
		minexptime = 0.4,
		maxexptime = 0.8,
		minpos = vector.subtract(pos, 0.1),
		maxpos = vector.add(pos, vector.new(0.1, 0, 0.1)),
		minvel = vector.new(-1, -0.5, -1),
		maxvel = vector.new(1, 0.5, 1),
		minacc = vector.new(0, -3, 0),
		maxacc = vector.new(0, -3, 0),
	})

	minetest.sound_play(
		{name = s.use_quern},
		{pos = pos, gain = 1, pitch = 0.25},
		true
	)
end

api.registered_threshing_crafts = {}

function api.register_threshing_craft(recipe)
	api.registered_threshing_crafts[recipe.input] = recipe.output

	if has_ui then
		unified_inventory.register_craft({
			output = recipe.output,
			type = "cottages:threshing",
			items = {recipe.input},
			width = 1,
		})
	end
end

local function get_threshing_results(input)
	local item = input:get_name()
	local output_def = api.registered_threshing_crafts[item]
	if type(output_def) == "string" then
		return {ItemStack(output_def)}

	elseif type(output_def) == "table" and #output_def > 0 then
		local outputs = {}
		for _, output_item in ipairs(output_def) do
			if type(output_item) == "string" then
				table.insert(outputs, ItemStack(output_item))

			elseif type(output_item) == "table" then
				local chance
				output_item, chance = unpack(output_item)
				if math.random() <= chance then
					table.insert(outputs, ItemStack(output_item))
				end
			end
		end

		return outputs

	elseif type(output_def) == "function" then
		return output_def()
	end
end

local threshing_formspec = ([[
	size[8,8]
	image[1.5,0;1,1;%s]
	image[0,1;1,1;%s]
	button[6.8,0.0;1.5,0.5;public;%s]
	list[context;harvest;1,1;2,1;]
	list[context;straw;5,0;2,2;]
	list[context;seeds;5,2;2,2;]
	label[1,0.5;%s]
	label[4,0.0;%s]
	label[4,2.0;%s]
	label[0,0;%s]
	label[0,2.5;%s]
	label[0,3.0;%s]
	list[current_player;main;0,4;8,4;]
	listring[current_player;main]
	listring[context;harvest]
	listring[current_player;main]
	listring[context;straw]
	listring[current_player;main]
	listring[context;seeds]
]]):format(
	F(cottages.textures.stick),
	F(cottages.textures.wheat),
	FS("Public?"),
	FS("Input:"),
	FS("Output1:"),
	FS("Output2:"),
	FS("Threshing Floor"),
	FS("Punch threshing floor with a stick"),
	FS("to get straw and seeds from wheat.")
)

function api.update_threshing_formspec(pos)
	local meta = minetest.get_meta(pos)
	local owner = meta:get_string("owner")
	if owner == "" then
		meta:set_string("formspec", threshing_formspec)

	else
		meta:set_string("formspec", threshing_formspec ..
			("label[2.5,0;%s]"):format(FS("Owner: @1", owner)))
	end
end

function api.update_threshing_infotext(pos)
	local meta = minetest.get_meta(pos)
	local owner = meta:get("owner")
	if not owner then
		meta:set_string("infotext", S("Public threshing floor"))

	elseif owner == " " then
		meta:set_string("infotext", S("Protected threshing floor"))

	else
		meta:set_string("infotext", S("Private threshing floor (owned by @1)", owner))
	end
end

function api.use_threshing_floor(pos, puncher)
	if not minetest.is_player(puncher) then
		return
	end

	local name = puncher:get_player_name()

	-- only punching with a normal stick is supposed to work
	local wielded = puncher:get_wielded_item()
	if minetest.get_item_group(wielded:get_name(), "stick") == 0 then
		return
	end

	local meta = minetest.get_meta(pos)
	local inv = meta:get_inventory()

	local input1 = inv:get_stack("harvest", 1)
	local input2 = inv:get_stack("harvest", 2)

	local input_count = input1:get_count() + input2:get_count()

	if input_count == 0 then
		minetest.chat_send_player(name, S("Nothing left to thresh"))

		return
	end

	local input_description
	if input1:is_empty() then
		input_description = input2:get_short_description() or input2:get_description()

	else
		input_description = input1:get_short_description() or input1:get_description()
	end
	local number_to_process = math.min(math.random(threshing_min_per_punch, threshing_max_per_punch), input_count)

	for _ = 1, number_to_process do
		local results
		if input1:is_empty() then
			results = get_threshing_results(input2:take_item(1))
		else
			results = get_threshing_results(input1:take_item(1))
		end

		for _, result in ipairs(results) do
			local leftovers = inv:add_item("straw", result)
			if not leftovers:is_empty() then
				leftovers = inv:add_item("seeds", result)
				if not leftovers:is_empty() then
					minetest.add_item(pos, leftovers)
				end
			end
		end
	end

	inv:set_stack("harvest", 1, input1)
	inv:set_stack("harvest", 2, input2)

	local particle_pos = vector.subtract(pos, vector.new(0, 0.25, 0))
	minetest.add_particlespawner({
		amount = 10,
		time = 0.1,
		collisiondetection = true,
		texture = textures.straw,
		minsize = 1,
		maxsize = 1,
		minexptime = 0.2,
		maxexptime = 0.4,
		minpos = vector.subtract(particle_pos, 0.1),
		maxpos = vector.add(particle_pos, 0.1),
		minvel = vector.new(-3, 1, -3),
		maxvel = vector.new(3, 2, 3),
		minacc = vector.new(0, -10, 0),
		maxacc = vector.new(0, -10, 0),
	})

	minetest.add_particlespawner({
		amount = 10,
		time = 0.1,
		collisiondetection = true,
		texture = textures.wheat_seed,
		minsize = 1,
		maxsize = 1,
		minexptime = 0.2,
		maxexptime = 0.4,
		minpos = vector.subtract(particle_pos, 0.1),
		maxpos = vector.add(particle_pos, 0.1),
		minvel = vector.new(-3, 0.5, -3),
		maxvel = vector.new(3, 1, 3),
		minacc = vector.new(0, -10, 0),
		maxacc = vector.new(0, -10, 0),
	})

	minetest.sound_play(
		{name = s.use_thresher},
		{pos = particle_pos, gain = 1, pitch = 0.5},
		true
	)

	minetest.chat_send_player(name, S("threshed @1 @2 (@3 are left)",
		number_to_process,
		input_description,
		input_count - number_to_process
	))
end
