local bankLocations = {
	-- { x, y, z, int, dim, { out x, out y, out z } },
	{ 362.3, 173.67, 1008.38, 3, 1, { 914.21, -1001.5, 38.1 } },
	{ 362.3, 173.67, 1008.38, 3, 2, { 2474.86, 1021.09, 10.82 } },
	{ 362.3, 173.67, 1008.38, 3, 3, { -1705.67, 785.32, 24.89 } },
	--{ 2478.19, 1013.93, 10.68, 0, 0, { 899.88, -984.7, 37.35 } }, -- for testing
}







local startingCash = 1000 
local accounts = { }

function doesBankAccountExist ( account )
	if ( accounts[account] ) then
		return true
	else
		return false
	end
end 

function createBankAccount ( name )
	if ( not doesBankAccountExist ( name ) ) then
		exports['NGSQL']:db_exec ( "INSERT INTO bank_accounts ( Account, Balance ) VALUES ( ?, ? )", tostring ( name ), tostring ( startingCash ) )
		accounts[tostring(name)] = tonumber ( startingCash )
		return true
	end
	return false
end 

function getBankAccounts ( )
	return acounts;
end 

function withdraw ( player, amount )
	local acc = getPlayerAccount ( player )
	if ( isGuestAccount ( acc ) ) then return false end
	local acc = getAccountName ( acc )
	if ( not doesBankAccountExist ( acc ) ) then
		createBankAccount ( acc )
	end
	accounts[acc] = accounts[acc] - amount
	givePlayerMoney ( player, amount )
	
	local today = exports.NGPlayerFunctions:getToday ( )
	local lg = getPlayerName ( player ).." withdrew $"..amount
	local serial = getPlayerSerial ( player )
	local ip = getPlayerIP ( player )
	exports.NGSQL:db_exec ( "INSERT INTO bank_transactions ( account, log, serial, ip, thetime ) VALUES ( ?, ?, ?, ?, ? )",
		acc, lg, serial, ip, today )
	
	return true
end 

function deposit ( player, ammount )
	local acc = getPlayerAccount ( player )
	if ( isGuestAccount ( acc ) ) then return false end
	local acc = getAccountName ( acc )
	if ( not doesBankAccountExist ( acc ) ) then
		createBankAccount ( acc )
	end
	takePlayerMoney ( player, amount )
	accounts[acc] = accounts[acc] + amount
	return true
end 

function getPlayerBank ( plr )
	local acc = getPlayerAccount ( plr )
	if ( isGuestAccount ( acc ) ) then return false end
	local acc = getAccountName ( acc )
	if ( not doesBankAccountExist ( acc ) ) then
		createBankAccount ( acc )
	end
	return accounts[acc]
end 

function onBankMarkerHit ( p )
	if ( p and getElementType ( p ) == 'player' and not isPedInVehicle ( p ) ) then
		if ( getElementInterior ( p ) == getElementInterior ( source ) and getElementDimension ( p ) == getElementDimension ( source )  ) then
			local acc = getPlayerAccount ( p )
			if ( isGuestAccount ( acc ) ) then return false end
			local acc = getAccountName ( acc )
			
			if ( not doesBankAccountExist ( acc ) ) then
				createBankAccount ( acc )
			end
			triggerClientEvent ( p, 'NGBank:onClientEnterBank', p, accounts[acc], acc, source )
		end
	end
end 

