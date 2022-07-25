local S = cottages.S

local has_ui = cottages.has.unified_inventory

local min_per_turn = cottages.settings.quern_min_per_turn
local max_per_turn = cottages.settings.quern_max_per_turn

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

local function get_results(input)
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
	if not (pos and puncher and cottages.player_can_use(pos, puncher)) then
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

	local number_to_process = math.random(min_per_turn, max_per_turn)
	local input_count = input:get_count()

	if input_count < number_to_process then
		number_to_process = input_count
	end

	for _ = 1, number_to_process do
		local results = get_results(input)

		for _, result in ipairs(results) do
			local leftovers = inv:add_item("flour", result)
			if not leftovers:is_empty() then
				minetest.add_item(pos, leftovers)
			end
		end
	end

	minetest.chat_send_player(name, S("ground @1 (@2 are left)",
		input:get_description(),
		input_count - number_to_process
	))

	local node = minetest.get_node(pos)
	node.param2 = (node.param2 + 1) % 4
	minetest.swap_node(pos, node)
end

function cottages.straw.use_threshing_floor(pos, puncher)
	if not (pos and puncher and cottages.player_can_use(pos, puncher)) then
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

	local number_to_process = math.random(min_per_turn, max_per_turn)
	local input_count = input:get_count()

	if input_count < number_to_process then
		number_to_process = input_count
	end

	for _ = 1, number_to_process do
		local results = get_results(input)

		for _, result in ipairs(results) do
			local leftovers = inv:add_item("flour", result)
			if not leftovers:is_empty() then
				minetest.add_item(pos, leftovers)
			end
		end
	end

	minetest.chat_send_player(name, S("ground @1 (@2 are left)",
		input:get_description(),
		input_count - number_to_process
	))

	local node = minetest.get_node(pos)
	node.param2 = (node.param2 + 1) % 4
	minetest.swap_node(pos, node)
end
