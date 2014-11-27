local fuelPrice = math.random ( 1, 7 )
exports.NGMessages:sendClientMessage ( "Fuel prices are now $"..tostring(fuelPrice).."/gallon!", root, 255, 255, 0 )
--setTimer ( triggerClientEvent, 500, 1, root, "NGVehicles:Fuel:OnFuelPriceChange", root, fuelPrice )

addEvent ( "NGVehicles:Fuel:OnClientRequestFuelPrice", true )
addEventHandler ( "NGVehicles:Fuel:OnClientRequestFuelPrice", root, function ( )
	triggerClientEvent ( source, "NGVehicles:Fuel:OnFuelPriceChange", source, fuelPrice )
end )

setTimer ( function ( )
	local _fuelPrice = math.random ( 1, 7 )
	while ( fuelPrice == _fulePrice ) do
		_fuelPrice = math.random ( 1, 7 )
	end
	fuelPrice = _fuelPrice
	exports.NGMessages:sendClientMessage ( "Fuel prices are now $"..tostring(fuelPrice).."/gallon!", root, 255, 255, 0 )
	triggerClientEvent ( root, "NGVehicles:Fuel:OnFuelPriceChange", root, fuelPrice )
end, 700000, 0 )

local warnings = {
	[20]=true,
	[15]=true,
	[10]=true,
	[7]=true,
	[5]=true,
	[2]=true,
}

setTimer ( function ( ) 
	for i, v in ipairs ( getElementsByType ( 'vehicle' ) ) do 
		local fuel = getElementData ( v, "fuel" )
		if not fuel then
			setElementData ( v, "fuel", 75 )
			fuel = 75
		end
		
		local speed = getVehicleSpeed ( v, "kph" )
		if ( fuel >= 1 and speed > 0 and getVehicleOccupant ( v ) ) then
			setElementData ( v, "fuel", fuel - 1 )
			local fuel = fuel - 1
			if ( warnings[fuel] ) then
				exports['NGMessages']:sendClientMessage ( "Warning, your fuel is getting low, it's at "..tostring(fuel).."%", getVehicleOccupant ( v ), 255, 0, 0 )
			end
		end
		
	end
end, 15000, 0 )


function getVehicleSpeed ( tp, md )
	local md = md or "kph"
	local sx, sy, sz = getElementVelocity ( tp )
	local speed = math.ceil( ( ( sx^2 + sy^2 + sz^2 ) ^ ( 0.5 ) ) * 161 )
	local speed1 = math.ceil( ( ( ( sx^2 + sy^2 + sz^2 ) ^ ( 0.5 ) ) * 161 ) / 1.61 )
	if ( md == "kph" ) then
		return speed;
	else
		return speed1;
	end
end


addEvent ( "NGFuel:takeMoney", true )
addEventHandler ( "NGFuel:takeMoney", root, function ( p )
	takePlayerMoney ( source, p )
end )