local bankMarkers = { }
addEventHandler ( "onResourceStart", resourceRoot, function ( )
	exports['NGSQL']:db_exec ( "CREATE TABLE IF NOT EXISTS bank_accounts ( Account TEXT, Balance INT )" )
	exports['NGSQL']:db_exec ( "CREATE TABLE IF NOT EXISTS bank_transactions ( account TEXT, log TEXT, serial TEXT, ip TEXT, thetime DATE )" )

	local q = exports['NGSQL']:db_query ( "SELECT * FROM bank_accounts" )
	for i, v in ipairs ( q ) do 
		accounts[v['Account']] = tonumber ( v['Balance'] )
	end
	
	for i, v in pairs ( bankLocations ) do
		local x, y, z, int, dim, out = unpack ( v )
		bankMarkers[i] = createMarker ( x, y, z-1, "cylinder", 3, 0, 200, 0, 100 )
		local bx, by, bz = unpack ( out )
		createBlip ( bx, by, bz, 52 )
		setElementInterior ( bankMarkers[i], int )
		setElementDimension ( bankMarkers[i], dim )
		addEventHandler ( "onMarkerHit", bankMarkers[i], onBankMarkerHit )
	end
	
	for i, v in ipairs ( getElementsByType ( 'player' ) ) do 
		local acc = getAccountName ( getPlayerAccount ( v ) )
		setElementData ( v, "NGBank:BankBalance", accounts[acc] or 0 )
	end
end ) function saveBankAccounts ( )
	if ( getResourceState ( getResourceFromName ( "NGSQL" ) ) ~= "running" ) then return end
	for i, v in pairs ( accounts ) do 
		exports['NGSQL']:db_exec ( "UPDATE bank_accounts SET Balance=? WHERE Account=?", tostring ( v ), tostring ( i ) )
	end
end 
addEventHandler ( "onResourceStop", resourceRoot, saveBankAccounts )

addEvent ( "NGBank:ModifyAccount", true )
addEventHandler ( "NGBank:ModifyAccount", root, function ( action, amount )
	local acc = getPlayerAccount ( source )
	if ( isGuestAccount ( acc ) ) then
		return exports['NGMessages']:sendClientMessage ( "Please login to use the bank system.", source, 200, 200, 200 )
	end
	
	local acc = getAccountName ( acc )
	local bankBalance = accounts[acc]
	if ( action == 'withdraw' ) then
		if ( bankBalance < amount ) then
			return exports['NGMessages']:sendClientMessage ( "You don't have that much money in your bank account.", source, 200, 200, 200 )
		end
		accounts[acc] = accounts[acc] - amount
		givePlayerMoney ( source, amount )
		exports['NGMessages']:sendClientMessage ( "You've withdrawn $"..tostring ( amount ).." from your bank account", source, 200, 200, 200 )
		exports['NGLogs']:outputActionLog ( getPlayerName ( source ).." deposited $"..tostring(amount).." into his bank. (Total: $"..accounts[acc]..")" )
		lg = getPlayerName ( source ).." withdrew $"..amount
	elseif ( action == 'deposit' ) then
		if ( amount > getPlayerMoney ( source ) ) then
			return exports['NGMessages']:sendClientMessage ( "You don't have that much money.", source, 200, 200, 200 )
		end
		accounts[acc] = bankBalance + amount
		takePlayerMoney ( source, amount ) 
		exports['NGMessages']:sendClientMessage ( "You've deposited $"..tostring ( amount ).." into your bank account.", source, 200, 200, 200 )
		exports['NGLogs']:outputActionLog ( getPlayerName ( source ).." deposited $"..tostring(amount).." into his bank. (Total: $"..accounts[acc]..")" )
		lg = getPlayerName ( source ).." deposited $"..amount
	end
	setElementData ( source, "NGBank:BankBalance", accounts[acc] ) 
	triggerClientEvent ( source, "NGBanks:resfreshBankData", source, accounts[acc] )
	
	
	-- log it
	local today = exports.NGPlayerFunctions:getToday ( )
	local serial = getPlayerSerial ( source )
	local ip = getPlayerIP ( source )
	exports.NGSQL:db_exec ( "INSERT INTO bank_transactions ( account, log, serial, ip, thetime ) VALUES ( ?, ?, ?, ?, ? )",
		acc, lg, serial, ip, today )
end ) 

addEventHandler ( "onPlayerJoin", root, function ( )
	setElementData ( source, "NGBank:BankBalance", 0 )
end ) 

addEventHandler ( "onPlayerLogin", root, function ( _, acc )
	local acc = getAccountName ( acc )
	setElementData ( source, "NGBank:BankBalance", accounts[acc] or 0 )
end )

function getAccountBalance ( account )
	return accounts [ account ] 
end




addEvent ( "NGBank->OnClientHitBankMarker", true )
addEventHandler ( "NGBank->OnClientHitBankMarker", root, function ( player, mark )
	outputChatBox ( "Hi, "..getPlayerName ( player ) )
	onBankMarkerHit ( player, mark )
end )
