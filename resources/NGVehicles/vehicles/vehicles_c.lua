local option = { }
local blips = { }
local vehicleData = { }
local sx, sy = guiGetScreenSize ( )
local rSX, rSY = sx / 1280, sx / 1024
local Vehicles = guiCreateWindow( (sx-(rSX*470))-5, (sy-(rSY*260))-5, rSX*466, rSY*260, "Vehicles", false)
local cars = guiCreateGridList((rSX*11), (rSY*28), (rSX*274), (rSY*220), false, Vehicles)
option['show'] = guiCreateButton((rSX*295), (rSY*28), (rSX*162), (rSY*40), "Show", false, Vehicles)
option['recover'] = guiCreateButton((rSX*295), (rSY*28)+((rSY*40))+(rSY*5), (rSX*162), (rSY*40), "Recover", false, Vehicles)
option['sell'] = guiCreateButton((rSX*295), (rSY*28)+((rSY*40)*2)+(rSY*10), (rSX*162), (rSY*40), "Sell", false, Vehicles)
option['give'] = guiCreateButton((rSX*295), (rSY*28)+((rSY*40)*3)+(rSY*15), (rSX*162), (rSY*40), "Give", false, Vehicles)
option['close'] = guiCreateButton((rSX*295), (rSY*28)+((rSY*40)*4)+(rSY*20), (rSX*162), (rSY*40), "Close", false, Vehicles)  
guiSetVisible ( Vehicles, false )
guiWindowSetSizable(Vehicles, false)
guiGridListAddColumn(cars, "ID", 0.15)
guiGridListAddColumn(cars, "Vehicle", 0.75)
guiGridListSetSortingEnabled ( cars, false )

local GiveWindow = guiCreateWindow( ( sx / 2 - 449 / 2 ), ( sy / 2 - 401 / 2 ), 449, 401, "Give Vehicle", false)
guiWindowSetSizable(GiveWindow, false)
guiSetVisible ( GiveWindow, false )
local gridGive = guiCreateGridList(9, 27, 430, 317, false, GiveWindow)
guiGridListAddColumn(gridGive, "Name", 0.9)
btnGiveGive = guiCreateButton(302, 354, 137, 33, "Give", false, GiveWindow)
btnGiveCancel = guiCreateButton(151, 354, 137, 33, "Cancel", false, GiveWindow)   




bindKey ( "F2", "down", function ( )
	if ( not exports['NGLogin']:isClientLoggedin ( ) ) then return end 
	local tos = not guiGetVisible ( Vehicles )
	guiSetVisible ( Vehicles, tos )
	showCursor ( tos )
	guiGridListClear ( cars )
	givingVehicle = nil
	if ( tos ) then
		reloadList ( )
		for i, v in pairs ( option  ) do 
			addEventHandler ( "onClientGUIClick", v, buttonClicking )
			if ( i ~= 'close' ) then
				guiSetEnabled ( v, false )
			end
		end
		addEventHandler ( "onClientGUIClick", cars, buttonClicking )
		addEventHandler ( "onClientGUIClick", btnGiveCancel, buttonClicking )
		addEventHandler ( "onClientGUIClick", btnGiveGive, buttonClicking )
	else
		closeMenu ( )
	end
end )

