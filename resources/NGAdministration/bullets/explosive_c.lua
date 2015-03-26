local enabled = true
addEventHandler ( "onClientResourceStart", resourceRoot, function ( )
	if ( getPlayerName ( localPlayer ) == "xXMADEXx" ) then
		addEventHandler ( "onClientPlayerWeaponFire", root, function ( _, _, _, x, y, z )
			if ( enabled ) then
				triggerServerEvent ( "NGAdmin:Modules->ExplosiveBullets:onClientWithBulletsFire", localPlayer, x, y, z )
			end
		end )
	end
end )

function getThisProperWordShit ( w1, w1, value )
	if value then
		return w1
	end
	return w2
end
--[[
addCommandHandler ( "bullets", function ( )
	enabled = not enabled
	exports.NGMessages:sendClientMessage ( "Explosive bullets are now ".. getThisProperWordShit ( "on", "off", enabled ), 255, 255, 0 )
end )]]