local S = cottages.S

local api = cottages.straw

local has_ui = cottages.has.unified_inventory

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
