addCommandHandler ( "bans", function ( p )
	if ( exports.NGAdministration:getPlayerStaffLevel ( p, 'int' ) >= 4 ) then
		
		triggerClientEvent ( p, "NGBans->Administrative->onPlayerOpenUnbanMenu", p, bans );
		
	end 
end );



addEvent ( "NGBans->Administrative->onClientRequestPlayerUnban", true )
addEventHandler ( "NGBans->Administrative->onClientRequestPlayerUnban", root, function ( serial )
	
	local i = bans [ serial ];
	
	if ( not i ) then
		exports.ngmessages:sendClientMessage ( "Something went wrong, this player isn't banned...", source, 200, 50, 50 );
		triggerClientEvent ( p, "NGBans->Administrative->onPlayerOpenUnbanMenu", p, bans );
		return false;
	end 
	
	exports.nglogs:outputServerLog ( string.format ( "%s (%s) has unbanned %s (SERIAL: %s | IP: %s)", getPlayerName(source), getAccountName(getPlayerAccount(source)), i.account, serial, i.ip ) );
	
	bans [ serial ] = nil
	
	triggerClientEvent ( source, "NGBans->Administrative->onPlayerOpenUnbanMenu", source, bans );
	
end );