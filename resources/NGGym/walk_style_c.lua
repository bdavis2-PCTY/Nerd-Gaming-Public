sx, sy = guiGetScreenSize ( )

local locations = {
	[1] = {
		outPos = { 2229.52, -1721.75, 13.57 },
		inPos = { 772.18, -4.89, 1000.73 },
		interior = 5,

		walking = { 
			markerPos = { 773.3, 0.45, 1000.72 },
			runPos = { 773.52, -2.29, 1000.85 },
			runRot = 180,
			cam = { 770.94, -2.33, 1000.73 }
		}
	},


	[2] = {
		outPos = { -2270.28, -155.99, 35.32 },
		inPos = { 774.213989,-48.924297,1000.585937 },
		interior = 6,

		walking = { 
			markerPos = { 759.62, -44.45, 1000.59 },
			runPos =  { 759.69, -48.36, 1000.85 },
			runRot = 180,
			cam = {  757.14, -48.05, 1000.78 }
		}
	},


	[3] = {
		outPos = { 1968.9, 2295.32, 16.46 },
		inPos = { 773.579956,-77.096694,1000.655029 },
		interior = 7,

		walking = { 
			markerPos = { 758.29, -62.29, 1000.65 },
			runPos = { 758.42, -65.75, 1000.85 },
			runRot = 180,
			cam = { 761.28, -65.48, 1000.66 }
		}
	}
}

local markers = { walk = { } }
local walk = { }
walk.modes = { 
	{ "Default", 0 },
	{ "Default Fat", 55 },
	{ "Muscular", 56 },
	{ "Sneak", 69 },
	{ "Man", 118 },
	{ "Shuffle", 119 },
	{ "Old Man", 120 },
	{ "Gang 1", 121 },
	{ "Gang 2", 122 },
	{ "Fat Man", 124 },
	{ "Jogger", 125 },
	{ "Drunk", 126 },
	{ "Blind", 127 },
	{ "SWAT", 128 },
	{ "Woman", 129 },
	{ "Shopper", 130 },
	{ "Busy Woman", 131 },
	{ "Sexy Woman", 132 },
	{ "Hooker", 133 },
	{ "Old Woman", 134 }
}

walk.wModes = { 
	{ "forwards", "Running" },
	{ "sprint", "Sprinting" },
	{ "walk", "Walking" }
}

walk.bind = { }

function walk.onHit ( p )
	if ( p and p == localPlayer and p.interior == source.interior and p.dimension == source.dimension ) then
		fadeCamera ( false )

		toggleControl ( "forwards", false )
		toggleControl ( "backwards", false )
		toggleControl ( "left", false )
		toggleControl ( "right", false )
		toggleControl ( "jump", false )
		toggleControl ( "sprint", false )

		showChat ( false )
		setPlayerHudComponentVisible ( "all", false )


		setTimer ( function ( source )
			local i = tonumber ( getElementData ( source, "nggym->markerId" ) )
			local data = locations[i].walking
			local x, y, z = unpack ( data.cam )
			local x2, y2, z2 = unpack ( data.runPos )
			setCameraMatrix ( x, y, z, x2, y2, z2 )
			tempPed = Ped.create ( localPlayer.model, x2, y2, z2 )
			tempPed:setRotation ( 0, 0, data.runRot )
			tempPed.interior = localPlayer.interior 
			tempPed.dimension = localPlayer.dimension
			tempPed:setControlState ( "forwards", true )
			walk.runMode = "Running"
			walk.mode = "Default"

			local s = getElementData ( localPlayer, "PlayerServerSettings" )
			if ( s and s.walkStyle ) then
				for i, v in pairs ( walk.modes ) do
					if ( v [ 2 ] == s.walkStyle ) then
						walk.mode = v [ 1]
						break
					end
				end
				tempPed:setWalkingStyle ( s.walkStyle )
			end
			bindKey ( "arrow_l", "down", walk.bind.left )
			bindKey ( "arrow_r", "down", walk.bind.right )
			bindKey ( "arrow_u", "down", walk.bind.up )
			bindKey ( "arrow_d", "down", walk.bind.down )
			bindKey ( "enter", "down", walk.buy )
			bindKey ( "backspace", "down", walk.exit )

			addEventHandler ( "onClientRender", root, walk.onRender )

			fadeCamera ( true )
		end, 1000, 1, source )
	end 
end 

