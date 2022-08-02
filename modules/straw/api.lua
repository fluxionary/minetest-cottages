local S = cottages.S

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

cottages.straw.registered_quern_crafts = {}

function cottages.straw.register_quern_craft(recipe)
	cottages.straw.registered_quern_crafts[recipe.input] = recipe.output

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
	local output_def = cottages.straw.registered_quern_crafts[item]
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

function cottages.straw.use_quern(pos, puncher)
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
end

cottages.straw.registered_threshing_crafts = {}

function cottages.straw.register_threshing_craft(recipe)
	cottages.straw.registered_threshing_crafts[recipe.input] = recipe.output

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
	local output_def = cottages.straw.registered_threshing_crafts[item]
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

function cottages.straw.use_threshing_floor(pos, puncher)
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

	minetest.chat_send_player(name, S("threshed @1 @2 (@3 are left)",
		number_to_process,
		input_description,
		input_count - number_to_process
	))
end
