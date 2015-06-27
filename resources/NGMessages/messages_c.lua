local useTopbar = true
local joinquit = true
local namechanges = true
local sx, sy  = guiGetScreenSize ( )
local rsx, rsy = sx / 1280, sy / 1024

addEvent ( "onClientPlayerLogin", true )
addEventHandler ( "onClientPlayerLogin", root, function ( ) 
	useTopbar = tobool ( exports.NGPhone:getSetting ( "usersettings_usetopbar" ) )
	joinquit = tobool ( exports.NGPhone:getSetting ( "usersetting_notification_joinquitmessages" ) )
	namechanges = tobool ( exports.NGPhone:getSetting ( "usersetting_notification_nickchangemessages" ) )
	if not useTopbar then
		useTopbar = false
		removeEventHandler ( "onClientRender", root, dxDrawNotificationBar )
	end
end )

addEvent ( "onClientUserSettingChange", true )
addEventHandler ( "onClientUserSettingChange", root, function ( g, v ) 
	if ( g == "usersettings_usetopbar" ) then
		if not tobool ( v ) and useTopbar then
			useTopbar = false
			removeEventHandler ( "onClientRender", root, dxDrawNotificationBar )
		elseif tobool ( v ) and not useTopbar then 
			useTopbar = true
			addEventHandler ( "onClientRender", root, dxDrawNotificationBar )
		end
	elseif ( g == "usersetting_notification_joinquitmessages" ) then
		joinquit = v
	elseif ( g == "usersetting_notification_nickchangemessages" ) then
		namechanges = v
	end
end )

local maxMessages = 5;
local DefaultTime = 8;
local moveSpeed = 2;
local sx, sy = guiGetScreenSize ( )
local DefaultPos = true;
local messages_top = { }
local toDo = { }
local messageDelay = 500
local TheResourceName = getResourceName ( getThisResource ( ) )
local lastAutoMessage = 1
local t = 0

function sendClientMessage ( msg, r, g, b, img, checkImgPath )
	
	if ( checkImgPath == nil ) then checkImgPath = true; end

	if ( img and sourceResource and checkImgPath ) then 
		img = ":"..tostring(getResourceName(sourceResource)).."/"..img;
	end 
	
	return _sendClientMessage ( msg, r, g, b, img );
end 


function _sendClientMessage ( msg, r, g, b, img )
	
	if ( useTopbar ) then
		if ( not exports.NGLogin:isClientLoggedin ( ) ) then return end
		local msg, r, g, b = tostring ( msg ), tonumber ( r ) or 255, tonumber ( g ) or 255, tonumber ( b ) or 255
		
		local img = img or "";
		
		if ( img ~= "" and not fileExists ( img ) ) then 
			img = ""
		end
		
		local data = { 
			msg, 
			r, 
			g, 
			b, 
			getTickCount ( ) + DefaultTime*1000, 
			-25, 
			true,
			img	
		}
		
		
		if ( getTickCount ( ) - t >= messageDelay ) then
			table.insert ( messages_top, data )
			t = getTickCount ( )
		else
			table.insert ( toDo, data )
		end
	else
		outputChatBox ( msg, r, g, b )
	end
end 
addEvent ( TheResourceName..":sendClientMessage", true )
addEventHandler ( TheResourceName..":sendClientMessage", root, _sendClientMessage )

local width = (sx/1.95)
local t2 = getTickCount ( )

--[[
	.:Table Format:.
	[1] = message,
	[2] = red count,
	[3] = green count,
	[4] = blue count,
	[5] = Remove Time,
	[6] = Y Axis,
	[7] = Is Locked,
	[8] = Image icon path
]]

function dxDrawNotificationBar ( )
	if ( #toDo > 0 and getTickCount ( ) -t >= messageDelay ) then
		local d = toDo[1]
		d[5] = getTickCount ( ) + DefaultTime*1000
		table.insert ( messages_top, d )
		table.remove ( toDo, 1 )
		t = getTickCount ( )
	end
	
	local doRemove = { }
	for i, v in pairs ( messages_top ) do
		local i = i - 1
		local msg, r, g, b, rTime, y = unpack ( v )
		local continue = true
		if ( rTime < getTickCount ( ) and v[7] ) then
			messages_top[i+1][7] = false
		end
		if ( v[7] ) then
			if ( messages_top[i] ) then
				toY = messages_top[i][6] + 25
			else
				toY = 0
			end
			if ( y ~= toY ) then
				if ( y < toY ) then
					y = y + moveSpeed
					if ( y > toY ) then
						y = toY
					end
				else
					y = y - moveSpeed
					if ( y < toY ) then
						y = toY
					end
				end
			else
				if ( #messages_top > maxMessages ) then
					messages_top[1][5] = 0
					messages_top[1][7] = false
				end
			end
		else
			y = y - moveSpeed
			if ( y < -25 ) then
				continue = false
			end
		end
		messages_top[i+1][6] = y
		local lColor = tocolor ( 0, 0, 0, 255 )
		dxDrawRectangle ( (sx/2-width/2), rsy*y, width, rsy*25, tocolor ( 0, 0, 0, 120 ) )
		dxDrawLine ( (sx/2-width/2), rsy*y, (sx/2-width/2)+width, rsy*y, lColor )
		dxDrawLine ( (sx/2-width/2), rsy*y, (sx/2-width/2), rsy*(y+25), lColor )
		dxDrawLine ( (sx/2+width/2), rsy*y, (sx/2+width/2), rsy*(y+25), lColor )
		dxDrawLine ( (sx/2+width/2)-width, rsy*(y+25), (sx/2+width/2), rsy*(y+25), lColor )
		
		if ( v[8] and v[8] ~= "" ) then
			dxDrawImage ( (sx/2-width/2)+3, (rsy*y)+2, rsx*21, rsy*21, v[8] );
			dxDrawImage ( (sx/2-width/2)+(width-25), (rsy*y)+2, rsx*21, rsy*21, v[8] );
		end 
		
		dxDrawText ( v[1], 0, rsy*y, sx, rsy*(y+25), tocolor ( v[2], v[3], v[4], 255 ), rsx*1, "default-bold", "center", "center", true, false, false, true )
		
		
		if ( not continue ) then
			table.insert ( doRemove, i+1 )
		end
	end

	if ( #doRemove > 0 ) then
		for i, v in ipairs ( doRemove ) do
			if ( messages_top [ v ] ) then
				table.remove ( messages_top, v )
			end
		end 
	end
end
addEventHandler ( "onClientRender", root, dxDrawNotificationBar )

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

--[[
addCommandHandler ( 'rt', function ( )
	for i=1,5 do
		sendClientMessage ( tostring ( i ), 255, 255, 0 )
	end
end )
]]

-- join/quit messages
addEventHandler ( "onClientPlayerJoin", root, function ( ) 
	if joinquit then
		sendClientMessage ( "* "..getPlayerName(source).." has joined into the server", 255, 150, 150 )
	end
end ) addEventHandler ( "onClientPlayerQuit", root, function ( r )
	if ( joinquit ) then
		sendClientMessage ( "* "..getPlayerName(source).." has disconnect from the server ("..r..")", 255, 150, 150 )
	end
end )

-- Nickname changes
addEventHandler ( "onClientPlayerChangeNick", root, function ( o, n )
	sendClientMessage ( "* "..o.." is now known as "..n, 255, 150, 150 )
end )