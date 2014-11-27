function getStatsForWebsite( )

	local pTable = { }
	for i, v in pairs ( getElementsByType ( "player" ) ) do
		local data = getAllElementData ( v )
		data.ncolor = { getPlayerNametagColor ( v ) }
		data.ping = getPlayerPing ( v )
		pTable [ getPlayerName ( v ) ] = data
	end 

    return {
    	server = getServerName ( ), 
    	password = getServerPassword ( ), 
    	online = getPlayerCount ( ),
    	players = pTable
    }
end