----------------------------------------------
-- Author: Braydon Davis / xXMADEXx			--
-- Project: Community - Ammunation DX		--
-- File: client-side.lua					--
-- Copyright (C) 2013-2014 					--
-- All Rights Reserved						--
----------------------------------------------

--
-- warps
-- LS
exports.ngwarpmanager:makeWarp ( { pos = { 1367.63, -1279.82, 14.55 }, toPos = { 286.15,-40.65,1001.52 }, cInt = 0, cDim = 0, tInt = 1, tDim = 0 } )
exports.ngwarpmanager:makeWarp ( { pos = { 285.94, -41, 1002.52 }, toPos = { 1367.63, -1279.82, 14.55 }, cInt = 1, cDim = 0, tInt = 0, tDim = 0 } )

-- LV
exports.ngwarpmanager:makeWarp ( { pos = { 2159.45, 943.09, 11.82 }, toPos = { 286.15,-40.65,1001.52 }, cInt = 0, cDim = 0, tInt = 1, tDim = 1 } )
exports.ngwarpmanager:makeWarp ( { pos = { 285.3, -40.64, 1002.52 }, toPos = { 2159.45, 943.09, 10.82 }, cInt = 1, cDim = 1, tInt = 0, tDim = 0 } )


local blips = { }
local outsideLocations = {
	{ 1366.68, -1281.1, 13.55 },
	{ 2159.45, 943.09, 10.82 }
}

addEvent ( "onClientPlayerLogin", true )
addEventHandler ( "onClientPlayerLogin", root, function ( ) 
	local cb = exports.NGPhone:getSetting ( "usersetting_display_createammunationblips" )
	if cb then
		for i, v in pairs ( outsideLocations ) do
			local x, y, z = unpack ( v )
			blips[i] = createBlip ( x, y, z, 6, 2, 255, 255, 255, 255, 0, 450 ) 
		end
	end
end )

addEvent ( "onClientUserSettingChange", true )
addEventHandler ( "onClientUserSettingChange", root, function ( g, v )
	if ( g == "usersetting_display_createammunationblips" ) then
		for i, v in pairs ( blips ) do
			destroyElement ( blips [ i ] )
			blips [ i ] = nil
		end
		blips = { }
		if v then
			for i, v in pairs ( outsideLocations ) do
				local x, y, z = unpack ( v )
				blips[i] = createBlip ( x, y, z, 6, 2, 255, 255, 255, 255, 0, 450 ) 
			end
		end
	end
end )

local marker = createMarker ( 295.93292, -37.88273, 1000.5156, "cylinder", 1.2, 255, 255, 0, 200 )
setElementInterior ( marker, 1 )

setTimer ( setElementDimension, 500, 0, marker, localPlayer.dimension )

local alpha = 255
local g_aMode = false
local g_flashSpeed = 3
local menuX = -350
local menuMoveSpeed = 10
local items = {
	--[[ { "cad Name" {
			{ "Weapon name", weapon id, price },
			{ "Weapon name", weapon id, price },
		} }]]
		
	{ "Pistols", {
		{ "9mm", 22, 240 },
		{ "Silenced 9mm", 23, 720 },
		{ "Desert Eagle", 24, 1440 }
	} },
	
	{ "Micro SMGs", {
		{ "Tec-9", 32, 360 },
		{ "Micro SMF/Uzi", 28, 600 }
	} },
	
	{ "Shotguns", {
		{ "Shotgun", 25, 720 },
		{ "Sawnoff", 26, 960 },
		{ "Combat Shotgun", 27, 1200 },
	} },
	
	{ "Thrown", { 
		{ "Grenade", 16, 360 },
		{ "Remote Explosive", 39, 2400 }
	} },
	
	{ "Armor", { 
		{ "Body Armor", nil, 240 }
	} },
	
	{ "SMG", { 
		{ "SMG/MP5", 29, 2400 }
	} },
	
	{ "Rifles", { 
		{ "Rifle", 33, 1200 },
		{ "Sniper Rifle", 34, 6000 }
	} },
	
	{ "Assault", { 
		{ "AK47", 30, 4200 },
		{ "M4", 31, 5400 }
	} },
	
}
local selectedI = 1
local maxI = #items
local menu = "main"
local isOpen = false
local loadedI = nil
local sx, sy = guiGetScreenSize ( )
local rSX, rSY = sx / 1280, sx / 1024

function setMenuOpen ( bool )
	isOpen = bool
	if ( bool ) then
		addEventHandler ( "onClientRender", root, dxDrawInterface )
		menu = "main"
		selectedI = 1
		maxI = #items
		bindTheyKeys ( true )
		toggleAllControls ( false, true, false )
	end
end

