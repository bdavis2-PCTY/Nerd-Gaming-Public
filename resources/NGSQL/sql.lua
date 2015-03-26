

if ( tostring ( get ( "CONNECTION_TYPE" ) ):lower() == "mysql" ) then 
	outputConsole ( "Attempting to connect as MySQL... Please wait")
	db = dbConnect( "mysql", "dbname="..tostring(get("DATABASE_NAME"))..";host="..tostring(get("MYSQL_HOST"))..";port="..tostring(get("MYSQL_PORT"))..";unix_socket=/opt/lampp/var/mysql/mysql.sock", tostring(get("MYSQL_USER")), tostring(get("MYSQL_PASS")), "share=1;autoreconnect=1" );
elseif ( tostring ( get ( "CONNECTION_TYPE" ) ):lower() == "sqlite" ) then 
	db = dbConnect ( "sqlite", tostring(get("DATABASE_NAME")) .. ".sql" );
else 
	error ( tostring(get("CONNECTION_TYPE")) .. " is an invalid SQL connection -- valid: mysql, sqlite" );
end 

if not db then
	print ( "The database has failed to connect")
	return 
else
	print ( "Database has been connected")
end

function db_query ( ... ) 
	local data = { ... }
	return dbPoll ( dbQuery ( db, ... ), - 1 )
end

function db_exec ( ... )
	return dbExec ( db, ... );
end

--[[ Columns:

	Username TEXT,
	Money TEXT,
	Armour TEXT,
	Health TEXT, 
	x TEXT,
	y TEXT,
	z TEXT,
	Skin INT,
	Interior INT, 
	Dimension INT,
	Team TEXT
	Job TEXT,
	Playtime_mins INT,
	JailTime INT,
	WL INT,
	Weapons TEXT,
	JobRank TEXT,
	GroupName TEXT,
	GroupRank TEXT,
	LasterOnline DATE,
	LastSerial TEXT,
	LastIP TEXT,
	Kills INT,
	Deaths INT, 
	weapstats TEXT,
	items TEXT,
	unemployedskin INT,
	vip TEXT,
	vipexp DATE,
	plrtosrvrsettings TEXT

]]

db_exec ( [[CREATE TABLE IF NOT EXISTS accountdata ( Username VARCHAR(200), Money INT, Armour INT, Health INT, x VARCHAR(20), 
y VARCHAR(20), z VARCHAR(20), Skin INT, Interior INT, Dimension INT, 
Team VARCHAR(70), Job VARCHAR(70), Playtime_mins INT, JailTime INT, 
WL INT, Weapons TEXT, JobRank VARCHAR(20), GroupName VARCHAR(100), GroupRank VARCHAR(100), LastOnline DATE, 
LastSerial VARCHAR(50), LastIP VARCHAR(20), Kills INT, Deaths INT, weapstats TEXT, 
items TEXT, unemployedskin INT, vip VARCHAR(100), vipexp DATE, plrtosrvrsettings TEXT )]] );

local weapStats_ = { 
	['9mm'] = 0, ['silenced'] = 0, ['deagle'] = 0, ['shotgun'] = 0, ['combat_shotgun'] = 0, 
	['micro_smg'] = 0, ['mp5'] = 0, ['ak47'] = 0, ['m4'] = 0, ['tec-9'] = 0, ['sniper_rifle'] = 0 }

function createAccount ( account )
	if ( account and type ( account ) == 'string' ) then
		local plr = getPlayerFromAccount ( account )
		local autoIP = "unknown"
		local autoSerial = "unknown"
		local weapStats = toJSON ( weapStats_ )
		if plr and isElement ( plr ) then
			autoSerial = getPlayerSerial ( plr )
			autoIP = getPlayerIP ( plr )
			outputDebugString ( "NGSQL: Creating account "..account.." for player "..getPlayerName ( plr ).." (Serial: "..autoSerial.." || IP: "..autoIP..")" )
		else
			outputDebugString ( "NGSQL: Creating account "..account.." for player N/A (Serial: None || IP: None)" );
		end
		local today = exports['NGPlayerFunctions']:getToday ( )
		return db_exec ( 
[[INSERT INTO `accountdata` (`Username`, `Money`, `Armour`, `Health`, `x`, `y`, `z`, 
`Skin`, `Interior`, `Dimension`, `Team`, `Job`, `Playtime_mins`, `JailTime`, `WL`, `Weapons`, `JobRank`, 
`GroupName`, `GroupRank`, `LastOnline`, `LastSerial`, `LastIP`, `Kills`, `Deaths`, `weapstats`, `items`, 
`unemployedskin`, `vip`, `vipexp`, `plrtosrvrsettings` ) 
VALUES ( ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ? );]], 
			account, '0', '0', '100', '0', '0', '0', '0', '0', '0', 'UnEmployed', 'UnEmployed', '0', '0', '0', 
			'[ [ ] ]', 'None', 'None', 'None', today, autoSerial, autoIP, '0', '0', weapStats, toJSON ( { } ), '28', 'None', nil, toJSON ( { } ) )
	end
	return false
