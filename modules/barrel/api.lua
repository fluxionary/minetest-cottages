local S = cottages.S
local F = minetest.formspec_escape
local FS = function(...) return F(S(...)) end

local max_liquid_amount = cottages.settings.barrel.max_liquid_amount

local api = cottages.barrel

local barrel_formspec = ([[
	size[8,9]
	image[2.6,2;2,3;default_sandstone.png^[lowpart:50:default_desert_stone.png]
	label[2.2,0;%s]
	list[context;input;3,0.5;1,1;]
	label[5,3.3;"..%s.."]
	list[context;output;5,3.8;1,1;]
	list[current_player;main;0,5;8,4;]
    listring[context;output]
    listring[current_player;main]
    listring[context;input]
    listring[current_player;main]
	button[6.8,0.0;1.5,0.5;public;%s]
]]):format(
	FS("Input:"),
	FS("Output:"),
	FS("Public?")
)

function api.update_formspec(pos)
	local meta = minetest.get_meta(pos)
	local owner = meta:get("owner")

	if owner and owner ~= " " then
		meta:set_string("formspec", ("%slabel[2.5,0.0;%s]"):format(barrel_formspec, S("Owner: @1", owner)))

	else
		meta:set_string("formspec", barrel_formspec)
	end
end

function api.update_infotext(pos)
	local meta = minetest.get_meta(pos)
	local owner = meta:get("owner")
	if not owner then
		meta:set_string("infotext", S("Public barrel"))

	elseif owner == " " then
		meta:set_string("infotext", S("Protected barrel"))

	else
		meta:set_string("infotext", S("Private barrel (owned by @1)", owner))
	end
end

function api.get_barrel_liquid(pos)
	local meta = minetest.get_meta(pos)
	return meta:get("liquid")
end

function api.set_barrel_liquid(pos, liquid)
	local meta = minetest.get_meta(pos)
	meta:set_string("liquid", liquid)
end

function api.get_liquid_amount(pos)
	local meta = minetest.get_meta(pos)
	return meta:get_int("amount")
end

function api.increase_liquid_amount(pos)
	local meta = minetest.get_meta(pos)
	meta:set_int("amount", meta:get_int("amount") + 1)
end

function api.decrease_liquid_amount(pos)
	local meta = minetest.get_meta(pos)
	local amount = meta:get_int("amount") - 1
	meta:set_int("amount", amount)
	if amount == 0 then
		api.set_barrel_liquid(pos, "")
	end
end

api.bucket_empty_by_bucket_full = {}
api.liquid_by_bucket_full = {}
api.bucket_full_by_empty_and_liquid = {}

local function empty_and_liquid(bucket_empty, liquid)
	return table.concat({bucket_empty, liquid}, "::")
end

function api.register_barrel_liquid(def)
	api.liquid_by_bucket_full[def.bucket_full] = def.liquid
	api.bucket_empty_by_bucket_full[def.bucket_full] = def.bucket_empty

	api.bucket_full_by_empty_and_liquid[empty_and_liquid(def.bucket_empty, def.liquid)] = def.bucket_full
end

function api.get_bucket_liquid(bucket_full)
	return api.liquid_by_bucket_full[bucket_full]
end

function api.get_bucket_empty(liquid)
	return api.bucket_empty_by_liquid[liquid]
end

function api.get_bucket_empty(bucket_full)
	return api.bucket_empty_by_bucket_full[bucket_full]
end

function api.get_bucket_full(bucket_empty, liquid)
	return api.bucket_full_by_empty_and_liquid[empty_and_liquid(bucket_empty, liquid)]
end

function api.can_fill(pos, bucket_empty)
	local liquid = api.get_barrel_liquid(pos)
	return liquid and api.get_bucket_full(bucket_empty, liquid)
end

function api.can_drain(pos, bucket_full)
	local barrel_liquid = api.get_barrel_liquid(pos)
	local liquid_amount = api.get_liquid_amount(pos)
	local bucket_liquid = api.get_bucket_liquid(bucket_full)

	if (not bucket_liquid) or liquid_amount >= max_liquid_amount then
		return false
	end

	return bucket_liquid and ((not barrel_liquid) or barrel_liquid == bucket_liquid)
end

function api.add_barrel_liquid(pos, bucket_full)
	if not api.get_barrel_liquid(pos) then
		local liquid = api.get_bucket_liquid(bucket_full)
		api.set_barrel_liquid(pos, liquid)
	end

	api.increase_liquid_amount(pos)

	return api.get_bucket_empty(bucket_full)
end

function api.drain_barrel_liquid(pos, bucket_empty)
	local liquid = api.get_barrel_liquid(pos)

	api.decrease_liquid_amount(pos)

	return api.get_bucket_full(bucket_empty, liquid)
end
