local user_shop = {
	functions = { },
	vars = { },
	gui = {
		main = { },
		pro = { }
	},
	
	locs = { 
		{ 1512.28, -1674.4, 14.05 },
		{ 2176.97, -1761.03, 13.55 },
		{ 1236.33, 211.6, 19.55 },
		{ 2335.43, -19.79, 26.48 },
		{ 2000.94, 1246.31, 10.81 },
		{ 1487.71, 2215.84, 11.02 },
		{ -154.09, 1181.54, 19.74 },
		{ -1675.47, 1319.94, 7.19 },
		{ -2677.69, -278.85, 7.17 },
		{ -1089.54, -1655.38, 76.37 },
	},
	
	markers = { },
	blips = { }
}


-- gui
local sx_, sy_ = guiGetScreenSize ( )
local sx, sy = sx_/1280, sy_/720

--------------------------
-- Main Gui				--
--------------------------
function user_shop.functions:createMainGui ( )
	user_shop.gui.main.window = guiCreateWindow((sx_/2-660/2), (sy_/2-435/2), 660, 435, "User Shop", false)
	guiWindowSetSizable(user_shop.gui.main.window, false)
	user_shop.gui.main.list = guiCreateGridList(11, 21, 639, 357, false, user_shop.gui.main.window)
	guiGridListAddColumn(user_shop.gui.main.list, "Item", 0.3)
	guiGridListAddColumn(user_shop.gui.main.list, "Price/1", 0.2)
	guiGridListAddColumn(user_shop.gui.main.list, "Amount", 0.2)
	guiGridListAddColumn(user_shop.gui.main.list, "Seller", 0.25)
	guiGridListSetItemText ( user_shop.gui.main.list, guiGridListAddRow ( user_shop.gui.main.list ), 1, "Downloading list... Please wait", true, true )
	guiGridListSetSortingEnabled ( user_shop.gui.main.list, false )
	user_shop.gui.main.purchAmount = guiCreateEdit(11, 388, 38, 27, "1", false, user_shop.gui.main.window)
	user_shop.gui.main.purchase = guiCreateButton(49, 388, 109, 27, "Purchase", false, user_shop.gui.main.window)
	user_shop.gui.main.filter = guiCreateButton(329, 388, 58, 27, "Filter", false, user_shop.gui.main.window)
	user_shop.gui.main.filtEdit = guiCreateEdit(206, 388, 123, 27, "", false, user_shop.gui.main.window)
	user_shop.gui.main.exit = guiCreateButton(558, 388, 90, 27, "Exit", false, user_shop.gui.main.window)
	user_shop.gui.main.myitems = guiCreateButton(460, 388, 90, 27, "My Items", false, user_shop.gui.main.window)
	addEventHandler ( "onClientGUIClick", root, _G['user_shop.functions:onClientGUIClick'] )
	addEventHandler ( "onClientGUIChanged", root, _G['user_shop.functions:onClientGUIChanged'] )
	showCursor ( true )
	_G['user_shop.functions:refreshPanel'] ( )
	
	if ( isTimer ( _G['user_shop.vars:refreshTimer'] ) ) then	
		killTimer ( _G['user_shop.vars:refreshTimer'] )
	end
	
	_G['user_shop.vars:refreshTimer'] = setTimer ( _G['user_shop.functions:refreshPanel'], 1000, 0 )
end

_G['user_shop.functions:destroyMainGui'] = function ( )
	for i, v in pairs ( user_shop.gui.main ) do
		if ( v and isElement ( v ) ) then
			local t = getElementType ( v )
			if ( t and string.sub ( t, 0, 4 ) == 'gui-' ) then
				destroyElement ( v )
				user_shop.gui.main [ i ] = nil
			end
		end
	end
	removeEventHandler ( "onClientGUIClick", root, _G['user_shop.functions:onClientGUIClick'] )
	removeEventHandler ( "onClientGUIChanged", root, _G['user_shop.functions:onClientGUIChanged'] )
	showCursor( false )
	if ( isTimer ( _G['user_shop.vars:refreshTimer'] ) ) then	
		killTimer ( _G['user_shop.vars:refreshTimer'] )
	end
