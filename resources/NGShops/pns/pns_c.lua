local shops = {
	{ 2064.78, -1831.55, 13.55 },
	{ 1921.63, -2243.18, 13.55 },
	{ 1024.84, -1023.4, 32.1 },
	{ 157.49, -22.02, 1.58},
	{ 487.41, -1741.73, 11.13 },
	{ -1349.63, -234.77, 14.15 },
	{ -1904.95, 283.94, 41.05 },
	{ -2425.24, 1022.06, 50.4 },
	{ 1976.65, 2162.53, 11.07 },
	{ -99.77, 1120.9, 19.74 },
	{ 1333.63, 1584.72, 10.82 },
	{ 384.31, 2538.77, 16.54 },
}

local pnsBlips = { }
setTimer ( function ( )
	local createBlips = exports['NGPhone']:getSetting ( "usersetting_display_createpnsblips" )
	for i, v in ipairs ( shops ) do
		local x, y, z = unpack ( v )
		local z = z - 3
		addEventHandler ( 'onClientMarkerHit', createMarker ( x, y, z, 'cylinder', 5, 0, 255, 0, 140 ), function ( p ) 
			if ( p == localPlayer ) then
				triggerServerEvent ( "NGShops:Module->PNS:onClientHitShop", localPlayer, localPlayer )
			end
		end )
		if ( createBlips ) then 
			pnsBlips[i] = createBlip ( x, y, z, 63, 2, 255, 255, 255, 255, 0, 450 ) 
		end
	end
end, 500, 1 )


addEvent ( "onClientUserSettingChange", true )
addEventHandler ( "onClientUserSettingChange", root, function ( g, v )
	if ( g == "usersetting_display_createpnsblips" ) then
		for i, v in pairs ( pnsBlips ) do
			destroyElement ( pnsBlips [ i ] )
			pnsBlips [ i ] = nil
		end
		
		if v then
			for i, v2 in pairs ( shops ) do
				local x, y, z= unpack ( v2 )
				pnsBlips[i] = createBlip ( x, y, z, 63, 2, 255, 255, 255, 255, 0, 450 ) 
			end
		end
	end
end )