addEvent ( "NGVehicles:onServerSendClientVehicleList", true )
addEventHandler ( "NGVehicles:onServerSendClientVehicleList", root, function  ( cList ) 
	vehicleData = { }
	guiGridListClear ( cars )
	if ( #cList == 0 ) then
		guiGridListSetItemText ( cars, guiGridListAddRow ( cars ), 2, "You have no vehicles.", true, true )
	else
		local impoundedVehicles = ""
		for i, v in ipairs ( cList ) do
			if ( v[11] == 0 ) then
				local row = guiGridListAddRow ( cars )
				guiGridListSetItemText ( cars, row, 1, tostring ( i ), false, true )
				guiGridListSetItemText ( cars, row, 2, tostring ( getVehicleNameFromModel ( v[3] ) ), false, false )
				guiGridListSetItemData ( cars, row, 1, v[2] )
				table.insert ( vehicleData, v[2], v )
			else
				if (  impoundedVehicles == "" ) then
					impoundedVehicles = getVehicleNameFromModel ( v[3] )
				else
					impoundedVehicles = impoundedVehicles..", "..getVehicleNameFromModel ( v[3] )
				end
			end
		end
		if ( impoundedVehicles ~= "" ) then
			exports['NGMessages']:sendClientMessage ( "Vehicles: "..impoundedVehicles.." are impounded.", 255, 255, 0 )
		end
	end
end )

function buttonClicking ( )
	if ( source == option['close'] ) then
		closeMenu ( )
	elseif ( source == cars ) then
		local row, col = guiGridListGetSelectedItem ( cars )
		if ( row ~= -1 ) then
			for i, v in pairs ( option ) do guiSetEnabled ( v, true ) end
			local index = guiGridListGetItemData ( source, row, 1 )
			local visible = tonumber ( vehicleData[index][9] )
			if ( visible == 1 ) then visible = true else visible = false end
			if ( visible ) then
				guiSetText ( option['show'], "Hide" )
				vehicleData[index][9] = 1
			else
				guiSetText ( option['show'], "Show" )
				vehicleData[index][9] = 0
			end
		else
			for i,v in pairs ( option ) do
				guiSetEnabled ( v, false )
				if ( i == 'close' ) then
					guiSetEnabled ( v, true )
				elseif ( i == 'show' ) then
					guiSetText ( v, 'Show' )
				end
			end
		end
	elseif ( source == option['show'] ) then
		local row, col = guiGridListGetSelectedItem ( cars )
		if ( row ~= -1 ) then
			local index = guiGridListGetItemData ( cars, row, 1 )
			local visible = tonumber ( vehicleData[index][9] )
			if ( visible == 1 ) then visible = true else visible = false end
			triggerServerEvent ( "NGVehicles:SetVehicleVisible", localPlayer, vehicleData[index][2], not visible )
			if visible then
				guiSetText ( source, "Show" )
				vehicleData[index][9] = 0
			else
				guiSetText ( source, "Hide" )
				vehicleData[index][9] = 1
			end
		end
	elseif ( source == option['sell'] ) then
		local row, col = guiGridListGetSelectedItem ( cars )
		if ( row ~= -1 ) then
			local index = guiGridListGetItemData ( cars, row, 1 )
			local visible = tonumber ( vehicleData[index][9] )
			if ( visible == 1 ) then visible = true else visible = false end
			if ( visible ) then
				return exports['NGMessages']:sendClientMessage ( "Hide your vehicle before you sell it.", 255, 255, 0 )
			end
			triggerServerEvent ( "NGVehicles:sellPlayerVehicle", localPlayer, localPlayer, index )
			setTimer ( reloadList, 200, 1 )
		end
	elseif ( source == option['give'] ) then
		local row, col = guiGridListGetSelectedItem ( cars )
		if ( row ~= -1 ) then
			local index = guiGridListGetItemData ( cars, row, 1 )
			local visible = tonumber ( vehicleData[index][9] )
			if ( visible == 1 ) then visible = true else visible = false end
			if ( visible ) then
				return exports['NGMessages']:sendClientMessage ( "Please hide the vehicle to send it.", 255, 0, 0 )
			end
			local vehID = vehicleData[index][2]
			if ( vehID ) then
			
				guiSetVisible ( GiveWindow, true )
				guiBringToFront ( GiveWindow ) 
				guiGridListClear ( gridGive )
				givingVehicle = index
				local count = 0
				for i, v in ipairs ( getElementsByType ( 'player' ) ) do
					if ( v ~= localPlayer ) then
						guiGridListSetItemText ( gridGive, guiGridListAddRow ( gridGive ), 1, getPlayerName ( v ), false, false  )
						count = count + 1
					end
				end
				if ( count == 0 ) then
					guiGridListSetItemText ( gridGive, guiGridListAddRow ( gridGive ), 1, "Sorry, there are currently no players online.", true, true  )
				end
			end
		end
	elseif ( source == btnGiveCancel ) then
		guiSetVisible ( GiveWindow, false )
	elseif ( source == btnGiveGive ) then 
		local row, col = guiGridListGetSelectedItem ( gridGive )
		if ( row ~= -1 ) then
			local pName = guiGridListGetItemText ( gridGive, row, 1 )
			if ( not isElement ( getPlayerFromName ( pName ) ) ) then return exports['NGMessages']:sendClientMessage ( "Sorry, that player  no longer exists.", 255, 0, 0 ) end
			
			if ( vehicleData[givingVehicle][9] == 1 ) then return exports['NGMessages']:sendClientMessage ( "Hide the vehicle to give it.", 255, 0, 0 ) end
			local vehicleID = vehicleData[givingVehicle][2]
			triggerServerEvent ( "NGVehicles:onPlayerGivePlayerVehicle", localPlayer, vehicleID, getPlayerFromName ( pName ) )
			guiSetVisible ( GiveWindow, false ) 
			setTimer ( reloadList, 200, 1 )
		else
			exports['NGMessages']:sendClientMessage ( "Select a player to send your vehicle to.", 255, 0, 0 )
		end
	elseif ( source == option['recover'] ) then
		local row, col = guiGridListGetSelectedItem ( cars )
		if ( row == -1 ) then return end
		local data = vehicleData[guiGridListGetItemData ( cars, row, 1 )]
		if ( data[9] == 1 ) then return exports['NGMessages']:sendClientMessage ( "To recover your vehicle, please hide it first.", 255, 0, 0 ) end
		triggerServerEvent ( "NGVehicles:AttemptRecoveryOnID", localPlayer, data[2] )
	end
end

function closeMenu ( )
	guiSetText ( option['show'], "Show" )
	guiGridListClear ( cars )
	guiSetVisible ( Vehicles, false )
	showCursor ( false )
	vehicleData = nil
	for i, v in pairs ( option  ) do 
		removeEventHandler ( "onClientGUIClick", v, buttonClicking )
		guiSetEnabled ( v, false )
		if ( i == 'close' ) then
			guiSetEnabled ( v, true )
		elseif( i == 'show' ) then
			guiSetText ( v, "Show" )
		end
	end
	removeEventHandler ( "onClientGUIClick", cars, buttonClicking )
	removeEventHandler ( "onClientGUIClick", btnGiveCancel, buttonClicking )
	removeEventHandler ( "onClientGUIClick", btnGiveGive, buttonClicking )
	
	guiSetVisible ( GiveWindow, false )
end

function reloadList ( )
	guiGridListClear ( cars )
	guiGridListSetItemText ( cars, guiGridListAddRow ( cars ), 2, "Loading...", true, true )
	triggerServerEvent ( "NGVehicles:onClientRequestPlayerVehicles", localPlayer )
	for i, v in pairs ( option ) do 
		if ( i ~= 'close' ) then
			guiSetEnabled ( v, false )
		end
	end
end

function getVehicleVisiable ( id )
	local i = vehicleData[id][9]
	if ( i == 1 ) then
		return true
	else
		return false
	end
end