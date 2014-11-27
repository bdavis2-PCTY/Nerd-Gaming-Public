addCommandHandler ( "redirectplayer", function ( p, _, p2 )
	if ( isPlayerStaff ( p ) and getPlayerStaffLevel ( p, 'int' ) >= 4 ) then
		if p2 then
			local p2x = getPlayerFromName ( p2 )
			if p2x then
				redirectPlayer ( p2x, "184.99.104.252", getServerPort ( ) )
				outputChatBox ( p2.." has been reconnected!", p, 0, 255, 0 )
			else
				outputChatBox ( p2.." isn't on the server.", p, 255, 0, 0 )
			end
		end
	end
end )