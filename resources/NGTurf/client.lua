local isRender = false
local renderData = nil
local removeIfNotText = 0

addEvent ( "NGTurfs:onClientEnterTurfArea", true )
addEventHandler ( "NGTurfs:onClientEnterTurfArea", root, function ( info ) 
	renderData = info
	if ( not render ) then
		addEventHandler ( "onClientRender", root, onClientRender )
		render = true
	end
end )

addEvent ( "NGTurfs:onClientExitTurfArea", true )
addEventHandler ( "NGTurfs:onClientExitTurfArea", root, function ( ) 
	isRender = false 
	renderData = nil
end )

addEvent ( "NGTurfs:upadateClientInfo", true )
addEventHandler ( "NGTurfs:upadateClientInfo", root, function ( data ) 
	renderData = data
	if ( not render ) then
		addEventHandler ( "onClientRender", root, onClientRender )
		render = true
	end
end )


local _sx, _sy = guiGetScreenSize ( )
local sx, sy = _sx/1280, _sy/720

local attackersProgWidth = 0
local defenderProgWidth = 100
function onClientRender ( )
	if ( not render or not renderData  ) then 
		render = false 
		renderData = nil
		return removeEventHandler ( "onClientRender", root, onClientRender )
	end

	local data = renderData
	if ( not data.attackers ) then 
		if ( removeIfNotText and removeIfNotText > 20 ) then 
			render = false 
			removeIfNotText = 0
			return 
		end 
		removeIfNotText = removeIfNotText + 1
		return 
	end

	local mode = "prep"
	if ( data.prepProg == 0 and data.attackProg > 0 ) then
		mode = "attack"
	end 

	if ( mode == "prep" ) then 
		ownerProg = 100 - data.prepProg
		attackProg = data.prepProg 
	else 
		ownerProg = 100 - data.attackProg
		attackProg = data.attackProg
	end

	local progWidth = 230
	dxDrawRectangle ( sx*970, sy*520, sx*280, sy*145, tocolor ( 0, 0, 0, 120 ) )
	dxDrawText ( "Turf War Progress", sx*970, sy*520, sx*1250, sy*720, tocolor ( 255, 255, 255, 255 ), (sx/sy)*2, "default-bold", "center" )
	dxDrawLine ( sx*980, sy*555, sx*1240, sy*555 )
	dxDrawRectangle ( sx*990, sy*570, sx*240, sy*30, tocolor ( 0, 0, 0, 120 ) )
	dxDrawRectangle ( sx*995, sy*575, sx*((ownerProg*0.01)*progWidth), sy*20, tocolor ( 0, 255, 0, 255 ) )
	dxDrawText ( tostring ( data.owner ).." - "..ownerProg.."%", sx*990, sy*570, sx*1230, sy*600, tocolor ( 255, 255, 255, 255 ), (sx/sy)*1.2, "default-bold", "center", "center" )
	dxDrawRectangle ( sx*990, sy*620, sx*240, sy*30, tocolor ( 0, 0, 0, 120 ) )
	dxDrawRectangle ( sx*995, sy*625,  sx*((attackProg*0.01)*progWidth), sy*20, tocolor ( 255, 0, 0, 255 ) )
	dxDrawText ( tostring ( data.attackers ).." - "..attackProg.."%", sx*990, sy*620, sx*1230, sy*650, tocolor ( 255, 255, 255, 255 ), (sx/sy)*1.2, "default-bold", "center", "center" )
end