end

function getPlayerFromAccount ( accnt )
	if accnt and type ( accnt ) == 'string' then
		for i, v in ipairs ( getElementsByType ( 'player' ) ) do
			if ( getAccountName ( getPlayerAccount ( v ) ) == accnt ) then
				return v;
			end
		end
	end
	return false
end


function savePlayerData ( p, loadMsg, deleteTime )
	if ( p and getElementType ( p ) == 'player' ) then
		if ( not isGuestAccount ( getPlayerAccount ( p ) ) ) then
			
			if ( loadMessage == nil ) then loadMessage = true end
			if ( deleteTime == nil ) then deleteTime = false end
		
			local account = getAccountName ( getPlayerAccount ( p ) )
			local x, y, z = getElementPosition ( p )
			local money, health = getPlayerMoney ( p ), getElementHealth ( p )
			local armor, skin = getPedArmor ( p ), getElementModel ( p )
			local int, dim  = getElementInterior ( p ), getElementDimension ( p )
			local job = getElementData ( p, "Job" )
			local pt = exports['NGPlayerFunctions']:getPlayerPlaytime ( p )
			local team = "UnEmployed"
			local wl = getElementData ( p, "WantedPoints" ) or 0
			local rank = tostring ( getElementData ( p, "Job Rank" ) )

			local group = tostring ( getElementData ( p, "Group" ) )
			local gRank = tostring ( getElementData ( p, "Group Rank" ) )

			local jt = exports['NGPolice']:isPlayerJailed ( p ) or 0
			local weapons = { }
			local today = exports['NGPlayerFunctions']:getToday ( )
			local kills = tonumber ( getElementData ( p, "NGSQL:Kills" ) ) or 0
			local deaths = tonumber ( getElementData ( p, "NGSQL:Deaths" ) ) or 0
			local weapstats = toJSON ( getElementData ( p, "NGSQL:WeaponStats" ) or weapStats_ )
			local items = tostring ( toJSON ( getElementData ( p, "NGUser:Items" ) or { } ) )
			local unemloyedSkin = tostring ( getElementData ( p, "NGUser.UnemployedSkin" ) ) or 28
			local vip = tostring ( getElementData ( p, "VIP" ) )
			local vipexp = tostring ( getElementData ( p, "NGVIP.expDate" ) )

			local plrtosrvrsettings = tostring ( toJSON ( getElementData ( p, "PlayerServerSettings" ) or { } ) )
			
			if ( getElementData ( p, "NGEvents:IsPlayerInEvent" ) ) then
				health = 0
				dim = 0
			end
			
			if ( getPlayerTeam ( p ) ) then
				team = getTeamName ( getPlayerTeam ( p ) )
			end if not armor then
				armor = 0
			end
			if ( not jt ) then jt = 0 end
			
			for i=1,12 do
				weapons[i] = { getPedWeapon ( p, i ), getPedTotalAmmo ( p, i ) }
			end
			local weapons = toJSON ( weapons )
			
			local ip = getPlayerIP ( p )
			local serial = getPlayerSerial ( p )
			
			if loadMsg then outputDebugString ( "NGSQL: Attempting to save account "..account.." (Player: "..getPlayerName ( p )..") userdata." ) end
			if ( deleteTime ) then exports['NGPlayerFunctions']:deletePlayerPlaytime ( p ) end
			return db_exec ( "UPDATE accountdata SET Money=?, Armour=?, Health=?, x=?, y=?, z=?, Skin=?, Interior=?, Dimension=?, Team=?, Job=?, Playtime_mins=?, JailTime=?, WL=?, Weapons=?, JobRank=?, GroupName=?, GroupRank=?, LastOnline=?, LastSerial=?, lastIP=?, Kills=?, Deaths=?, weapstats=?, items=?, unemployedskin=?, vip=?, vipexp=?, plrtosrvrsettings=? WHERE Username=?", 
				money, armor, health, x, y, z, skin, int, dim, team, job, pt, jt, wl, weapons, rank, group, gRank, today, serial, ip, kills, deaths, 
				weapstats, items, unemloyedSkin, vip, vipexp, plrtosrvrsettings, account )
		end
	end
end

