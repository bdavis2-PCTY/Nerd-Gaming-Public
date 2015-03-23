addCommandHandler ( "spawners", function ( p )
	if ( exports['NGAdministration']:isPlayerStaff ( p ) ) then
		if ( exports['NGAdministration']:getPlayerStaffLevel ( p, 'int' ) >= 3 ) then
			local f = fileOpen ( 'data.lua' )
			local data = fileRead ( f, fileGetSize ( f ) )
			fileClose ( f )
			triggerClientEvent ( p, "NGSpawners:onStaffOpenEditor", p, data )
		end
	end
end )

addEvent ( 'NGSpawners:onAdminEditSpawnerList', true )
addEventHandler ( 'NGSpawners:onAdminEditSpawnerList', root, function ( data )
	local f = fileOpen ( 'data.lua' )
	fileWrite ( f, tostring ( data ) )
	fileClose ( f  )
	exports['NGLogs']:outputActionLog ( "Spawners updated" )
	restartResource ( getThisResource ( ) ) 
end )