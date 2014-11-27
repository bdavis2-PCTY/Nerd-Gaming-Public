local spawners = { 
	['Free'] = { },
	['Job'] = { }
}
local spawnedVehciles = { }
function createFreeSpawner ( x, y, z, rz, sx, sy, sz )
	local i = #spawners['Free']+1
	local z = z - 1
	local sx, sy, sz = sx or x, sy or y, sz or z+1.5
	local rz = rz or 0
	spawners['Free'][i] = createMarker ( x, y, z, 'cylinder', 2, 255, 255, 255, 120 )
	setElementData ( spawners['Free'][i], "SpawnCoordinates", { sx, sy, sz, rz } )
	setElementData ( spawners['Free'][i], "NGVehicles:SpawnVehicleList", JobVehicles['Free'] )
	setElementData ( spawners['Free'][i], "NGVehicles:JobRestriction", false )
	addEventHandler ( "onMarkerHit", spawners['Free'][i], onSpawnerHit )
	return spawners['Free'][i]
end

function createJobSpawner ( job, x, y, z, colors, rz, sx, sy, sz )
	local i = #spawners['Job']+1
	local z = z - 1
	local sx, sy, sz = sx or x, sy or y, sz or z+1.5
	local rz = rz or 0
	local r, g, b = unpack ( colors )
	spawners['Job'][i] = createMarker ( x, y, z, 'cylinder', 2, r, g, b, 120 )
	setElementData ( spawners['Job'][i], "SpawnCoordinates", { sx, sy, sz, rz } )
	setElementData ( spawners['Job'][i], "NGVehicles:SpawnVehicleList", JobVehicles[job] )
	setElementData ( spawners['Job'][i], "NGVehicles:JobRestriction", tostring ( job ) )
	addEventHandler ( "onMarkerHit", spawners['Job'][i], onSpawnerHit )
	return spawners['Job'][i]
end


function onSpawnerHit ( p )
	local job = string.lower ( getElementData ( source, "NGVehicles:JobRestriction" ) or "false" )
	if ( job == 'false' ) then job = false end
	local pJob =  string.lower ( getElementData ( p, "Job" ) or "" )
	if ( job ) then
		if ( pJob ~= job ) then
			exports['NGMessages']:sendClientMessage ( "This spawner is for the "..job.." job. You're not in the "..job.." job.", p, 255, 140, 40 )
			return
		end
	end
	
	if ( getElementType ( p ) == 'player' and not isPedInVehicle ( p ) ) then
		local list = getElementData ( source, "NGVehicles:SpawnVehicleList" );
		triggerClientEvent ( p, 'NGSpawners:ShowClientSpawner', p, list, source )
		triggerEvent ( "NGSpawners:onPlayerOpenSpawner", source, p )
	end
end


addEvent ( "NGSpawners:spawnVehicle", true )
addEventHandler ( "NGSpawners:spawnVehicle", root, function ( id, x, y, z, rz, job ) 
	local c = exports['NGAntiRestart']:createPlayerVehicle ( source, id, x, y, z, rz, true, job )
end )



for i, v in pairs ( data ) do 
	if ( i == 'Free' ) then
		for k, e in ipairs ( v ) do 
			createFreeSpawner ( unpack ( e ) )
		end
	elseif ( i == 'Jobs' ) then
		for k, e in ipairs ( v ) do 
			createJobSpawner ( unpack ( e ) )
		end
	end
end

addEvent ( "NGSpawners:onPlayerOpenSpawner", true )