function loadPlayerData ( p, loadMsg )
	local acc = getAccountName ( getPlayerAccount ( p ) )
	local data = account_exist ( acc )
	if ( data and type ( data ) == 'table' ) then
		for i, v in ipairs  ( data ) do
			if ( v['Username'] == acc ) then
			
				if ( loadMsg == nil ) then
					loadMesg = true
				end
				
				local money = 		tonumber ( v['Money'] ) 			or 0
				local armor = 		tonumber ( v['Armour'] )		 	or 0
				local health = 		tonumber ( v['Health'] ) 			or 0
				local x = 			tonumber ( v['x'] ) 				or 0
				local y = 			tonumber ( v['y'] ) 				or 0
				local z = 			tonumber ( v['z'] ) 				or 3
				local skin = 		tonumber ( v['Skin'] ) 				or 28
				local interior = 	tonumber ( v['Interior'] ) 			or 0
				local dimension = 	tonumber ( v['Dimension'] )		 	or 0
				local team = 		tostring ( v['Team'] ) 				or "None"
				local job = 		tostring ( v['Job'] ) 				or "None"
				local pt = 			tonumber ( v["Playtime_mins"] ) 	or 0
				local jt = 			tonumber ( v['JailTime'] or 0 )
				local wl = 			tonumber ( v['WL'] or 0 )
				local weapons = 	fromJSON ( v['Weapons'] 			or toJSON ( { } ) )
				local rank = 		tostring ( v['JobRank'] or "None" )
				local group = 		tostring ( v['GroupName'] or "None" )
				local gRank = 		tostring ( v['GroupRank'] or "None" )
				local kills = 		tonumber ( v['Kills'] )
				local deaths = 		tonumber ( v['Deaths'] )
				local weapstats = 	fromJSON ( tostring ( v['weapstats'] ) )
				local items = 		fromJSON ( tostring ( v['items'] ) )
				local unemployedSkin=tonumber( v['unemployedskin'] )	or 28
				local vip =			tostring ( v['vip'] )
				local vipexp =		tostring ( v['vipexp'] )
				local group =		tostring ( v['GroupName'] or "None" )
				local groupRank =	tostring ( v['GroupRank'] or "None" )
				local srvrsettings =fromJSON ( tostring ( v['plrtosrvrsettings'] or tosJSON ( { } ) ) )

				if ( not exports.nggroups:doesGroupExist ( group ) ) then
					group = "None"
				else
					if ( not exports.nggroups:isRankInGroup ( group, groupRank ) ) then
						groupRank = "None"
					end 
				end 

				if ( group:lower ( ) == "none" ) then
					groupRank = "None"
				end
				
				spawnPlayer ( p, x, y, z, 0, skin, interior, dimension )
				setElementData ( p, "Job Rank", rank )
				if ( jt > 0 ) then exports['NGPolice']:jailPlayer ( p, jt, false ) end
				setElementData ( p, "NGSQL:Kills", kills )
				setElementData ( p, "NGSQL:Deaths", deaths )
				setElementData ( p, "Job", job )
				setPedArmor ( p, armor )
				givePlayerMoney ( p, money )
				exports['NGPlayerFunctions']:setPlayerPlaytime ( p,pt )
				setElementData ( p, "WantedPoints", wl )
				setElementData ( p, "Group", group )
				setElementData ( p, "Group Rank", gRank	)
				setElementData ( p, "NGSQL:WeaponStats", weapstats )
				setElementData ( p, "NGUser:Items", items )
				setElementData ( p, "NGUser.UnemployedSkin", unemployedSkin )
				setElementData ( p, "VIP", vip )
				setElementData ( p, "NGVIP.expDate", vipexp )
				setElementHealth ( p, health )
				setElementData ( p, "PlayerServerSettings", srvrsettings )

				if ( srvrsettings.walkStyle ) then
					setPedWalkingStyle ( p, srvrsettings.walkStyle)
				end
				
				exports.NGVIP:checkPlayerVipTime ( p )
				for i, v in ipairs ( weapons ) do giveWeapon ( p, v[1], v[2] ) end
				if ( team and getTeamFromName ( team ) ) then setPlayerTeam ( p, getTeamFromName ( team ) ) end
				if ( loadMsg ) then outputDebugString ( "NGSQL: Loading "..acc.." account data (Player: "..getPlayerName ( p )..")" ) end
				return true
			end
		end
	end
	return false
end

