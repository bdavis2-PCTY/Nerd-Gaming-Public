function reload (player, key, state)
	
	local total_clip = 0
	local cur_gun = getPedWeapon ( player )
	if getPedWeapon ( player ) == 22 or getPedWeapon ( player ) == 23 then
		total_clip = 17
	elseif getPedWeapon ( player ) == 24 or getPedWeapon ( player ) == 27 then
		total_clip = 7
	elseif getPedWeapon ( player ) == 26 then
		total_clip = 2
	elseif getPedWeapon ( player ) == 28 or getPedWeapon ( player ) == 32 or getPedWeapon ( player ) == 31 or getPedWeapon ( player ) == 37 then
		total_clip = 50
	elseif getPedWeapon ( player ) == 29 or getPedWeapon ( player ) == 30 then
		total_clip = 30
	elseif getPedWeapon ( player ) == 41 or getPedWeapon ( player ) == 42 or getPedWeapon ( player ) == 38 then
		total_clip = 500
	end
	if total_clip == 0 then
	else
		if getPedWeaponSlot ( player ) > 1 and getPedWeaponSlot ( player ) < 10 and getPedWeaponSlot ( player ) ~= 6 and getPedWeaponSlot ( player ) ~= 8 and getPedWeapon ( player ) ~= 25 and getPedWeapon ( player ) ~= 35 and getPedWeapon ( player ) ~= 36 and getPedWeapon ( player ) ~= 25 then
			if state == "down" then
				reloadPedWeapon(player)
				triggerClientEvent ( player, "reload_settimer_trigger", getRootElement(), total_clip, cur_clip )
			end
		end
	end
end
-- The Key will be bound when the Player joins
function reload_keybind()

	bindKey ( source, "r", "down", reload )
end
addEventHandler ("onPlayerJoin", getRootElement(), reload_keybind)

addEventHandler ( "onResourceStart", resourceRoot, function ( )
	for i, v in ipairs ( getElementsByType ( "player" ) ) do
		bindKey ( v, "r", "down", reload )
	end
end )