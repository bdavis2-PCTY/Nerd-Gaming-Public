local blockedVehicles = {
	[481] = true,
	[509] = true,
	[510] = true,
}

for i=1,49 do
	setGarageOpen ( i, true )
end

function shop_fixVehicle ( p )
	if ( getElementType ( p ) == 'player' and isPedInVehicle ( p ) ) then
		if ( getPedOccupiedVehicleSeat ( p ) == 0 ) then
			local car = getPedOccupiedVehicle ( p )
			
			if ( blockedVehicles[getElementModel(car)] ) then
				return exports['NGMessages']:sendClientMessage ( "This vehicle/bike cannot be repaired.", p, 255, 0, 0 )
			end
			
			local price = 1000-(math.floor(getElementHealth(car)))
			if ( price > 0 ) then
				if ( getPlayerMoney ( p ) >= price ) then
					setElementFrozen ( car, true )
					fadeCamera ( p, false )
					setVehicleDamageProof ( car, true )
					setTimer ( function ( car, p, price )
						exports['NGMessages']:sendClientMessage ( "Your vehicle has been fixed for $"..tostring ( price ).."!", p, 0, 255, 0 )
						takePlayerMoney ( p, price )
						fixVehicle ( car )
						fadeCamera ( p, true )
						setElementFrozen ( car, false )
						setVehicleDamageProof ( car, false )
						exports['NGLogs']:outputActionLog ( getPlayerName ( p ).." fixed their "..getVehicleNameFromModel(getElementModel(car)).." at pns for $"..tostring(price))
					end, 1200, 1, car, p, price )
				else
					exports['NGMessages']:sendClientMessage ( "You need at least $"..tostring ( price ).." to fix this vehicle.", p, 255, 0, 0 )
				end
			else
				exports['NGMessages']:sendClientMessage ( "This vehicle isn't damaged.", p, 0, 255, 0 )
			end
		end
	else
		exports['NGMessages']:sendClientMessage ( "This is to repair vehicles only.", p, 255, 0, 0 )
	end
end
addEvent ( "NGShops:Module->PNS:onClientHitShop", true )
addEventHandler ( "NGShops:Module->PNS:onClientHitShop", root, shop_fixVehicle )