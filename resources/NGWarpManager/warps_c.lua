local warps = { }
local fadeScreen = fadeCamera
local hitWarp = nil
local warping = false

function makeWarp ( data )
	if ( not data or type ( data ) ~= "table" or not data.pos or not data.toPos ) then
		return false
	end
	local cInt = data.cInt or 0
	local cDim = data.cDim or 0
	local tInt = data.tInt or 0
	local tDim = data.tDim or 0
	local size = data.size or 2
	local r, g, b, a = 255, 255, 0, 120
	if ( data.color ) then
		if ( data.color.r ) then r = data.color.r end
		if ( data.color.g ) then g = data.color.g end
		if ( data.color.b ) then b = data.color.b end
		if ( data.color.a ) then a = data.color.a end 
	end
		
	local type = data.type or "arrow"
	local x, y, z = unpack ( data.pos )
	local i = 0

	while ( warps [ i ] ) do
		i = i + 1
	end

	data.cInt = cInt
	data.cDim = cDim
	data.tInt = tInt
	data.tDim = tDim
	data.size = size
	data.color =  { }
	data.color.r = r
	data.color.g = g
	data.color.b = b
	data.color.a = a
	data.type = type
	data.sResource = getResourceName ( sourceResource or getThisResource() )

	warps [ i ] = Marker.create ( x, y, z, type, size, r, g, b, a )

	setElementData ( warps [ i ], "NGWarpManager->WarpData", data, false )

	setElementInterior ( warps [ i ], cInt )
	setElementDimension ( warps [ i ], cDim )

	addEventHandler ( "onClientMarkerHit", warps [ i ], onWarpHit )

	addEventHandler ( "onClientResourceStop", getResourceRootElement ( getResourceFromName ( data.sResource ) ), function ( source )
		local res = getResourceName ( source )
		for i, v in pairs ( warps ) do
			local d = getElementData ( v, "NGWarpManager->WarpData" )
			if ( d.sResource == res ) then
				removeEventHandler ( "onClientMarkerHit", v, onWarpHit )
				destroyElement ( v )
				warps [ i ] = nil
			end 
		end 
	end )
end 

function onWarpHit ( p )
	if ( source.dimension == p.dimension and source.interior == p.interior and p == localPlayer ) then
		hitWarp = source
		bindKey ( "lshift", "down", beginPlayerWarp )
		bindKey ( "rshift", "down", beginPlayerWarp )
	end
end

function triggerWarp ( p, source )
	if ( p and isElement ( p ) and getElementType ( p ) == "player" and p == localPlayer and not isPedInVehicle ( p ) ) then
		local int, dim = getElementInterior ( localPlayer ), getElementDimension ( localPlayer )
		if ( int ==  getElementInterior ( source ) and dim == getElementDimension ( source ) ) then
			local data = getElementData ( source, "NGWarpManager->WarpData" )
			
			toggleAllControls ( false )
			fadeScreen ( false )
			setTimer ( function ( data )
				local int = data.tInt
				local dim = data.tDim 
				local x, y, z = unpack ( data.toPos )
				triggerServerEvent ( "NGWarpManager->SetPlayerPositionInteriorDimension", localPlayer, x, y, z, int, dim )
				fadeScreen ( true )
				toggleAllControls ( true )
			end, 1000, 1, data )
		end
	end
end 

local prog = 0
local mode = true
local sx_, sy_ = guiGetScreenSize ( )
local sx, sy = sx_/1280, sy_/720
addEventHandler ( "onClientPreRender", root, function ( )
	prog = prog + 0.01
	for i, v in pairs ( warps ) do
		local data = getElementData ( v, "NGWarpManager->WarpData" )
		local x, y, z = unpack ( data.pos )

		local cx, cy, cz = getElementPosition ( v )

		if ( mode ) then
			ix, iy, iz = interpolateBetween ( cx, cy, z, cx, cy, z+0.5, prog, "InOutQuad" )
		else
			ix, iy, iz = interpolateBetween ( cx, cy, z+0.5, cx, cy, z, prog, "InOutQuad" )
		end
		setElementPosition ( v, x, y, iz )

		if ( prog >= 1.1 ) then
			mode = not mode
			prog = 0
		end
	end 

	if ( hitWarp ) then
		if ( not isElementWithinMarker ( localPlayer, hitWarp ) ) then
			hitWarp = nil
			warping = false
			unbindKey ( "lshift", "down", beginPlayerWarp )
			unbindKey ( "rshift", "down", beginPlayerWarp )
		end

		if ( hitWarp and not warping ) then
			dxDrawBoarderedText ( "Press Shift To Warp", 0, sy*600, sx_, sx*620, tocolor ( 0, 255, 0, 255 ), sy*1.5, "pricedown", "center", "top", nil, nil, nil, nil, nil, nil, nil, nil, 1.5 )
		end
	end 
end )

function beginPlayerWarp ( )
	if ( warping ) then return end 
	triggerWarp ( localPlayer, hitWarp )
	warping = true
end 

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
	dxDrawText ( t_g, x-offSet, y-offSet, endX, endY, tocolor(0,0,0,a), size, font, alignX, alignY, clip, wordBreak, postGUI, colorCode, subPixelPos, fRot, fRotCX, fRotCY, offSet )
	dxDrawText ( t_g, x+offSet, y+offSet, endX, endY, tocolor(0,0,0,a), size, font, alignX, alignY, clip, wordBreak, postGUI, colorCode, subPixelPos, fRot, fRotCX, fRotCY, offSet )
	dxDrawText ( t_g, x-offSet, y, endX, endY, tocolor(0,0,0,a), size, font, alignX, alignY, clip, wordBreak, postGUI, colorCode, subPixelPos, fRot, fRotCX, fRotCY, offSet )
	dxDrawText ( t_g, x+offSet, y, endX, endY, tocolor(0,0,0,a), size, font, alignX, alignY, clip, wordBreak, postGUI, colorCode, subPixelPos, fRot, fRotCX, fRotCY, offSet )
	dxDrawText ( t_g, x, y-offSet, endX, endY, tocolor(0,0,0,a), size, font, alignX, alignY, clip, wordBreak, postGUI, colorCode, subPixelPos, fRot, fRotCX, fRotCY, offSet )
	dxDrawText ( t_g, x, y+offSet, endX, endY, tocolor(0,0,0,a), size, font, alignX, alignY, clip, wordBreak, postGUI, colorCode, subPixelPos, fRot, fRotCX, fRotCY, offSet )
	return dxDrawText ( text, x, y, endX, endY, color, size, font, alignX, alignY, clip, wordBreak, postGUI, colorCode, subPixelPos, fRot, fRotCX, fRotCY, offSet )
end

