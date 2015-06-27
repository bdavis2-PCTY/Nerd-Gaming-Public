local locations = {
	{ 1984.82, -1994.24, 13.55 },
	{ -82.1, -1602.55, 2.62 },
	{ -2238.09, -2305.26, 30.52 },
	{ -2233.13, 299.29, 35.12 },
	{ -33.92, 1171.19, 19.42 },
	{ 2211.84, 1515.69, 10.82 }
}

local points = {
	marker = { },
	blip = { }
}

local InMarker = nil

addEventHandler ( "onClientResourceStart", resourceRoot, function ( )
	setTimer ( function ( )
		local makeBlips = exports.ngphone:getSetting ( "usersetting_display_usedvehicleshopblips" );
		for i, loc in ipairs ( locations ) do 
			local x, y, z = unpack ( loc )
			points.marker[i] = createMarker ( x, y, z - 1, 'cylinder', 3.5, 255, 140, 0, 120 );
			addEventHandler ( "onClientMarkerHit", points.marker[i], function ( p )
				if ( p == localPlayer and not isPedInVehicle ( p ) ) then 
					InMarker = source;
					createWindow ( )
				end 
			end );
			
			if ( makeBlips ) then 
				points.blip[i] = exports.customblips:createCustomBlip ( x, y, 20, 20, "blip.png", 245 )
			end 
		end 
	end, 1500, 1 );
end );

addEvent( "onClientUserSettingChange", true );
addEventHandler ( "onClientUserSettingChange", root, function ( setting, to )
	if ( setting == "usersetting_display_usedvehicleshopblips" ) then 
		for i, v in pairs ( points.blip ) do 
			if ( v ) then 
				exports.customblips:destroyCustomBlip ( v );
			end 
		end 
		
		points.blip = { }

		if ( to ) then 
			for i, loc in ipairs ( locations ) do 
				local x, y, z = unpack ( loc )
				points.blip[i] = exports.customblips:createCustomBlip ( x, y, 20, 20, "blip.png", 245 )
			end 
		end 
	end 
end );


sx_, sy_ = guiGetScreenSize ( );
sx, sy = sx_/1280, sy_/768;

local vList = { }
local tempVehicle = nil;
local tempPed = nil;

local gui = { 
	details = { }
}

function createWindow ( ) 
	if ( isElement ( gui.usedWind ) ) then 
		return
	end

	triggerServerEvent ( "NGShops->UsedVehicles->onClientRequestUsedList", localPlayer );

	-- Main used vehicle menu
	gui.usedWind = guiCreateWindow(sx*12, sy*317, sx*417, sy*436, "Used Vehicle Shop", false)
	guiWindowSetSizable(gui.usedWind, false)
	guiWindowSetMovable(gui.usedWind, false)
	gui.usedList = guiCreateGridList(sx*9, sy*25, sx*398, sy*262, false, gui.usedWind)
	guiGridListAddColumn(gui.usedList, "Vehicle", 0.35)
	guiGridListAddColumn(gui.usedList, "Price", 0.2)
	guiGridListAddColumn(gui.usedList, "Owner", 0.35)
	guiGridListSetSortingEnabled ( gui.usedList, false );
	
	guiGridListSetItemText ( gui.usedList, guiGridListAddRow ( gui.usedList ), 1, "Loading...", true, true );
	
	gui.vDetails = guiCreateLabel(sx*14, sy*296, sx*212, sy*130, "Vehicle: None\n\nOwner: None\n\nSell Price: None", false, gui.usedWind)
	gui.viewDesc = guiCreateButton(sx*237, sy*296, sx*170, sy*21, "View Description", false, gui.usedWind)
	gui.purchase = guiCreateButton(sx*237, sy*327, sx*170, sy*21, "Purchase vehicle", false, gui.usedWind)
	gui.addVehicle = guiCreateButton(sx*237, sy*358, sx*170, sy*21, "Add a vehicle", false, gui.usedWind)
	gui.exitShop = guiCreateButton(sx*237, sy*389, sx*170, sy*21, "Exit shop", false, gui.usedWind)
	
	-- Vehicle details menu
	gui.details.window = guiCreateWindow((sx_/2-(sx*478)/2), (sy_/2-(sy*386)/2), sx*478, sy*386, "Vehicle Details", false)
	guiWindowSetSizable(gui.details.window, false)
	guiSetVisible ( gui.details.window, false );
	gui.details.details = guiCreateMemo(sx*9, sy*21, sx*459, sy*317, "", false, gui.details.window)
	guiMemoSetReadOnly(gui.details.details, true)
	gui.details.ok = guiCreateButton(sx*10, sy*348, sy*458, sy*28, "OK!", false, gui.details.window)

	showCursor ( true );
	exports.ngmessages:sendClientMessage ( "Please wait as the used vehicle shop is loaded", 255, 140, 0 );
	addEventHandler ( "onClientGUIClick", root, onGuiClick );
	setCameraMatrix ( 2525.9, -2364.19, 15.94, 2516.25, -2354.31, 13.63 );
	showPlayerHudComponent ( 'all', false );
	addEventHandler ( "onClientPreRender", root, onRender );