end 
 
 _G['user_shop.functions:refreshPanel'] = function ( )
	triggerServerEvent ( "NGShops:Module->UserShp:getShopList", localPlayer )
 end
 
 _G['user_shop.functions:triggerSearchFilter'] = function ( )
	local count = guiGridListGetRowCount ( user_shop.gui.main.list )
	local search = tostring ( guiGetText ( user_shop.gui.main.filtEdit ) ):lower ( )
	if ( count < 0 ) then return false end
	if ( search == "" ) then
		for i=0, count-1 do
			for k=1, 4 do
				guiGridListSetItemColor ( user_shop.gui.main.list, i, k, 255, 255, 255 )
			end
		end
		return false;
	end
	
	local r = { }
	for i=0, count-1 do
		local item = tostring ( guiGridListGetItemText ( user_shop.gui.main.list, i, 1 ) ):lower ( )
		local seller = tostring ( guiGridListGetItemText ( user_shop.gui.main.list, i, 4 ) ):lower ( )
		
		local remove = true
		
		if ( string.find ( item, search ) or string.find ( seller, search ) ) then
			remove = false
		end
		
		if  ( remove ) then
			local d = guiGridListGetItemData ( user_shop.gui.main.list, i, 1 )
			r [ d.this_id ] = true
		end
	end
	
	for i, v in pairs ( r ) do
		for k=0, count-1 do
			local d = guiGridListGetItemData ( user_shop.gui.main.list, k, 1 )
			if ( d.this_id == i ) then
				guiGridListRemoveRow ( user_shop.gui.main.list, k )
				break
			end
		end
	end
end

_G['user_shop.functions:purchaseCurrentItem'] = function ( )
	local row, _ = guiGridListGetSelectedItem ( user_shop.gui.main.list )
	if ( row == -1 ) then
		return exports.NGMessages:sendClientMessage ( "There is currently no item selected. Please select an item.", 255, 255, 0 )
	end
	
	local data = guiGridListGetItemData ( user_shop.gui.main.list, row, 1 )
	local ammount = guiGetText ( user_shop.gui.main.purchAmount )
	if ( ammount == "" ) then
		return exports.NGMessages:sendClientMessage ( "Please enter the amount that you would like to purchase", 255, 255, 0 )
	end
	
	local ammount = tonumber ( ammount )
	if ( ammount < 0 ) then
		return exports.NGMessages:sendClientMessage ( "invalid amount", 255, 0, 0 )
	end
	
	if ( ammount > data.quantity ) then
		return exports.NGMessages:sendClientMessage ( "The seller only has "..tostring(data.quantity).." for sale.", 255, 255, 0 )
	end
	
	triggerServerEvent ( "NGShops:Module->UserShop:onClientAttemptBuyItem", localPlayer, data.this_id, ammount )
	
end
 
 addEvent ( "NGShops:Module->UserShop:onClientReciveList", true )
 addEventHandler ( "NGShops:Module->UserShop:onClientReciveList", root, function ( list )
	if ( not isElement ( user_shop.gui.main.list ) ) then return end
	local r, _ = guiGridListGetSelectedItem ( user_shop.gui.main.list )
	if ( r ~= -1 ) then
		selectedId = guiGridListGetItemData ( user_shop.gui.main.list, r, 1 ).this_id
	end
	
	guiGridListClear ( user_shop.gui.main.list )
	if ( type ( list ) == "table" and table.len ( list ) > 0 ) then
		for i, v in pairs ( list ) do
			local r = guiGridListAddRow ( user_shop.gui.main.list )
			guiGridListSetItemText ( user_shop.gui.main.list, r, 1, itemList [ v.item:lower( ) ], false, false )
			guiGridListSetItemText ( user_shop.gui.main.list, r, 2, "$"..v.amountperone, false, false )
			guiGridListSetItemText ( user_shop.gui.main.list, r, 3, v.quantity, false, false )
			guiGridListSetItemText ( user_shop.gui.main.list, r, 4, v.seller_account, false, false )
			guiGridListSetItemData ( user_shop.gui.main.list, r, 1, v )
		end
		if ( selectedId ) then
			for i=0, guiGridListGetRowCount ( user_shop.gui.main.list )-1 do
				local id = guiGridListGetItemData ( user_shop.gui.main.list, i, 1 ).this_id
				if ( id == selectedId ) then
					guiGridListSetSelectedItem ( user_shop.gui.main.list, i, 1 )
					break
				end
			end
		end
		selectedId = nil
		_G['user_shop.functions:triggerSearchFilter'] ( );
	else
		guiGridListSetItemText ( user_shop.gui.main.list, guiGridListAddRow ( user_shop.gui.main.list ), 1, "No items in database", true, true )
	end
 end )



