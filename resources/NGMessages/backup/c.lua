local maxMessages = 5;
local DefaultTime = 8;
local sx, sy = guiGetScreenSize ( )
local DefaultPos = true;
local timer_top =  { }
local messages_top = { }

function sendClientMessage ( msg, r, g, b, pos, time )
	local r, g, b = r, g, b or 255, 255, 255
	if ( pos == nil ) then pos = DefaultPos end -- Check for pos
	if ( time == nil ) then time = DefaultTime end -- Check for time
	local GsubedMessage = msg:gsub ( "#%x%x%x%x%x%x", "" )
	if ( pos == true ) then
		if ( not isTimer ( timer_top[GsubedMessage] ) ) then
			local c_messages = messages_top;
			if ( #messages_top >= maxMessages ) then
				local c_messages = messages_top;
				messages_top = { }
				for i,v in ipairs ( c_messages ) do
					if ( i ~= 1 ) then
						table.insert ( messages_top, { v[1], v[2], v[3], v[4] } )
					end
				end
			end
			table.insert ( messages_top, { msg, r, g, b } )
			timer_top[GsubedMessage] = setTimer ( function ( msg )
				for i,v in ipairs ( messages_top ) do
					if ( v[1] == msg ) then
						table.remove ( messages_top, i )
						break
					end
				end
			end, time*1000, 1, msg )
			return_value = true
			outputConsole ( "Message Bar: "..tostring ( msg ) )
		else return_value = false end
	end
	return return_value or false
end 
local TheResourceName = getResourceName ( getThisResource ( ) )
addEvent ( TheResourceName..":sendClientMessage", true )
addEventHandler ( TheResourceName..":sendClientMessage", root, sendClientMessage )

local width = (sx/1.95)
function dxDrawNotificationBar ( )
	for i,v in ipairs ( messages_top ) do
		local i = i - 1 -- Because tables start at 1 -.-
		--[[if ( i == #messages_top-1 ) then
			dxDrawRectangle ( (sx/2-width/2), i*25, width, 25, tocolor ( 0, 0, 0, 100 ) )
		end]]
		
		local lColor = tocolor ( 0, 0, 0, 255 )
		dxDrawLine ( (sx/2-width/2), i*25, (sx/2-width/2), i*25+25, lColor )
		dxDrawLine ( (sx/2+width/2), i*25, (sx/2+width/2), i*25+25, lColor )
		dxDrawLine ( (sx/2+width/2)-width, i*25+25, (sx/2+width/2), i*25+25, lColor )
		
		dxDrawRectangle ( (sx/2-width/2), i*25, width, 25, tocolor ( 0, 0, 0, 120 ) )
		dxDrawText ( v[1], 0, i*25+5, sx, 25, tocolor ( v[2], v[3], v[4], 255 ), 1, "default-bold", "center", "top", true, false, false, true )
	end
end
addEventHandler ( "onClientRender", root, dxDrawNotificationBar )

addCommandHandler ( 'rt', function ( )
	for i=1,3 do
		sendClientMessage ( tostring ( i ), 255, 255, 0 )
	end
end )
