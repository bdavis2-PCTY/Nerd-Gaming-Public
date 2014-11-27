------------------------------------------
-- 		 	  Dx Login Panel			--
------------------------------------------
-- Developer: Braydon Davis	(xXMADEXx)	--
-- File: server.lua						--
-- Copyright 2013 (C) Braydon Davis		--
-- All rights reserved.					--
------------------------------------------

local cameras = {
	{ 329.10980224609, -2117.2749023438, 50.161201477051, 329.65179443359, -2116.4926757813, 49.853763580322 },
	{ 1266.0053710938, -1965.7087402344, 114.59829711914, 1265.1549072266, -1966.1115722656, 114.25980377197 },
	{ 1514.0283203125, -1716.5743408203, 39.910701751709, 1514.5087890625, -1715.865234375, 39.394691467285 },
	{ 1338.7514648438, -875.66558837891, 99.84880065918, 1339.4935302734, -875.07824707031, 99.52579498291 },
	{ 1426.5421142578, -725.40289306641, 120.97090148926, 1427.3695068359, -725.00805664063, 120.571434021 },
	{ 1357.5914306641, -592.23327636719, 125.15190124512, 1357.1751708984, -593.02673339844, 124.70780944824 },
	{ 988.01123046875, -341.88409423828, 74.752601623535, 988.70251464844, -342.45135498047, 75.200187683105 },
	{ -224.32290649414, -153.71020507813, 35.085899353027, -223.61195373535, -153.04695129395, 34.852146148682 }
}

function openView( plr )
	local theplr = nil
	if ( source and getElementType ( source ) == 'player' ) then
		theplr = source
	elseif ( plr and getElementType ( plr ) == 'player' ) then
		theplr = plr
	end
	setTimer ( function ( p )
		local ind = math.random ( #cameras )
		setCameraMatrix ( p, unpack ( cameras[ind] ) )
		fadeCamera ( p, true )
	end, 300, 1, theplr )
end
addEventHandler ( "onPlayerJoin", root, openView )
addEventHandler ( "onPlayerLogout", root, openView )

function attemptLogin ( user, pass )
	local s = getPlayerSerial ( source )
	if ( exports.NGBans:isSerialBanned ( s ) ) then
		exports.NGBans:loadBanScreenForPlayer ( source )
		triggerClientEvent ( source, "NGLogin:hideLoginPanel", source )
	end
	if ( user and pass and type ( user ) == 'string' and type ( pass ) == 'string' ) then
		--local user = string.lower ( user )
		--local pass = string.lower ( pass )
		local account = getAccount ( user )
		if ( account ) then
			if ( not logIn ( source, account, pass ) ) then
				message ( source, "Incorrect password." )
				return false
			end
			exports['NGLogs']:outputActionLog ( getPlayerName ( source ).." has logged in as "..tostring(user).." (IP: "..getPlayerIP(source).."  || Serial: "..getPlayerSerial(source)..")" )
			setCameraTarget ( source, source )
			triggerLogin ( source, user, pass, false )
		else
			message ( source, "Unknown account." )
			return false
		end
	end
	return false
end
addEvent ( "Login:onClientAttemptLogin", true )
addEventHandler ( "Login:onClientAttemptLogin", root, attemptLogin )

addEvent ( "NGLogin:RequestClientLoginConfirmation", true )
addEventHandler ( "NGLogin:RequestClientLoginConfirmation", root, function ( )
	local s = getPlayerSerial ( source )
	if ( exports.NGBans:isSerialBanned ( s ) ) then
		exports.NGBans:loadBanScreenForPlayer ( source )
		return
	end
	triggerClientEvent ( source, "NGLogin:OnServerGiveClientAutherizationForLogin", source )
end )

function attemptRegister ( user, pass )
	if ( user and pass and type ( user ) == 'string' and type ( pass ) == 'string' ) then
		--local user = string.lower ( user )
		--local pass = string.lower ( pass )
		local account = getAccount ( user )
		if ( not account ) then
			local account = addAccount ( user, pass )
			if ( account ) then
				if ( not logIn ( source, account, pass ) ) then
					return message ( source, "Logging in has failed." )
				end
				exports['NGLogs']:outputActionLog ( getPlayerName ( source ).." has registered on the server" )
				triggerLogin ( source, user, pass, true )
				setElementData ( source, "Job", "UnEmployed" )
				setElementData ( source, "NGPlayerFunctions:Playtime_Mins", 0 )
				setElementData ( source, "Playtime", "0 Hours" )
				setElementData ( source, "Gang", "None" )
				setElementData ( source, "Gang Rank", "None" )
				exports['NGSQL']:createAccount ( user );
				exports['NGJobs']:addPlayerToJobDatabase ( source )
				exports.NGPlayerFunctions:setTeam(source,"Unemployed")
			else
				message ( source, "Adding account failed.\nPlease report to an admin." )
			end
		else
			message ( source, "This account already exists." )
		end
	end
	return false
end
addEvent ( "Login:onClientAttemptRegistration", true )
addEventHandler ( "Login:onClientAttemptRegistration", root, attemptRegister )

function message ( source, msg ) triggerClientEvent ( source, "onPlayerLoginPanelError", source, msg ) end
function triggerLogin ( source, user,  pass, triggerIntro ) triggerClientEvent ( source, "onClientPlayerLogin", source, user, pass, triggerIntro, getPlayerIP ( source ) ) end
addEventHandler ( 'onPlayerLogout', root, function ( ) triggerClientEvent ( source, 'onClientPlayerLogout', source ) end )



addEvent ( "Login:onPlayerFinishIntro", true )
addEventHandler ( "Login:onPlayerFinishIntro", root, function ( )
	if source then
		setElementInterior ( source, 0 )
		setElementDimension ( source, 0 )
		fadeCamera ( source, true )
		setCameraTarget ( source, source )
		spawnPlayer ( source, 1546.58, -1675.31, 13.56 )
		setElementModel ( source, 28 )
		setPlayerMoney ( source, 1500 )
		setElementRotation ( source, 0, 0, 90 )
		
		showChat ( source, true )
		showCursor ( source, false )
		showPlayerHudComponent ( source, 'all', true )
	end
	return false
end )


addEventHandler ( "onPlayerJoin", root, function ( )
	setElementData ( source, "Job", "None" )
	setElementData ( source, "Job Rank", "None" )
	setElementData ( source, "Gang", "None" )
	setElementData ( source, "Gang Rank", "None" )
	setElementData ( source, "Money", "$0" )
	setElementData ( source, "Playtime", "0 Minutes" )
	setElementData ( source, "FPS", "0" )
end )
	