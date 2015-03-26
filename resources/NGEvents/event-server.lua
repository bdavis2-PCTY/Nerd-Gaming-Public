--[[

	How does the script work?
	When the admin types /makeevent [id] the server will create the event if there isn't an event currently running.
	The timer will begin and announce to players to join the event. Once the countdown is over, it checks to see if
	there are enough players in the event to continue. If there are then it calls the function:
	eventStartFunctions [ eventID ] ( )
	For example, the Sanchez race, it would call:
	eventStartFunctions [ 1 ] ( )
	The "eventStartFunctions" functions are defined in other files inside the events folder.
	



	How to make the eventStartFunctions function?
	First of all, you cannot name the function eventStartFunctions[int]( ). You have to make a temporary function
	and then define eventStartFunctions[int] with the _G variable. Example:
	function onClientStartRace ( )
		outputChatBox ( "Let the race begin!", root )
	end
	eventStartFunctions[2] = _G["onClientStartRace"]




	CURRENT EVENT ID'S:
		[1] = Sanchez race (Up the mountain)
		[2] = One in the chamber
		[3] = Los santos street race




	GLOBAL VARIABLES:
		eventStartFunctions
			Type: Table
			For: Storing the event start functions
		playersInEvent
			Type: Table
			For: Storing the players that are in the event
		eventInfo
			Type: Table
			For: Storing all of the event information
		eventObjects
			Type: Table
			For: Storing event objects. Player vehicles are defined with their element
		events
			Type: Table
			For: Storing all of the events and their settings
		EventCore
			Type: Table
			For: Holding all of the core functions




	RESOURCE EVENTS:
		NGEvents:onEventCreated 			- Triggers when an event is created
		NGEvents:onPlayerJoinEvent 			- Triggers when a player successfully joins an event
		NGEvents:onEventStarted 			- Triggers when the event countdown is over
		NGEvents:onEventEnded				- Triggers when the event ends (forced or not)
		NGEvents:onPlayerRemovedFromEvent	- Triggers when a player gets removed from an event
		
]]


eventStartFunctions = { }
playersInEvent = nil
eventInfo = nil
eventObjects = nil
events = { }
EventCore = { }

