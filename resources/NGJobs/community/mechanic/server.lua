local vehicleDropPoints = {
	-- x, y, z, rz
	{ 2316.04, -2366.29, 13.55, 46.5 },
	{ -1699.16, 401.86, 7.18, 230.3 },
	{ 1639.13, 2193.94, 10.82 }
}

addEventHandler ( "onResourceStart", resourceRoot, function ( )
	for i, v in ipairs ( vehicleDropPoints ) do 
		local x, y, z, rz = unpack ( v )
		create3DText ( "Vehicle Recovery", { x, y, z }, { 255, 255, 255 } )
		local marker = createMarker ( x, y, z-2, "cylinder", 5, 255, 255, 0, 80 )
		setElementData ( marker, "NGJobs:Mechanic.DropPointRotation", rz )
		addEventHandler ( "onMarkerHit", marker, function ( p )
			if ( getElementType ( p ) == 'player' ) then
				if ( isPedInVehicle ( p ) and getElementData ( p, "Job" ) == "Mechanic" and getElementModel ( getPedOccupiedVehicle ( p ) ) == 525 ) then
					local car = getVehicleTowedByVehicle ( getPedOccupiedVehicle ( p ) )
					if car then
						local vehicleID = getElementData ( car, "NGVehicles:VehicleID" )
						local vehicleOwner = getElementData ( car, "NGVehicles:VehicleAccountOwner" )
						local name = getVehicleNameFromModel ( getElementModel ( car ) )
						if vehicleID and vehicleOwner then
							local owner = exports['NGPlayerFunctions']:getPlayerFromAcocunt ( vehicleOwner )
							if owner then
								exports['NGMessages']:sendClientMessage ( "Your "..name.." has been impounded.", owner, 255, 255, 0 )
							end
							exports['NGVehicles']:showVehicle ( vehicleID, false )
							local cash = 1000 + math.random ( 0, 150 )
							givePlayerMoney ( p, cash )
							exports['NGMessages']:sendClientMessage ( "You have been paid $"..cash.." for impounding this vehicle.", p, 0, 255, 0 )
							exports['NGSQL']:db_exec ( "UPDATE vehicles SET Impounded=? WHERE VehicleID=?", '1', vehicleID )
							local acc = getAccountName ( getPlayerAccount ( p ) )
							updateJobColumn ( acc, "TowedVehicles", "AddOne" )
						else
							exports['NGMessages']:sendClientMessage ( "This vehicle isn't owned.", p, 255, 255, 255 )
						end
					else
						exports['NGMessages']:sendClientMessage ( "You require to be towing a vehicle to drop it.", p, 0, 255, 255 )
					end
				elseif ( not isPedInVehicle ( p ) ) then
					local acc = getPlayerAccount ( p )
					if isGuestAccount ( acc ) then return end
					
					local cars = exports['NGSQL']:db_query ( "SELECT * FROM vehicles WHERE Owner=? AND Impounded=?", getAccountName ( acc ), '1' )
					if ( #cars == 0 ) then
						return exports['NGMessages']:sendClientMessage ( "You have no impounded vehicles!", p, 0, 255, 0 )
					end
					
					triggerClientEvent ( p, "NGJobs:Mechanic.OpenRecovery", p, cars, source )
				end
			end
		end )
	end
end )

addEvent ( "NGJobs:Mechanic.onPlayerRecoverVehicle", true )
addEventHandler ( "NGJobs:Mechanic.onPlayerRecoverVehicle", root, function ( id, marker, price ) 
	if id and marker then
		local x, y, z = getElementPosition ( marker )
		local rz = getElementData ( marker, "NGJobs:Mechanic.DropPointRotation" ) or 0
		veh = exports['NGVehicles']:showVehicle ( id, true )
		setElementPosition ( veh, x, y, z + 3.5 )
		setElementRotation ( veh, 0, 0, rz )
		warpPedIntoVehicle ( source, veh )
		exports['NGSQL']:db_exec ( "UPDATE vehicles SET Impounded=? WHERE VehicleID=?", '0', id )
		takePlayerMoney ( source, price )
	end
end )


local vehiclesBeingFixed = { }
local timer = { }
addEvent ( "NGJobs:Mechanic_AttemptFixVehicle", true )
addEventHandler ( "NGJobs:Mechanic_AttemptFixVehicle", root, function ( v )
	if ( vehiclesBeingFixed[v] ) then
		exports['NGMessages']:sendClientMessage ( "This vehicle is already being repaired.", source, 255, 0, 0 )
		return triggerClientEvent ( source, "NGJobs:Mechanic_CancelFixingRequest", source, 'source', false )
	end
	
	local controller = getVehicleController ( v )
	local price = (1000-(math.floor(getElementHealth(v))))
	if ( getPlayerMoney ( controller ) >= price ) then
		if ( price == 0 ) then
			return exports['NGMessages']:sendClientMessage ( "This vehicle doesn't need to be fixed.", source, 255, 255, 0 )
		end
		exports['NGMessages']:sendClientMessage ( "Sending "..getPlayerName ( controller ).." a request that'll expire in 15 seconds.", source, 0, 255, 0 )
		exports['NGMessages']:sendClientMessage ( getPlayerName ( source ).." wants to fix your vehicle for $"..tostring(price)..". Press 1 to accept, and 2 to deny", controller, 255, 255, 255 )
		setElementFrozen ( v, true )
		setElementFrozen ( source, true )
		showCursor ( controller, true )
		showCursor ( source, true )
		vehiclesBeingFixed[v] = true
		triggerClientEvent ( controller, "NGjobs:Mechanic_BindClientKeys", controller, source )
		timer[v] = setTimer ( function ( s, p, v )
			if ( isElement ( s ) ) then
				triggerClientEvent ( s, "NGJobs:Mechanic_CancelFixingRequest", s, 'source' )
				setElementFrozen ( s, false )
				showCursor ( s, false )
			end
			
			if ( isElement ( p ) ) then
				triggerClientEvent ( p, "NGJobs:Mechanic_CancelFixingRequest", p, 'client' )
				setElementFrozen ( p, false )
				showCursor ( p, false )
			end
			
			if ( isElement ( v ) ) then
				setElementFrozen ( v, false )
				vehiclesBeingFixed[v] = nil
			end
			
		end, 15000, 1, source, controller, v )
	else
		exports['NGMessages']:sendClientMessage ( "This player doesn't have enough money to pay you.", source, 255, 0, 0 )
	end
end )

addEvent ( "NGJobs:Mech_OnClientAcceptFixing", true )
addEventHandler ( "NGJobs:Mech_OnClientAcceptFixing", root, function ( fixer )
	local v = getPedOccupiedVehicle ( source )
	
	if ( isTimer ( timer[v] ) ) then
		killTimer ( timer[v] )
	end
	
	if ( isElement ( v ) and isElement ( fixer ) ) then
		exports['NGMessages']:sendClientMessage ( "Your vehicle is beginning repairs by "..getPlayerName ( fixer )..".", source, 0, 255, 0 )
		exports['NGMessages']:sendClientMessage ( "Beginning repairs...", fixer, 0, 255, 0 )
		triggerClientEvent ( fixer, "NGMessages:Mechanic_OpenLoadingBar", fixer, source )
		setVehicleDoorOpenRatio ( v, 0, 1 )
	else
		exports['NGMessages']:sendClientMessage ( "Failed!", source, 255, 0, 0 )
		if ( isElement ( v ) ) then
			setElementFrozen ( v, false )
		end if ( isElement ( fixer ) ) then
			setElementFrozen ( fixer, false )
			showCursor ( fixer, false )
		end
		
		showCursor ( source, false )
		vehiclesBeingFixed[v] = nil
	end
end )

addEvent ( "NGJobs:Mech_OnClientDenyFixing", true )
addEventHandler ( "NGJobs:Mech_OnClientDenyFixing", root, function ( f )
	setElementFrozen ( source, false )
	setElementFrozen ( f, false )
	showCursor ( source, false )
	showCursor ( f, false )
	local car = getPedOccupiedVehicle ( source )
	if ( isElement ( car ) ) then
		setElementFrozen ( car, false )
		vehiclesBeingFixed[car] = nil
	end
	exports['NGMessages']:sendClientMessage ( getPlayerName ( source ).." has denied you to fix their vehicle.", f, 255, 0, 0 )
	exports['NGMessages']:sendClientMessage ( "You denied "..getPlayerName ( f ).." to fix your vehicle.", source, 255, 255, 0 )
	if ( isTimer ( timer[car] ) ) then
		killTimer ( timer[car] )
	end
	triggerClientEvent ( f, 'NGJobs:Mechanic_onDenied', f )
end )

addEvent ( "NGJobs:Mechanic_onVehicleCompleteFinish", true )
addEventHandler ( "NGJobs:Mechanic_onVehicleCompleteFinish", root, function ( p )
	-- p = client being fixed
	if ( isElement ( p ) ) then
		local car = getPedOccupiedVehicle ( p )
		if ( isElement ( car ) ) then
			local price = (1000-(math.floor(getElementHealth(car))))
			fixVehicle ( car )
			local rx, ry, rz = getElementRotation ( car )
			setElementRotation ( car, rx, 0, rz )
			takePlayerMoney ( p, price )
			givePlayerMoney ( source, price )
			exports['NGMessages']:sendClientMessage ( "Your vehicle has been fixed for $"..tostring ( price ).."!", p, 0, 255, 0 )
			exports['NGMessages']:sendClientMessage ( "You fixed "..getPlayerName ( p ).."'s vehicle and earned $"..tostring ( price ), source, 0, 255, 0 )
			mechanic_reset ( p, source, car )
			updateJobColumn ( getAccountName ( getPlayerAccount ( source ) ), "FixedVehicles", "AddOne" )
		else
			exports['NGMessages']:sendClientMessage ( "Failed to fix the vehicle - the vehicle doesn't exist.", source, 255, 0, 0 )
			mechanic_reset ( p, source, car )
		end
	else
		exports['NGMessages']:sendClientMessage ( "Failed to fix the vehicle - the client doesn't exist.", source, 255, 0, 0 )
		mechanic_reset ( p, source, car )
	end
end )

function mechanic_reset ( p, s, car )
	if ( isElement ( p ) ) then
		showCursor ( p, false )
		setElementFrozen ( p, false )
	end
	
	if ( isElement ( s ) ) then
		showCursor ( s, false )
		setElementFrozen ( s, false )
	end
	
	if ( isElement ( car ) ) then
		setElementFrozen ( car, false )
		vehiclesBeingFixed[car] = nil
	end
	
end



-- Turn off lights and close doors
-- of vehicle being towed
addEventHandler ( "onTrailerAttach", root, function ( t )
	if ( getVehicleName ( t ) == "Towtruck" ) then
		setVehicleOverrideLights ( source, 1 );
		for i = 0, 5 do 
			setVehicleDoorState ( source, i, 0 )
		end
	end 
end );