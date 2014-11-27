function loadShops ( )
	for i, v in pairs ( shopLocations ) do 
		for k, e in ipairs ( v ) do 
			local x, y, z, _ = unpack ( e )
			local m = createMarker ( x, y, z -1, 'cylinder', 2, 255, 255, 0, 255 )
			setElementData ( m, 'NGVehicles:ShopType', i )
			setElementData ( m, 'NGVehicles:CameraView', e[4] )
			setElementData ( m, 'NGVehicles:SpawnPosition', e[5] )
			addEventHandler ( "onMarkerHit", m, function ( p )
				if ( getElementType ( p ) == 'player' and not isPedInVehicle ( p ) ) then
					local t = getElementData ( source, 'NGVehicles:ShopType' )
					local vx, vy, vz, px, py, pz = unpack ( getElementData ( source, 'NGVehicles:CameraView' ) ) 
					triggerClientEvent ( p, 'NGVehicles:openClientShop', p, vehicleList[t], { px, py, pz }, getElementData ( source, "NGVehicles:SpawnPosition" ) )
					setCameraMatrix ( p, vx, vy, vz, px, py, pz )
					
				end
			end )
			
		end
	end
end

addEvent ( "NGVehicles:onClientBuyVehicle", true )
addEventHandler ( "NGVehicles:onClientBuyVehicle", root, function ( id, price, spawn, colors ) 
	takePlayerMoney ( source, price )
	local vID = givePlayerVehicle ( source, id, unpack ( colors ) )
	local car = showVehicle ( vID, true )
	local x, y, z, rz = unpack ( spawn )
	setElementPosition ( car, x, y, z )
	setElementRotation ( car, 0, 0, rz )
	warpPedIntoVehicle ( source, car )
	setElementData ( car, "fuel", 100 )
end )

loadShops ( )