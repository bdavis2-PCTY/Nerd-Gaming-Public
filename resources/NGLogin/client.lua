------------------------------------------
-- 		 	  Dx Login Panel			--
------------------------------------------
-- Developer: Braydon Davis	(xXMADEXx)	--
-- File: client.lua						--
-- Copyright 2013 (C) Braydon Davis		--
-- All rights reserved.					--
------------------------------------------

local enableGuest = false;
local alphaChange = 3;
local clicked = false
local sx, sy = guiGetScreenSize ( )
local pX, pY = ( sx / 2 - 485 / 2 ), ( sy / 2 - 231 / 2 )
local username = guiCreateEdit(pX+156, pY+61, 288, 33, "", false)
guiSetVisible ( username, false )
local password = guiCreateEdit(pX+156, pY+121, 288, 33, "", false)
guiSetVisible ( password, false )
guiEditSetMasked(password, true)
local window = guiCreateWindow( ( sx / 2 - 266 / 2 ), ( sy / 2 - 208 / 2 ), 266, 208, "Login Panel Message", false)
guiWindowSetMovable(window, false)
guiWindowSetSizable(window, false)
guiSetVisible ( window, false )
guiSetAlpha ( window, 1 )
local exitBtn = guiCreateButton(155, 162, 101, 36, "Exit", false, window)
local infoLbl = guiCreateLabel(18, 26, 228, 130, "Message", false, window)

local intData = {
	start = { 0, 0 },
	_end = { 485, 231 },
	startTime = nil,
	endTime = nil,
	alpha = 0
}

local isOpen = false;
local isLoggedin = false;
local data = {
	login = {
		hovering = false,
		alphaMode = false,
		loginTextAlpha = 235,
		colors = { 255, 255, 255 }
	},
	reg = {
		hovering = false,
		alphaMode = false,
		loginTextAlpha = 235,
		colors = { 255, 255, 255 }
	},
	remember = {
		hovering = false,
		alphaMode = false,
		loginTextAlpha = 255,
		colors = { 255, 255, 255 },
		clicked = false
	}
}
function dxDrawLoginPanel( )
	-- default: 350, 266
	if not intData.startTime then
		intData.startTime = getTickCount ( )
		intData.endTime = getTickCount ( ) + 1500
		intData.isDone = false
	end
	
	if ( isOpen ) then
		local now = getTickCount ( )
		local elapsedTime = now - intData.startTime
		local duration = intData.endTime - intData.startTime
		local progress = elapsedTime / duration
		
		local start = intData.start
		local _end = intData._end
		local w, h, _ = interpolateBetween ( start[1], start[2], 0, _end[1], _end[2], 0,  progress, "OutBounce" )
		
		if ( now >= intData.endTime and not intData.isDone ) then
			intData.isDone = true 
			addEventHandler ( 'onClientCursorMove', root, cursorMove )
			addEventHandler ( "onClientClick", root, clientClicking )
			guiSetInputMode ( "no_binds_when_editing" )
			guiSetVisible ( password, true )
			guiSetVisible ( username, true )
			showCursor ( true )
			addEventHandler ( 'onClientGUIClick', root, clientClosingErrorWindowEvent )
		end
		dxDrawImage ( 0, 0, sx, sy, "files/back.png" )
		dxDrawRectangle((sx/2-w/2), (sy/2-h/2), w, h, tocolor(0, 0, 0, 180), false)
		
		if not intData.isDone then return end
		
		if ( intData.alpha < 255 ) then 
			intData.alpha = intData.alpha + 1
			guiSetAlpha ( password, intData.alpha / 255 )
			guiSetAlpha ( username, intData.alpha / 255 )
		end
		
		local alpha = intData.alpha
		
		dxDrawText("Login", pX, pY, pX+485, pY+48, tocolor(255, 255, 255, alpha), 1.50, "bankgothic", "center", "center", false, false, false, false, false)
		dxDrawLine(pX, pY+48, pX+485, pY+48, tocolor(255, 255, 255, alpha), 1, false)
		dxDrawText("Username:", pX+10, pY+69, 506, 368, tocolor(255, 255, 255, alpha), 0.80, "bankgothic", "left", "top", false, false, false, false, false)
		dxDrawText("Password:", pX+10, pY+129, 506, 428, tocolor(255, 255, 255, alpha), 0.80, "bankgothic", "left", "top", false, false, false, false, false)
		dxDrawLine(pX+281, pY+168, pX+281, pY+168+34, tocolor(255, 255, 255, alpha), 1, false)

		local r, g, b = unpack ( data.login.colors )
		dxDrawText("Login", pX+166, pY+167, 600, 468, tocolor( 0, 0, 0, alpha), 1.00, "bankgothic", "left", "top", false, false, false, false, false)
		dxDrawText("Login", pX+166, pY+167, 600, 468, tocolor( r, g, b, alpha), 1.00, "bankgothic", "left", "top", false, false, false, false, false)
		local r, g, b = unpack ( data.reg.colors )
		dxDrawText("Register", pX+305, pY+167, 794, 468, tocolor(0, 0, 0, alpha), 1.00, "bankgothic", "left", "top", false, false, false, false, false)
		dxDrawText("Register", pX+305, pY+167, 794, 468, tocolor(r, g, b, alpha), 1.00, "bankgothic", "left", "top", false, false, false, false, false)
		
		local r, g, b = unpack ( data.remember.colors )
		dxDrawText("Remember Login", pX+30, pY+177, 794, 468, tocolor(0, 0, 0, alpha), 1.00, "default-bold", "left", "top", false, false, false, false, false)
		dxDrawText("Remember Login", pX+30, pY+177, 794, 468, tocolor(r, g, b, alpha), 1.00, "default-bold", "left", "top", false, false, false, false, false)
		dxDrawLinedRectangle ( pX+9, pY+176, 14, 14, tocolor ( 0, 0, 0, alpha ), 1, false )
		dxDrawLinedRectangle ( pX+9, pY+176, 14, 14, tocolor ( r, g, b, alpha ), 1, false )
		
		if ( data.remember.clicked ) then 
			dxDrawImage ( pX+10, pY+177, 13, 13, "files/check.png", 0, 0, 0, tocolor ( 255, 255, 255, alpha ) ) 
		end
		
		-- give fade effect
		if ( data.login.hovering ) then
			data.login.colors = { 255, 140, 0 }
			local alpha = data.login.loginTextAlpha
		elseif ( data.reg.hovering ) then
			data.reg.colors = { 255, 140, 0 }
		elseif ( data.remember.hovering ) then
			data.remember.colors = { 255, 140, 0 }
		else
			data.login.loginTextAlpha = 235
			data.reg.loginTextAlpha = 235
			data.remember.loginTextAlpha = 235
			data.login.colors = { 255, 255, 255 }
			data.reg.colors = { 255, 255, 255 }
			data.remember.colors = { 255, 255, 255 }
		end
	end