local text_y = ( sy / 2 - ( rSY * 374 ) / 2 ) - ( rSY * 27 )
function dxDrawInterface( )
	if ( isOpen ) then
		if ( menuX ~= rSX*20 ) then
			if ( menuX > rSX*20 ) then
				menuX = rSX*20
			else
				menuX = menuX + rSX*menuMoveSpeed
			end
		end
	end

	dxDrawRectangle ( sx - ( rSX * 300 ), sy / 2 - ( rSY * 150 ) /2 , rSX*280, rSY*150, tocolor(0, 0, 0, 200), false )
	dxDrawLinedRectangle ( sx - ( rSX * 300 ), sy / 2 - ( rSY * 150) /2, rSX*280, rSY*150, tocolor ( 0, 0, 0, 255 ), rSY*2, false )
	dxDrawBorderedText ("Help", sx - ( rSX * 300 ), sy / 2 - ( rSY * 150 ) /2 - ( rSY * 20 ), sx - ( rSX * 20 ), sy / 2 - ( rSY * 150 ) /2 + ( rSY * 20 ), tocolor(255, 255, 255, 255), rSY*2.30, "beckett", "center", "center", false, false, false, false, false)
	dxDrawText ( "Use up and down arrow keys to navigate", sx - rSX*290,  sy / 2 - rSY*150 /2 + rSY*35, 0, 0, tocolor(255, 255, 255, 255), rSY*0.85, "default-bold", "left", "top", false, false, false, false, false)
	dxDrawText ( "Use space to select", sx - rSX*290,  sy / 2 - rSY*150 /2 + rSY*55, 0, 0, tocolor(255, 255, 255, 255), rSY*0.85, "default-bold", "left", "top", false, false, false, false, false)
	dxDrawText ( "Use backspace to go back or exit", sx - rSX*290,  sy / 2 - rSY*150 /2 + rSY*75, 0, 0, tocolor(255, 255, 255, 255), rSY*0.85, "default-bold", "left", "top", false, false, false, false, false)

	dxDrawRectangle(menuX, ( sy / 2 - rSY*374 / 2 ), rSX*325, rSY*374, tocolor(0, 0, 0, 200), false)
	dxDrawLinedRectangle ( menuX, ( sy / 2 - rSY*374 / 2 ), rSX*325, rSY*374, tocolor ( 0, 0, 0, 255 ), rSY*2, false )
	dxDrawBorderedText ("Ammu-Nation", menuX, ( sy / 2 - rSY*374 / 2 )-rSY*15, menuX+rSX*325, rSY*324, tocolor(255, 255, 255, 255), rSY*2, "beckett", "center", "top", false, false, false, false, false)
	if ( menu == "main" ) then
		for i, v in ipairs ( items ) do
			if ( i ~= selectedI ) then
				dxDrawBorderedText ( v[1], menuX+rSX*20, text_y+(rSY*36)+(rSY*(40*i)), menuX+rSX*30, rSY*50, tocolor ( 0, 50, 100, 255 ), rSY*1.4, "default-bold" )
			else
				dxDrawBorderedText ( v[1], menuX+rSX*20, text_y+rSY*(36+(40*i)), menuX+rSX*310, rSY*50, tocolor ( 0, 100, 200, alpha ), rSY*1.4, "default-bold" )
			end
		end
	else
		for i, v in ipairs ( items[loadedI][2] ) do
			if ( i ~= selectedI ) then
				dxDrawBorderedText ( v[1], menuX+rSX*20, text_y+rSY*(36+(40*i)), menuX+rSX*30, rSY*50, tocolor ( 0, 50, 100, 255 ), rSY*1.4, "default-bold" )
				dxDrawBorderedText ( tostring ( "$"..v[3] ), rSX*40, text_y+rSY*(36+(40*i)), menuX+rSX*310, rSY*50, tocolor ( 0, 50, 100, 255 ), rSY*1.4, "default-bold", "right" )
			else
				dxDrawBorderedText ( v[1], menuX+rSX*20, text_y+rSY*(36+(40*i)), menuX+rSX*30, rSY*50, tocolor ( 0, 100, 200, alpha ), rSY*1.4, "default-bold" )
				dxDrawBorderedText ( tostring ( "$"..v[3] ), rSX*40, text_y+rSY*(36+(40*i)), menuX+rSX*310, rSY*50, tocolor ( 0, 100, 200, alpha ), rSY*1.4, "default-bold", "right" )
			end
		end
	end
	if ( not g_aMode ) then
		alpha = alpha - g_flashSpeed
		if ( alpha <= 50 ) then
			g_aMode = true
		end
	else
		alpha = alpha + g_flashSpeed
		if  ( alpha >= 255 ) then
			g_aMode = false
		end
	end
	if ( not isOpen ) then
		if ( menuX ~= - 350 and menuX > -350 ) then
			menuX = menuX - menuMoveSpeed
		else
			removeEventHandler ( "onClientRender", root, dxDrawInterface )
			menu = "main"
			selectedI = 1
			maxI = #items
			bindTheyKeys ( false )
			toggleAllControls ( true, true, false )
		end
	end
