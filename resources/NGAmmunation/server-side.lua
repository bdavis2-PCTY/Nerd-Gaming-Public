----------------------------------------------
-- Author: Braydon Davis / xXMADEXx			--
-- Project: Community - Ammunation DX		--
-- File: server-side.lua					--
-- Copyright (C) 2013-2014 					--
-- All Rights Reserved						--
----------------------------------------------


addEvent ( "Ammunation:onClientBuyWeapon", true )
addEventHandler ( "Ammunation:onClientBuyWeapon", root, function ( name, id, price )
	if ( getPlayerMoney ( source ) >= price ) then
		takePlayerMoney ( source, price )
		if ( id ) then	
			if ( id ~= 16 and id ~= 39 ) then
				outputChatBox ( name.." purchased with 600 bullets for $"..tostring ( price ).."!", source, 0, 255, 0 )
				giveWeapon ( source, id, 600, true )
			else
				outputChatBox ( "Two "..name.." purchased for $"..tostring ( price ).."!", source, 0, 255, 0 )
				giveWeapon ( source, id, 2, true )
				--[[if ( id == 39 ) then
					giveWeapon ( source, 40, 999999 ) -- donno why but it's bugged  :C
				end]]
			end
		else
			outputChatBox ( name.." purchased for $"..tostring ( price ).."!", source, 0, 255, 0 )
			setPedArmor ( source, 100 )
		end
	else
		outputChatBox ( "You cannot afford a(n) "..name..".", source, 255, 0, 0 )
	end
end )


function outputChatBox ( m, p, r, g, b )
	return exports.NGMessages:sendClientMessage ( m, p, r, g, b )
end