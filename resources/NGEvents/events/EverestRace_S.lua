events[1] = { 
	name 						= 'Sanchez race',	-- The event name
	maxSlots 					= 20,				-- The max players for the event
	minSlots 					= 2,				-- The required amount of players
	warpPoses = {									-- Positions players will warp to on start
		-- { x, y, z, rot },
		{ -2320.68, -2169.16, 38.49, 294.7 },			-- Warp position 1
		{ -2319.92, -2170.25, 38.44, 294.7 },			-- Warp position 2
		{ -2319.45, -2170.68, 38.49, 294.7 },			-- Warp position 3
		{ -2319.07, -2171.74, 38.46, 294.7 },			-- Warp position 4
		{ -2318.96, -2172.48, 38.39, 294.7 },			-- Warp position 5
	},
	
	disableWeapons 				= true,				-- Force no weapons
	useGodmode 					= true,				-- Set players in godmode for the whole event
	warpVehicle 				= 468,				-- Model ID for players to be warped to, use false for none
	allowedVehicleExit 			= false,			-- Allow players to exit the vehicle
	allowPositionOffset 		= true,				-- Position offset for warps, used so players don't warp into each other
	allowLeaveCommand			= true,				-- Enable the player to use /leaveevent
	onlyOnePersonPerWarp		= false				-- When set to true, only person can spawn at each warp
}


function StartSanchezRace ( ) 
	local m = createMarker ( -2314.18, -1618.83, 483.77, "checkpoint", 8, 0, 255, 255, 120 )
	setElementDimension ( m, eventInfo.dim )
	triggerClientEvent ( root, "NGEvents:Event.EverestRace:SetVehicleCollisions", root, eventObjects.playerItems )
	addEventHandler ( "onMarkerHit", m, function ( p )
		if ( not isElement ( p ) ) then
			return
		end
		
		if ( getElementType ( p ) == "player" and getElementDimension ( p ) == getElementDimension ( source ) and getElementInterior ( p ) == 0 ) then
			if ( getElementData ( p, "NGEvents:IsPlayerInEvent" ) and isPedInVehicle ( p ) ) then
				EventCore.WinPlayerEvent( p )
				destroyElement ( source )
			end
		end
	end )
	
	return true
end

eventStartFunctions[1] = _G['StartSanchezRace']
StartSanchezRace = nil