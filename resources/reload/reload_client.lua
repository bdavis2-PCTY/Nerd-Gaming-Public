-------------------------
------- (c) 2010 --------
------- by Zipper -------
-- and Vio MTA:RL Crew --
-------------------------

function reload_settimer (total_clip, cur_clip, cur_gun)

	toggleControl ( "next_weapon", false )
	toggleControl ( "previous_weapon", false )
	toggleControl ( "fire", false )
	toggleControl ( "aim_weapon", false )
	setPedControlState ( getLocalPlayer(), "aim_weapon", false )
	setPedControlState ( getLocalPlayer(), "fire", false )
	setTimer ( rebind_wpchange, 500, 1, total_clip )
	setTimer ( kill_evr, 5000, 1 )
end
addEvent( "reload_settimer_trigger", true )
addEventHandler( "reload_settimer_trigger", getRootElement(), reload_settimer )

function rebind_wpchange (total_clip)

	local x = getPedAmmoInClip ( getLocalPlayer(), getPedWeaponSlot ( getLocalPlayer() ) )
	if x == total_clip then
		toggleControl ( "next_weapon", true )
		toggleControl ( "previous_weapon", true )
		toggleControl ( "fire", true )
		toggleControl ( "aim_weapon", true )
	else
		setTimer ( rebind_wpchange, 500, 1, total_clip )
	end
end

function kill_evr ()

	toggleControl ( "next_weapon", true )
	toggleControl ( "previous_weapon", true )
	toggleControl ( "fire", true )
	toggleControl ( "aim_weapon", true )
end