local pilot = { }

local paths = {
	main = { 
		{ 1848.36, -2416.57, 13.55 },
		{ 1603.27, 1604.38, 10.82 },
		{ 369.06, 2538.43, 16.62 },
		{ -1274.43, -157.23, 14.15 },
	},
	
	extra = { 
		{ -729.39, -170.51, 65.82 },
		{ -1426.05, 501.51, 18.23  },
		{ -1532.31, 1030.19, 25.32 },
		{ -870.73, 1765.54, 87.98 },
		{ -780.03, 2435.35, 157.1 },
		{ 2068.11, 1603.76, 10.68 },
		{ 1927.86, 703.53, 16.05 }
	}
}



local flightPath = nil
function pilot.createFlightPath ( )
	pilot.destroyFlightPath ( )
	flightPath = { }
	flightPath.elements = { }
	
	local x, y, z = unpack ( paths.main [ math.random ( #paths.main ) ] )
	local px, py, pz = getElementPosition ( localPlayer )
	while ( getZoneName ( x, y, z, true ) == getZoneName ( px, py, pz, true ) ) do
		x, y, z = unpack ( paths.main [ math.random ( #paths.main ) ] )
	end
	flightPath.elements.FlightMarker = createMarker ( x, y, z - 1, "cylinder", 7, 255, 200, 0, 120 )
	flightPath.elements.FlightBlip = createBlip ( x, y, z, 5 )
	exports.NGMessages:sendClientMessage ( "You have been assigned a flight from "..getZoneName(px,py,pz,true).." to "..getZoneName(x,y,z)..", "..getZoneName(x,y,z,true).."! ("..math.floor(getDistanceBetweenPoints2D(px,py,x,y)).." meters)", 0, 255, 0 )
	addEventHandler ( "onClientMarkerHit", flightPath.elements.FlightMarker, function ( p )
		if ( p == localPlayer and isPedInVehicle ( p ) ) then
			local c = getPedOccupiedVehicle ( p )
			if ( getVehicleType ( c ) ~= "Plane" ) then return end
			if ( getElementData ( c, "NGAntiRestart:VehicleJobRestriction" ) == nil ) then return end
			if ( getVehicleController ( c ) ~= p ) then return end
			if ( pilot.VehicleSpeed ( c ) > 10 ) then return exports.NGMessages:sendClientMessage("Enter the marker at a slower pace.",255,0,0) end
			pilot.destroyFlightPath ( )
			local m = math.random ( 1000, 4000 )
			triggerServerEvent ( "NGJobs->GivePlayerMoney", localPlayer, localPlayer, m, "You were paid $"..tostring(m).." for completing the flight path!" )
			triggerServerEvent ( "NGJobs->SQL->UpdateColumn", localPlayer, localPlayer, "completeflights", "AddOne" )
		end
	end )
	
	if ( pilot.ShouldiGetaGoodPoint ( ) ) then
		exports.NGMessages:sendClientMessage ( "There is now a flashing blip on your radar. If you deliver the passenger here, he'll give you $4500!", 150, 150, 150 )
		local x, y, z = unpack ( paths.extra [ math.random ( #paths.extra ) ] )
		flightPath.elements.FlightMarkerExtra = createMarker ( x, y, z - 1, "cylinder", 4, 0, 0, 200, 150 )
		flightPath.elements.FlightBlipExtra = createBlip ( x, y, z, 5 )
		BlipBlinkTimer = setTimer ( function ( )
			if ( not isElement ( flightPath.elements.FlightMarkerExtra ) ) then
				killTimer ( BlipBlinkTimer )
				if ( isElement ( flightPath.elements.FlightBlipExtra ) ) then
					destroyElement ( lightPath.elements.FlightBlipExtra )
					flightPath.elements.FlightBlipExtra = nil
				end
			end
			
			if ( isElement( flightPath.elements.FlightBlipExtra ) ) then
				destroyElement ( flightPath.elements.FlightBlipExtra )
				flightPath.elements.FlightBlipExtra = nil
			else
				local x, y, z = getElementPosition ( flightPath.elements.FlightMarkerExtra )
				flightPath.elements.FlightBlipExtra = createBlip ( x, y, z, 5 )
			end
		end, 700, 0 )
		
		
		addEventHandler ( "onClientMarkerHit", flightPath.elements.FlightMarkerExtra, function ( p )
			if ( p == localPlayer and isPedInVehicle ( p ) ) then
				local c = getPedOccupiedVehicle ( p )
				if ( getVehicleType ( c ) ~= "Plane" ) then return end
				if ( getElementData ( c, "NGAntiRestart:VehicleJobRestriction" ) == nil ) then return end
				if ( getVehicleController ( c ) ~= p ) then return end
				if ( pilot.VehicleSpeed ( c ) > 10 ) then return exports.NGMessages:sendClientMessage("Enter the marker at a slower pace.",255,0,0) end
				pilot.destroyFlightPath ( )
				local m = 4500
				triggerServerEvent ( "NGJobs->GivePlayerMoney", localPlayer, localPlayer, m, "You were paid $"..tostring(m).." for completing the flight path!" )
				triggerServerEvent ( "NGJobs->SQL->UpdateColumn", localPlayer, localPlayer, "completeflights", "AddOne" )
			end
		end )
	end
end 

function pilot.destroyFlightPath ( )
	if ( flightPath ) then
		for i, v in pairs ( flightPath.elements ) do
			if ( isElement ( v ) ) then
				destroyElement ( v )
			end
		end
	end
	if (  isTimer ( BlipBlinkTimer ) ) then 
		killTimer ( BlipBlinkTimer )
	end
	flightPath = nil
end

setTimer ( function ( )
	if ( getElementData ( localPlayer, "Job" ) == "Pilot" and not isPedInVehicle ( localPlayer ) ) then
		pilot.destroyFlightPath ( )
	elseif ( getElementData ( localPlayer, "Job" ) == "Pilot" and isPedInVehicle ( localPlayer ) ) then
		if ( not flightPath ) then
			local c = getPedOccupiedVehicle ( localPlayer ) 
			if ( getVehicleType ( c ) == "Plane" and getElementData ( c, "NGAntiRestart:VehicleJobRestriction" ) ~= nil ) then
				pilot.createFlightPath ( )
			end
		end
	end
end, 5000, 0 )

function getZoneShortName ( zone )	-- Incomplete function
	local zone = tostring ( zone ):lower ( )
	if ( zone == "Las Venturas" or zone == "Bone County" or zone == "Tierra Robada" ) then
		return "LV"
	elseif ( zone == "San Fierro" ) then
		return "SF"
	end
end

function pilot.ShouldiGetaGoodPoint ( )
	local n = math.random ( 0, 100 )
	return n >= 95
end

function pilot.VehicleSpeed (v )
	return exports.NGVehicles:getVehicleSpeed ( v, "mph" )
end




----------------------
-- F5 Panel			--
----------------------
pilotGui = { }
function createPilotInterface ( )
	if ( isElement ( pilotGui.window ) ) then 
		removeEventHandler ( "onClientGUIClick", pilotGui.close, createPilotInterface );
		destroyElement ( pilotGui.window );
		pilotGui.window = false;
		showCursor ( false );
		return
	end 
	
	local job = getElementData ( localPlayer, "Job" ) or "";
	if ( job ~= "Pilot" ) then return false; end
	
	pilotGui.window = guiCreateWindow( ( sx / 2 - 471 / 2 ), ( sy / 2 - 330 / 2 ), 471, 330, "Pilot", false)
	guiWindowSetSizable(pilotGui.window, false)
	pilotGui.close = guiCreateButton(353, 295, 108, 25, "Close", false, pilotGui.window)
	pilotGui.username = guiCreateLabel(10, 34, 437, 18, "Username: ".. tostring ( getElementData ( localPlayer, "AccountData:Username" ) ), false, pilotGui.window)
	pilotGui.job = guiCreateLabel(10, 62, 437, 18, "Job: "..tostring ( getElementData ( localPlayer, "Job" ) ), false, pilotGui.window)
	pilotGui.completedFlights = guiCreateLabel(10, 118, 437, 18, "Flights: Loading...", false, pilotGui.window)
	pilotGui.jobRank = guiCreateLabel(10, 90, 437, 18, "Job Rank: "..tostring ( getElementData ( localPlayer, "Job Rank" ) ), false, pilotGui.window)
	pilotGui.nextRank  = guiCreateLabel(10, 146, 437, 18, "Next Rank: Loading || Loading", false, pilotGui.window)
	pilotGui.jobDesc = guiCreateMemo(12, 187, 449, 98, jobDescriptions['pilot'], false, pilotGui.window)
	triggerServerEvent ( "NGJobs->Module->Job->Pilot->OnClientRequestF5Data", localPlayer );
	showCursor ( true );
	addEventHandler ( "onClientGUIClick", pilotGui.close, createPilotInterface );
end

addEvent ( "NGJobs->Module->Job->Pilot->onServerSendClientJobInfo", true );
addEventHandler ( "NGJobs->Module->Job->Pilot->onServerSendClientJobInfo", root, function ( data )
	if ( not isElement ( pilotGui.window ) ) then return false; end 
	
	guiSetText ( pilotGui.completedFlights, "Flights: "..tostring ( data.flights ) );
	guiSetText ( pilotGui.nextRank, "Next Rank: "..tostring ( data.nextRank ).. " | Requires "..tostring(data.requiredFlights).." more flights");
	
end );

bindKey ( "f5", "down", createPilotInterface );