end

function dxDrawBorderedText ( text, x, y, w, h, color, scale, font, alignX, alignY, clip, wordBreak, postGUI, color2 )
	local wh = 2
	local msg_gsub = text:gsub ( '#%x%x%x%x%x%x', '' )
    dxDrawText ( msg_gsub, x - wh, y - wh, w - wh, h - wh, tocolor ( 0, 0, 0, 255 ), scale, font, alignX, alignY, clip, wordBreak, false ) -- black
    dxDrawText ( msg_gsub, x + wh, y - wh, w + wh, h - wh, tocolor ( 0, 0, 0, 255 ), scale, font, alignX, alignY, clip, wordBreak, false )
    dxDrawText ( msg_gsub, x - wh, y + wh, w - wh, h + wh, tocolor ( 0, 0, 0, 255 ), scale, font, alignX, alignY, clip, wordBreak, false )
    dxDrawText ( msg_gsub, x + wh, y + wh, w + wh, h + wh, tocolor ( 0, 0, 0, 255 ), scale, font, alignX, alignY, clip, wordBreak, false )
    dxDrawText ( msg_gsub, x - wh, y, w - wh, h, tocolor ( 0, 0, 0, 255 ), scale, font, alignX, alignY, clip, wordBreak, false )
    dxDrawText ( msg_gsub, x + wh, y, w + wh, h, tocolor ( 0, 0, 0, 255 ), scale, font, alignX, alignY, clip, wordBreak, false )
    dxDrawText ( msg_gsub, x, y - wh, w, h - wh, tocolor ( 0, 0, 0, 255 ), scale, font, alignX, alignY, clip, wordBreak, false )
    dxDrawText ( msg_gsub, x, y + wh, w, h + wh, tocolor ( 0, 0, 0, 255 ), scale, font, alignX, alignY, clip, wordBreak, false )
    dxDrawText ( text, x, y, w, h, color, scale, font, alignX, alignY, clip, wordBreak, postGUI, color2 )
end

function dxDrawLinedRectangle( x, y, width, height, color, _width, postGUI )
	local _width = _width or 1
	dxDrawLine ( x, y, x+width, y, color, _width, postGUI ) -- Top
	dxDrawLine ( x, y, x, y+height, color, _width, postGUI ) -- Left
	dxDrawLine ( x, y+height, x+width, y+height, color, _width, postGUI ) -- Bottom
	return dxDrawLine ( x+width, y, x+width, y+height, color, _width, postGUI ) -- Right
end

local binding = { }
function binding.d ( )
	if ( selectedI+1 <= maxI ) then
		selectedI = selectedI + 1
	else
		selectedI = 1
	end
	alpha = 255
	g_aMode = false
	playSoundFrontEnd ( 0 )
end
function binding.u ( )
	if ( selectedI-1 > 0 ) then
		selectedI = selectedI - 1
	else
		selectedI = maxI
	end
	alpha = 255
	g_aMode = false
	playSoundFrontEnd ( 0 )
end
function binding.back ( )
	if ( menu == "main" ) then
		setMenuOpen ( false )
	else
		selectedI = 1
		maxI = #items
		menu = "main"
		loadedI = nil
	end
	alpha = 255
	g_aMode = false
	playSoundFrontEnd ( 2 )
end
function binding.select ( )
	playSoundFrontEnd ( 1 )
	if ( menu == "main" ) then
		for i, v in ipairs ( items ) do
			if ( i == selectedI ) then
				menu = v[1]
				selectedI = 1
				loadedI = i
				maxI = #items[i][2]
				return
			end
		end
	else
		local i = items[loadedI][2][selectedI]
		local name, id, price = i[1], i[2], i[3]
		triggerServerEvent ( "Ammunation:onClientBuyWeapon", localPlayer, name, id, price )
	end
end

function bindTheyKeys ( bool )
	if ( bool ) then
		bindKey ( "arrow_d", "down", binding.d )
		bindKey ( "arrow_u", "down", binding.u )
		bindKey ( "backspace", "down", binding.back )
		bindKey ( "space", "down", binding.select )
	else
		unbindKey ( "arrow_d", "down", binding.d )
		unbindKey ( "arrow_u", "down", binding.u )
		unbindKey ( "backspace", "down", binding.back )
		unbindKey ( "space", "down", binding.select )
	end
end





addEventHandler ( "onClientMarkerHit", marker, function ( p )
	if ( p == localPlayer ) then
		setMenuOpen ( true )
	end
end ) addEventHandler ( "onClientMarkerLeave", marker, function ( p )
	if ( p == localPlayer ) then
		setMenuOpen ( false )
	end
end ) addEventHandler ( "onClientResourceStop", resourceRoot, function ( )
	if ( isOpen ) then
		toggleAllControls ( true, true, false )
	end
end )

--setMenuOpen ( true )
