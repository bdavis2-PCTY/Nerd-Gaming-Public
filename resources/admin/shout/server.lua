------------------------------------------
-- 			    AdminShout				--
------------------------------------------
-- Developer: Braydon Davis				--
-- File: server.lua						--
-- Copywrite 2013 (C) Braydon Davis		--
-- All rights reserved.					--
------------------------------------------	

function checkPlayerShoutAllowence( p )
	local team = getPlayerTeam ( p )
	if ( team and getTeamName ( team ) == "Staff" ) then
		triggerClientEvent ( p, "Shouts:onPlayerChangeMenu", p )
	else return end
end
addCommandHandler ( "shoutall", checkPlayerShoutAllowence )
addEvent ( "Admin:checkPlayerShoutAllowence", true )
addEventHandler ( "Admin:checkPlayerShoutAllowence", root, checkPlayerShoutAllowence )

local isMessage = false
addEvent ( "Shouts:onPlayerTriggerServerShout", true )
addEventHandler ( "Shouts:onPlayerTriggerServerShout", root, function ( text, name, r, g, b )
	if ( text and name ~= nil ) then
		if not isMessage then
			if ( name == true ) then 
				send = getPlayerName ( source ).."\n"..text 
			else
				send = text
			end
			isMessage = true
			triggerClientEvent ( root, "Shouts:onPlayerGetText", root, send, r, g, b )
			outputDebugString ( "SHOUT ALL: "..getPlayerName ( source ).." has shouted at everyone." )
			setTimer ( function ( )
				isMessage = false
			end, 10200, 1 )
		else
			outputChatBox ( "Please wait for the current text to leave.", source, 255, 255, 0 )
			return
		end
	end
end )

