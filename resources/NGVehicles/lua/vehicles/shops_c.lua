local sx, sy = guiGetScreenSize ( )
local rec_x = ( sx - 360 )
local rec_y = ( sy / 4.2 )
local changeCar = { }
local drawData = { 
	hover_buy = false,
	hover_close = false,
	hover_editColor = false
}

function dxDrawVehicleShop ( )
	local cR, cG, cB = unpack ( carColor ) 
	local pR, pG, pB = 255, 0, 0
	
	if ( getPlayerMoney ( localPlayer ) >= carList[carIndex][2] ) then
		pR, pG, pB = 0, 255, 0
	end
	
	if ( isElement ( PreviewVehicle ) ) then
		local rx, ry, rz = getElementRotation ( PreviewVehicle )
		if ( rz > 360 ) then
			rz = 0
		end
		setElementRotation ( PreviewVehicle, 0, 0, rz+0.5 )
		local _, _, posZ = getElementPosition ( PreviewVehicle )
		setElementPosition ( PreviewVehicle, createtionPointX, createtionPointY, posZ )
		setVehicleColor ( PreviewVehicle, cR, cG, cB, cR, cG, cB ) 
	end

	dxDrawRectangle(rec_x, rec_y, 313, 148, tocolor(0, 0, 0, 120), false)
	dxDrawText(tostring ( getVehicleNameFromModel ( carList[carIndex][1] ) ), rec_x, rec_y, rec_x+313, rec_y+40, tocolor(255, 255, 255, 255), 2.00, "default-bold", "center", "center", false, false, true, false, false)
	dxDrawLine(rec_x, rec_y+48, rec_x+313, rec_y+48, tocolor(255, 255, 255, 255), 2, true)
	dxDrawText("Price: "..RGBToHex ( pR, pG, pB ).." $"..convertNumber ( carList[carIndex][2] ), rec_x+10, rec_y+58, 0, 0, tocolor(255, 255, 255, 255), 2.00, "default-bold", "left", "top", false, false, true, true, false)
	dxDrawText("Color:", rec_x+10, rec_y+90, 0, 0, tocolor(255, 255, 255, 255), 2.00, "default-bold", "left", "top", false, false, true, false, false)
	dxDrawRectangle(rec_x, rec_y+163, 150, 53, tocolor(0, 0, 0, 120), false) -- buy button
	dxDrawRectangle((rec_x+313)-150, rec_y+163, 150, 53, tocolor(0, 0, 0, 120), false)
	dxDrawRectangle(rec_x, rec_y+230, 313, 53, tocolor(0, 0, 0, 120), false)
	dxDrawText("Use arrow keys to navigate", rec_x, rec_y+230, rec_x+313, rec_y+230+53, tocolor(255, 255, 255, 255), 1.7, "default-bold", "center", "center", false, false, true, false, false)
	
	if ( drawData.hover_buy ) then
		dxDrawRectangle(rec_x, rec_y+163, 150, 53, tocolor(0, 0, 0, 120), false) -- buy button
		dxDrawText("Buy", rec_x, rec_y+163, rec_x+150, rec_y+163+53, tocolor(255, 136, 0, 255), 2.05, "default-bold", "center", "center", false, false, true, false, false)
	else
		dxDrawText("Buy", rec_x, rec_y+163, rec_x+150, rec_y+163+53, tocolor(255, 255, 255, 255), 2.00, "default-bold", "center", "center", false, false, true, false, false)
	end

	if	( drawData.hover_close ) then
		dxDrawRectangle((rec_x+313)-150, rec_y+163, 150, 53, tocolor(0, 0, 0, 120), false)
		dxDrawText("Close", ((rec_x+313)-150), rec_y+163, (rec_x+313), rec_y+163+53, tocolor(255, 136, 0, 255), 2.05, "default-bold", "center", "center", false, false, true, false, false)
	else
		dxDrawText("Close", ((rec_x+313)-150), rec_y+163, (rec_x+313), rec_y+163+53, tocolor(255, 255, 255, 255), 2.00, "default-bold", "center", "center", false, false, true, false, false)
	end

	if	( drawData.hover_editColor ) then
		dxDrawText("Edit", rec_x+90, rec_y+90, 0, 0, tocolor(255, 136, 0, 255), 2.05, "default-bold", "left", "top", false, false, true, false, false)
	else
		dxDrawText("Edit", rec_x+90, rec_y+90, 0, 0, tocolor( cR, cG, cB, 255 ), 2.00, "default-bold", "left", "top", false, false, true, false, false)
	end
end 