end

function cursorMove ( _, _, x, y )
	if ( isCursorShowing ( ) and not guiGetVisible ( window ) and isOpen) then
		if ( y >=  pY+170 and y <=  pY+200 and intData.isDone ) then
			if ( x >= pX+161 and x <= pX+251 ) then
				data.login.hovering = true
				return
			elseif ( x >= pX+305 and x <= pX+445 ) then
				data.reg.hovering = true
				return
			elseif ( x >= pX+8 and x <= pX + 130 ) then
				data.remember.hovering = true;
				return
			end
		end
	end
	data.login.hovering = false
	data.reg.hovering = false
	data.remember.hovering = false
end

function openLogin ( )
	clicked = false
	addEventHandler ( "onClientPreRender", root, dxDrawLoginPanel )
	isOpen = true
	showChat(false)
	showPlayerHudComponent ( 'all', false )
	
	local f = xmlLoadFile ( '@data.xml', 'account' )
	if f then
		local user = xmlNodeGetAttribute ( xmlFindChild ( f, 'user', 0 ), 'value' )
		local pass = xmlNodeGetAttribute ( xmlFindChild ( f, 'pass', 0 ), 'value' )
		guiSetText ( username, tostring ( user ) )
		guiSetText ( password, tostring ( pass ) )
		if ( user ~= "" or pass ~= "" ) then
			data.remember.clicked = true
		end
	end
	xmlUnloadFile ( f )
end
addEvent ( "onClientPlayerLogout", true )
addEventHandler ( 'onClientPlayerLogout', root, openLogin )
addEvent ( "NGLogin:OnServerGiveClientAutherizationForLogin", true )
addEventHandler ( "NGLogin:OnServerGiveClientAutherizationForLogin", root, openLogin ) 

