local spawnProtectionTime = 18000

local hospitals = {
	-- ['name'] = { start x, start y, start z, end x, end y, end z, rot }
	['Saint General Hospital'] = { 1177.26, -1324.92, 14.06, 1205.53, -1332.19, 23, -90 },
	['County General Hospital'] = { 2029.25, -1419.17, 16.99, 1972.12, -1469.78, 35, 180 },
	['Las Venturas Hospital'] = { 1607.06, 1825.09, 10.82, 1622.59, 1855.38, 10, 0 },
	['Medical Clinic'] = { 2546.67, 1971.37, 10.82, 2566.92, 1936.79, 20, 180 },
	['Fort Carson Medical Center'] = { -320.21, 1055.96, 20, -302.87, 1072.36, 19, 0 },
	['San Fierro Medical Center'] = { -2644.37, 633.05, 14.45, -2621.81, 586.03, 23, 180 },
	['Angel Pine Medical Center'] = { -2201.14, -2292.66, 30.63, -2184.92, -2285.6, 35, 320.8 },
	['Crippen Memorial Hospital'] = { 1371.24, 406.06, 19.76, 1349.78, 401.49, 19.56, 85 },
	['El Quebrados Medical Center'] = { -1514.47, 2527.25, 55.74, -1505.11, 2549.74, 62, 0 }
}

addEvent ( "NGHospitals:onClientRequestLocations", true )
addEventHandler ( "NGHospitals:onClientRequestLocations", root, function ( )
	triggerClientEvent ( source, "NGHospitals:onServerSendClientLocRequest", source, hospitals )
end )

addEventHandler ( 'onPlayerWasted', root, function ( )
	exports['NGLogs']:outputActionLog ( getPlayerName ( source ).." died" )
	local weapons = { }
	for i=1,12 do weapons[i] = { getPedWeapon ( source, i ), getPedTotalAmmo ( source, i ) } end
	setTimer ( function ( p, weapons )
		local data = getNearestHospital ( p )
		data[9] = getElementModel ( p )
		data[10] = weapons
		triggerClientEvent ( p, 'NGHospitals:onClientWasted', p, data )
	end, 2000, 1, source, weapons )
end )

addEvent ( "NGHospitals:triggerPlayerSpawn", true )
addEventHandler ( "NGHospitals:triggerPlayerSpawn", root, function ( d )
	spawnPlayer ( source, d[2], d[3], d[4], d[8], d[9], 0, 0 )
	
	for i, v in pairs ( d[10] ) do
		giveWeapon ( source, v[1], v[2] )
	end
	setElementData ( source, "isSpawnProtectionEnabled", true )
	setElementData ( source, "isGodmodeEnabled", true )
	setElementAlpha ( source, 180 )
	toggleControl ( source, "fire", false )
	toggleControl ( source, "next_weapon", false )
	toggleControl ( source, "previous_weapon", false )
	
	setTimer ( function ( source )
		if ( not isElement ( source ) ) then return end
		outputChatBox ( "Spawn protection ending in 3...", source, 0, 255, 255 )
		setTimer ( function ( source )
			if ( not isElement ( source ) ) then return end
			outputChatBox ( "Spawn protection ending in 2...", source, 0, 255, 255 )
			setTimer ( function ( source )
				if ( not isElement ( source ) ) then return end
				outputChatBox ( "Spawn protection ending in 1...", source, 0, 255, 255 )
				setTimer ( function ( source )
					if ( not isElement ( source ) ) then return end
					outputChatBox ( "Spawn protection ended! You can now die.", source, 255, 0, 0 )
					setElementData ( source, "isGodmodeEnabled", false )
					setElementData ( source, "isSpawnProtectionEnabled", false )
					setElementAlpha ( source, 255 )
					
					toggleControl ( source, "fire", true )
					toggleControl ( source, "next_weapon", true )
					toggleControl ( source, "previous_weapon", true )
				end, 1000, 1, source )
			end, 1000, 1, source )
		end, 1000, 1, source )
	end, spawnProtectionTime-3000, 1, source )
end )

function getNearestHospital ( p )
	local dist = 9999999
	local loadedI = nil
	local data = nil
	for ind, var in pairs ( hospitals ) do
		local x, y, z = getElementPosition ( p )
		local c = getDistanceBetweenPoints3D ( x, y, z, var[1], var[2], var[3] )
		if ( c <= dist ) then
			dist = c
			loadedI = ind
			data = { ind, var[1], var[2], var[3], var[4], var[5], var[6], var[7] }
		end
	end	
	return data
end

addEventHandler ( 'onVehicleDamage', root, function ( loss )
	local driver = getVehicleOccupant ( source )
	if driver and getElementData ( driver, 'isSpawnProtectionEnabled' ) then
		setElementHealth ( source, getElementHealth ( source ) + loss )
	end
end )
