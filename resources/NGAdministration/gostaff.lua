addCommandHandler ( "staff", function ( p )
	if ( isPlayerStaff ( p ) ) then
		local st, lvl = getPlayerStaffLevel ( p, 'both' )
		if ( lvl >= 2 ) then
			setElementModel ( p, 217 )
		else
			setElementModel ( p, 216 )
		end
		setElementData ( p, "Job", "Staff" )
		setElementData ( p, "Job Rank", tostring ( st ) )
		exports['NGPlayerFunctions']:setTeam ( p, 'Staff' )
		exports['NGMessages']:sendClientMessage ( "Now in staff mode!", p, 0, 255, 0 )
		exports['NGlogs']:outputActionLog ( getPlayerName ( p ).." is now in staff mode" )
	end
end )
