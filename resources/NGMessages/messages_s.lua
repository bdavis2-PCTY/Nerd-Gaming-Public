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
function sendClientMessage ( msg, who, r, g, b, img, checkImagePath )
	if ( msg and who ) then
		if ( isElement ( who ) ) then
			
			if ( checkImagePath == nil ) then checkImagePath = true; end
			
			if ( img and sourceResource and checkImagePath ) then 
				img = ":"..tostring(getResourceName(sourceResource)).."/"..img;
			end 
			
			triggerClientEvent ( who, TheResourceName..":sendClientMessage", who, msg, r, g, b, img )
			
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