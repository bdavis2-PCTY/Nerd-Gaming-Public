-- NGJobs:Criminal:Theft:setWaypointsVisible


local waypoints = {
	{ 1597.08, -1551.65, 13.59},
	{ 2733.43, -1842.82, 9.97 },
	{ 748.28, -1343.59, 13.52 },
}
local waypoint = { blip = { }, marker = { } }
addEvent ( "NGJobs:Criminal:Theft:setWaypointsVisible", true )
addEventHandler ( "NGJobs:Criminal:Theft:setWaypointsVisible", root, function ( s )
	if ( s ) then
		for i, v in pairs ( waypoint ) do 
			for k, e in pairs ( v ) do 
				destroyElement ( e )
			end
		end
		waypoint = { blip = { }, marker = { } }
		for i, v in ipairs ( waypoints ) do
			local x, y, z = unpack ( v )
			waypoint.blip[i] = createBlip ( x, y, z, 53 )
			waypoint.marker[i] = createMarker ( x, y, z-1.3, "cylinder", 5, 255, 255, 0, 120 )
			addEventHandler ( 'onClientMarkerHit', waypoint.marker[i], CriminalVehicleTheftCapture )
		end
	else
		for i, v in pairs ( waypoint ) do 
			for k, e in pairs ( v ) do 
				destroyElement ( e )
			end
		end
		waypoint = { blip = { }, marker = { } }
	end
end )

function CriminalVehicleTheftCapture ( p )
	if ( p  and p == localPlayer and isPedInVehicle ( p ) ) then
		for i, v in pairs ( waypoint ) do 
			for k, e in pairs ( v ) do 
				destroyElement ( e )
			end
		end
		waypoint = { blip = { }, marker = { } }
		triggerServerEvent ( "NGJobs:Criminal:Theft:onPlayerCaptureVehicle", localPlayer )
	end
end
