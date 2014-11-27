------------------------------------------
-- 			    AdminShout				--
------------------------------------------
-- Developer: Braydon Davis				--
-- File: client.lua						--
-- Copywrite 2013 (C) Braydon Davis		--
-- All rights reserved.					--
------------------------------------------	

local msg = ""
local r, g, b = 255, 255, 0
window = guiCreateWindow(413, 364, 480, 169, "Shout All By xXMADEXx", false)
guiWindowSetSizable(window, false)
guiSetVisible ( window, false )
guiCreateLabel(18, 37, 81, 26, "Message:", false, window)
message = guiCreateEdit(97, 37, 371, 26, "", false, window)
guiCreateLabel(18, 80, 81, 26, "R, G, B:", false, window)
r2 = guiCreateEdit(99, 80, 91, 26, "255", false, window)
g2 = guiCreateEdit(190, 80, 91, 26, "255", false, window)
b2 = guiCreateEdit(281, 80, 91, 26, "0", false, window)
cPicker = guiCreateButton(371, 81, 97, 25, "Color Picker", false, window)
IncludeName = guiCreateCheckBox(18, 123, 125, 29, "Include My Name", true, false, window)
Cancel = guiCreateButton(143, 124, 119, 28, "Cancel", false, window)
Execute = guiCreateButton(272, 124, 119, 28, "Shout", false, window)    

addEvent ( "Shouts:onPlayerChangeMenu", true )
addEventHandler ( "Shouts:onPlayerChangeMenu", root, function  ()
	local tostate = not guiGetVisible ( window )
	guiSetVisible ( window, tostate )
	showCursor ( tostate )
	if ( tostate == true ) then
		guiSetInputMode ( "no_binds_when_editing" )
		return
	end
end )

addEventHandler ( "onClientGUIClick", root, function ( )
	if ( source == Cancel ) then
		guiSetText ( message, "" )
		guiSetVisible ( window, false )
		showCursor ( false )
	elseif ( source == Execute ) then
		if ( guiGetText ( message ) ~= "" ) then
			if ( guiGetText ( r2 ) ~= "" ) and ( guiGetText ( g2 ) ~= "" ) and ( guiGetText ( b2 ) ~= "" ) then
				triggerServerEvent ( "Shouts:onPlayerTriggerServerShout", localPlayer, guiGetText ( message ), guiCheckBoxGetSelected ( IncludeName ), guiGetText ( r2 ), guiGetText ( g2 ), guiGetText ( b2 ) )
				guiSetText ( message, "" )
				guiSetVisible ( window, false )
				showCursor ( false )
			else outputChatBox ( "You need to enter in all the colors.", 255, 0, 0 ) return end
		else outputChatBox ( "You need to enter a message.", 255, 0, 0 ) return end
	elseif ( source == cPicker ) then
		openPicker ( 59553532, "#000000", "Admin Shout Color Picker" )
	end
end )

addEvent ( "AS:onColorPickerOK", true )
addEventHandler ( "AS:onColorPickerOK", root, function ( _, _, r3, g3, b3 )
	guiSetText ( r2, r3 )
	guiSetText ( g2, g3 )
	guiSetText ( b2, b3 )
end )

addEvent ( "Shouts:onPlayerGetText", true )
addEventHandler ( "Shouts:onPlayerGetText", root, function ( inpu, r, g, b )
	msg = inpu
	rx = r
	gx = g 
	bx = b
	addEventHandler ( "onClientRender", root, drawMsg )
	setTimer ( function ( )	
		msg = "" 
		r = 255 
		g = 255
		b = 0
		removeEventHandler ( "onClientRender", root, drawMsg )
	end, 10000, 1 )
end )

local rx, ry = guiGetScreenSize ( )
function drawMsg ( )
	dxDrawBorderedText ( msg, 0, 0, rx, ry, tocolor ( rx, gx, bx, 255 ), 2.3, "default-bold", "center", "center", false, true, true )
end 

-- Thank you Castillo for this function --
function dxDrawBorderedText ( text, x, y, w, h, color, scale, font, alignX, alignY, clip, wordBreak, postGUI )
	local wh = 1
    dxDrawText ( text, x - wh, y - wh, w - wh, h - wh, tocolor ( 0, 0, 0, 255 ), scale, font, alignX, alignY, clip, wordBreak, false ) -- black
    dxDrawText ( text, x + wh, y - wh, w + wh, h - wh, tocolor ( 0, 0, 0, 255 ), scale, font, alignX, alignY, clip, wordBreak, false )
    dxDrawText ( text, x - wh, y + wh, w - wh, h + wh, tocolor ( 0, 0, 0, 255 ), scale, font, alignX, alignY, clip, wordBreak, false )
    dxDrawText ( text, x + wh, y + wh, w + wh, h + wh, tocolor ( 0, 0, 0, 255 ), scale, font, alignX, alignY, clip, wordBreak, false )
    dxDrawText ( text, x - wh, y, w - wh, h, tocolor ( 0, 0, 0, 255 ), scale, font, alignX, alignY, clip, wordBreak, false )
    dxDrawText ( text, x + wh, y, w + wh, h, tocolor ( 0, 0, 0, 255 ), scale, font, alignX, alignY, clip, wordBreak, false )
    dxDrawText ( text, x, y - wh, w, h - wh, tocolor ( 0, 0, 0, 255 ), scale, font, alignX, alignY, clip, wordBreak, false )
    dxDrawText ( text, x, y + wh, w, h + wh, tocolor ( 0, 0, 0, 255 ), scale, font, alignX, alignY, clip, wordBreak, false )
    dxDrawText ( text, x, y, w, h, color, scale, font, alignX, alignY, clip, wordBreak, postGUI )
end

