------------------------------------------
-- 			  TopBarChat				--
------------------------------------------
-- Developer: Braydon Davis				--
-- File: s.lua							--
-- Copyright 2013 (C) Braydon Davis		--
-- All rights reserved.					--	
------------------------------------------
sec = {{{{{{},{},{},{}}}}}}				--
------------------------------------------

local TheResourceName = getResourceName ( getThisResource ( ) )
function sendClientMessage ( msg, who, r, g, b, pos, time )
	if ( msg and who ) then
		if ( isElement ( who ) ) then
			triggerClientEvent ( who, TheResourceName..":sendClientMessage", who, msg, r, g, b, pos, time )
			return true
		else return false end
	else return false end
end

addEventHandler ( "onPlayerLogin", root, function ( )
	if ( not exports['NGAdministration']:isPlayerStaff ( source ) ) then
		sendClientMessage ( getPlayerName ( source ).." has logged into NG:RPG!", root, 0, 255, 0 )
	else
		local lvl = exports['NGAdministration']:getPlayerStaffLevel ( source, 'string' )
	--	sendClientMessage ( "* "..getPlayerName ( source ).." has logged in - "..lvl, root, math.random ( 100, 250 ), math.random ( 100, 250 ), math.random ( 100, 250 ) )
		outputChatBox ( "* "..getPlayerName ( source ).." has logged in - "..lvl, root, math.random ( 100, 250 ), math.random ( 100, 250 ), math.random ( 100, 250 ) )
	end
end )

addEventHandler ( 'onPlayerQuit', root, function ( rson, x, element )
	local reason = ""
	local rson = string.lower ( tostring ( rson ) )
	if ( rson == 'unknown' or rson == 'quit' or rson =='bad connection' or rson == 'timed out' ) then
		reason = getPlayerName ( source ).." has left ("..rson..")"
	elseif ( rson == 'quit' ) then
		reason = getPlayerName ( source ).." has left ("..rson..")"
	elseif ( rson == 'kicked' ) then
		if ( isElement ( element ) ) then
			reason = getPlayerName ( source ).." has left ("..rson.." by "..getPlayerName ( element )..")"
		else
			reason = getPlayerName ( source ).." has left ("..rson.." by Console)"
		end
	elseif ( rson == 'banned' ) then
		if ( isElement ( element ) ) then
			reason = getPlayerName ( source ).." has left ("..rson.." by "..getPlayerName ( element )..")"
		else
			reason = getPlayerName ( source ).." has left ("..rson.." by Console)"
		end
	end
	
	sendClientMessage ( "* "..reason, root, 255, 0, 0 )
	--sendClientMessage ( rson, root, 255, 0, 0 )
	
end )

addCommandHandler ( 'note', function ( p, _, ... ) 
	if exports['NGAdministration']:isPlayerStaff ( p ) then
		if ... then
			local msg = table.concat ( { ... }, " " )
			sendClientMessage ( "("..getPlayerName ( p )..") "..msg, root, 0, 120, 255 )
		else
			sendClientMessage ( "Syntax: /note [message]", p, 255, 0, 0 )
		end
	end
end )