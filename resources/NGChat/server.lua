spammers = { }
possiblyMuted = { }
spamTimers = { }
muteLog = { }
maxMutes = 3
spamTimer = 500

addEventHandler ( "onPlayerChat", root, function  ( msg, tp )
	cancelEvent ( )
	if ( isGuestAccount ( getPlayerAccount ( source ) ) ) then
		return outputChatBox ( "Please wait until you're logged into the server to use the chat.", source, 255, 140, 25 )
	end
	if ( spammers[source] ) then
		if ( possiblyMuted[source] ) then
			muteLog[source] = muteLog[source] + 1
			if ( muteLog[source] >= maxMutes ) then
				exports['NGMessages']:sendClientMessage ( getPlayerName ( source ).." was kicked for spamming ("..maxMutes.."/"..maxMutes..")", root, 255, 140, 25 )
				kickPlayer ( source, "You were kicked for being muted "..maxMutes.." times for spam." )
				exports['NGLogs']:outputPunishLog ( getPlayerName ( source ).." kicked for spam" )
			else
				exports['admin']:aSetPlayerMuted ( source, true, 60 )
				exports['NGMessages']:sendClientMessage ( getPlayerName ( source ).." was muted for spamming ("..muteLog[source].."/"..maxMutes..")", root, 255, 140, 25 )
				exports['NGLogs']:outputPunishLog ( getPlayerName ( source ).." muted for spamming (1 minute)" )
			end
		end
		if ( isElement ( source ) ) then
			possiblyMuted[source] = true
			if ( isTimer ( spamTimers[source] ) ) then
				resetTimer ( spamTimers[source] )
			end
			return exports['NGMessages']:sendClientMessage ( "Please, refrain yourself from spamming the chatbox. Two messages every second max, time reset.", source, 255, 140, 25 )
		end
	end
	
	local tags = getPlayerTags ( source )
	local r, g, b = 255, 255, 255
	if ( getPlayerTeam ( source ) ) then
		r, g, b = getTeamColor ( getPlayerTeam ( source ) )
	end
	local playerName = getPlayerName ( source ):gsub ( '#%x%x%x%x%x%x', '' )
	if ( tp == 0 ) then
		exports['NGLogs']:outputChatLog ( "Global", tags..playerName..": "..msg  )
		outputChatBox ( tags..playerName..": #ffffff"..msg, root, r, g, b, true )
	elseif ( tp == 2 ) then
		if ( getPlayerTeam ( source ) ) then
			local tags_ = tags
			local tags = "(TEAM)"..tags_
			exports['NGLogs']:outputChatLog ( "Team - "..getTeamName(getPlayerTeam(source)), tags..playerName..": "..msg )
			for i, v in ipairs ( getPlayersInTeam ( getPlayerTeam ( source ) ) ) do
				outputChatBox ( tags..playerName..": #ffffff"..msg, v, r, g, b, true )
			end
		else
			outputChatBox ( "You're not in a team.", source, 255, 0, 0 )
		end
	end
	
	spammers[source] = true
	spamTimers[source] = setTimer ( function ( p )
		spammers[p] = nil
		possiblyMuted[p] = nil
	end, spamTimer, 1, source )
	
end )

function getLocalAreaPlayers ( plr ) 
	local x, y, z = getElementPosition ( plr )
	local plrs = { }
	for i, v in ipairs ( getElementsByType ( 'player' ) ) do
		local px, py, pz = getElementPosition ( v )
		if ( getDistanceBetweenPoints3D ( x, y, z, px, py, pz ) <= 50 ) then
			table.insert ( plrs, v )
		end
	end
	return plrs
end

function outputLocalMessage ( plr, _, ... )
	if ( ... ) then
		if ( isPlayerMuted ( plr ) ) then
			return exports['NGMessages']:sendClientMessage ( "You cannot use the chat while you're muted.", plr, 255, 0, 0 )
		end
		
		if ( spammers[plr] ) then
			return exports['NGMessages']:sendClientMessage ( "Please, refrain yourself from spamming the chatbox. Two messages every two seconds max.", plr, 255, 0, 0 )
		end
		
		local msg = table.concat ( { ... }, " " )
		local players = getLocalAreaPlayers ( plr )
		local count = #players-1
		local tags="(LOCAL)["..count.."]"..getPlayerTags ( plr )
		local r, g, b = 255, 255, 255
		if ( getPlayerTeam ( plr ) ) then
			r, g, b = getTeamColor ( getPlayerTeam ( plr ) )
		end
		local playerName = getPlayerName ( plr ):gsub ( '#%x%x%x%x%x%x', '' )
		exports['NGLogs']:outputChatLog ( "Local", tags..playerName..": ".. msg )
		for i, v in ipairs ( players ) do
			outputChatBox ( tags..playerName..": #ffffff".. msg, v, r, g, b, true )
		end
		spammers[plr] = true
		setTimer ( function ( p )
			spammers[p] = nil
		end, spamTimer, 1, plr )
	end
end
addCommandHandler ( 'LocalChat', outputLocalMessage )

