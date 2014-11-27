local max_time = 5		-- Minutes

setTimer ( function ( )
	local max_milsecs = ( max_time * 60 ) * 1000
	for i, v in pairs ( getElementsByType ( "player" ) ) do
		if ( not exports.NGAdministration:isPlayerStaff ( v ) ) then
			local idle = getPlayerIdleTime ( v )
			if ( idle > max_milsecs ) then
				kickPlayer ( v, "You were detected as being AFK. Join back - Nerd Gaming RPG" )
			elseif ( idle > max_milsecs ) then
				exports.NGMessages:sendClientMessage ( "Please move, you're going to be kicked in ".. math.floor ( ( max_milsecs - idle ) / 1000 ).." seconds  if you don't.", v, 255, 0, 0 ) 
			end
		end
	end
end, 5000, 0 )