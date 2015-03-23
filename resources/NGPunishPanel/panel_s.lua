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

function outputPlayerPunishLog ( player, admin, log )
	local time = getRealTime ( );
	
	local month = time.month +1;
	if ( time.month+1 < 10 ) then
		month = 0 .. month;
	end
	
	local _time = table.concat ( { time.year + 1900, month, time.monthday }, "-" )
	
	local account = tostring ( player.account.name );
	local serial = tostring ( player.serial );
	local admin = admin or "Server"
	local log = tostring ( log );
	
	exports.ngsql:db_exec ( "INSERT INTO log_punish ( _time, account, serial, admin, log ) VALUES ( ?, ?, ?, ?, ? )",
		_time, account, serial, admin, log );
	
end