function walk.exit ( v1 )
	fadeCamera ( false )
	if ( v1 ) then
		playSoundFrontEnd ( 8 )
	end

	unbindKey ( "arrow_l", "down", walk.bind.left )
	unbindKey ( "arrow_r", "down", walk.bind.right )
	unbindKey ( "arrow_u", "down", walk.bind.up )
	unbindKey ( "arrow_d", "down", walk.bind.down )
	unbindKey ( "enter", "down", walk.buy )
	unbindKey ( "backspace", "down", walk.exit )

	setTimer ( function ( )
		if ( isElement ( tempPed ) ) then
			destroyElement ( tempPed )
		end
		walk.runMode = nil
		walk.mode = nil
		removeEventHandler ( "onClientRender", root, walk.onRender )
		setCameraTarget ( localPlayer )
		toggleControl ( "forwards", true )
		toggleControl ( "backwards", true )
		toggleControl ( "left", true )
		toggleControl ( "right", true )
		toggleControl ( "jump", true )
		toggleControl ( "sprint", true )
		showChat ( true )
		setPlayerHudComponentVisible ( "all", true )
		fadeCamera ( true )
	end, 1000, 1 )
end 

function walk.buy ( )
	playSoundFrontEnd ( 5 )
	local walkStyle;
	for i, v in pairs ( walk.modes ) do 
		if ( v [ 1 ] == walk.mode ) then
			walkStyle = v [ 2 ]
			break
		end
	end 

	walk.exit ( )
	triggerServerEvent ( "NGGym->Modules->Walking->SetWalkingStyle", localPlayer, walkStyle )
end 

function walk.onRender ( )
	dxDrawBoarderedText ( "Use the left and right arrow keys to change the style\nUse the up and down arrow keys to change run mode\nPress [enter] to select, and [backspace] to exit", 0, 0, sx, sy, tocolor ( 255, 255, 255, 255 ), 1.8, "default-bold", "center", "top", false, true, false )
	dxDrawBoarderedText ( "Walk Style: "..tostring ( walk.mode ).."\nRun mode: "..tostring ( walk.runMode ), 0, 0, sx, sy/1.1, tocolor ( 255, 255, 255, 255 ), 1.8, "default-bold", "center", "bottom", false, true, false )
end 

