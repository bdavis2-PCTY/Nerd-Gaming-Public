addEvent ( "AdminSystem:getPlayerStats", true )
addEventHandler ( "AdminSystem:getPlayerStats", root, function ( p )
	
	local hour, min = exports['NGPlayerFunctions']:getPlayerPlaytime ( p )
	
	local account = tostring(getAccountName(getPlayerAccount(p)))
	
	local data = { 
		{ "Player", getPlayerName(p).."\n" },
		{ "Bank Balance", "$"..tostring ( exports.NGBank:getPlayerBank ( p ) ) },
		{ "Current Balance", "$"..tostring ( getPlayerMoney(p) ) },
		{ "Playtime", hour.." hours, "..min.." minutes" },
		{ "Job", tostring(getElementData(p,"Job")) },
		{ "Owned Vehicles", tostring(#exports.NGVehicles:getAllAccountVehicles(account) or 0) },
	}
	
	triggerClientEvent ( source, "AdminSystem:onServerSendClientStats", source, p, data )
end )