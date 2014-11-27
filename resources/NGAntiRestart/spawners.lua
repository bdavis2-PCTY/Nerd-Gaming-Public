--------------------------------------
-- Player Vehicle For Spawners		--
--------------------------------------
local playerVehicles = { }
function createPlayerVehicle ( p, id, marker, warp )
	if ( isElement ( playerVehicles[p] ) ) then
		destroyElement ( playerVehicles[p] )
	end
	
	local x, y, z, rz = unpack ( getElementData ( marker, "SpawnCoordinates" ) )
	local job = getElementData ( marker, "NGVehicles:JobRestriction" ) or false
	
	playerVehicles[p] = createVehicle ( id, x, y, z, 0, 0, rz )
	exports['NGLogs']:outputActionLog ( getPlayerName ( p ).." spawned a(n) "..getVehicleNameFromModel ( id ) )
	--exports['NGJobs']:create3DText ( getPlayerName ( p ).."'s Vehicle", { 0, 0, 0.5 }, { 255, 255, 255 }, playerVehicles[p], { 7, true } )
	if ( warp and isElement ( playerVehicles[p] ) ) then
		warpPedIntoVehicle ( p, playerVehicles[p] )
	end
	
	if job then
		setElementData ( playerVehicles[p], "NGAntiRestart:VehicleJobRestriction", tostring ( job ) )
		addEventHandler ( "onVehicleStartEnter", playerVehicles[p], checkRestrictions )
	end

	return playerVehicles[p]
end 

function checkRestrictions ( p, seat )
	if ( seat == 0 ) then
		local job = string.lower ( getElementData ( source, "NGAntiRestart:VehicleJobRestriction" ) or "false" )
		local pJob = string.lower ( getElementData ( p, "Job" ) or "" )
		if ( pJob ~= job and getElementData ( p, "Job Rank" ) ~= 'Level 5' ) then
			exports['NGMessages']:sendClientMessage ( "This vehicle is restricted to the "..job.." job. You cannot enter it.", p, 255, 140, 40 )
			cancelEvent ( )
		end
	end
end

addEventHandler ( 'onPlayerQuit', root, function ( )
	if ( isElement ( playerVehicles[source] ) ) then
		destroyElement ( playerVehicles[source] )
	end
end )




addEvent ( "NGSpawners:onVehicleCreated", true )