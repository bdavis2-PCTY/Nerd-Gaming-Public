local customZones = true
local customRadio = true
local customVehicleNames = true

setTimer ( function ( )
	customZones = tobool ( exports.NGPhone:getSetting ( "usersettings_usecustomhud" ) )
	customRadio = tobool ( exports.NGPhone:getSetting ( "usersettings_usecustomradio" ) )
	customVehicleNames = tobool ( exports.NGPhone:getSetting ( "usersettings_usecustomvehiclenames" ) )
end, 500, 1 )


local x, y, z = getElementPosition ( localPlayer )
local zone = getZoneName ( x, y, z )
local radioHud = {
	isRendering = false,
	y =  nil,
	alpha = nil,
	text = nil
}
local zoneHud = {
	isRendering = false,
	y =  nil,
	alpha = nil
}

function createBottomMovingText ( text )
	showPlayerHudComponent ( "radio", not customRadio )
	showPlayerHudComponent ( "area_name", not customZones )
	showPlayerHudComponent ( "vehicle_name", not customVehicleNames )
	
	radioHud.text = text
	if ( isTimer ( radioRemoveTimer ) ) then
		killTimer ( radioRemoveTimer )
	end
	radioHud.y =  0
	if not radioHud.isRendering then 
		addEventHandler ( "onClientPreRender", root, radioRender ) 
	end
	radioRemoveTimer = setTimer ( function  ( )
		radioHud.isRendering = false
	end, 3000, 1 )
	radioHud.isRendering = true
	radioHud.alpha = 255
	startRemoveTick = getTickCount ( ) + 200
end

addEventHandler ( "onClientPlayerRadioSwitch", localPlayer, function ( id ) 
	if ( customRadio ) then
		createBottomMovingText ( getRadioChannelName ( id ) ) 
	end
end )

addEventHandler ( "onClientPlayerVehicleEnter", root, function ( veh )
	if ( source == localPlayer and customVehicleNames ) then
		createBottomMovingText ( getVehicleNameFromModel ( getElementModel ( veh ) ) )
	end
end )



local sx, sy = guiGetScreenSize ( )
function radioRender ( )
	if radioHud.isRendering then
		showPlayerHudComponent ( "radio", false )
		dxDrawText ( radioHud.text, 2, radioHud.y+2, sx, ( sy / 1.2 )+radioHud.y, tocolor ( 0, 0, 0, radioHud.alpha ), 1.5, "default-bold", "center", "bottom" )
		dxDrawText ( radioHud.text, 0, 0, sx, ( sy / 1.2 )+radioHud.y, tocolor ( 220, 140, 0, radioHud.alpha ), 1.5, "default-bold", "center", "bottom" )
		radioHud.y =  radioHud.y + sy * 0.0025
		if ( getTickCount ( ) >= startRemoveTick ) then
			radioHud.alpha = radioHud.alpha - 3
			if ( radioHud.alpha < 0 ) then
				radioHud.isRendering = false
			end
		end
	else
		removeEventHandler ( "onClientPreRender", root, radioRender )
	end
end

local startremovetick_zone = getTickCount ( )
local DrawZoneHudRenderIsRendering = true
function DrawZoneHudRender ( ) 
	if not DrawZoneHudRenderIsRendering or not customZones then
		DrawZoneHudRenderIsRendering = false
		removeEventHandler ( "onClientPreRender", root, DrawZoneHudRender )
	end
	
	local x, y, z = getElementPosition ( localPlayer )
	if ( zone ~= getZoneName ( x, y, z ) ) then 
		zoneHud.isRendering = true
		zoneHud.y = sy / 4
		zoneHud.alpha = 255
		zone = getZoneName ( x, y, z )
		startremovetick_zone = getTickCount ( ) + 200
		showPlayerHudComponent ( "area_name", false )
	end
	if ( zoneHud.isRendering ) then 
		if ( zoneHud.y <= 0 or zoneHud.alpha <= 3 ) then
			zoneHud.isRendering = false
		end if ( getTickCount ( ) >= startremovetick_zone ) then
			zoneHud.alpha = zoneHud.alpha - 3
		end
		dxDrawText ( getZoneName ( x, y, z ), 2, zoneHud.y+2, sx, sy / 6, tocolor ( 0, 0, 0, zoneHud.alpha ), 1.5, "default-bold", "center", "top" )
		dxDrawText ( getZoneName ( x, y, z ), 0, zoneHud.y, sx, sy / 6, tocolor ( 220, 140, 0, zoneHud.alpha ), 1.5, "default-bold", "center", "top" )
		zoneHud.y =  zoneHud.y - sy * 0.0025
	end
end
addEventHandler ( "onClientPreRender", root, DrawZoneHudRender )

function tobool ( input )
	local input = tostring ( input ):lower ( )
	if ( input == "true" ) then
		return true
	elseif ( input == "false" ) then
		return false
	else
		return nil
	end
end


addEvent ( "onClientUserSettingChange", true )
addEventHandler ( "onClientUserSettingChange", root, function ( g, v )
	local v = tobool ( v )
	if ( g == "usersettings_usecustomradio" ) then
		customRadio = v
		showPlayerHudComponent ( "radio", not v )
	elseif ( g == "usersettings_usecustomvehiclenames" ) then
		customVehicleNames = v
		showPlayerHudComponent ( "vehicle_name", not v )
	elseif ( g == "usersettings_usecustomhud" ) then
		customZones = v
		if v then
			if not DrawZoneHudRenderIsRendering then
				addEventHandler ( "onClientPreRender", root, DrawZoneHudRender )
			end
		end
		DrawZoneHudRenderIsRendering = v
		showPlayerHudComponent ( "area_name", not tobool ( v ) )
	end
end )