------------------------------
-- User Items				--
------------------------------
function user_shop.functions:createProfileGui ( )
	user_shop.gui.pro.window = guiCreateWindow((sx_/2-sx*468/2), (sy_/2-sy*462/2), sx*468, sy*462, "User Shop", false)
	guiWindowSetSizable(user_shop.gui.pro.window, false)
	user_shop.gui.pro.add_lbl = guiCreateLabel(sx*10, sy*23, sx*260, sy*16, "Add Items", false, user_shop.gui.pro.window)
	guiSetFont(user_shop.gui.pro.add_lbl, "default-bold-small")
	user_shop.gui.pro.add_items = guiCreateGridList(sx*9, sy*46, sx*266, sy*144, false, user_shop.gui.pro.window)
	guiGridListAddColumn(user_shop.gui.pro.add_items, "Item", 0.5)
	guiGridListAddColumn(user_shop.gui.pro.add_items, "Amount", 0.3)
	user_shop.gui.pro.add_lbl2 = guiCreateLabel(sx*285, sy*49, sx*164, sy*17, "Price per each:", false, user_shop.gui.pro.window)
	user_shop.gui.pro.add_price = guiCreateEdit(sx*285, sy*66, sx*164, sy*24, "", false, user_shop.gui.pro.window)
	user_shop.gui.pro.add_lbl3 = guiCreateLabel(sx*286, sy*100, sx*164, sy*17, "Quantity:", false, user_shop.gui.pro.window)
	user_shop.gui.pro.add_quan = guiCreateEdit(sx*285, sy*117, sx*164, sy*24, "", false, user_shop.gui.pro.window)
	user_shop.gui.pro.add_add = guiCreateButton(sx*337, sy*156, sx*112, sy*33, "Add To Shop", false, user_shop.gui.pro.window)
	user_shop.gui.pro.my_lbl = guiCreateLabel(sx*10, sy*235, sx*294, sy*18, "My Items", false, user_shop.gui.pro.window)
	guiSetFont(user_shop.gui.pro.my_lbl, "default-bold-small")
	user_shop.gui.pro.my_grid = guiCreateGridList(12, 255, 446, 156, false, user_shop.gui.pro.window)
	guiGridListAddColumn(user_shop.gui.pro.my_grid, "Item", 0.4)
	guiGridListAddColumn(user_shop.gui.pro.my_grid, "Amount", 0.2)
	guiGridListAddColumn(user_shop.gui.pro.my_grid, "Price", 0.2)
	user_shop.gui.pro.exit = guiCreateButton(346, 419, 112, 33, "Back To Shop", false, user_shop.gui.pro.window)
	addEventHandler ( "onClientGUIClick", root, _G['user_shop.functions:onClientGUIClick'] )
	addEventHandler ( "onClientGUIChanged", root, _G['user_shop.functions:onClientGUIChanged'] )
	guiGridListSetSortingEnabled ( user_shop.gui.pro.add_items, false )
	guiGridListSetSortingEnabled ( user_shop.gui.pro.my_grid, false )
	guiGridListSetItemText ( user_shop.gui.pro.my_grid, guiGridListAddRow ( user_shop.gui.pro.my_grid ), 1, "Loading items...", true, true )
	showCursor ( true )
	_G['user_shop.functions:refreshProfileList'] ( );
	local items = getElementData ( localPlayer, "NGUser:Items" ) or { }
	if ( not items or type ( items ) ~= "table" or table.len ( items ) <= 0 ) then
		return guiGridListSetItemText ( user_shop.gui.pro.add_items, guiGridListAddRow ( user_shop.gui.pro.add_items ), 1, "No items", true, true )
	else
		for i, v in pairs ( items ) do
			if ( itemList [ i:lower ( ) ] and tonumber ( v ) ~= 0 ) then
				local r = guiGridListAddRow ( user_shop.gui.pro.add_items )
				guiGridListSetItemText ( user_shop.gui.pro.add_items, r, 1, tostring ( itemList [ i:lower( ) ] ), false ,false )
				guiGridListSetItemText ( user_shop.gui.pro.add_items, r, 2, tostring ( v ), false ,false )
				guiGridListSetItemData ( user_shop.gui.pro.add_items, r, 1, { item=i, quantity=v } )
			end
		end
	end
	_G['user_shop.vars:refreshProfileListTimer'] = setTimer (  _G['user_shop.functions:refreshProfileList'], 1000, 0 )
end

function user_shop.functions:destroyProfileGui ( )
	for i, v in pairs ( user_shop.gui.pro ) do
		if ( v and isElement ( v ) ) then
			local t = getElementType ( v )
			if ( t:sub ( 0, 4 ) == "gui-" ) then
				destroyElement ( v )
			end
		end
	end
	user_shop.gui.pro = { }
	removeEventHandler ( "onClientGUIClick", root, _G['user_shop.functions:onClientGUIClick'] )
	removeEventHandler ( "onClientGUIChanged", root, _G['user_shop.functions:onClientGUIChanged'] )
	if ( isTimer ( _G['user_shop.vars:refreshProfileListTimer'] ) ) then
		killTimer ( _G['user_shop.vars:refreshProfileListTimer'] )
	end
