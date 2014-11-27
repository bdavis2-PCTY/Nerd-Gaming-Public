
local counter = 0
local peak = 0
local ping = 0
local maxPing = 10000
local starttick = getTickCount ( )
local temp = ""
local sx, sy = guiGetScreenSize ( )
local renderText = false
local tick_2 = getTickCount ( )

addEvent ( "onClientPlayerLogin", true )
addEventHandler ( "onClientPlayerLogin", root, function ( ) 
	renderText = exports.NGPhone:getSetting ( "usersettings_display_clienttoserverstats" )
end )

addEvent ( "onClientUserSettingChange", true )
addEventHandler ( "onClientUserSettingChange", root, function ( cad, val )
	if ( cad == "usersettings_display_clienttoserverstats") then
		renderText = val
	end
end )

addEventHandler("onClientRender",root, function()
	counter = counter + 1
	if ( getTickCount ( ) - starttick ) >= 1000 then
		temp = counter
		counter = 0
		starttick = getTickCount ( )
		ping = getPlayerPing ( localPlayer )
		if ( ping < maxPing ) then
			maxPing = ping
		end

		if ( temp < 10 and exports.NGPhone:getSetting ( "usersettings_display_lowfpswarning" ) and tick_2-getTickCount () >= 5000 ) then
			exports["NGMessages"]:sendClientMessage ( "Low FPS warning. Use F3->Settings->Performance->Save to try to boost your FPS", 255, 0, 0 )
			tick_2 = getTickCount ( )
		end

		if ( temp > peak ) then
			peak = temp
		end
	end

	if ( renderText ) then
		dxDrawBoarderedText ( "Current FPS: "..tostring(temp).." | FPS Peak: "..tostring(peak).." | Current Ping: "..tostring(ping) .. " | Lowest Ping: "..tostring(maxPing), 15, sy/1.03, 0, 0)
	end
end )

function dxDrawBoarderedText ( text, x, y, endX, endY, color, size, font, alignX, alignY, clip, wordBreak, postGUI, colorCode, subPixelPos, fRot, fRotCX, fRotCY, offSet )
	local text = tostring ( text )
	local x = tonumber(x) or 0
	local y = tonumber(y) or 0
	local endX = tonumber(endX) or x
	local endY = tonumber(endY) or y
	local color = color or tocolor ( 255, 255, 255, 255 )
	local size = tonumber(size) or 1
	local font = font or "default"
	local alignX = alignX or "left"
	local alignY = alignY or "top"
	local clip = clip or false
	local wordBreak = wordBreak or false
	local postGUI = postGUI or false
	local colorCode = colorCode or false
	local subPixelPos = subPixelPos or false
	local fRot = tonumber(fRot) or 0
	local fRotCX = tonumber(fRotCX) or 0
	local fRotCY = tonumber(fRotCy) or 0
	local offSet = tonumber(offSet) or 1
	local t_g = text:gsub ( "#%x%x%x%x%x%x", "" )
	dxDrawText ( t_g, x-offSet, y-offSet, endX, endY, tocolor(0,0,0,255), size, font, alignX, alignY, clip, wordBreak, postGUI, colorCode, subPixelPos, fRot, fRotCX, fRotCY, offSet )
	dxDrawText ( t_g, x-offSet, y, endX, endY, tocolor(0,0,0,255), size, font, alignX, alignY, clip, wordBreak, postGUI, colorCode, subPixelPos, fRot, fRotCX, fRotCY, offSet )
	dxDrawText ( t_g, x, y-offSet, endX, endY, tocolor(0,0,0,255), size, font, alignX, alignY, clip, wordBreak, postGUI, colorCode, subPixelPos, fRot, fRotCX, fRotCY, offSet )
	dxDrawText ( t_g, x+offSet, y+offSet, endX, endY, tocolor(0,0,0,255), size, font, alignX, alignY, clip, wordBreak, postGUI, colorCode, subPixelPos, fRot, fRotCX, fRotCY, offSet )
	dxDrawText ( t_g, x+offSet, y, endX, endY, tocolor(0,0,0,255), size, font, alignX, alignY, clip, wordBreak, postGUI, colorCode, subPixelPos, fRot, fRotCX, fRotCY, offSet )
	dxDrawText ( t_g, x, y+offSet, endX, endY, tocolor(0,0,0,255), size, font, alignX, alignY, clip, wordBreak, postGUI, colorCode, subPixelPos, fRot, fRotCX, fRotCY, offSet )
	return dxDrawText ( text, x, y, endX, endY, color, size, font, alignX, alignY, clip, wordBreak, postGUI, colorCode, subPixelPos, fRot, fRotCX, fRotCY, offSet )
end



function getPlayerFPS ( )
	return temp
end