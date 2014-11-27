local locations = {
	-- x, y, z, rotation z
	{ 1825.94, -872.12, 63, 90 },
	{ 1365.44, -640.1, 108.4, -90 },
	{ 1037.28, -724.34, 118.05, 45 },
	{ 684.22, -441.59, 16.34, 93 },
	{ 215.46, -230.01, 1.78, -90 },
	{ 513.48, -116.15, 38.16, 330 },
	{ 1105.34, -307.32, 73.69, -90 },
	
}

local vehicleModels = { 402, 411, 414, 415, 434, 440, 442, 444, 451, 455, 456, 475, 477, 489, 494, 495, 498, 499, 502, 503, 404, 506, 522 }

local crimainlTheftVehicle = nil
local criminalTheftBlip = nil
local last_i = 0
local CriminalTheftVehicleLabel = nil

function makeCriminalTheftVehicle ( )
	if ( isElement ( crimainlTheftVehicle ) ) then
		if ( getVehicleController ( crimainlTheftVehicle ) ) then return end
		destroyElement ( crimainlTheftVehicle ) 
	end  if ( isElement ( criminalTheftBlip ) ) then
		destroyElement ( criminalTheftBlip )
	end if ( isElement ( CriminalTheftVehicleLabel ) ) then
		destroyElement ( CriminalTheftVehicleLabel )
	end if ( isTimer ( CriminalVehicleTheftTimer ) ) then
		killTimer ( CriminalVehicleTheftTimer )
	end

	local i = math.random ( #locations )
	if ( i == last_i  ) then
		while ( i == last_i ) do
			i = math.random ( #locations )
		end
	end
	
	local data = locations[i]
	local carModel = vehicleModels[math.random ( #vehicleModels )]
	crimainlTheftVehicle  = createVehicle ( carModel, data[1], data[2], data[3], 0, 0, data[4] )
	CriminalTheftVehicleLabel = create3DText ( "Criminal Theft Vehicle", { 0, 0, 1 }, { 255, 0, 0 }, crimainlTheftVehicle )
	criminalTheftBlip = createBlipAttachedTo ( crimainlTheftVehicle, 56 )
	addEventHandler ( "onVehicleStartEnter", crimainlTheftVehicle, function ( p, seat ) if ( seat == 0 ) then if ( not getPlayerTeam ( p ) or getTeamName ( getPlayerTeam ( p ) ) ~= "Criminals" ) then cancelEvent ( ) exports['NGMessages']:sendClientMessage ( "You cannot enter this vehicle.", p, 255, 0, 0 ) end	 end end )
	addEventHandler ( 'onVehicleEnter', crimainlTheftVehicle, function ( p, seat ) if ( seat == 0 ) then outputTeamMessage ( getPlayerName ( p ).." has entered the "..getVehicleNameFromModel ( getElementModel ( source ) ).."!", "Criminals", 255, 255, 0 ) exports['NGMessages']:sendClientMessage ( "Take this vehicle to an avalible drop off point; The checkered flags on your map.", p, 0, 255, 0 ) triggerClientEvent ( p, 'NGJobs:Criminal:Theft:setWaypointsVisible', p, true ) end end )
	addEventHandler ( 'onVehicleExit', crimainlTheftVehicle, function ( p, seat ) if ( seat == 0 ) then outputTeamMessage ( getPlayerName ( p ).." has left the vehicle!", "Criminals", 0, 255, 0 ) triggerClientEvent ( p, "NGJobs:Criminal:Theft:setWaypointsVisible", p, false ) end end )
	addEventHandler ( 'onVehicleExplode', crimainlTheftVehicle, function ( ) if ( isElement ( criminalTheftBlip ) ) then destroyElement ( criminalTheftBlip ) end if ( isElement ( CriminalTheftVehicleLabel ) ) then destroyElement ( CriminalTheftVehicleLabel ) end outputTeamMessage ( "The "..getVehicleNameFromModel ( getElementModel ( source ) ).." has exploded.", "Criminals", 255, 0, 0 ) if ( isElement ( crimainlTheftVehicle ) ) then destroyElement ( crimainlTheftVehicle ) end triggerClientEvent ( root, "NGJobs:Criminal:Theft:setWaypointsVisible", root, false )  if ( isTimer ( CriminalVehicleTheftTimer ) ) then killTimer ( CriminalVehicleTheftTimer ) end CriminalVehicleTheftTimer = setTimer ( makeCriminalTheftVehicle, 1000*math.random ( 200, 500 ), 1 ) end )
	
	local city = getZoneName ( data[1], data[2], data[3], true )
	local area = getZoneName ( data[1], data[2], data[3] )
	local vehName = getVehicleNameFromModel ( carModel )
	for i, v in ipairs ( getPlayersInTeam ( getTeamFromName ( "Criminals" ) ) ) do
		exports['NGMessages']:sendClientMessage ( "There is a "..vehName.." available for pickup in "..area..", "..city.."! Be the first one! (The yellow dot icon)", v, 255, 255, 0 )
	end
end

addEvent ( "NGJobs:Criminal:Theft:onPlayerCaptureVehicle", true )
addEventHandler ( "NGJobs:Criminal:Theft:onPlayerCaptureVehicle", root, function ( )
	if ( isElement ( crimainlTheftVehicle ) ) then
		destroyElement ( crimainlTheftVehicle ) 
	end  if ( isElement ( criminalTheftBlip ) ) then
		destroyElement ( criminalTheftBlip )
	end if ( isElement ( CriminalTheftVehicleLabel ) ) then
		destroyElement ( CriminalTheftVehicleLabel )
	end if ( isTimer ( CriminalVehicleTheftTimer ) ) then
		killTimer ( CriminalVehicleTheftTimer )
	end
	local cash = math.random ( 5000, 15000 )
	outputTeamMessage ( getPlayerName ( source ).." has captured the vehicle and made $"..cash, "Criminals", 255, 255, 0 )
	exports['NGMessages']:sendClientMessage ( "Nice job!", source, 0, 255, 0 )
	givePlayerMoney ( source, cash )
	updateJobColumn ( getAccountName ( getPlayerAccount ( source ) ), "CriminalActions", "AddOne" )
	CriminalVehicleTheftTimer = setTimer ( makeCriminalTheftVehicle, 1000*math.random ( 200, 500 ), 1 )
	exports['NGLogs']:outputActionLog ( getPlayerName ( source ).." captured the criminal theft vehicle" )
	giveWantedPoints ( source, math.random ( 70, 150 ) ) 
end )

setTimer ( function ( )
	makeCriminalTheftVehicle ( )
	CriminalVehicleTheftTimer = setTimer ( makeCriminalTheftVehicle, 300000, 0 )
end, 1000, 1 )