end

_G['user_shop.functions:refreshProfileList'] = function ( )
	triggerServerEvent ( "NGShops:Module->UserShop:getProfileItems", localPlayer )
end

function user_shop.functions:attemptToSellMyItem ( )
	local r, c = guiGridListGetSelectedItem ( user_shop.gui.pro.add_items ) 
	if ( r == -1 )  then
		return exports.NGMessages:sendClientMessage ( "There is no item selected", 255, 255, 0 )
	end
	
	local price = guiGetText ( user_shop.gui.pro.add_price )
	if ( price == "" ) then return exports.NGMessages:sendClientMessage ( "Enter a price", 255, 255, 0 ) end
	local price = tonumber ( price )
	
	local quan = guiGetText ( user_shop.gui.pro.add_quan )
	if ( quan == "" ) then return exports.NGMessages:sendClientMessage ( "Enter an amount (quantity)", 255, 255, 0 ) end
	local quan = tonumber ( quan ) 
	
	local data = guiGridListGetItemData ( user_shop.gui.pro.add_items, r, 1 )
	local item = data.item
	local quantity = data.quantity
	
	if ( price > itemPrices[item:lower()].max or price < ( itemPrices[item:lower()].min or 0 ) ) then
		return exports.NGMessages:sendClientMessage ( "The max price for this item is $"..tostring(itemPrices[item:lower()].max).." and the minimum price is $"..tostring(itemPrices[item:lower()].min), 255, 255, 0 )
	elseif ( quan == 0 ) then
		return exports.NGMessages:sendClientMessage ( "Invalid quantity", 255, 0, 0 )
	elseif ( quan > quantity ) then
		return exports.NGMessages:sendClientMessage ( "You don't have that much of this item.", 255, 255, 0 )
	end
	triggerServerEvent ( "NGShops:Module->UserShop:addItemToShop", localPlayer, item, quan, price )
end

addEvent ( "NGShops:Module->UserShop:sendClientItems", true )
addEventHandler ( "NGShops:Module->UserShop:sendClientItems", root, function ( list )
	-- top grid
	local r, c = guiGridListGetSelectedItem ( user_shop.gui.pro.add_items )
	guiGridListClear ( user_shop.gui.pro.add_items )
	local items = getElementData ( localPlayer, "NGUser:Items" ) or { }
	if ( not items or type ( items ) ~= "table" or table.len ( items ) <= 0 ) then
		return guiGridListSetItemText ( user_shop.gui.pro.add_items, guiGridListAddRow ( user_shop.gui.pro.add_items ), 1, "No items", true, true )
	else
		for i, v in pairs ( items ) do
			if ( itemList [ i:lower ( ) ] and tonumber ( v ) ~= 0 ) then
				local r = guiGridListAddRow ( user_shop.gui.pro.add_items )
				guiGridListSetItemText ( user_shop.gui.pro.add_items, r, 1, tostring ( itemList [ i:lower( ) ] ), false ,false )
				guiGridListSetItemText ( user_shop.gui.pro.add_items, r, 2, tostring ( v ), false ,false )
				guiGridListSetItemData ( user_shop.gui.pro.add_items, r, 1, { item=i, quantity=v } )
			end
		end
	end

	guiGridListSetSelectedItem ( user_shop.gui.pro.add_items, r, c )

	-- user items
	local sRow, sCol = guiGridListGetSelectedItem ( user_shop.gui.pro.my_grid )
	guiGridListClear ( user_shop.gui.pro.my_grid )
	if ( table.len ( list ) == 0 ) then
		guiGridListSetItemText ( user_shop.gui.pro.my_grid, guiGridListAddRow ( user_shop.gui.pro.my_grid ), 1, "You don't have any items in the shop", true, true )
		return
	end
	for i, v in pairs ( list ) do
		local r = guiGridListAddRow ( user_shop.gui.pro.my_grid )
		guiGridListSetItemText ( user_shop.gui.pro.my_grid, r, 1, tostring ( itemList [ tostring ( v.item ):lower ( ) ] ) .. "(s)", false, false )
		guiGridListSetItemText ( user_shop.gui.pro.my_grid, r, 2, tostring( v.quantity ), false, false )
		guiGridListSetItemText ( user_shop.gui.pro.my_grid, r, 3, "$"..tostring ( v.amountperone ).."/Unit", false, false )
		guiGridListSetItemData ( user_shop.gui.pro.my_grid, r, 1, v )
	end
	
	if ( r ~= -1 ) then
		guiGridListSetSelectedItem ( user_shop.gui.pro.my_grid, sRow, sCol )
	end
end )



