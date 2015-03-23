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
		outputChatBox ( "* "..getPlayerName ( source ).." has logged in - "..lvl, root, math.random ( 100, 250 ), math.random ( 100, 250 ), math.random ( 100, 250 ) )
	end
end )