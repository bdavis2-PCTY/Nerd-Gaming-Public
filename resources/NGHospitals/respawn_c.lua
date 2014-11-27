local data = nil
local dead = false
local sx, sy = guiGetScreenSize ( )
local hospitals = { }


addEvent ( 'NGHospitals:onClientWasted', true )
addEventHandler ( 'NGHospitals:onClientWasted', root, function ( d )
	dead = true
	data = d
	l_tick = getTickCount ( )
	ind = 0
	rec_y = sy
	moveMode = true
	drawRec = false
	addEventHandler ( 'onClientRender', root, dxDrawRespawnMenu )
	showChat ( false )
	showPlayerHudComponent ( 'all', false )
	setElementInterior ( localPlayer, 0 )
	setElementDimension ( localPlayer, 0 )
end )

function dxDrawRespawnMenu ( )
	if ( ind == 0 and getTickCount ( ) - l_tick >= 2000 ) then
		fadeCamera ( false )
		ind = ind + 1
	elseif ( ind == 1 and getTickCount ( ) - l_tick >= 5500 ) then
		ind = ind + 1
		fadeCamera ( true )
		setCameraMatrix ( data[5], data[6], data[7], data[2], data[3], data[4] )
		drawRec = true
	elseif ( ind == 2 and getTickCount ( ) - l_tick >= 10000 ) then
		ind = ind + 1
		moveMode = false
		fadeCamera ( false )
	elseif ( ind == 3 and getTickCount ( ) - l_tick >= 11500 ) then
		triggerServerEvent ( "NGHospitals:triggerPlayerSpawn", localPlayer, data )
		fadeCamera ( true )
		setCameraTarget ( localPlayer )
		removeEventHandler ( "onClientRender", root, dxDrawRespawnMenu )
		drawRec=false
		moveMode=true
		rec_y = sy
		ind = 0
		
		showChat ( true )
		showPlayerHudComponent ( 'all', true )
		dead = false
	end
	
	if ( drawRec ) then
		dxDrawRectangle ( 0, rec_y, sx, ( sy / 8 ), tocolor ( 0, 0, 0, 255 )  )
		dxDrawText ( data[1], 0, rec_y, sx, rec_y + ( sy / 8 ), tocolor ( 255, 255, 255, 255 ), 3, 'default-bold', 'center', 'center' )
		
		if ( moveMode ) then
			if ( rec_y > sy - ( sy / 8 ) ) then
				rec_y = rec_y - 3
			else
				rec_y = sy - ( sy / 8 )
			end
		else
			if ( rec_y < sy ) then
				rec_y = rec_y + 3
			end
		end
	end
end


function isClientDead ( )
	return dead
end




-- Blip Sys --
addEvent ( "NGHospitals:onServerSendClientLocRequest", true )
addEventHandler ( "NGHospitals:onServerSendClientLocRequest", root, function ( hos )
	hospitals = hos
end )

addEvent ( "onClientPlayerLogin", true )
addEventHandler ( "onClientPlayerLogin", root, function ( )
	local mBlips = exports.NGPhone:getSetting ( "usersetting_display_hospitalblips" )
	if ( mBlips ) then
		blips = { }
		for i, v in pairs ( hospitals ) do
			local x, y, z = v[4], v[5], v[6]
			blips[i] = createBlip ( x, y, z, 22, 2, 255, 255, 255, 255, 0, 450 )
		end
	end
end )

addEvent ( "onClientUserSettingChange", true )
addEventHandler ( "onClientUserSettingChange", root, function ( set, to ) 
	if ( set == "usersetting_display_hospitalblips" ) then
		if ( to and not blips ) then
			blips =  { }
			for i, v in pairs ( hospitals ) do
				local x, y, z = v[4], v[5], v[6]
				blips[i] = createBlip ( x, y, z, 22, 2, 255, 255, 255, 255, 0, 450 )
			end
		elseif ( not to and blips ) then
			for i, v in pairs ( blips ) do
				destroyElement ( v )
			end
			blips = nil
		end
	end
end )


triggerServerEvent ( "NGHospitals:onClientRequestLocations", localPlayer )