------------------------------
-- Event Functions			--
------------------------------
_G['user_shop.functions:onClientGUIClick'] = function ( )
	if ( not source or not isElement ( source ) ) then return false end
	if ( source == user_shop.gui.main.exit ) then
		_G['user_shop.functions:destroyMainGui'] ( );
	elseif ( source == user_shop.gui.main.filter ) then
		_G['user_shop.functions:refreshPanel'] ( );
		_G['user_shop.functions:triggerSearchFilter'] ( );
	elseif ( source == user_shop.gui.main.purchase ) then
		_G['user_shop.functions:purchaseCurrentItem'] ( );
		_G['user_shop.functions:refreshPanel'] ( );
	elseif ( source == user_shop.gui.main.myitems ) then
		_G['user_shop.functions:destroyMainGui'] ( );
		user_shop.functions:createProfileGui ( )
	elseif ( source == user_shop.gui.pro.exit ) then
		user_shop.functions:destroyProfileGui ( )
		user_shop.functions:createMainGui ( )
	elseif ( source == user_shop.gui.pro.add_add ) then
		user_shop.functions:attemptToSellMyItem ( )
	end
end 

_G['user_shop.functions:onClientGUIChanged'] = function ( )
	if ( not source or not isElement ( source ))  then return end
	if ( source == user_shop.gui.main.purchAmount or
	source == user_shop.gui.pro.add_price or 
	source == user_shop.gui.pro.add_quan ) then
		guiSetText ( source, guiGetText(source):gsub ( "%p", "" ) )
		guiSetText ( source, guiGetText(source):gsub ( "%s", "" ) )
		guiSetText ( source, guiGetText(source):gsub ( "%a", "" ) )
	end
 end






------------------------------
-- Markers & Blips			--
local makeBlip = true
_G['user_shop.functions:loadMarkers'] = function ( )
	if ( makeBlip ) then
		user_shop.blips = { }
	else
		user_shop.blips = nil
	end
	
	for i,v in pairs ( user_shop.locs ) do
		local x, y, z = unpack ( v )
		user_shop.markers[i] = createMarker ( x, y,z - 1, "cylinder", 3.5, 200, 100, 0, 120 )
		addEventHandler ( "onClientMarkerHit", user_shop.markers[i], function ( p )
			if ( p == localPlayer and not isPedInVehicle ( p ) and not isElement ( user_shop.gui.main.window ) ) then
				user_shop.functions:createMainGui ( );
			end
		end )
		
		addEventHandler ( "onClientMarkerLeave", user_shop.markers[i], function ( p )
			if ( p == localPlayer and isElement ( user_shop.gui.main.window ) ) then
				_G['user_shop.functions:destroyMainGui'] ( );
			end
		end )
		
		if ( makeBlip and user_shop.blips ) then
			user_shop.blips[i] = createBlip ( x, y, z, 32, 2, 255, 255, 255, 255, 0, 450 )
		end
	end
end

addEvent ( "onClientPlayerLogin", true )
addEventHandler ( "onClientPlayerLogin", root, function ( )
	makeBlip = exports.NGPhone:getSetting ( "usersetting_display_usershopblips" );
	if ( not makeBlip and user_shop.blips ) then
		for i, v in pairs ( user_shop.blips ) do
			destroyElement ( v )
		end
		user_shop.blips = nil
	elseif ( makeBlip and not user_shop.blips ) then
		user_shop.blips = { }
		for i,v in pairs ( user_shop.locs ) do
			user_shop.blips[i] = createBlip ( x, y, z, 32, 2, 255, 255, 255, 255, 0, 450 )
		end
	end
end )

addEvent ( "onClientUserSettingChange", true )
addEventHandler ( "onClientUserSettingChange", root, function ( setting, makeBlip_ )
	if ( setting ~= "usersetting_display_usershopblips" ) then return end
	makeBlip = makeBlip_
	if ( not makeBlip and user_shop.blips ) then
		for i, v in pairs ( user_shop.blips ) do
			destroyElement ( v )
		end
		user_shop.blips = nil
	elseif ( makeBlip and not user_shop.blips ) then
		user_shop.blips = { }
		for i,v in pairs ( user_shop.locs ) do
			local x, y, z = unpack ( v )
			user_shop.blips[i] = createBlip ( x, y, z, 32, 2, 255, 255, 255, 255, 0, 450 )
		end
	end
end )

_G['user_shop.functions:loadMarkers'] ( )