function walk.bind.left ( )
	playSoundFrontEnd ( 10 )
	for i, v in ipairs ( walk.modes ) do 
		if ( v[1] == walk.mode ) then 
			if ( walk.modes[i-1] ) then
				walk.mode = walk.modes[i-1][1]
				tempPed:setWalkingStyle ( walk.modes[i-1][2] )
			else
				walk.mode = walk.modes[#walk.modes][1]
				tempPed:setWalkingStyle ( walk.modes[#walk.modes][2] )
			end 
			break
		end 
	end 
end 

function walk.bind.right ( )
	playSoundFrontEnd ( 10 )
	for i, v in ipairs ( walk.modes ) do 
		if ( v[1] == walk.mode ) then 
			if ( walk.modes[i+1] ) then
				walk.mode = walk.modes[i+1][1]
				tempPed:setWalkingStyle ( walk.modes[i+1][2] )
			else
				walk.mode = walk.modes[1][1]
				tempPed:setWalkingStyle ( walk.modes[1][2] )
			end 
			break
		end 
	end 
end 

function walk.bind.up ( )
	playSoundFrontEnd ( 15 )
	for i, v in ipairs ( walk.wModes ) do
		if ( v[2] == walk.runMode ) then 
			if ( walk.wModes[i+1] ) then 
				walk.runMode = walk.wModes[i+1][2]
				for i, v in pairs ( walk.wModes ) do 
					tempPed:setControlState ( v[1], false )
				end 
				tempPed:setControlState ( "forwards", true )
				tempPed:setControlState ( walk.wModes[i+1][1], true )
			else
				walk.runMode = walk.wModes[1][2]
				for i, v in pairs ( walk.wModes ) do 
					tempPed:setControlState ( v[1], false )
				end 
				tempPed:setControlState ( "forwards", true )
				tempPed:setControlState ( walk.wModes[1][1], true )
			end 
			break
		end 
	end 
end 

function walk.bind.down ( )
	playSoundFrontEnd ( 15 )
	for i, v in ipairs ( walk.wModes ) do
		if ( v[2] == walk.runMode ) then 
			if ( walk.wModes[i-1] ) then 
				walk.runMode = walk.wModes[i-1][2]
				for i, v in pairs ( walk.wModes ) do 
					tempPed:setControlState ( v[1], false )
				end 
				tempPed:setControlState ( "forwards", true )
				tempPed:setControlState ( walk.wModes[i-1][1], true )
			else
				walk.runMode = walk.wModes[#walk.wModes][2]
				for i, v in pairs ( walk.wModes ) do 
					tempPed:setControlState ( v[1], false )
				end 
				tempPed:setControlState ( "forwards", true )
				tempPed:setControlState ( walk.wModes[#walk.wModes][1], true )
			end 
			break
		end 
	end 
end 
--[[
addCommandHandler ( "f", function ( )
	setCameraTarget ( localPlayer )
	toggleControl ( "forwards", true )
	toggleControl ( "backwards", true )
	toggleControl ( "left", true )
	toggleControl ( "right", true )
	toggleControl ( "jump", true )
	toggleControl ( "sprint", true )

	showChat ( true )
	setPlayerHudComponentVisible ( "all", true )
end )
]]
addEventHandler ( "onClientResourceStart", resourceRoot, function ( )
	for i, v in pairs ( locations ) do
		-- warps
		local dim = tostring ( i )
		local x, y, z = unpack ( v.outPos )
		exports.ngwarpmanager:makeWarp ( { pos = { x, y, z + 1 }, toPos = v.inPos, cInt = 0, cDim = 0, tInt = v.interior, tDim = dim } )
		local x, y, z = unpack ( v.inPos )
		exports.ngwarpmanager:makeWarp ( { pos = { x, y, z + 1 }, toPos = v.outPos, cInt = v.interior, cDim = dim, tInt = 0, tDim = 0 } )

		local x, y, z = unpack ( v.walking.markerPos )
		markers.walk[i] = Marker.create ( x, y, z - 1, "cylinder", 1, 0, 120, 255, 120 )
		markers.walk[i].dimension = dim
		markers.walk[i].interior = v.interior
		setElementData ( markers.walk[i], "nggym->markerId", i)
		addEventHandler ( "onClientMarkerHit", markers.walk[i], walk.onHit)
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
	local a = bitExtract ( color, 24, 8 )
	dxDrawText ( t_g, x-offSet, y-offSet, endX, endY, tocolor(0,0,0,255), size, font, alignX, alignY, clip, wordBreak, postGUI, colorCode, subPixelPos, fRot, fRotCX, fRotCY, offSet )
	dxDrawText ( t_g, x-offSet, y, endX, endY, tocolor(0,0,0,255), size, font, alignX, alignY, clip, wordBreak, postGUI, colorCode, subPixelPos, fRot, fRotCX, fRotCY, offSet )
	dxDrawText ( t_g, x, y-offSet, endX, endY, tocolor(0,0,0,255), size, font, alignX, alignY, clip, wordBreak, postGUI, colorCode, subPixelPos, fRot, fRotCX, fRotCY, offSet )
	dxDrawText ( t_g, x+offSet, y+offSet, endX, endY, tocolor(0,0,0,255), size, font, alignX, alignY, clip, wordBreak, postGUI, colorCode, subPixelPos, fRot, fRotCX, fRotCY, offSet )
	dxDrawText ( t_g, x+offSet, y, endX, endY, tocolor(0,0,0,255), size, font, alignX, alignY, clip, wordBreak, postGUI, colorCode, subPixelPos, fRot, fRotCX, fRotCY, offSet )
	dxDrawText ( t_g, x, y+offSet, endX, endY, tocolor(0,0,0,255), size, font, alignX, alignY, clip, wordBreak, postGUI, colorCode, subPixelPos, fRot, fRotCX, fRotCY, offSet )
	return dxDrawText ( text, x, y, endX, endY, color, size, font, alignX, alignY, clip, wordBreak, postGUI, colorCode, subPixelPos, fRot, fRotCX, fRotCY, offSet )
end



local blips = { }
addEvent ( "onClientPlayerLogin", true )
addEventHandler ( "onClientPlayerLogin", root, function ( )
	local b = exports.ngphone:getSetting ( );
	if b then
		for i, v in pairs ( locations ) do
			local x, y, z = unpack ( v.outPos )
			blips[i] = createBlip ( x, y, z, 54, 2, 255, 255, 255, 255, 0, 450 )
		end 
	end 
end )

addEvent ( "onClientUserSettingChange", true )
addEventHandler ( "onClientUserSettingChange", root, function ( name, value )
	if ( name == "usersetting_display_gymblips" ) then
		for i, v in pairs ( blips ) do
			destroyElement ( v )
		end
		blips = { }

		if value then
			for i, v in pairs ( locations ) do
				local x, y, z = unpack ( v.outPos )
				blips[i] = createBlip ( x, y, z, 54, 2, 255, 255, 255, 255, 0, 450 )
			end 
		end
	end
end )