function EventCore.StartEvent ( id )
	if ( not events [ id ] or eventInfo ) then
		return false
	end
	
	local text_ = textCreateDisplay ( )
	local text = textCreateTextItem ( "Event starting in: 30", 0.6, 0.65, "hight", 255, 255, 0, 255, 2, "right", "bottom", 2 ) 
	textDisplayAddText ( text_, text )
	local timer = setTimer ( EventCore.BeginTheEvent, 30000, 1 )	
	
	local dim = math.random ( 5, 59565 )
	
	eventInfo = { 
		id 								= id, 
		name 							= events[id].name, 
		maxSlots 						= events[id].maxSlots, 
		minSlots 						= events[id].minSlots, 
		warps 							= events[id].warpPoses, 
		text 							= text_, 
		timer 							= timer, 
		dispText 						= text,
		disableWeapons 					= events[id].disableWeapons,
		godmode 						= events[id].useGodmode,
		dim 							= dim,
		vehicleID 						= events[id].warpVehicle,
		allowedVehicleExit 				= events[id].allowedVehicleExit,
		allowLeaveCommand 				= events[id].allowLeaveCommand,
		onlyOnePersonPerWarp 			= events[id].onlyOnePersonPerWarp,
		hiddenHud						= events[id].hideHud or { },
		originalPlayerCount 			= 0,
	}
	
	if ( eventInfo.onlyOnePersonPerWarp ) then
		if ( eventInfo.maxSlots > #eventInfo.warps ) then
			eventInfo.maxSlots = #eventInfo.warps
		end
		eventInfo.usedWarps = { }
	end
	
	
	DummyTimer1 = setTimer ( function ( )
		if ( not isTimer ( eventInfo.timer ) ) then
			killTimer ( DummyTimer1 )
			return
		end
		--textDisplayRemoveText ( eventInfo.text, eventInfo.dispText )
		--eventInfo.dispText = textCreateTextItem ( "Event starting in "..math.floor(getTimerDetails(eventInfo.timer)/1000).." seconds...", 0.98, 0.98, "hight", 0, 255, 255, 255, 2, "right", "bottom", 2 ) 
		--textDisplayAddText ( eventInfo.text, eventInfo.dispText )
		textItemSetText ( eventInfo.dispText, "Event starting in: "..math.floor(getTimerDetails(eventInfo.timer)/1000) )
	end, 1000, 0 )
	
	playersInEvent = { }
	eventObjects = {
		playerItems = { }
	}
	exports.NGMessages:sendClientMessage ( "Event: The "..tostring(events[id].name).." event has been created! Starting in 30 seconds, use /joinevent to join!", root, 0, 255, 0 )
	addCommandHandler ( "joinevent", EventCore.PlayerJoinEventCommand )
	triggerEvent ( "NGEvents:onEventCreated", resourceRoot, eventInfo )
	--exports.NGLogs:outputServerLog ( "Events: "..tostring(events[id].name).." has been created" )
end

function EventCore.PlayerJoinEventCommand ( p )
	if ( playersInEvent [ p ] ) then
		return exports.NGMessages:sendClientMessage ( "What the hell are you doing? You're already in the event", p, 0, 255, 255 )
	end
	
	local rSlots = eventInfo.maxSlots-table.len(playersInEvent)
	if ( getElementData ( p, "NGPolice:JailTime" ) ) then return exports.NGMessages:sendClientMessage ( "You cannot join an event while in jail", p, 255, 0, 0 ) end
	if ( isPedInVehicle ( p ) ) then return exports.NGMessages:sendClientMessage ( "Please exit your vehicle first", p, 255, 255, 0 ) end
	if ( getPlayerWantedLevel ( p ) > 0 and EventCore.GetDistanceToNearestCop ( p ) <= 170 ) then return exports.NGMessages:sendClientMessage ( "You're wanted and there is a near by officer. You cannot join the event.", p, 255, 255, 0 ) end
	if ( getElementInterior ( p ) ~= 0 ) then return exports.NGMessages:sendClientMessage ( "Please go outside to join the event", p, 255, 255, 0 ) end
	if ( rSlots <= 0 ) then return exports.NGMessages:sendClientMessage ( "This event is full, you need to be faster!", p, 255, 0, 0 ) end
	--exports.NGLogs:outputActionLog ( getPlayerName ( p ).." has joined the "..eventInfo.name.." event" )
	--exports.NGLogs:outputServerLog ( getPlayerName ( p ).." has joined the "..eventInfo.name.." event" )
	local px, py, pz = getElementPosition ( p )
	playersInEvent[p] = { 
		int = getElementInterior ( p ),
		dim = getElementDimension ( p ),
		x=px,
		y=py,
		z=pz,
		health = getElementHealth ( p ),
		weapons = { }
	}
	
	eventInfo.originalPlayerCount = table.len ( playersInEvent )
	
	for i=1,12 do
		table.insert ( playersInEvent [ p ].weapons, { getPedWeapon ( p, i ), getPedTotalAmmo ( p, i ) } )
	end
	takeAllWeapons ( p )

	if ( rSlots > 0 ) then exports.NGMessages:sendClientMessage ( "Event: "..getPlayerName(p).." has joined the event. Only "..rSlots.." slots left", root, 255, 255, 2550 )
	else exports.NGMessages:sendClientMessage ( "Event: "..getPlayerName(p).." has joined the event. Event is now full", root, 255, 0, 0 ) end
	
	local warps = eventInfo.warps
	local x, y, z, r = unpack ( warps [ math.random ( table.len ( warps ) ) ] )
	if ( eventInfo.onlyOnePersonPerWarp ) then
		while ( eventInfo.usedWarps[table.concat({x,y,z},",")] ) do
			x, y, z, r = unpack ( warps [ math.random ( table.len ( warps ) ) ] )
		end
	end
	
	setElementInterior ( p, 0 )
	setElementDimension ( p, eventInfo.dim )
	
	local x = x + ( math.random ( -0.7, 0.7 ) )
	local y = y + ( math.random ( -0.7, 0.7 ) )
	setElementPosition ( p, x, y, z + 0.3 )
	if ( not isPedInVehicle ( p ) ) then
		setPedRotation ( p, r )
	else
		setPedRotation ( getPedOccupiedVehicle ( p ), r )
	end
	setElementAlpha ( p, 200 )
	textDisplayAddObserver ( eventInfo.text, p )
	setElementData ( p, "isGodmodeEnabled", true )
	toggleControl ( p, "fire", false )
	toggleControl ( p, "next_weapon", false )
	toggleControl ( p, "previous_weapon", false )
	toggleControl ( p, "forwards", false )
	toggleControl ( p, "backwards", false )
	toggleControl ( p, "left", false )
	toggleControl ( p, "right", false )
	setPedWeaponSlot ( p, 0 )
	setElementData ( p, "NGEvents:IsPlayerInEvent", true )
	addEventHandler ( "onPlayerWasted", p, EventCore.RemovePlayerByWasted )
	triggerEvent ( "NGEvents:onPlayerJoinEvent", p )
	
	for i, v in pairs ( eventInfo.hiddenHud ) do
		setPlayerHudComponentVisible ( p, v, false )
	end
	
	if ( eventInfo.vehicleID ) then
		eventObjects.playerItems[p] = createVehicle ( eventInfo.vehicleID, x, y, z, 0, 0, r )
		setElementData ( eventObjects.playerItems[p], "VOwner", p )
		setElementDimension ( eventObjects.playerItems[p], eventInfo.dim )
		warpPedIntoVehicle ( p, eventObjects.playerItems[p] )
		setCameraTarget ( p, p ) 
		toggleControl ( p, "vehicle_fire", false )
		toggleControl ( p, "vehicle_secondary_fire", false )
		toggleControl ( p, "vehicle_left", false )
		toggleControl ( p, "vehicle_right", false )
		toggleControl ( p, "vehicle_right", false )
		toggleControl ( p, "vehicle_forward", false )
		toggleControl ( p, "vehicle_backward", false )
		toggleControl ( p, "accelerate", false )
		toggleControl ( p, "brake_reverse", false )
		setElementFrozen ( eventObjects.playerItems[p], true )
		if ( not eventInfo.allowedVehicleExit ) then
			addEventHandler ( "onVehicleStartExit", eventObjects.playerItems[p], function ( p )
				cancelEvent ( )
			end )
		end
	end
end

function EventCore.GetDistanceToNearestCop ( p )
	if ( p and isElement ( p ) ) then
		local dist = 9999999
		local x, y, z = getElementPosition ( p )
		for i, v in pairs ( getElementsByType ( 'player' ) ) do
			local t = getPlayerTeam ( v )
			if t then
				local n = getTeamName ( t )
				if ( exports.NGPlayerFunctions:isTeamLaw ( n ) ) then
					local px, py, pz = getElementPosition ( v )
					local d = getDistanceBetweenPoints3D ( x, y, z, px, py, pz )
					if ( d < dist ) then
						dist = d
					end
				end
			end
		end
		return dist
	end
	return false
end


function EventCore.BeginTheEvent ( )
	if ( isTimer ( DummyTimer1 ) ) then
		killTimer ( DummyTimer1 )
	end
	removeCommandHandler ( "joinevent", _G['EventCore.PlayerJoinEventCommand'] )
	
	if ( not eventInfo ) then
		return
	end
	
	textDestroyDisplay ( eventInfo.text )
	eventInfo.text = nil
	
	if ( #EventCore.GetPlayersInEvent ( ) < eventInfo.minSlots ) then
		EventCore.EndEvent ( )
		return exports.NGMessages:sendClientMessage ( "The event was cancelled due to not enough players.", root, 255, 255, 0 )
	end
	
	exports.NGMessages:sendClientMessage ( "Event: Let the games begin!", root, 0, 255, 0 )
	eventStartFunctions [ eventInfo.id ] ( )
	for i, p in pairs ( EventCore.GetPlayersInEvent ( ) ) do
		setElementData ( p, "isGodmodeEnabled", eventInfo.godmode )
		toggleControl ( p, "fire", not eventInfo.disableWeapons )
		toggleControl ( p, "next_weapon", not eventInfo.disableWeapons )
		toggleControl ( p, "previous_weapon", not eventInfo.disableWeapons )
		toggleControl ( p, "forwards", true )
		toggleControl ( p, "backwards", true )
		toggleControl ( p, "left", true )
		toggleControl ( p, "right", true )
		toggleControl ( p, "vehicle_fire", true )
		toggleControl ( p, "vehicle_secondary_fire", true )
		toggleControl ( p, "vehicle_left", true )
		toggleControl ( p, "vehicle_right", true )
		toggleControl ( p, "vehicle_right", true )
		toggleControl ( p, "vehicle_forward", true )
		toggleControl ( p, "vehicle_backward", true )
		toggleControl ( p, "accelerate", true )
		toggleControl ( p, "brake_reverse", true )
		setElementAlpha ( p, 255 )
		if ( isElement ( eventObjects.playerItems[p] ) ) then
			setElementFrozen ( eventObjects.playerItems[p], false )
		end
	end
	triggerEvent ( "NGEvents:onEventStarted", resourceRoot )
	--exports.NGLogs:outputServerLog ( "Events: Event has begun successfully" )
	-- Detect if the resource is bugged --
	setTimer ( function ( ) 
		for i, v in pairs ( EventCore.GetPlayersInEvent ( ) ) do
			if ( getElementAlpha ( v ) == 200  ) then
				exports.NGMessages:sendClientMessage ( "The event detected its self as being bugged. Cancelling the event.", root, 255, 0, 0 )
				EventCore.EndEvent ( )
				break
			end
		end
	end, 800, 1 )
	
end

function table.len ( tb )
	local c = 0
	for i, v in pairs ( tb ) do
		c = c + 1
	end
	return c
end

addEventHandler ( "onResourceStop", resourceRoot, function ( )
	if ( eventInfo ) then
		for i, v in pairs ( playersInEvent ) do
			if ( isElement ( i ) ) then
				--EventCore.RemovePlayerFromEvent ( i, false )
				exports.NGMessages:sendClientMessage("Sorry for the unexpected death. The events resource was stopped during an event", i, 255, 0, 0 )
			end
		end
	end
end )


function EventCore.GetPlayersInEvent ( )
	local c = { }
	for i, v in pairs ( playersInEvent ) do
		if ( isElement ( i ) ) then
			table.insert ( c, i )
		else
			playersInEvent[i] = nil
		end
	end
	return c
end

function EventCore.RemovePlayerByWasted ( )
	EventCore.RemovePlayerFromEvent ( source, false )
	exports.NGMessages:sendClientMessage ( getPlayerName ( source ).." was killed in the event!", root, 255, 255, 0 )
end

function EventCore.EndEvent ( )
	for i, v in ipairs ( EventCore.GetPlayersInEvent ( ) ) do
		EventCore.RemovePlayerFromEvent ( v, true )
	end
	
	--exports.NGLogs:outputServerLog ( "Events: "..eventInfo.name.." has been cancelled" )
	setTimer ( function ( ) 
		if ( isTimer ( DummyTimer1 ) ) then
			killTimer ( DummyTimer1 )
		end if ( eventInfo and eventInfo.text ) then
			textDestroyDisplay ( eventInfo.text )
		end
		removeCommandHandler ( "joinevent", _G['EventCore.PlayerJoinEventCommand'] )
		triggerEvent ( "NGEvents:onEventEnded", resourceRoot, eventInfo )
		playersInEvent = nil
		eventInfo = nil
	end, 700, 1 )
end

function EventCore.RemovePlayerFromEvent ( p, reset )
	if ( not playersInEvent [ p ] ) then
		return false
	end
	removeEventHandler ( "onPlayerWasted", p, EventCore.RemovePlayerByWasted )
	toggleControl ( p, "fire", true )
	toggleControl ( p, "next_weapon", true )
	toggleControl ( p, "previous_weapon", true )
	setElementData ( p, "isGodmodeEnabled", false )
	toggleControl ( p, "forwards", true )
	toggleControl ( p, "backwards", true )
	toggleControl ( p, "left", true )
	toggleControl ( p, "right", true )
	toggleControl ( p, "vehicle_fire", true )
	toggleControl ( p, "vehicle_secondary_fire", true )
	toggleControl ( p, "vehicle_left", true )
	toggleControl ( p, "vehicle_right", true )
	toggleControl ( p, "vehicle_right", true )
	toggleControl ( p, "vehicle_forward", true )
	toggleControl ( p, "vehicle_backward", true )
	toggleControl ( p, "accelerate", true )
	toggleControl ( p, "brake_reverse", true )
	setElementAlpha ( p, 255 )
	setElementDimension ( p, 0 )
	setElementData ( p, "NGEvents:IsPlayerInEvent", false )
	if ( isElement ( eventObjects.playerItems[p] ) ) then
		destroyElement ( eventObjects.playerItems[p] )
		eventObjects.playerItems[p] = nil
	end

	if reset then
		setTimer ( function ( p, pData )
			local x, y, z = tonumber ( pData.x ), tonumber ( pData.y ), tonumber ( pData.z )
			takeAllWeapons ( p )
			setElementInterior ( p, pData.int )
			setElementDimension ( p, pData.dim )
			setElementPosition ( p, x, y, z + 0.5 )
			setCameraTarget ( p, p )
			setElementHealth ( p, pData.health )
			
			for i, v in pairs ( eventInfo.hiddenHud ) do
				setPlayerHudComponentVisible ( p, v, true )
			end
			
			for i, v in pairs ( pData.weapons ) do
				giveWeapon ( p, v [ 1 ], v [ 2 ] )
			end
			
		end, 500, 1, p, playersInEvent [ p ] )
	else
		killPed ( p )
	end
	
	triggerEvent ( "NGEvents:onPlayerRemovedFromEvent", p )
	playersInEvent[p] = nil
	
	local c = EventCore.GetPlayersInEvent ( )
	if ( #c == 0 ) then
		EventCore.EndEvent ( );
	elseif( #c == 1 ) then
		for i, v in pairs ( c ) do
			EventCore.WinPlayerEvent ( i )
			break
		end
	end
	
end

function isPlayerInEvent ( p )
	if playersInEvent [ p ] then
		return true
	else
		return false
	end
end

function getEventInfo ( )
	return eventInfo
end

function EventCore.WinPlayerEvent ( p )
	if ( isElement ( p ) ) then
		local a = math.random ( 500, 800 ) * eventInfo.originalPlayerCount
		exports.NGMessages:sendClientMessage ( "Event: "..getPlayerName(p).." won $"..a.." for winning the "..eventInfo.name.." event!", root, 0, 255, 0 )
		--exports.NGLogs:outputServerLog ( "Event: "..getPlayerName(p).." has won the "..eventInfo.name.." event" )
		givePlayerMoney ( p, a )
		EventCore.EndEvent( )
		return true
	end
	return false
end




function isPlayerInACL ( player, acl )
	local account = getPlayerAccount ( player )
	if ( isGuestAccount ( account ) ) then
		return false
	end
        return isObjectInACLGroup ( "user."..getAccountName ( account ), aclGetGroup ( acl ) )
end

addCommandHandler ( "makeevent", function ( p, cmd, id )
	if ( exports.ngadministration:getPlayerStaffLevel ( p, 'int' ) >= 2 ) then
		if ( not tonumber ( id ) ) then
			return exports.NGMessages:sendClientMessage ( "Usage: /"..cmd.." [event id(1-"..table.len(events)..")]", p, 255, 255, 0 )
		end
		local id = tonumber ( id )
		if ( not events [ id ] ) then
			return exports.NGMessages:sendClientMessage ( "Invalid event id. Valid ranges from 1 to "..table.len ( events )..".", p, 255, 255, 0 )
		end
		if ( eventInfo ) then
			return exports.NGMessages:sendClientMessage ( "There is already an event running", p, 255, 255, 0 )
		end
		--exports.NGLogs:outputActionLog ( getPlayerName ( p ).." has created the event "..events[id].name.." (id:"..id..")" )
		EventCore.StartEvent ( id )
	end
end )

addCommandHandler ( "stopevent",  function ( p )
	if ( not exports.ngadministration:getPlayerStaffLevel ( p, 'int' ) >= 2 ) then
		return 
	end 
	
	if ( not eventInfo ) then
		return exports.NGMessages:sendClientMessage ( "There is no event running at the moment.", p, 255, 255, 0 )
	end
	--exports.NGLogs:outputActionLog ( getPlayerName ( p ).." has stopped the event (event: "..eventInfo.name..")" )
	exports.NGMessages:sendClientMessage ( "Event cancelled by level "..tostring(l).." admin "..getPlayerName(p)..".", root, 255, 0, 0 )
	EventCore.EndEvent ( )
end )

addCommandHandler ( "leaveevent", function ( p )
	if ( isPlayerInEvent ( p ) ) then
		if ( not eventInfo.allowLeaveCommand ) then
			return exports.NGMessages:sendClientMessage ( "You are not allowed to leave this event.", p, 255, 0, 0 )
		end
		
		EventCore.RemovePlayerFromEvent ( p, true )
		exports.NGMessages:sendClientMessage ( "Event: "..getPlayerName(p).." quit the event", root, 255, 255, 0 )
		--exports.NGLogs:outputActionLog ( getPlayerName ( p ).." has left the "..eventInfo.name.." event" )
	else
		exports.NGMessages:sendClientMessage ( "You're not in an event", p, 255, 255, 255 )
	end
end )

addCommandHandler ( "eventhelp", function ( p )
	outputChatBox ( "----- Event Help -----", p, 0,255, 255 )
	outputChatBox ( "/joinevent - Join an event if there is one running", p, 0, 255, 255 )
	outputChatBox ( "/leaveevent - Kill yourself out of the event", p, 0, 255, 255 )
	if ( exports.ngadministration:getPlayerStaffLevel ( p, 'int' ) >= 2 ) then
		outputChatBox ( "----- For Staff -----", p, 255, 255, 0 )
		outputChatBox ( "/makeevent - Create an event", p, 255, 255, 0 )
		for i, v in pairs ( events ) do
			outputChatBox ( "        "..tostring ( i ).." -> "..tostring ( v.name ), p, 255, 255, 0 )
		end
		outputChatBox ( "/stopevent - Stop the current event", p, 255, 255, 0 )
	end
end )


addEvent ( "NGEvents:onEventCreated", true )
addEvent ( "NGEvents:onPlayerJoinEvent", true )
addEvent ( "NGEvents:onEventStarted", true )
addEvent ( "NGEvents:onEventEnded", true )
addEvent ( "NGEvents:onPlayerRemovedFromEvent", true )







-- create event every 12 minutes 30 seconds
local lastRanEvent = nil
setTimer ( function ( )
	local id = math.random ( table.len ( events ) )
	while ( lastRanEvent == id or ( not events [ id ] ) ) do
		id = math.random ( table.len ( events ) )
	end
	
	--exports.NGLogs:outputServerLog ( "Event: Server automatically started the "..events[id].name.." event (id:"..tostring(id)..")" )
	EventCore.StartEvent ( id )
end, 750000, 0 )