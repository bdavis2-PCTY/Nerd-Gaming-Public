local useMoneyLog = true
setTimer ( function ( )
	useMoneyLog = tobool ( exports.NGPhone:getSetting ( "usersettings_showmoneylogs" ) )
	if ( useMoneyLog ) then
		addEventHandler ( "onClientRender", root, MoneyLog_OnClientRender )
	end
end, 500, 1 )

addEvent ( "onClientUserSettingChange", true )
addEventHandler ( "onClientUserSettingChange", root, function ( g, v ) 
	if ( g == "usersettings_showmoneylogs" ) then	
		if v and not useMoneyLog then
			useMoneyLog = true
			addEventHandler ( "onClientRender", root, MoneyLog_OnClientRender )
		elseif not v and useMoneyLog then
			useMoneyLog = false
			removeEventHandler ( "onClientRender", root, MoneyLog_OnClientRender )
		end
	end
end )

local playerMoney = getPlayerMoney ( localPlayer )
local messages =  { }
local sx, sy = guiGetScreenSize ( )
local start_y = sy / 3
local pos_x = sx - 220
local toDo = { }
local t = getTickCount ( )

function outputDxLog ( text, r, g, b )
	local tick = getTickCount ( )
	local r, g, b = tonumber ( r ) or 255, tonumber ( g ) or 255, tonumber ( b ) or 255
	local data = { text, nil, tick + 5000, 150, sx + 5, start_y+(#messages*25)+25, r, g, b }
	outputConsole ( "Side Message: "..tostring ( text ) )
	if ( getTickCount ( ) - t >= 300 ) then
		table.insert ( messages, data )
		t = getTickCount ( )
	else
		table.insert ( toDo, data )
	end
end

function MoneyLog_OnClientRender( )
	if ( isPedDead ( localPlayer ) ) then
		return
	end
	local tick = getTickCount ( )
	if ( playerMoney ~= getPlayerMoney ( localPlayer ) ) then
		local pM = getPlayerMoney ( localPlayer ) 
		local data = nil
		if ( pM > playerMoney ) then
			local diff = pM - playerMoney
			data = { diff, true }
		else
			local diff = playerMoney - pM
			data = { diff, false }
		end
		playerMoney = pM
		
		if ( not data[2] ) then
			outputDxLog ( "- $"..convertNumber(data[1]), 255, 0, 0 )
		else
			outputDxLog ( "+ $"..convertNumber(data[1]), 0, 255, 0 )	
		end
	end
	
	if ( getTickCount ( ) - t >= 300 and toDo[1] ) then
		local data = toDo[1]
		data[3] = t + 5000
		table.insert ( messages, data )
		table.remove ( toDo, 1 )
		t = getTickCount ( )
	end
	
	if ( #messages > 7 ) then
		table.remove ( messages, 1 )
	end
	
	for index, data in ipairs ( messages ) do
		for i=1,6 do
			_G['v'..tostring(i)] = data[i];
		end
		
		dxDrawRectangle ( v5, v6, 200, 20, tocolor ( 0, 0, 0, v4 ) )
		dxDrawLinedRectangle ( v5, v6, 200, 20, tocolor ( 0, 0, 0, v4 ), 1.5, false )
		dxDrawText ( tostring ( v1 ), v5+50, v6, v5+50, v6+20, tocolor ( data[7], data[8], data[9], v4+75 ), 1, 'default-bold', 'center', 'center' )
		
		if ( v5 ~= pos_x ) then
			if ( v5 < pos_x ) then
				data[5] = pos_x
			else
				data[5] = v5 - 10
			end
		end if ( v6 ~= start_y+(index*25) ) then
			if ( v6 < start_y+(index*25) ) then
				data[6] = start_y+(index*25)
			else
				data[6] = v6 - 2
			end
		end
		
		if ( tick >= v3 ) then
			messages[index][4] = v4-2
			if ( v4 <= 10 ) then
				table.remove ( messages, index )
			end
		end
	end
end

function dxDrawLinedRectangle( x, y, width, height, color, _width, postGUI )
	local _width = _width or 1
	dxDrawLine ( x, y, x+width, y, color, _width, postGUI ) -- Top
	dxDrawLine ( x, y, x, y+height, color, _width, postGUI ) -- Left
	dxDrawLine ( x, y+height, x+width, y+height, color, _width, postGUI ) -- Bottom
	return dxDrawLine ( x+width, y, x+width, y+height, color, _width, postGUI ) -- Right
end

function convertNumber ( number )  
	local formatted = number  
	while true do      
		formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')    
		if ( k==0 ) then      
			break   
		end  
	end  
	return formatted
end