addEvent ( "NGVehicles:openClientShop", true )
addEventHandler ( "NGVehicles:openClientShop", root, function ( list, createPoint, spawnpoint )

	showChat ( false )
	showPlayerHudComponent ( 'all', false )
	spawnPosition = spawnpoint
	carList = list
	carIndex=1
	carColor = { 255, 255, 255 }
	PreviewVehicle = createVehicle ( list[1][1], unpack ( createPoint ) )
	setVehicleLocked ( PreviewVehicle, true )
	setVehicleDamageProof ( PreviewVehicle, true )
	createtionPointX = createPoint[1]
	createtionPointY =  createPoint[2]
	showCursor ( true )
	toggleAllControls ( false )
	addEventHandler ( 'onClientPreRender', root, dxDrawVehicleShop )
	addEventHandler ( 'onClientCursorMove', root, onEvent_CursorMove )
	addEventHandler ( 'onClientClick', root, onEvent_CursorClick )
	
	bindKey ( "arrow_l", "down", changeCar.left )
	bindKey ( "arrow_r", "down", changeCar.right )
end )



function changeCar.left ( )
	local x, y, z = getElementPosition ( PreviewVehicle ) 
	setElementPosition ( PreviewVehicle, x, y, z+0.7 )
	if ( carIndex > 1 ) then
		carIndex = carIndex - 1
		setElementModel ( PreviewVehicle, carList[carIndex][1] )
	else
		carIndex = #carList
		setElementModel ( PreviewVehicle, carList[carIndex][1] )
	end
end 

function changeCar.right ( )
	local x, y, z = getElementPosition ( PreviewVehicle ) 
	setElementPosition ( PreviewVehicle, x, y, z+0.7 )
	if ( carIndex < #carList ) then
		carIndex = carIndex + 1
		setElementModel ( PreviewVehicle, carList[carIndex][1] )
	else
		carIndex = 1
		setElementModel ( PreviewVehicle, carList[carIndex][1] )
	end
end 


function onEvent_CursorMove ( _, _, x, y )
	if ( x >= rec_x and y >= rec_y+163 and x <= rec_x+150 and y <= rec_y+163+53  ) then
		drawData.hover_buy = true
		drawData.hover_close = false
		drawData.hover_editColor = false
		return
	elseif ( x >=  (( rec_x+313)-150 )  and y >= rec_y+163 and x <= ( rec_x+313 ) and y <= rec_y+163+53 ) then
		drawData.hover_close = true
		drawData.hover_buy = false
		drawData.hover_editColor = false
		return
	elseif ( x >= rec_x+90 and y >= rec_y+90 and x <= rec_x+140 and y <= rec_y + 115 ) then
		drawData.hover_editColor = true
		drawData.hover_close = false
		drawData.hover_buy = false
		return
	end
	
	drawData.hover_buy = false
	drawData.hover_close = false
	drawData.hover_editColor = false
end

function onEvent_CursorClick ( )
	if ( drawData.hover_close ) then
		restoreSettings ( )
	elseif ( drawData.hover_editColor ) then
		exports['cpicker']:openPicker ( localPlayer, 'fff', 'Vehicle Shop Color Picker' )
	elseif ( drawData.hover_buy ) then
		if ( getPlayerMoney ( localPlayer ) >= carList[carIndex][2] ) then
			local sx, sy, sz, srz = unpack ( spawnPosition )
			local id = carList[carIndex][1]
			local price = carList[carIndex][2]
			triggerServerEvent ( "NGVehicles:onClientBuyVehicle", localPlayer, id, price, { sx, sy, sz, srz }, { getVehicleColor ( PreviewVehicle, true ) } )
			restoreSettings ( )
		else
			exports['NGMessages']:sendClientMessage ( "You don't have enough money for this vehicle.", 255, 0, 0 )
		end
	end
end 

function restoreSettings ( )
	showChat ( true )
	showCursor ( false )
	showPlayerHudComponent ( 'all', true )
	carList = nil
	carIndex = nil
	if ( isElement ( PreviewVehicle ) ) then destroyElement ( PreviewVehicle ) end
	createtionPointX = nil
	createtionPointX = nil
	removeEventHandler ( 'onClientPreRender', root, dxDrawVehicleShop )
	removeEventHandler ( 'onClientCursorMove', root, onEvent_CursorMove )
	removeEventHandler ( 'onClientClick', root, onEvent_CursorClick )
	setCameraTarget ( localPlayer )
	drawData.hover_close = false
	drawData.hover_buy = false
	drawData.hover_editColor = false
	toggleAllControls ( true )
	unbindKey ( "arrow_l", "down", changeCar.left )
	unbindKey ( "arrow_r", "down", changeCar.right )
	spawnPosition = nil
end

addEvent ( "onColorPickerOK", true )
addEventHandler ( "onColorPickerOK", root, function ( e, hex, r, g, b )
	if ( e == localPlayer ) then
		carColor = { r, g, b }
	end
end )

function convertNumber ( number )  
	local formatted = number  
	while true do      
		formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')    
		if ( k==0 ) then      
			break   
		end  
	end  
	return formatted
end function RGBToHex(red, green, blue, alpha)
	if((red < 0 or red > 255 or green < 0 or green > 255 or blue < 0 or blue > 255) or (alpha and (alpha < 0 or alpha > 255))) then
		return nil
	end
	if(alpha) then
		return string.format("#%.2X%.2X%.2X%.2X", red,green,blue,alpha)
	else
		return string.format("#%.2X%.2X%.2X", red,green,blue)
	end
end