addCommandHandler ( "lock", function ( p )
	local acc = getPlayerAccount ( p )
	if ( isGuestAccount ( acc ) ) then
		return exports['NGMessages']:sendClientMessage ( "Please login to use this command.", p, 255, 0, 0 )
	end
	
	local acc = getAccountName ( acc )
	local x, y, z = getElementPosition ( p )
	for i, v in pairs ( vehicles ) do 
		if ( getElementData ( v, "NGVehicles:VehicleAccountOwner" ) == acc ) then 
			local dist = getDistanceBetweenPoints3D ( x, y, z, getElementPosition ( v ) )
			if ( dist <= 30 ) then
				setVehicleOverrideLights ( v, 2 )
				triggerClientEvent ( root, "NVehicles:playLockSoundOnVehicle", root, v )
				local locked = isVehicleLocked ( v )
				setVehicleLocked ( v, not locked )
				local name = getVehicleNameFromModel ( getElementModel ( v ) )
				if locked then
					exports['NGMessages']:sendClientMessage ( "You have unlocked your "..name, p, 0, 255, 0 )
					exports['NGLogs']:outputActionLog ( getPlayerName ( p ).." unlocked their "..name )
				else
					exports['NGMessages']:sendClientMessage ( "You have locked your "..name, p, 255, 255, 0 )
					exports['NGLogs']:outputActionLog ( getPlayerName ( p ).." locked their "..name )
				end
				setTimer ( function ( v )
					setVehicleOverrideLights ( v, 1 )
					
					setTimer ( function ( v )
						setVehicleOverrideLights ( v, 2 )
						triggerClientEvent ( root, "NVehicles:playLockSoundOnVehicle", root, v )
						setTimer ( function ( v )
							setVehicleOverrideLights ( v, 1 )
						end, 300, 1, v )
						
					end, 300, 1, v )
					
				end, 300, 1, v )
				return true, not locked
			end
		end
	end
	exports['NGMessages']:sendClientMessage ( "No vehicle in range.", p, 255, 255, 0 )
	return false, nil
end )