events[3] = { 
	name 						= 'Los Santos Street Race',	-- The event name
	maxSlots 					= 20,				-- The max players for the event
	minSlots 					= 1,				-- The required amount of players
	warpPoses = {									-- Positions players will warp to on start
		-- { x, y, z, rot },
		{ 1336.43, -1392.93, 13.4, 90 },
		{ 1336.43, -1397.91, 13.32, 90 },
		{ 1336.43, -1402.76, 13.33, 90 },
		{ 1336.43, -1408.88, 13.37, 90 },
		{ 1344.33, -1392.93, 13.4, 90 },
		{ 1344.33, -1397.91, 13.32, 90 },
		{ 1344.33, -1402.76, 13.33, 90 },
		{ 1344.33, -1408.88, 13.37, 90 },
	},
	
	disableWeapons 				= true,				-- Force no weapons
	useGodmode 					= true,				-- Set players in godmode for the whole event
	warpVehicle 				= 541,				-- Model ID for players to be warped to, use false for none
	allowedVehicleExit 			= false,			-- Allow players to exit the vehicle
	allowPositionOffset 		= false,				-- Position offset for warps, used so players don't warp into each other
	allowLeaveCommand			= true,				-- Enable the player to use /leaveevent
	onlyOnePersonPerWarp		= true				-- When set to true, only person can spawn at each warp
}


function tempFunction ( ) 
	for i, v in pairs ( EventCore.GetPlayersInEvent ( ) ) do
		triggerClientEvent ( v, "NGEvents:Modules->LSStreetRace:CreateCheckpoints", v, "CreateElements", getElementDimension ( v ) )
	end
	return true
end

eventStartFunctions[3] = _G['tempFunction']
tempFunction = nil

addEvent ( "NGEvents:Modules->LSRace:ThisPlayerWinsRace", true )
addEventHandler ( "NGEvents:Modules->LSRace:ThisPlayerWinsRace", root, function ( )
	for i, v in pairs ( EventCore.GetPlayersInEvent ( ) ) do
		triggerClientEvent ( v, "NGEvents:Modules->LSStreetRace:CreateCheckpoints", v, "DestroyElements", getElementDimension ( v ) )
	end
	
	EventCore.WinPlayerEvent ( source )
end )