end

function onRender ( )
	if ( isElement( tempVehicle ) ) then
		local _, _, rz = getElementRotation ( tempVehicle );
		local rz = rz - 1;
		if ( rz <= 1 ) then 
			rz = 359;
		end 
		
		setElementRotation ( tempVehicle, 0, 0, rz );
	end
end 

function destroyWindow ( ) 
	if ( isElement ( gui.usedWind ) ) then 
		destroyElement ( gui.usedWind );
	end if ( isElement ( gui.details.window ) ) then 
		destroyElement ( gui.details.window );
	end if ( isElement ( tempVehicle ) ) then 
		destroyElement ( tempVehicle )
	end if ( isElement ( tempPed ) ) then 
		destroyElement ( tempPed );
	end 
	
	if ( sell ) then 
		if ( isElement ( sell.window ) ) then 
			destroyElement ( sell.window )
		end 
	end
	
	showCursor ( false );
	removeEventHandler ( "onClientGUIClick", root, onGuiClick );
	removeEventHandler ( "onClientPreRender", root, onRender );
	showPlayerHudComponent ( 'all', true );
	setCameraTarget ( localPlayer );
	
	if ( InMarker ) then 
		local x, y, z = getElementPosition ( InMarker )
		setElementPosition ( localPlayer, x, y, z + 2 );
	end
end 

function onGuiClick ( )
	if ( source == gui.exitShop ) then 
		return destroyWindow ( )
	elseif ( source == gui.usedList ) then 
		local rot = 0;
		if ( isElement ( tempVehicle ) ) then
			_, _, rot = getElementRotation ( tempVehicle );
			destroyElement ( tempVehicle );
		end
		
		if ( isElement ( tempPed ) ) then 
			destroyElement ( tempPed )
		end
	
		guiSetText ( gui.vDetails, "Vehicle: None\n\nOwner: None\n\nSell Price: None" );
		local r, c = guiGridListGetSelectedItem ( source );
		if ( r ~= -1 ) then 
			local veh = guiGridListGetItemText ( source, r, 1 );
			local price = guiGridListGetItemText ( source, r, 2 );
			local owner = guiGridListGetItemText ( source, r, 3 );
			local data = guiGridListGetItemData ( source, r, 1 );
			guiSetText ( gui.vDetails, "Vehicle: "..veh.."\n\nOwner: "..owner.."\n\nSell Price: "..price );
			
			local r, g, b = unpack ( data.color );
			tempVehicle = createVehicle ( getVehicleModelFromName ( veh ), 2519, -2354.31, 14.5, 0, 0, rot );
			tempPed = createPed ( getElementModel ( localPlayer ), 0, 0, 0 );
			warpPedIntoVehicle ( tempPed, tempVehicle, 0 );
			setPedControlState ( tempPed, "accelerate", true );
			setPedControlState ( tempPed, "vehicle_left", true );
			
			setElementFrozen ( tempVehicle, true );
			
			for _, upgrade in pairs ( data.upgrades ) do 
				addVehicleUpgrade ( tempVehicle, upgrade );
			end
			
			local r, g, b = tonumber ( data.color.r ), tonumber ( data.color.g ), tonumber ( data.color.b );
			
			-- Has to be in a timer
			-- Won't set the vehicle color if not 
			setTimer ( setVehicleColor, 50, 1, tempVehicle, r, g, b );
			
		end 
	elseif ( source == gui.viewDesc ) then 
		local r, _ = guiGridListGetSelectedItem ( gui.usedList );
		if ( r == -1 ) then
			return exports.ngmessages:sendClientMessage ( "You must select a vehicle for this action!", 200, 100, 130 );
		end
		guiSetVisible ( gui.details.window, true );
		guiSetText ( gui.details.details, tostring ( guiGridListGetItemData(gui.usedList,r,1).desc ) );
		guiBringToFront ( gui.details.window );
	elseif ( source == gui.details.ok ) then 
		guiSetVisible ( gui.details.window, false );
	elseif ( source == gui.purchase ) then 
		local r, _ = guiGridListGetSelectedItem ( gui.usedList );
		if ( r == -1 ) then 
			return exports.ngmessages:sendClientMessage ( "You must select a vehicle for this action!", 200, 100, 130 );
		end 
		
		local id = guiGridListGetItemData ( gui.usedList, r, 1 ).unique_id;
		
		askConfirm ( "Are you sure you would like to purchase this vehicle?", function ( x, id )
			if ( x ) then 
				triggerServerEvent ( "NGShops->UsedVehicles->onPlayerTryBuyVehicle", localPlayer, id );
			end
		end, id );
	elseif ( source == gui.addVehicle ) then 
		createSellWindow ( );
	end 
	
	
	if ( sell ) then 
		if ( source == sell.close ) then 
			closeSellWindow ( );
		elseif ( source == sell.sell ) then 
			local row, _ = guiGridListGetSelectedItem ( sell.list );
			if ( row == -1 ) then 
				return exports.ngmessages:sendClientMessage ( "You must one of your vehicles for this action!", 200, 100, 130 );
			end 
			
			local price = tonumber ( guiGetText ( sell.price ) );
			local desc = guiGetText ( sell.desc );
			
			local data = guiGridListGetItemData ( sell.list, row, 1 )
			
			if ( tostring ( data.Visible ) == "1" ) then 
				return exports.ngmessages:sendClientMessage ( "You must hide your vehicle before selling it", 200, 100, 130 );
			elseif ( tostring ( data.Impounded ) == "1" ) then 
				return exports.ngmessages:sendClientMessage ( "Your vehicle cannot be impounded when selling it.", 200, 100, 130 );
			elseif ( not price or math.floor ( price ) ~= price ) then 
				return exports.ngmessages:sendClientMessage ( "Invalid price - must be an integer (whole number)", 200, 100, 130 );
			elseif ( price < 1000 or price > 1000000000 ) then 
				return exports.ngmessages:sendClientMessage ( "Price must be $1,000 - $1,000,000,000", 200, 100, 130 );
			elseif ( string.len ( desc ) < 10 or string.len ( desc ) > 2000 )  then 
				return exports.ngmessages:sendClientMessage ( "Description must be 10-2000 characters", 200, 100, 130 );
			end 
			
			triggerServerEvent ( "NGUsedVehicles->SellVehicle->OnPlayerTrySellVehicle", localPlayer, data.VehicleID, price, desc );
			
		end 
	end 
