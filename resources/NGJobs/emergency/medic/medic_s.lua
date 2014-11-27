addEvent ( "NGJobs:Medic.onPlayerHealPlayer", true )
addEventHandler ( "NGJobs:Medic.onPlayerHealPlayer", root, function ( client, medic ) 
	if ( getElementHealth ( client ) >= 95 ) then
		setElementHealth ( client, 100 )
		return exports['NGMessages']:sendClientMessage ( "This player doesn't need healing.", medic, 255, 0, 0 )
	end
	if ( getElementHealth ( client ) < 100 ) then
		setElementHealth ( client, getElementHealth ( client ) + 10 )
		if ( getElementHealth ( client ) >= 100 ) then
			setElementHealth ( client, 100 )
			givePlayerMoney ( medic, 50 )
			updateJobColumn ( getAccountName ( getPlayerAccount ( medic ) ), "HealedPlayers", "AddOne" )
		end
	end
end )