function closeLogin ( user, _, intro, ip )
	clicked = false
	removeEventHandler ( "onClientPreRender", root, dxDrawLoginPanel )
	removeEventHandler ( 'onClientCursorMove', root, cursorMove )
	removeEventHandler ( "onClientClick", root, clientClicking )
	guiSetVisible ( password, false )
	guiSetVisible ( username, false )
	showCursor ( false )
	removeEventHandler ( 'onClientGUIClick', root, clientClosingErrorWindowEvent )
	guiSetVisible ( window, false )
	isOpen = false
	isLoggedin = true
	
	local f = xmlCreateFile ( "@data.xml", "account" )
	local user, pass = "", "" 
	if ( data.remember.clicked ) then
		user = guiGetText ( username )
		pass = guiGetText ( password )
	end
	xmlNodeSetAttribute ( xmlCreateChild ( f, "user" ), "value", user )
	xmlNodeSetAttribute ( xmlCreateChild ( f, "pass" ), "value", pass )
	xmlSaveFile ( f )
	xmlUnloadFile ( f )
	
	if ( intro ) then
	
		startIntro ( )
	
	else
		showChat(true)
		showPlayerHudComponent ( 'all', true )
		fadeCamera ( true )
		setCameraTarget ( localPlayer )
	end
	
	setElementData(localPlayer,"AccountData:Username",tostring(user))
	setElementData ( localPlayer, "AccountData:Serial", getPlayerSerial ( ) )
	setElementData ( localPlayer, "AccountData:IP", ip )
	
	if ( sx < 1000 or sy < 700 ) then
		for i=1, 3 do 
			outputChatBox ( "You're playing in a small resolution, some GUI elements may not appear correctly. Please play in a higher resolution", 255, 0, 0 )
		end
	end
end
addEvent ( "onClientPlayerLogin", true )
addEvent ( "NGLogin:hideLoginPanel", true )
addEventHandler ( "onClientPlayerLogin", root, closeLogin )
addEventHandler ( "NGLogin:hideLoginPanel", root, closeLogin )

function sendError ( msg )
	if ( not guiGetVisible ( window ) ) then
		guiSetVisible ( window, true )
		guiSetText ( infoLbl, msg )
		guiBringToFront ( window )
		clicked = false
	end
end
addEvent ( "onPlayerLoginPanelError", true )
addEventHandler ( "onPlayerLoginPanelError", root, sendError )

function clientClicking ( btn, state, x, y )
	if clicked then return end
	if ( btn == 'left' and not guiGetVisible ( window ) and state == 'down' and isOpen and intData.isDone ) then
		if ( y >=  pY+170 and y <=  pY+200 ) then
			local user, pass = guiGetText ( username ), guiGetText ( password )
			-- Login Button --
			if ( x >= pX+156 and x <= pX+246 ) then
				if ( string.gsub ( user, ' ', '' ) ~= '' and string.gsub ( pass, ' ', '' ) ~= '' ) then
					if ( string.find ( user, '%s' ) ) then
						return sendError ( "Spaces (' ') are not allowed\nin the username." )
					end if ( string.find ( pass, '%s' ) ) then
						return sendError ( "Spaces (' ') are not allowed\nin the password." )
					end
					triggerServerEvent ( "Login:onClientAttemptLogin", localPlayer, user, pass )
					playSound( "files/click.mp3" )
					clicked = true
				else
					sendError ( "A username and password are\nrequired to access the server." )
				end

			-- register button
			elseif ( x >= pX+300 and x <= pX+440 ) then
				if ( string.gsub ( user, ' ', '' ) ~= '' and string.gsub ( pass, ' ', '' ) ~= '' ) then
					if ( string.find ( user, '%s' ) ) then
						return sendError ( "Spaces are not allowed\nin the username." )
					end if ( string.find ( pass, '%s' ) ) then
						return sendError ( "Spaces are not allowed\nin the password." )
					end if ( string.len ( user ) < 5 ) then
						return sendError ( "You're username must be at\nleast 5 characters long." )
					end if ( string.len ( pass ) < 6 ) then
						return sendError ( "You're password must be at\nleast 6 characters long." )
					end
					triggerServerEvent ( "Login:onClientAttemptRegistration", localPlayer, user, pass )
					playSound( "files/click.mp3" )
					clicked = true
				else
					sendError ( "A username and password are\nrequired to access the server." )
				end
			elseif ( x >= pX+8 and x <= pX + 130 ) then
				data.remember.clicked = not data.remember.clicked
			end
		end
	end
end

function clientClosingErrorWindowEvent( )
	if ( source == exitBtn ) then
		guiSetVisible ( window, false )
	end
end

function isClientLoggedin ( )
	return isLoggedin
end

setTimer ( triggerServerEvent, 200, 1, "NGLogin:RequestClientLoginConfirmation", localPlayer )

function dxDrawLinedRectangle( x, y, width, height, color, _width, postGUI )
	local _width = _width or 1
	dxDrawLine ( x, y, x+width, y, color, _width, postGUI ) -- Top
	dxDrawLine ( x, y, x, y+height, color, _width, postGUI ) -- Left
	dxDrawLine ( x, y+height, x+width, y+height, color, _width, postGUI ) -- Bottom
	return dxDrawLine ( x+width, y, x+width, y+height, color, _width, postGUI ) -- Right
end