end


addEvent ( "NGShops->UsedVehicles->onServerSendClientList", true );
addEventHandler ( "NGShops->UsedVehicles->onServerSendClientList", root, function ( list, mine )
	vList = list;
	myvehicles = mine

	guiGridListClear ( gui.usedList );
	
	if ( list and type ( list ) == "table" and table.len ( list ) > 0 ) then
		for _, data in pairs ( list ) do 
			local r = guiGridListAddRow ( gui.usedList );
			guiGridListSetItemText ( gui.usedList, r, 1, getVehicleNameFromModel ( data.vehicle_id ), false, false );
			guiGridListSetItemText ( gui.usedList, r, 3, tostring ( data.seller ), false, false );
			guiGridListSetItemText ( gui.usedList, r, 2, "$".. convertNumber ( data.price ), false, false );
			guiGridListSetItemData ( gui.usedList, r, 1, data );
			if ( getPlayerMoney ( localPlayer ) < data.price ) then 
				guiGridListSetItemColor ( gui.usedList, r, 1, 255, 0, 0 );
				guiGridListSetItemColor ( gui.usedList, r, 2, 255, 0, 0 );
				guiGridListSetItemColor ( gui.usedList, r, 3, 255, 0, 0 );
			else 
				guiGridListSetItemColor ( gui.usedList, r, 1, 0, 255, 0 );
				guiGridListSetItemColor ( gui.usedList, r, 2, 0, 255, 0 );
				guiGridListSetItemColor ( gui.usedList, r, 3, 0, 255, 0 );
			end
		end 
	else 
		guiGridListSetItemText ( gui.usedList, guiGridListAddRow ( gui.usedList ), 1, "No vehicles in stock", true, true );
	end 
	
end );

function table.len ( t )
	local l = 0;
	for _ in pairs ( t ) do l = l + 1; end 
	return l;
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


addEvent ( "NGUsedVehicles->Interface->SetInterfaceOpen", true )
addEventHandler ( "NGUsedVehicles->Interface->SetInterfaceOpen", root, function ( b )

	if ( b ) then 
		createWindow ( );
	else 
		destroyWindow ( )
	end

end );