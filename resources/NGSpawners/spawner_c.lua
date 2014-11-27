local sx, sy  = guiGetScreenSize ( )
local rsx, rsy = sx / 1280, sy / 1024
local window = guiCreateWindow( ( sx / 2 - ( rsx*354 ) / 2 ), ( sy / 2 - (rsy*400) / 2 ), (rsx*354), (rsy*400), "Spawners", false)
local vehList = guiCreateGridList((rsx*9), (rsy*26), (rsx*335), (rsy*315), false, window)
local btnSpawn = guiCreateButton((rsx*13), (rsy*346), (rsx*149), (rsy*43), "Spawn", false, window)
local btnClose = guiCreateButton((rsx*195), (rsy*346), (rsx*149), (rsy*43), "Cancel", false, window)
guiWindowSetSizable(window, false)
guiSetVisible ( window, false )
guiGridListAddColumn(vehList, "Vehicle", 0.9)
local marker = nil
addEvent ( "NGSpawners:ShowClientSpawner", true )
addEventHandler ( "NGSpawners:ShowClientSpawner", root, function ( cars, mrker )
	if ( wasEventCancelled ( ) ) then	
		return
	end
	
	if ( not guiGetVisible ( window ) ) then 
		bindKey ( "space", "down", spawnClickingFunctions )
		showCursor ( true )
		guiSetVisible ( window, true )
		guiGridListClear ( vehList )
		addEventHandler ( 'onClientMarkerLeave', mrker, closeWindow )
		marker = mrker
		job = getElementData ( marker, "NGVehicles:JobRestriction" )
		guiGridListSetItemText ( vehList, guiGridListAddRow ( vehList ), 1, "Free Vehicles", true, true )
		for i, v in ipairs ( cars ) do
			local name = getVehicleNameFromModel ( v )
			local row = guiGridListAddRow ( vehList )
			guiGridListSetItemText ( vehList, row, 1, name, false, false )
			guiGridListSetItemData ( vehList, row, 1, v )
		end
		
		if ( exports.NGVIP:isPlayerVIP ( ) ) then
			local level = exports.NGVIP:getVipLevelFromName ( getElementData ( localPlayer, "VIP" ) )
			if ( level and level > 0 and VipVehicles [ level ] and #VipVehicles [ level ] > 0 ) then
				guiGridListSetItemText ( vehList, guiGridListAddRow ( vehList ), 1, "VIP Vehicles", true, true )
				for i, v in pairs ( VipVehicles [ level ] ) do
					local name = getVehicleNameFromModel ( v )
					local row = guiGridListAddRow ( vehList )
					guiGridListSetItemText ( vehList, row, 1, name, false, false )
					guiGridListSetItemData ( vehList, row, 1, v )
				end
			end
		end
		
		guiGridListSetSelectedItem ( vehList, 0, 1 )
		addEventHandler ( "onClientGUIClick", btnSpawn, spawnClickingFunctions )
		addEventHandler ( "onClientGUIClick", btnClose, spawnClickingFunctions )
	end
end )


function spawnClickingFunctions ( )
	if ( source == btnClose ) then
		closeWindow ( localPlayer )
	elseif ( source == btnSpawn ) or getKeyState( "space" ) == true then
		local row, col = guiGridListGetSelectedItem ( vehList )
		if ( row == -1 ) then
			return exports['NGMessages']:sendClientMessage ( "Select a vehicle to be spawn.", 255, 255, 0 )
		end
		
		local id = guiGridListGetItemData ( vehList, row, 1 )
		triggerServerEvent ( "NGSpawners:spawnVehicle", localPlayer, id, marker, true )
		closeWindow ( localPlayer )
	end
end 

function closeWindow ( p )
	if ( not p or p == localPlayer ) then
		removeEventHandler ( 'onClientMarkerLeave', marker, closeWindow )
		marker = nil
		guiSetVisible ( window, false )
		showCursor ( false )
		guiGridListClear ( vehList )
		removeEventHandler ( "onClientGUIClick", btnSpawn, spawnClickingFunctions )
		removeEventHandler ( "onClientGUIClick", btnClose, spawnClickingFunctions )
		unbindKey ( "space", "down", spawnClickingFunctions )
	end
end
addEvent ( "NGSpawners:CloseWindow", true )
addEventHandler ( "NGSpawners:CloseWindow", root, closeWindow )
