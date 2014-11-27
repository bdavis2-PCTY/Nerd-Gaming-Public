addEvent ( "NGPunishPanel->Modules->Punishments->RequestPlayerPunishList", true )
addEventHandler ( "NGPunishPanel->Modules->Punishments->RequestPlayerPunishList", root, function ( )

	local list = { }
	list.account = { }
	list.serial = { }

	local account = getAccountName ( getPlayerAccount ( source ) )
	local serial = getPlayerSerial ( source )

	-- account punishments
	list.account = exports.ngsql:db_query ( "SELECT * FROM log_punish WHERE account=?", account )
	list.serial = exports.ngsql:db_query ( "SELECT * FROM log_punish WHERE serial=?", serial )

	triggerClientEvent ( source, "NGPunishPanel->Modules->Punishments->OnServerSendClientPunishments", source, list)
end )