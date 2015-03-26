local ban = nil

local sx, sy = guiGetScreenSize ( )
local rsx, rsy = sx, sy
local sx, sy = sx/1280, sy/960
local open = false
local banY = -(rsy/1.2)

local font_size =(sx+sy)

function drawBanScreen ( )
	if not startTime then
		startTime = getTickCount ( )
	end if not endTime then 
		endTime = getTickCount ( ) + 3500
	end
	local now = getTickCount()
	local elapsedTime = now - startTime
	local duration = endTime - startTime
	local progress = elapsedTime / duration
	local _, y, _ = interpolateBetween ( 0, -(rsy/1.2), 0, 0, 0, 0,  progress, "OutBack" )
	banY = y
	
	dxDrawBoarderedText("You are banned from Nerd Gaming!", 0, banY, sx*1280, banY+sy*98, tocolor(255, 0, 0, 255), 3, "default", "center", "center", false, false, true, false, false)
	
	dxDrawRectangle(sx*87, banY+sy*189, sx*152, sy*40, tocolor(0, 0, 0, 138), true)
	dxDrawText("Serial", sx*103, banY+sy*189, sx*239, banY+sy*229, tocolor(255, 255, 255, 255), font_size, "default", "left", "center", true, false, true, false, false)
	dxDrawRectangle(sx*249, banY+sy*189, sx*563, sy*40, tocolor(0, 0, 0, 138), true)
	dxDrawText(ban.serial, sx*259, banY+sy*189, sx*812, banY+sy*229, tocolor(255, 255, 255, 255), font_size, "default", "left", "center", true, false, true, false, false)
	
	dxDrawRectangle(sx*87, banY+sy*249, sx*152, sy*40, tocolor(0, 0, 0, 138), true)
	dxDrawText("IP", sx*103, banY+sy*249, sx*239, banY+sy*289, tocolor(255, 255, 255, 255), font_size, "default", "left", "center", true, false, true, false, false)
	dxDrawRectangle(sx*249, banY+sy*249, sx*563, sy*40, tocolor(0, 0, 0, 138), true)
	dxDrawText(ban.ip, sx*259, banY+sy*249, sx*812, banY+sy*289, tocolor(255, 255, 255, 255), font_size, "default", "left", "center", true, false, true, false, false)
	
	dxDrawRectangle(sx*87, banY+sy*309, sx*152, sy*40, tocolor(0, 0, 0, 138), true)
	dxDrawText("Account", sx*103, banY+sy*309, sx*239, banY+sy*349, tocolor(255, 255, 255, 255), font_size, "default", "left", "center", true, false, true, false, false)
	dxDrawRectangle(sx*249, banY+sy*309, sx*563, sy*40, tocolor(0, 0, 0, 138), true)
	dxDrawText(ban.account, sx*259, banY+sy*309, sx*812, banY+sy*349, tocolor(255, 255, 255, 255), font_size, "default", "left", "center", true, false, true, false, false)
	
	dxDrawRectangle(sx*87, banY+sy*369, sx*152, sy*40, tocolor(0, 0, 0, 138), true)
	dxDrawText("Until", sx*103, banY+sy*369, sx*239, banY+sy*409, tocolor(255, 255, 255, 255), font_size, "default", "left", "center", true, false, true, false, false)
	dxDrawRectangle(sx*249, banY+sy*369, sx*563, sy*40, tocolor(0, 0, 0, 138), true)
	dxDrawText(ban.unban, sx*259, banY+sy*369, sx*812, banY+sy*409, tocolor(255, 255, 255, 255), font_size, "default", "left", "center", true, false, true, false, false)
	
	dxDrawRectangle(sx*87, banY+sy*429, sx*152, sy*40, tocolor(0, 0, 0, 138), true)
	dxDrawText("Banned On", sx*103, banY+sy*429, sx*239, banY+sy*469, tocolor(255, 255, 255, 255), font_size, "default", "left", "center", true, false, true, false, false)
	dxDrawRectangle(sx*249, banY+sy*429, sx*563, sy*40, tocolor(0, 0, 0, 138), true)
	dxDrawText(ban.banned_on, sx*259, banY+sy*429, sx*812, banY+sy*469, tocolor(255, 255, 255, 255), font_size, "default", "left", "center", true, false, true, false, false)
	
	dxDrawRectangle(sx*87, banY+sy*489, sx*152, sy*40, tocolor(0, 0, 0, 138), true)
	dxDrawText("Banned By", sx*103, banY+sy*489, sx*239, banY+sy*529, tocolor(255, 255, 255, 255), font_size, "default", "left", "center", true, false, true, false, false)
	dxDrawRectangle(sx*249, banY+sy*489, sx*563, sy*40, tocolor(0, 0, 0, 138), true)
	dxDrawText(ban.banner, sx*259, banY+sy*489, sx*812, banY+sy*529, tocolor(255, 255, 255, 255), font_size, "default", "left", "center", true, false, true, false, false)
	
	dxDrawRectangle(sx*87, banY+sy*549, sx*152, sy*40, tocolor(0, 0, 0, 138), true)
	dxDrawText("Reason", sx*103, banY+sy*549, sx*239, banY+sy*589, tocolor(255, 255, 255, 255), font_size, "default", "left", "center", true, false, true, false, false)
	dxDrawRectangle(sx*249, banY+sy*549, sx*563, sy*40, tocolor(0, 0, 0, 138), true)
	dxDrawText(ban.reason, sx*259, banY+sy*549, sx*812, banY+sy*589, tocolor(255, 255, 255, 255), font_size, "default", "left", "center", true, false, true, false, false)
	
	dxDrawBoarderedText("Appeal @ nerdgaming.org", sx*87, banY+sy*609, sx*812, banY+sy*649, tocolor(255, 255, 255, 255), 2, "default", "center", "center", true, false, true, false, false, 0, 0, 0, 2)
end

addEvent ( "NGBans:OpenClientBanScreen", true )
addEventHandler ( "NGBans:OpenClientBanScreen", root, function ( d )
	ban = d
	if ( tonumber ( ban.unban_month ) and tonumber ( ban.unban_month ) < 10 )  then
		ban.unban_month = "0"..ban.unban_month
	end if ( tonumber ( ban.unban_day ) and tonumber ( ban.unban_day ) < 10 )  then
		ban.unban_day = "0"..ban.unban_day
	end

	ban.unban = table.concat ({ tostring(ban.unban_year), tostring(ban.unban_month), tostring(ban.unban_day) }, "-" )
	if ( tostring ( ban.unban ):upper() == "NIL" ) then
		ban.unban = "Forever"
	end
	
	if open then return end
	open = true
	addEventHandler ( "onClientPreRender", root, drawBanScreen )
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
	