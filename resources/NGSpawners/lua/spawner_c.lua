local sx, sy = guiGetScreenSize ( )
local window = guiCreateWindow( ( sx / 2 - 354 / 2 ), ( sy / 2 - 366 / 2 ), 354, 366, "Spawners", false)
local vehList = guiCreateGridList(9, 26, 335, 276, false, window)
local btnSpawn = guiCreateButton(13, 313, 149, 43, "Spawn", false, window)
local btnClose = guiCreateButton(195, 312, 149, 43, "Cancel", false, window)
guiWindowSetSizable(window, false)
guiSetVisible ( window, false )
guiGridListAddColumn(vehList, "Vehicle", 0.9)
local marker = nil
addEvent ( "NGSpawners:ShowClientSpawner", true )
addEventHandler ( "NGSpawners:ShowClientSpawner", root, function ( cars, mrker )
	if ( not guiGetVisible ( window ) ) then 
		showCursor ( true )
		guiSetVisible ( window, true )
		guiGridListClear ( vehList )
		addEventHandler ( 'onClientMarkerLeave', mrker, closeWindow )
		marker = mrker
		job = getElementData ( marker, "NGVehicles:JobRestriction" )
		for i, v in ipairs ( cars ) do
			local name = getVehicleNameFromModel ( v )
			local row = guiGridListAddRow ( vehList )
			guiGridListSetItemText ( vehList, row, 1, name, false, false )
			guiGridListSetItemData ( vehList, row, 1, v )
		end
		guiGridListSetSelectedItem ( vehList, 0, 1 )
		addEventHandler ( "onClientGUIClick", btnSpawn, spawnClickingFunctions )
		addEventHandler ( "onClientGUIClick", btnClose, spawnClickingFunctions )
	end
end )


function spawnClickingFunctions ( )
	if ( source == btnClose ) then
		closeWindow ( )
	elseif ( source == btnSpawn ) then
		local row, col = guiGridListGetSelectedItem ( vehList )
		if ( row == -1 ) then
			return exports['NGMessages']:sendClientMessage ( "Select a vehicle to be spawn.", 255, 255, 0 )
		end
		
		local id = guiGridListGetItemData ( vehList, row, 1 )
		triggerServerEvent ( "NGSpawners:spawnVehicle", localPlayer, id, marker, true )
		closeWindow ( )
	end
end 

function closeWindow ( )
	removeEventHandler ( 'onClientMarkerLeave', marker, closeWindow )
	marker = nil
	guiSetVisible ( window, false )
	showCursor ( false )
	guiGridListClear ( vehList )
	removeEventHandler ( "onClientGUIClick", btnSpawn, spawnClickingFunctions )
	removeEventHandler ( "onClientGUIClick", btnClose, spawnClickingFunctions )
end
