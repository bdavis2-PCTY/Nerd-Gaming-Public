function amOpenWindow ( p )
	if ( getPlayerStaffLevel ( p, 'int' ) >= 4 ) then
		local query = exports.NGSQL:db_query ( "SELECT * FROM accountdata  ORDER BY Username" )
		local accounts = { 
			valid = { },
			invalid = { }
		}
		for i, v in ipairs ( query ) do
			if ( getAccount ( v.Username ) ) then
				accounts.valid[ tostring ( v.Username ) ] = v
			else
				accounts.invalid[ v.Username] = v
				accounts.invalid[ v.Username].reason = "Account doesn't exist in server database"
			end
		end
		for i, v in ipairs ( getAccounts ( ) ) do
			local n = getAccountName ( v )
			if ( not accounts.valid [n] and not accounts.invalid[n] ) then
				accounts.invalid[n] = { }
				accounts.invalid[n].Username = n
				accounts.invalid[n].reason = "Account doesn't exist in MySQL database"
			end
		end
		triggerClientEvent ( p, "NGAdministration:AccountManager:onClientOpenWindow", p, accounts )
	end
end
addCommandHandler ( "am", amOpenWindow )

local removeAccount_ = removeAccount
-- remove account 
addEvent ( "NGAdmin:amManager:removeAccountFromHistory", true )
addEventHandler ( "NGAdmin:amManager:removeAccountFromHistory", root, function ( account )
	for i, v in ipairs ( getElementsByType ( "player" ) ) do
		if ( getAccountName ( getPlayerAccount ( v ) ) == account ) then
			return exports.NGMessages:sendClientMessage ( "You need to kick "..tostring(getPlayerName(v)).." before you can delete this account.", source, 255, 255, 0 )
		end
		removeAccount(account,source)
	end
end )


function removeAccount ( account, source )
	local user = ""
	if ( isElement ( source ) ) then
		user = getPlayerName ( source ).." ("..getAccountName(getPlayerAccount(source))..")"
	else
		user = "Console (Console)"
	end
	exports.NGSQL:db_exec ( "DELETE FROM accountdata WHERE Username=?", account )
	exports.NGSQL:db_exec ( "DELETE FROM bank_accounts WHERE Account=?", account )
	exports.NGSQL:db_exec ( "DELETE FROM bank_transactions WHERE account=?", account )
	exports.NGSQL:db_exec ( "DELETE FROM jobdata WHERE Username=?", account )
	exports.NGSQL:db_exec ( "DELETE FROM log_punish WHERE account=?", account )
	exports.NGSQL:db_exec ( "DELETE FROM user_shop WHERE seller_account=?", account )
	exports.NGSQL:db_exec ( "DELETE FROM vehicles WHERE Owner=?", account )
	local acc = getAccount ( account )
	if acc then removeAccount_ ( acc ) end
	exports.NGLogs:outputActionLog ( user.." deleted account "..tostring(account) )
	if(isElement(source))then
		amOpenWindow ( source )
	end
end

-- Execute server data saving
addEvent ( "NGAdmin:aManager:ExecuteServerSave", true )
addEventHandler ( "NGAdmin:aManager:ExecuteServerSave", root, function ( )
	exports.NGSQL:saveAllData ( true )
	exports.NGLogs:outputActionLog ( getPlayerName(source).."("..getAccountName(getPlayerAccount(source))..") saved all server data" )
end )

addEvent ( "NGAdmin:Module->aManager:OpenPanelFromSource", true )
addEventHandler ( "NGAdmin:Module->aManager:OpenPanelFromSource", root, function ( )
	amOpenWindow ( source )
end )




-- Ban accounts
addEvent ( "NGAdmin:Modules->Banner:onAdminBanClient", true )
addEventHandler ( "NGAdmin:Modules->Banner:onAdminBanClient", root, function ( acc, day, month, year, reason, days )
	local l = getPlayerName(source).." ("..getAccountName(getPlayerAccount(source)).." banned account "..tostring(acc).." for "..tostring(days).." days | reason: "..tostring(reason)
	outputDebugString ( l )
	exports.NGLogs:outputServerLog ( l )
	exports.NGLogs:outputActionLog ( l )
	exports.NGBans:banAccount ( acc, day, month, year, reason, getPlayerName(source) )
end )


-- update account vip
addEvent ( "NGAdmin->Modules->aManager->VIPManager->UpdateAccountVIP", true )
addEventHandler ( "NGAdmin->Modules->aManager->VIPManager->UpdateAccountVIP", root, function ( account, level, day, month, year )
	for i, v in pairs ( getElementsByType ( "player" ) ) do
		local a = getPlayerAccount ( v )
		if ( not isGuestAccount ( a ) and getAccountName ( a ) == account ) then
			kickPlayer ( v, "Server is giving you VIP... Please reconnect." )
			break 
		end
	end 

	setTimer ( function ( account, level, day, month, year, source )
		exports.ngsql:db_exec ( "UPDATE accountdata SET vip=?, vipexp=? WHERE Username=?", tostring ( level ), table.concat({year,month,day},"-"), account )
		exports.nglogs:outputActionLog ( getAccountName(getPlayerAccount(source)).." updated "..tostring(account).." VIP - Level: "..tostring(level).." | Exp. Date: "..table.concat({year,month,day},"-") )
	end, 250, 1, account, level, day, month, year, source)
end )