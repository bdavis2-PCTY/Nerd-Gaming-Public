local doDraw_Speed = true
local doDraw_Graph = true

setTimer ( function ( )
	doDraw_Graph = tobool ( exports.NGPhone:getSetting ( "usersettings_showspeedgraph" ) )
	doDraw_Speed = tobool ( exports.NGPhone:getSetting ( "usersettings_showspeedmeter" ) )
end, 500, 1 )

local open = false
local moving = false
local sx, sy = guiGetScreenSize ( )
local recX = sx+10
local moveSpeed = 10
local lastVehicleModel = nil
local speedGraph = { }
local someData = { 
	vehicleHealth = nil,
	vehicleFuel = nil,
	vehicleData = { 
		-- { showSpeed, showFuel, showHealth } 
	}
}

function setSpeedoOpen ( bool )
	if bool and not open and isPedInVehicle ( localPlayer ) then
		open = true
		moving = true
		someData.vehicleHealth = 0
		someData.vehicleFuel = 0
		addEventHandler ( "onClientPreRender", root, dxDrawSpeedo )
	elseif not bool and open then
		moving = true
	end
end

local t = getTickCount ( )
function dxDrawSpeedo ()
	if open then 
		if ( isPlayerMapVisible (  ) ) then
			return
		end
		if ( not doDraw_Speed ) then return end
		local car = getPedOccupiedVehicle ( localPlayer )
		
		if ( isElement ( car ) ) then
			vd = someData.vehicleData[getElementModel(car)]
		else
			vd = someData.vehicleData[lastVehicleModel]
		end
		
		if ( vd[1] ) then
			if car then
				mph = getVehicleSpeed ( car, "mph" )
				kph = getVehicleSpeed ( car, "kph" )
			else
				mph = 0
				kph = 0
			end
		end
		
		if ( moving ) then
			if (isPedInVehicle ( localPlayer ) ) then
				if ( recX ~= sx - 200 ) then
					if ( recX > sx - 200 ) then
						recX = recX - moveSpeed
					else
						recX = sx - 200
						moving = false
					end
				end
			else
				if ( recX < sx + 10 ) then
					recX = recX + moveSpeed
				else
					open = false
					moving = false
					speedGraph = { }
					removeEventHandler ( 'onClientPreRender', root, dxDrawSpeedo )
				end
			end
		end
		
		
		local fontSize = ( sx + sy ) / (sx*1.3)
		if ( vd[1] ) then
			-- speed
			local recY = sy - 115
			if ( not vd[2] and not vd[3] ) then
				recY = sy - 70
			end
			local width = math.ceil(mph)
			if ( width > 170 ) then
				width = 170
			end
			dxDrawRectangle ( recX, recY, 180, 40, tocolor ( 0, 0, 0, 255 ) )
			dxDrawRectangle ( recX+5, recY+5, width, 30, tocolor ( 255, 140, 0, 255 ) )
			dxDrawShadowText (  mph.."MPH | "..kph.."KPH", recX, recY,  recX + 180, recY + 40, tocolor ( 255, 255, 255, 255 ), fontSize, "default-bold", "center", "center" )
			if ( doDraw_Graph ) then
				if ( getTickCount ( ) - t >= 20 ) then
					if ( #speedGraph > 175 ) then
						table.remove ( speedGraph, 1 )
					end
					table.insert ( speedGraph, mph )
					t = getTickCount ( )
				end
				for i, v in ipairs ( speedGraph ) do
					local y = ((recY-5)-v)
					local x = recX+i
					if ( y < ( recY / 1.5 ) ) then 
						y = ( recY / 1.5 )
						y2 = y
						x = i
					end
					--dxDrawLine ( x, y, x+1, y+1 )
					local y2 = ((recY-5)-v)
					if ( y2 < ( recY / 1.5 ) ) then 
						y2 = ( recY / 1.5 )
						x = i + 1
					end
					dxDrawLine ( x, y-1, x - 1, y2, tocolor ( 0, 0, 0, 255 ) )
					dxDrawLine ( x, y, x - 1, y2, tocolor ( 255, 140, 0, 255 ) )
					dxDrawLine ( x, y+1, x - 1, y2, tocolor ( 0, 0, 0, 255 ) )
				end
			end
		end
		
		local fontSize = fontSize / 1.3
		if ( vd[2] ) then
			-- fuel
			if ( isElement ( car ) ) then
				fuel = tonumber ( getElementData ( car, "fuel" ) )
				if not fuel then
					fuel = 80
					setElementData ( car, "fuel", 80 )
				end
				
				local fuel2 = math.floor ( fuel )
				if ( someData.vehicleFuel ~= fuel2 ) then
					if ( someData.vehicleFuel > fuel2 ) then
						someData.vehicleFuel = someData.vehicleFuel - 1
					else
						someData.vehicleFuel = someData.vehicleFuel + 1
					end
				end
				
				if ( fuel2 <= 0 and getVehicleEngineState ( car ) ) then
					setVehicleEngineState ( car, false )
					exports['NGMessages']:sendClientMessage ( "This vehicle is out of fuel!", 255, 0, 0 )
				elseif ( fuel2 > 0 and not getVehicleEngineState ( car ) ) then
					setVehicleEngineState ( car, true )
				end
			else
				fuel = 0
			end
			dxDrawRectangle ( recX, sy - 70, 85, 40, tocolor ( 0, 0, 0, 255 ) )
			dxDrawRectangle ( recX+5, sy - 65, someData.vehicleFuel*0.75, 30, tocolor ( 255, 140, 0, 255 ) )
			dxDrawShadowText (  tostring ( someData.vehicleFuel ).."% Fuel", recX, sy - 70, recX + 85, ( sy - 70 ) + 40, tocolor ( 255, 255, 255, 255 ), fontSize, "default-bold", "center", "center" )
		end
		
		if ( vd[3] ) then
			-- health
			if ( isElement ( car ) ) then
				health = math.floor ( getElementHealth ( car ) / 10 )
			else
				health = 0
			end
			
			if ( someData.vehicleHealth ~= health ) then
				if ( someData.vehicleHealth > health ) then
					someData.vehicleHealth = someData.vehicleHealth - 1
				else
					someData.vehicleHealth =someData.vehicleHealth + 1
				end
			end
			
			dxDrawRectangle ( recX+95, sy - 70, 85, 40, tocolor ( 0, 0, 0, 255 ) )
			dxDrawRectangle ( recX+100, sy - 65, someData.vehicleHealth*0.75, 30, tocolor ( 255, 140, 0, 255 ) )
			dxDrawShadowText (  tostring ( someData.vehicleHealth ).."% Health", recX+95, sy - 70, recX + (100+85), ( sy - 70 ) + 40, tocolor ( 255, 255, 255, 255 ), fontSize, "default-bold", "center", "center" )
		end
	else
		open = false
	end
end

addEventHandler ( "onClientResourceStart", resourceRoot, function ( )
	if ( isPedInVehicle ( localPlayer ) ) then
		setSpeedoOpen ( true )
		lastVehicleModel = getElementModel ( getPedOccupiedVehicle ( localPlayer ) )
	end
end )

addEventHandler ( "onClientPlayerVehicleEnter", root, function ( car )
	if ( source == localPlayer ) then
		setSpeedoOpen ( true )
		lastVehicleModel = getElementModel ( car )
	end
end ) addEventHandler ( "onClientVehicleStartExit", root, function ( source2 )
	if ( source2 == localPlayer ) then
		setSpeedoOpen ( false )
	end
end ) addEventHandler ( "onClientPlayerWasted", root, function ( )
	if ( source == localPlayer ) then
		setSpeedoOpen ( false )
	end
end )


function getVehicleSpeed ( tp, md )
	local md = md or "kph"
	local sx, sy, sz = getElementVelocity ( tp )
	local speed = math.ceil( ( ( sx^2 + sy^2 + sz^2 ) ^ ( 0.5 ) ) * 161 )
	local speed1 = math.ceil( ( ( ( sx^2 + sy^2 + sz^2 ) ^ ( 0.5 ) ) * 161 ) / 1.61 )
	if ( md == "kph" ) then
		return speed;
	else
		return speed1;
	end
end

function dxDrawShadowText ( text, x, y, x2, y2, color, size, font, aX, aY )
	local off = 1
	dxDrawText ( text, x+off, y+off, x2+off, y2+off, tocolor ( 0, 0, 0, 255 ), size, font, aX, aY )
	dxDrawText ( text, x, y, x2, y2, color, size, font, aX, aY )
end





function getValidVehicleModels ( )
	local validVehicles = { }
	local invalidModels = {
		['435']=true, ['449']=true, ['450']=true, ['537']=true,
		['538']=true, ['569']=true, ['570']=true, ['584']=true,
		['590']=true, ['591']=true, ['606']=true, ['607']=true, 
		['608']=true
	}
	for i=400, 609 do
		if ( not invalidModels[tostring(i)] ) then
			table.insert ( validVehicles, i )
		end
	end
	return validVehicles
end

for i, v in ipairs ( getValidVehicleModels ( ) ) do
	local tp = getVehicleType ( v ):lower ( )
	if ( tp == 'trailer' or tp == 'trail' or tp == 'bmx' ) then
		someData.vehicleData[v] = { true, false, false }
	else
		someData.vehicleData[v] = { true, true, true }
	end
end


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
	if ( g == "usersettings_showspeedgraph" ) then
		doDraw_Graph = tobool ( v )
	elseif ( g == "usersettings_showspeedmeter" ) then
		doDraw_Speed = tobool ( v )
	end
end )