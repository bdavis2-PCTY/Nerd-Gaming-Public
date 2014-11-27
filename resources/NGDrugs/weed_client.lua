drugs.Marijuana = {
	loaded = false,
	func = { },
	var = { 
		rasta = { 
			{ 0, 255, 0 },
			{ 255, 255, 0 },
			{ 255, 0, 0 } 
		}
	},
	info = {
		timePerDoce = 30,
	}
}

local weed = drugs.Marijuana
function weed.func.load ( )
	if ( not weed.loaded ) then
		weed.loaded = true
		if ( not isElement ( weed.var.music ) ) then
			weed.var.music = playSound ( "files/weed_music.mp3", true )
		end

		if ( isElement ( weed.var.volTime ) ) then
			destroyElement ( weed.var.volTime )
		end

		weed.var.recAlpha = 0
		weed.var.recMode = "add"

		weed.var.imgMode = "small"
		weed.var.imgStart = getTickCount ( )

		weed.var.vehTick = getTickCount ( )

		weed.var.vehColors = { }

		for i, v in pairs ( getElementsByType ( "vehicle" ) ) do
			weed.var.vehColors [ v ] = { getVehicleColor ( v, true ) }
			local r, g, b = unpack ( weed.var.rasta [ math.random ( #weed.var.rasta ) ] )
			local r2, g2, b2 = unpack ( weed.var.rasta [ math.random ( #weed.var.rasta ) ] )
			setVehicleColor ( v, r, g, b, r2, g2, b2, r, g, b, r2, g2, b2 )
		end 

		setSkyGradient ( 255, 0, 0, 255, 0, 0 )
		setGameSpeed ( 0.7 )

		weed.var.healthTimer = setTimer ( function ( )
			triggerServerEvent ( "NGDrugs:Module->Marijuana:updatePlayerHealth", localPlayer )
		end, 1000, 0 )

		triggerServerEvent ( "NGDrugs:Module->Core:setPlayerHeadText", localPlayer, "Stoned", { 120, 0, 255 } )
		addEventHandler ( "onClientRender", root, weed.func.render )
	end 
end 

function weed.func.unload ( )
	if ( weed.loaded ) then
		triggerServerEvent ( "NGDrugs:Module->Core:destroyPlayerHeadText", localPlayer )
		weed.loaded = false
		if ( isElement ( weed.var.music ) ) then
			weed.var.volTime = setTimer ( function ( ) 
				if ( not isElement ( weed.var.music ) ) then
					killTimer ( weed.var.volTime )
				else
					local v = getSoundVolume ( weed.var.music )
					v = math.round ( v - 0.1, 1 )
					if ( v <= 0 ) then
						destroyElement ( weed.var.music )
					else
						setSoundVolume ( weed.var.music, v )
					end
				end
			end, 200, 0 )
		end 

		if ( weed.var.vehColors ) then
			for i, v in pairs ( weed.var.vehColors ) do 
				if ( isElement ( i ) ) then
					setVehicleColor ( i, unpack ( v ) )
				end 
			end 
		end 

		if ( isElement ( weed.var.healthTimer ) ) then
			killTImer ( weed.var.healthTimer )
		end
		setGameSpeed ( 1 )
		resetSkyGradient ( )
		removeEventHandler ( "onClientRender", root, weed.func.render )
	end 
end 


function weed.func.render ( )
	
	if ( getTickCount ( ) - weed.var.vehTick >= 3000 ) then
		weed.var.vehTick = getTickCount ( )
		for i, v in pairs ( getElementsByType ( "vehicle" ) ) do
			if ( not weed.var.vehColors [ v ] ) then
				weed.var.vehColors [ v ] = { getVehicleColor ( v ) }
			end
			local r, g, b = unpack ( weed.var.rasta [ math.random ( #weed.var.rasta ) ] )
			local r2, g2, b2 = unpack ( weed.var.rasta [ math.random ( #weed.var.rasta ) ] )
			setVehicleColor ( v, r, g, b, r2, g2, b2, r, g, b, r2, g2, b2 )
		end
	end 

	local a = weed.var.recAlpha
	if ( weed.var.recMode == "add" ) then
		a = a + 3
		if ( a >= 90 ) then
			weed.var.recMode = "remove"
		end
	else
		a = a - 3
		if ( a <= 10 ) then
			weed.var.recMode = "add"
		end
	end 
	weed.var.recAlpha = a
	dxDrawRectangle ( 0, 0, sx_, sy_, tocolor ( 255, 255, 0, a ) )


	local en = weed.var.imgStart + 1200
	if ( getTickCount ( ) >= en ) then
		weed.var.imgStart = getTickCount ( )
		if ( weed.var.imgMode == "small" ) then
			weed.var.imgMode = "big"
		else
			weed.var.imgMode = "small"
		end
	end

	local mode = weed.var.imgMode
	local elapsedTime = getTickCount() - weed.var.imgStart
	local duration = (weed.var.imgStart+1200) - weed.var.imgStart
	local prog = elapsedTime / duration

	if ( mode == "small" ) then
		w, h, _ = interpolateBetween ( sx_/1.4, sy_/1.4, 0, sx_/2, sy_/2, 0, prog, "InQuad" )
	else
		w, h, _ = interpolateBetween ( sx_/2, sy_/2, 0, sx_/1.4, sy_/1.4, 0, prog, "OutQuad" )
	end

	dxDrawImage ( (sx_/2-w/2), (sy_/2-h/2), w, h, "files/weed_icon.png", 0, 0, 0, tocolor ( 255, 255, 255, 120-weed.var.recAlpha ) )

end 

drugs.Marijuana = weed



function math.round(number, decimals, method)
    decimals = decimals or 0
    local factor = 10 ^ decimals
    if (method == "ceil" or method == "floor") then return math[method](number * factor) / factor
    else return tonumber(("%."..decimals.."f"):format(number)) end
end
