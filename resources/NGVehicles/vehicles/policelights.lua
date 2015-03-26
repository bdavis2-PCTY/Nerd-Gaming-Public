local emergencyVehicles = {
	[416] = true, [433] = true, [427] = true,
	[490] = true, [528] = true, [407] = true,
	[544] = true, [523] = true, [470] = true,
	[598] = true, [596] = true, [597] = true,
	[599] = true, [432] = true, [601] = true,
	[428] = true,
}

local serviceVehicles = {
	[525] = true, [524] = true, [443] = true,
	[552] = true, [578] = true, [408] = true,
	[455] = true,
}

local t = getTickCount ( )
addEventHandler ( "onClientRender", root, function ( )
	if ( getTickCount ( ) - t >= 500 ) then
		t = getTickCount ( )
		for i, v in ipairs ( getElementsByType ( 'vehicle' ) ) do
			local tp = nil
			local id = getElementModel ( v )
			if ( serviceVehicles[id] ) then
				tp = "service"
			elseif ( emergencyVehicles[id] ) then
				tp = "emergency"
			end
			
			if ( tp ) then
				if ( tp == "emergency" ) then
					if ( getVehicleSirensOn ( v ) ) then
						setElementData ( v, "NGVehicles:isCustomSirensEnabled", true, false )
						local lM = getElementData ( v, "NGVehicles:lightState" ) or 0
						setVehicleOverrideLights ( v, 2 )
						if ( lM == 0 ) then
							setElementData ( v, "NGVehicles:lightState", 1, false )
							setVehicleLightState ( v, 0, 0 )
							setVehicleLightState ( v, 3, 0 )
							setVehicleLightState ( v, 1, 1 )
							setVehicleLightState ( v, 2, 1 )
							setVehicleHeadLightColor ( v, 0, 255, 0 )
						else
							setElementData ( v, "NGVehicles:lightState", 0, false )
							setVehicleLightState ( v, 0, 1 )
							setVehicleLightState ( v, 3, 1 )
							setVehicleLightState ( v, 1, 0 )
							setVehicleLightState ( v, 2, 0 )
							setVehicleHeadLightColor ( v, 255, 255, 0 )
						end
					else
						setElementData ( v, "NGVehicles:isCustomSirensEnabled", false, false )
						setVehicleHeadLightColor ( v, 255, 255, 255 )
						setVehicleLightState ( v, 0, 0 )
						setVehicleLightState ( v, 3, 0 )
						setVehicleLightState ( v, 1, 0 )
						setVehicleLightState ( v, 2, 0 )
					end
				else
					if ( getElementData ( v, 'NGVehicles:customLights' ) ) then
						local lM = getElementData ( v, "NGVehicles:lightState" ) or 0
						setVehicleOverrideLights ( v, 2 )
						if ( getVehicleTowedByVehicle ( v ) ) then setVehicleOverrideLights ( getVehicleTowedByVehicle ( v ), 2 ) end
						if ( lM == 0 ) then
							setElementData ( v, "NGVehicles:lightState", 1, false )
							setVehicleLightState ( v, 0, 0 )
							setVehicleLightState ( v, 3, 0 )
							setVehicleLightState ( v, 1, 1 )
							setVehicleLightState ( v, 2, 1 )
							setVehicleHeadLightColor ( v, 255, 255, 0 )
						else
							setElementData ( v, "NGVehicles:lightState", 0, false )
							setVehicleLightState ( v, 0, 1 )
							setVehicleLightState ( v, 3, 1 )
							setVehicleLightState ( v, 1, 0 )
							setVehicleLightState ( v, 2, 0 )
							setVehicleHeadLightColor ( v, 255, 255, 0 )
						end
					else
						setVehicleHeadLightColor ( v, 255, 255, 255 )
						setVehicleLightState ( v, 0, 0 )
						setVehicleLightState ( v, 3, 0 )
						setVehicleLightState ( v, 1, 0 )
						setVehicleLightState ( v, 2, 0 )
					end
				end
			end
		end
	end
end )

bindKey ( 'horn', 'down', function ( )
	local car = getPedOccupiedVehicle ( localPlayer )
	if ( car and getVehicleController ( car ) == localPlayer and serviceVehicles[getElementModel(car)] ) then
		local stat = getElementData ( car, 'NGVehicles:customLights' ) or false
		setElementData ( car, 'NGVehicles:customLights', not stat )
		if stat then
			exports['NGMessages']:sendClientMessage ( "Lights off!", 255, 255, 0 )
			setElementData ( car, 'NGVehicles:lightState', 0 )
		else
			exports['NGMessages']:sendClientMessage ( "Lights on!", 0, 255, 255 )
		end
	end
end )

addEventHandler ( "onClientPlayerVehicleEnter", root, function ( veh, seat )
	if ( source == localPlayer and seat == 0 and serviceVehicles[getElementModel(veh)] ) then
		exports['NGMessages']:sendClientMessage ( "This vehicle has custom alert lights! Use the horn to activate/deactivate them.", 0, 255, 0 )
	end
end )