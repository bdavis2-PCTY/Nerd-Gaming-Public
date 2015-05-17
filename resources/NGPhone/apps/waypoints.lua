WaypointPage = "main"

WayPointLocs = {
	['Jobs'] = { 
		-- Los Santos
		{ "LS - Criminal 1", 1625.33, -1509.2, 13.6 },
		{ "LS - Criminal 2", 2141.6, -1733.16, 17.29 },
		{ "LS - Mechanic", 2277.06, -2359.07, 13.58 },
		{ "LS - Medic", 1178.47, -1327.87, 14.12 },
		{ "LS - Police", 1545.88, -1681.27, 13.56 },
	},
	
	
	['Locations'] = { 
		-- Los Santos
		['Los Santos'] = {
			-- { "Name", x, y, z }
			{ "Ammunation", 1366.23, -1278.39, 13.6 },
			{ "Bank", 914.4, -995.55, 38.19 },
			{ "All Saints General Hospital", 1184.45, -1322.87, 13.57 },
			{ "Jefferson Hospital", 2001, -1446.85, 13.56 },
			{ "Transfender Modshop", 1041.3, -1032.18, 32.09 },
			{ "Aircraft Modshop", 1937.03, -2302.26, 13.55 },
			{ "Lowrider Modshop", 2644.5, -2020.54, 13.55 },
			{ "Pay n' Spray", 1025.46, -1031.82, 32.02 },
			{ "Pay n' Spray", 2077.75, -1831.17, 13.38 },
			{ "Pay n' Spray", 1921.97, -2247.42, 13.55 },
			{ "Sports Car Shop (Grotti)", 551.84, -1272.28, 17.3 },
			{ "Ghetto Car Shop (Coutt And Schutz)", 551.84, -1272.28, 17.3 },
			{ "Cycle Shop", 1802.8, -1914.98, 13.4 },
			{ "Aircraft Shop", 1802.8, -1914.98, 13.4 },
		}, 
		['San Fierro'] = {
			{ "Wheel Arch Angels Modshop", -2712.92, 217.36, 4.25 },
			{ "Transfender Modshop", -1936.02, 234.95, 34.31 },
			{ "Pay n' Spray", -1904.97, 273.14, 41.05 },
			{ "Sports Car Shop", -1972.91, 286.07, 35.17 },
			{ "San Fierro Medical Center", -2661.14, 606.22, 13.86 },
		}
	},
	
	['Players'] = { },
	['Custom'] = { },
}

function appFunctions.waypoints:onPanelLoad ( )
	WaypointPage = "main"
	guiGridListClear ( pages['waypoints'].grid  )
	WayPointLocs.Custom = { }
	WayPointLocs.Players = { }
	
	for i, v in pairs ( WayPointLocs ) do
		local r = guiGridListAddRow ( pages['waypoints'].grid  )
		guiGridListSetItemText ( pages['waypoints'].grid , r, 1, tostring ( i ), false, false )
	end
	
	local waypns = fromJSON ( getSetting ( "user_waypoints" ) );
	if ( type ( waypns ) == "table" ) then 
		for i,v in pairs ( waypns ) do 
			table.insert(WayPointLocs.Custom,v);
			--outputDebugString(string.format("Loading waypoint '%s' (%s, %s, %s)",unpack(v)))
		end 
	end 
	
	for _, p in pairs ( getElementsByType ( "player" ) ) do
		if ( p ~= localPlayer ) then
			local x, y, z = getElementPosition ( p )
			table.insert(WayPointLocs.Players,{getPlayerName(p),x,y,z})
		end
	end 
end

function appFunctions.waypoints:addWaypoint ( )
	local name = guiGetText ( pages['waypoints'].add_name )
	if ( name:gsub ( " ", "" ) == "" ) then
		return exports.NGMessages:sendClientMessage ( "Invalid name", 255, 255, 0 )
	elseif ( appFunctions.waypoints:waypointExists ( name ) ) then
		return exports.NGMessages:sendClientMessage ( "A waypoint with this name already exists", 255, 255 ,0 )
	end
	
	local x, y, z = getElementPosition ( localPlayer ) 
	table.insert ( WayPointLocs.Custom, { name, x, y, z } )
	updateSetting ( "user_waypoints", toJSON ( WayPointLocs.Custom ) )
	exports.NGMessages:sendClientMessage ( "You have added the '"..tostring(name).."' waypoint!", 0, 255, 0 )
	appFunctions.waypoints:onPanelLoad ( )
	guiSetText ( pages['waypoints'].add_name, '' )
end

function appFunctions.waypoints:waypointExists ( n )
	local n = tostring ( n ):lower ( )
	for i, v in pairs ( WayPointLocs.Custom ) do
		if ( tostring ( v[1] ):lower ( ) == n ) then
			return true
		end
	end
	return false
end
