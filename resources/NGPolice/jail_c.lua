local remainingTime = nil
local sx, sy = guiGetScreenSize ( )

addEvent ( "onPlayerArrested", true )
addEventHandler ( "onPlayerArrested", root, function ( dur )
	if dur then
		remainingTime = dur
		l_tick = getTickCount ( )
		addEventHandler ( 'onClientRender', root, dxDrawRemainingJailTime )
	end
end )

function dxDrawRemainingJailTime ( )
	dxDrawText ( tostring ( remainingTime ).. " seconds", 0, 0, (sx/1.1)+2, (sy/1.1)+2, tocolor ( 0, 0, 0, 255 ), 2.5, 'default-bold', 'right', 'bottom' )
	dxDrawText ( tostring ( remainingTime ).. " seconds", 0, 0, sx/1.1, sy/1.1, tocolor ( 255, 255, 0, 255 ), 2.5, 'default-bold', 'right', 'bottom' )
	if ( getTickCount ( ) - l_tick >= 1000 ) then
		remainingTime = remainingTime - 1
		l_tick = getTickCount ( )
		setElementData ( localPlayer, "NGPolice:JailTime", remainingTime ) 
		if ( remainingTime < 0 ) then
			triggerServerEvent ( "NGJail:UnjailPlayer", localPlayer, false )
			remainingTime = nil
			l_tick = nil
			removeEventHandler ( "onClientRender", root, dxDrawRemainingJailTime )
		end
	end
end

addEvent ( "NGJail:StopJailClientTimer", true )
addEventHandler ( "NGJail:StopJailClientTimer", root, function ( )
	remainingTime = nil
	l_tick = nil
	removeEventHandler ( "onClientRender", root, dxDrawRemainingJailTime )
end )


-------------------------------
-- Export functions 
-- Implemented in NG V1.1.3
-------------------------------
function isPlayerJailed ( )
	return ( 
		getElementData ( localPlayer, 'NGPolice:JailTime' ) and 
		tonumber ( getElementData ( localPlayer, 'NGPolice:JailTime' ) ) 
		) and 
		tonumber ( getElementData ( localPlayer, 'NGPolice:JailTime' ) ) > 0
end