local S = cottages.S

local util = {}

function util.player_can_use(pos, player)
	if not (pos and player and minetest.is_player(player)) then
		return false
	end

	local player_name = player:get_player_name()
	local meta = minetest.get_meta(pos)
	local owner = meta:get_string("owner")

	return (
		(owner == "") or
			(owner == " " and not minetest.is_protected(pos, player_name)) or
			(owner == player_name)
	)
end

function util.switch_public(pos, fields, sender, name_of_the_thing)
	if fields.public == nil then
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
		minetest.chat_send_player(sender_name, S("The @1 is now private.", S(name_of_the_thing)))

	elseif owner == " " then
		meta:set_string("owner", "")
		minetest.chat_send_player(sender_name, S("The @1 is now fully public.", S(name_of_the_thing)))

	else
		meta:set_string("owner", " ")
		minetest.chat_send_player(sender_name, S("The @1 is now protected but not private.", S(name_of_the_thing)))
	end

	return true
end

cottages.util = util
