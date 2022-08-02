local S = cottages.S

local util = {}

function util.player_can_use(pos, player)
	if not (pos and player and minetest.is_player(player)) then
		return false
	end

	local player_name = player:get_player_name()
	local meta = minetest.get_meta(pos)
	local owner = meta:get_string("owner")

	return (not minetest.is_protected(pos, player_name)) and owner == "" or owner == player_name
end

function util.switch_public(pos, formname, fields, sender, name_of_the_thing)
	minetest.chat_send_all(("formname: %s"):format(formname))
	if not (formname:match("^cottages:") and fields.public) then
		return
	end

	if not util.player_can_use(pos, sender) then
		return
	end

	local sender_name = sender:get_player_name()
	local meta = minetest.get_meta(pos)
	local owner = meta:get_string("owner")

	if owner == "" then
		meta:set_string("owner", sender_name)
		minetest.chat_send_player(sender_name, S("The @1 can only be used by yourself.", S(name_of_the_thing)))
	else
		meta:set_string("owner", "")
		minetest.chat_send_player(sender_name, S("The @1 can now be used by anyone.", S(name_of_the_thing)))
	end

	return true
end

function util.check_exists(item)
	while minetest.registered_aliases[item] do
		item = minetest.registered_aliases[item]
	end

	if minetest.registered_items[item] then
		return item
	end
end

cottages.util = util