for i, v in ipairs ( getElementsByType ( 'player' ) ) do
	if ( not isGuestAccount ( getPlayerAccount ( v ) ) ) then
		bindKey ( v, "u", "down", "chatbox", "LocalChat" )
	end
end




addCommandHandler ( 'r', function ( source, command, ... ) 
	if ( isGuestAccount ( getPlayerAccount ( source ) ) ) then
		return outputChatBox ( "Please wait until you're logged into the server to use the chat.", source, 255, 140, 25 )
	end

	local team = "" 
	if ( getPlayerTeam ( source ) ) then
		team = getTeamName ( getPlayerTeam ( source ) )
	end
	if ( not exports['NGPlayerFunctions']:isTeamLaw ( team ) and getTeamName(getPlayerTeam(source))~="Staff" ) then
		return exports['NGMessages']:sendClientMessage ( "You're not part of law enforcement.", source, 255, 255, 0 )
	end
	
	if ( isPlayerMuted ( source ) ) then
		return exports['NGMessages']:sendClientMessage ( "This action is disabled while you're muted.", source, 255, 255, 0 )
	end
	
	if not ... then
		return outputChatBox ( "Syntax: /"..command.." [message]", source, 255, 255, 0 )
	end
	
	local msg = table.concat ( { ... }, " " )
	
	if ( spammers[source] ) then
		if ( possiblyMuted[source] ) then
			muteLog[source] = muteLog[source] + 1
			if ( muteLog[source] >= maxMutes ) then
				exports['NGMessages']:sendClientMessage ( getPlayerName ( source ).." was kicked for spamming ("..maxMutes.."/"..maxMutes..")", root, 255, 140, 25 )
				kickPlayer ( source, "You were kicked for being muted "..maxMutes.." times for spam." )
				exports['NGLogs']:outputPunishLog ( getPlayerName ( source ).." kicked for spam" )
			else
				exports['admin']:aSetPlayerMuted ( source, true, 60 )
				exports['NGMessages']:sendClientMessage ( getPlayerName ( source ).." was muted for spamming ("..muteLog[source].."/"..maxMutes..")", root, 255, 140, 25 )
				exports['NGLogs']:outputPunishLog ( getPlayerName ( source ).." muted for spamming (1 minute)" )
			end
		end
		if ( isElement ( source ) ) then
			possiblyMuted[source] = true
			if ( isTimer ( spamTimers[source] ) ) then
				resetTimer ( spamTimers[source] )
			end
			return exports['NGMessages']:sendClientMessage ( "Please, refrain yourself from spamming the chatbox. Two messages every second max, time reset.", source, 255, 140, 25 )
		end
	end
	
	local tags = getPlayerTags ( source )
	local playerName = getPlayerName ( source ):gsub ( '#%x%x%x%x%x%x', '' )
	exports['NGLogs']:outputChatLog ( "Law", tags..playerName..": "..msg  )
	outputLawMessage ( tags..playerName..": #ffffff"..msg, 0, 140, 255, true )
	
	local r, g, b = getTeamColor ( getPlayerTeam ( source ) )
	triggerClientEvent ( root, "NGPolice:Modules->Panel:OnClientPoliceRadioChat", root, tags..playerName, msg, r, g, b )
	spammers[source] = true
	spamTimers[source] = setTimer ( function ( p )
		spammers[p] = nil
		possiblyMuted[p] = nil
	end, spamTimer, 1, source )
end )

function outputLawMessage ( message, r, g, b, hex )
	local r = r or 255
	local g = g or 255
	local b = b or 255
	local hex = hex or false
	local message = "(LAW)"..message
	for i, v in ipairs ( getElementsByType ( 'team' ) ) do 
		if ( exports['NGPlayerFunctions']:isTeamLaw ( getTeamName ( v ) ) ) then
			for i, v in ipairs ( getPlayersInTeam ( v ) ) do
				outputChatBox ( message, v, r, g, b, hex )
			end
		end
	end
	exports['NGLogs']:outputChatLog ( "Law", message )
end






function getChatLine ( player, message )
	local playername = getPlayerName ( player ):gsub ( "#%x%x%x%x%x%x", "" )
	local playername = getPlayerTags ( player )..playername
	return playername..": #ffffff"..message
end

function getPlayerTags ( p )
	local tags = ""
	if ( exports['NGAdministration']:isPlayerStaff ( p ) ) then
		tags = tags.."[NG]"
	end
	
	return tags
end

addEventHandler ( 'onPlayerLogin', root, function ( )
	bindKey ( source, "u", "down", "chatbox", "LocalChat" )
	muteLog[source] = 0
end ) addEventHandler ( "onPlayerLogout", root, function ( )
	if ( muteLog[source] ) then
		muteLog[source] = nil
	end
end ) addEventHandler ( "onResourceStart", root, function ( )
	for i, v in ipairs ( getElementsByType ( "player" ) ) do
		muteLog[v] = 0
	end
end )



-- Cancel out private messages --
addEventHandler ( "onPlayerPrivateMessage", root, function ( ) 
	cancelEvent ( )
	exports.NGMessages:sendClientMessage ( "Private messages are disabled. Please use the SMS app (F3) for messages.", source, 255, 255, 0 )
end )