function account_exist ( acc )
	if ( acc ) then
		local q = db_query ( "SELECT * FROM accountdata WHERE Username='"..acc.."' LIMIT 1" )
		if ( type ( q ) == 'table' ) then
			if ( #q > 0 ) then
				return q
			end
			return false
		end
	end
	return nil
end

function saveAllData ( useTime )
	if ( useTime == nil ) then useTime = true end
	if ( useTime ) then
		if ( getResourceState ( getResourceFromName ( 'NGMessages' ) ) == 'running' ) then exports['NGMessages']:sendClientMessage ( "Please expect some lag, saving server data in 5 seconds.", root, 255, 0, 0 ) end
		setTimer ( function ( )
			for i, v in ipairs ( getElementsByType ( 'player' ) ) do
				savePlayerData ( v, false, false )
			end
			if ( isTimer ( saveAllTimer ) ) then
				resetTimer ( saveAllTimer )
			else
				saveAllTimer = setTimer ( saveAllData, 3600000, 1, true )
			end
			if ( getResourceState ( getResourceFromName ( "NGBank" ) ) == 'running' ) then exports['NGBank']:saveBankAccounts ( ) end
			if ( getResourceState ( getResourceFromName ( 'NGMessages' ) ) == 'running' ) then exports['NGMessages']:sendClientMessage ( "Server data has been saved!", root, 0, 255, 0 ) end
			if ( getResourceState ( getResourceFromName ( "NGBans" ) ) == "running" ) then exports.NGBans:saveBans ( ) end
			if ( getResourceState ( getResourceFromName ( "NGTurf" ) ) == "running" ) then exports.NGTurf:saveTurfs ( ) end 
		end, 5000, 1 )
	else
		if ( getResourceState ( getResourceFromName ( 'NGMessages' ) ) == 'running' ) then exports['NGMessages']:sendClientMessage ( "Saving server data! Please expect some lag.", root, 255, 0, 0 ) end
		if ( getResourceState ( getResourceFromName ( 'NGBank' ) ) == 'running' ) then exports['NGBank']:saveBankAccounts ( ) end
		if ( getResourceState ( getResourceFromName ( "NGBans" ) ) == "running" ) then exports.NGBans:saveBans ( ) end
		if ( getResourceState ( getResourceFromName ( "NGTurf" ) ) == "running" ) then exports.NGTurf:saveTurfs ( ) end 
		for i, v in ipairs ( getElementsByType ( 'player' ) ) do savePlayerData ( v, false, false ) end
		if ( isTimer ( saveAllTimer ) ) then resetTimer ( saveAllTimer ) else saveAllTimer = setTimer ( saveAllData, 3600000, 1, true ) end
	end
end
saveAllTimer = setTimer ( saveAllData, 3600000, 1, true )

addEventHandler ( "onPlayerQuit", root, function ( ) 
	if ( isGuestAccount ( getPlayerAccount ( source ) ) ) then return end 
	savePlayerData ( source, false, true ) 
end ) 

addEventHandler ( "onPlayerLogin", root, function ( ) 
	loadPlayerData ( source, true ) 
end ) 

addEventHandler ( "onResourceStop", resourceRoot, function ( ) 
	saveAllData ( false ) 
end ) 

-- For development purposes 
--[[
addCommandHandler ( "makeaccnt", function ( p, cmd, accnt ) 
	if ( getPlayerName ( p ) == "Console" or getAccountName ( getPlayerAccount ( p ) ) == "xXMADEXx" ) then
		outputChatBox ( "Executing command: Account Creation", root, 255, 255, 255 )
		results = nil
		if ( accnt ) then
			if ( createAccount ( accnt ) ) then
				print ( "The account "..accnt.." has been created!" )
				results = "Account "..accnt.." has been created"
			else
				print ( "Failed to create account." )
				results = "Account "..accnt.." has failed to create!!"
			end
		else
			print ( "Format: /"..cmd.." [account name]" )
			results = "none"
		end
		outputChatBox ( "Command Execution Results: "..tostring ( results ), root, 255, 255, 255 )
	end
end )

addCommandHandler ( "delaccnt", function ( p, cmd, accnt ) 
	if ( getPlayerName ( p ) == "Console" ) then
		if ( account_exist ( accnt ) ) then
			print ( "Removing account "..accnt.." from database......" )
			if ( db_exec ( "DELETE FROM accountdata WHERE Username='"..accnt.."'" ) ) then
				print ( "Account has been removed!" )
			else
				print ( "Account has failed to have been removed." )
			end
		else
			print ( "The account "..accnt.." doesn't exist in the mysql database." )
		end
	end
end )

addCommandHandler ( 'saveall', function ( p, cmd )
	if ( ( getPlayerName ( p ) == 'Console' ) or ( getAccountName ( getPlayerAccount ( p ) ) == 'xXMADEXx' ) ) then
		saveAllData ( true )
	end
end )
]]

