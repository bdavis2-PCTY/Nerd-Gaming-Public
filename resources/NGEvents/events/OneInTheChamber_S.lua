events[2] = { 
	name 						= 'One in the chamber',-- The event name
	maxSlots 					= 100,				-- The max players for the event
	minSlots 					= 2,				-- The required amount of players
	warpPoses = {									-- Positions players will warp to on start
		-- { x, y, z, rot },
		{ -1254.05, 491.64, 16.58, 180 },
		{  -1459.74, 513.38, 3.04, -70 },
		{ -1415.63, 506.25, 3.04, 180 },	
		{ -1384.37, 507.69, 3.04, -90 },
		{ -1369.13, 495.68, 3.04, 100 },	
		{ -1351.86, 494.52, 11.2, 100 },
		{ -1395.21, 495.9, 19.5, 0 },		
		{ -1319, 492.66, 18.23, -90 },	
		{ -1324.92, 486.97, 11.19, 180 },		
		{ -1290.35, 491.52, 11.2, 90 },	
		{ -1362.64, 502.71, 11.2, -90 },
		{ -1394.38, 499.66, 11.2, 0 },	
	},
	
	disableWeapons 				= false,			-- Force no weapons
	useGodmode 					= false,			-- Set players in godmode for the whole event
	warpVehicle 				= false,			-- Model ID for players to be warped to, use false for none
	allowedVehicleExit 			= false,			-- Allow players to exit the vehicle
	allowPositionOffset 		= false,			-- Position offset for warps, used so players don't warp into each other
	allowLeaveCommand			= false,			-- Enable the player to use /leaveevent
	onlyOnePersonPerWarp		= true,				-- When set to true, only person can spawn at each warp
	hideHud						= { "clock", "money", "radar", "wanted" }
}


local thisEventFunctions = { }
function StartOneInTheChamber ( ) 
	for i, v in pairs ( EventCore.GetPlayersInEvent ( ) ) do
		giveWeapon ( v, 4, 1, false )
		giveWeapon ( v, 22, 1, true )
		exports.NGMessages:sendClientMessage ( "Use your ammo wisely! You will get a bullet for every kill", v, 255, 255, 255 )
	end
	addEventHandler ( "onPlayerWasted", root, thisEventFunctions.OnPlayerWasted )
	addEventHandler ( "onPlayerDamage", root, thisEventFunctions.OnPlayerDamage )
	addEventHandler ( "NGEvents:onEventEnded", root, thisEventFunctions.OnEventEnded )
end

function thisEventFunctions.OnPlayerDamage ( s, w )
	if ( s and isElement ( s ) and w and w == 22 and not isPedDead ( source ) and isPlayerInEvent ( source ) and isPlayerInEvent ( s ) ) then
		killPed ( source );
	end
end

function thisEventFunctions.OnPlayerWasted ( _, killer )
	--killPed ( source )
	if ( killer and isElement ( killer ) and isPlayerInEvent ( killer ) ) then
		giveWeapon ( killer, 22, 1, true )
	end
	
	local plrs = EventCore.GetPlayersInEvent ( )
	local winner = nil
	if ( table.len ( plrs ) == 0 ) then
		winner = source
	elseif ( table.len ( plrs ) == 1 ) then
		for i, v in pairs ( plrs ) do
			winner = v
		end
	end
	if winner then
		EventCore.WinPlayerEvent ( winner )
	end
	
end

function thisEventFunctions.OnEventEnded ( x )
	if ( x.name == events[2].name ) then
		removeEventHandler ( "onPlayerWasted", root, thisEventFunctions.OnPlayerWasted )
		removeEventHandler ( "onPlayerDamage", root, thisEventFunctions.OnPlayerDamage )
		removeEventHandler ( "NGEvents:onEventEnded", root, thisEventFunctions.OnEventEnded )
	end
end




eventStartFunctions[2] = _G['StartOneInTheChamber']
StartOneInTheChamber = nil