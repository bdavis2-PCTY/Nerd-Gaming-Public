addEvent ( "NGDrugs:Module->LSD:givePlayerCash", true )
addEventHandler ( "NGDrugs:Module->LSD:givePlayerCash", root, function ( )
	givePlayerMoney ( source, math.random ( 50, 100 ) )
end )