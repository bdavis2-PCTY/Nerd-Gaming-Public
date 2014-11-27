sx, sy = guiGetScreenSize ( )
local aManager = { button = {}, label = { } }
aManager.window 				= guiCreateWindow( ( sx / 2 - 582 / 2 ), ( sy / 2 - 478 / 2 ), 582, 478, "Account Manager", false)
aManager.accounts 				= guiCreateGridList(9, 28, 225, 404, false, aManager.window)
aManager.search 				= guiCreateEdit(9, 442, 225, 26, "", false, aManager.window)
aManager.scroll 				= guiCreateScrollPane(239, 33, 333, 435, false, aManager.window)
aManager.label["Username"]		= guiCreateLabel(4, 4, 329, 20, "Username: N/A", false, aManager.scroll)
aManager.label["Money"] 		= guiCreateLabel(4, 34, 329, 20, "Money: N/A", false, aManager.scroll)
aManager.label["Armour"] 		= guiCreateLabel(4, 64, 329, 20, "Armour: N/A", false, aManager.scroll)
aManager.label["Health"] 		= guiCreateLabel(4, 94, 329, 20, "Health: N/A", false, aManager.scroll)
aManager.label["x"] 			= guiCreateLabel(4, 124, 329, 20, "x: N/A", false, aManager.scroll)
aManager.label["y"] 			= guiCreateLabel(4, 154, 329, 20, "y: N/A", false, aManager.scroll)
aManager.label["z"] 			= guiCreateLabel(4, 184, 329, 20, "z: N/A", false, aManager.scroll)
aManager.label["Skin"] 			= guiCreateLabel(4, 214, 329, 20, "Skin: N/A", false, aManager.scroll)
aManager.label["Interior"]		= guiCreateLabel(4, 244, 329, 20, "Interior: N/A", false, aManager.scroll)
aManager.label["Dimension"] 	= guiCreateLabel(4, 274, 329, 20, "Dimension: N/A", false, aManager.scroll)
aManager.label["Team"] 			= guiCreateLabel(4, 304, 329, 20, "Team: N/A", false, aManager.scroll)
aManager.label["Job"] 			= guiCreateLabel(4, 334, 329, 20, "Job: N/A", false, aManager.scroll)
aManager.label["Playtime_hours"] = guiCreateLabel(4, 364, 329, 20, "Playtime_hours: N/A", false, aManager.scroll)
aManager.label["Playtime_mins"]	= guiCreateLabel(4, 394, 329, 20, "Playtime_mins: N/A", false, aManager.scroll)
aManager.label["JailTime"] 		= guiCreateLabel(4, 424, 329, 20, "JailTime: N/A", false, aManager.scroll)
aManager.label["WL"] 			= guiCreateLabel(4, 454, 329, 20, "WL: N/A", false, aManager.scroll)
aManager.label["Weapons"] 		= guiCreateLabel(4, 484, 329, 20, "Weapons: N/A", false, aManager.scroll)
aManager.label["JobRank"] 		= guiCreateLabel(4, 514, 329, 20, "JobRank: N/A", false, aManager.scroll)
aManager.label["GroupName"]	 	= guiCreateLabel(4, 544, 329, 20, "GroupName: N/A", false, aManager.scroll)
aManager.label["GroupRank"] 	= guiCreateLabel(4, 574, 329, 20, "GroupRank: N/A", false, aManager.scroll)
aManager.label["LastOnline"] 	= guiCreateLabel(4, 604, 329, 20, "LastOnline: N/A", false, aManager.scroll)
aManager.label["Bank"] 			= guiCreateLabel(4, 634, 329, 20, "Bank: N/A", false, aManager.scroll)
aManager.label["LastIP"] 		= guiCreateLabel(4, 664, 329, 20, "LastIP: N/A", false, aManager.scroll)
aManager.label["LastSerial"] 	= guiCreateLabel(4, 694, 329, 20, "LastSerial: N/A", false, aManager.scroll)
aManager.button['CloseWindow'] 	= guiCreateButton(199, 10, 107, 20, "Close Window", false, aManager.scroll)
aManager.button['ExecuteSave'] 	= guiCreateButton(199, 40, 107, 20, "Server Save", false, aManager.scroll)
aManager.button['BanAccount'] = guiCreateButton(199, 70, 107, 20, "Ban Account", false, aManager.scroll)
aManager.button['DeleteAccount'] = guiCreateButton(199, 100, 107, 20, "Delete Account", false, aManager.scroll)
aManager.button['EditVIP'] = guiCreateButton(199, 130, 107, 20, "Give VIP", false, aManager.scroll)
guiWindowSetSizable(aManager.window, false)
guiSetVisible ( aManager.window, false )
guiGridListAddColumn(aManager.accounts, "Account Name", 0.9)
guiGridListSetSortingEnabled ( aManager.accounts, false )


addEvent ( "NGAdministration:AccountManager:onClientOpenWindow", true )
addEventHandler ( "NGAdministration:AccountManager:onClientOpenWindow", root, function ( d )
	
	if ( guiGetVisible ( aManager.window ) ) then
		amCloseWindow ( )
	end
	guiSetText ( aManager.search, "" )
	guiGridListClear ( aManager.accounts )
	guiSetVisible ( aManager.window, true )
	showCursor ( true )
	addEventHandler ( "onClientGUIClick", aManager.accounts, amOnGUIClick )
	addEventHandler ( "onClientGUIClick", aManager.button['CloseWindow'], amOnGUIClick )
	addEventHandler ( "onClientGUIClick", aManager.button['ExecuteSave'], amOnGUIClick )
	addEventHandler ( "onClientGUIClick", aManager.button['BanAccount'], amOnGUIClick )
	addEventHandler ( "onClientGUIClick", aManager.button['DeleteAccount'], amOnGUIClick )
	addEventHandler ( "onClientGUIClick", aManager.button['EditVIP'], amOnGUIClick )
	addEventHandler ( "onClientGUIChanged", aManager.search, amOnGUIChange )
	
	accounts = { }
	accounts_invalid = { }
	local r = guiGridListAddRow ( aManager.accounts )
	guiGridListSetItemText ( aManager.accounts, r, 1, "Valid Accounts", true, true )
	guiGridListSetItemColor ( aManager.accounts, r, 1, 0, 255, 0 )
	for i, v in pairs ( d['valid'] ) do
		local r = guiGridListAddRow ( aManager.accounts )
		guiGridListSetItemText ( aManager.accounts, r, 1, tostring ( v.Username ), false, false )
		accounts[v.Username] = v
	end
	
	guiGridListSetItemText ( aManager.accounts, guiGridListAddRow ( aManager.accounts ), 1, "", true, true )
	local r = guiGridListAddRow ( aManager.accounts )
	guiGridListSetItemText ( aManager.accounts, r, 1, "Invalid Accounts", true, true )
	guiGridListSetItemColor ( aManager.accounts, r, 1, 255, 0, 0 )
	
	if ( table.size ( d['invalid'] ) > 0 ) then
		for i, v in pairs ( d['invalid'] ) do
			local r = guiGridListAddRow ( aManager.accounts )
			guiGridListSetItemText ( aManager.accounts, r, 1, tostring ( v.Username ), false, false )
			accounts[v.Username] = v
			accounts_invalid[v.Username] = v
		end
	else
		guiGridListSetItemText ( aManager.accounts, guiGridListAddRow ( aManager.accounts ), 1, "N/A", true, true )
	end
end )


function amOnGUIClick ( )
	if ( source == aManager.accounts ) then
		for i, v in pairs ( aManager.label ) do
			guiSetText ( v, tostring(i)..": N/A" )
		end
		local r, _ = guiGridListGetSelectedItem ( source )
		if ( r == -1 ) then return end
		local t = guiGridListGetItemText ( source, r, 1 )
		if ( not accounts [ t ] ) then return end
		for i, v in pairs ( aManager.label ) do
			if ( accounts [ t ] [ i ] ) then
				guiSetText ( v, i..": "..accounts [ t ] [ i ] )
			end
		end
		
		if ( accounts_invalid [ t ] ) then
			exports.NGMessages:sendClientMessage("Invalid - "..tostring(accounts_invalid[t].reason), 255, 0, 0 )
		end
		
	elseif ( source == aManager.button['CloseWindow'] ) then
		amCloseWindow ( )
	elseif ( source == aManager.button['DeleteAccount'] ) then
		local row,_ = guiGridListGetSelectedItem ( aManager.accounts )
		if ( row == -1 ) then return outputChatBox ( "No account selected.", 255, 0, 0 ) end
		name = guiGridListGetItemText ( aManager.accounts, row, 1 )

		askConfirm ( "Are you sure you want to delete account\n"..tostring(name).."?", amOnConfirmCallback )
	elseif ( source == aManager.button['ExecuteSave'] ) then
		askConfirm ( "Are you sure you want to save server data? May cause lag.", function ( x )
			if not x then return end
			triggerServerEvent ( "NGAdmin:aManager:ExecuteServerSave", localPlayer )
		end )
		
	elseif (source == aManager.button['BanAccount'] ) then
		local row,_ = guiGridListGetSelectedItem ( aManager.accounts )
		if ( row == -1 ) then return outputChatBox ( "You need to select an account", 255, 0, 0 ) end
		local acc = guiGridListGetItemText ( aManager.accounts, row, 1 )
		amCloseWindow ( )
		openBanWindow(acc)
	elseif ( source == aManager.button['EditVIP'] ) then
		local row,_ = guiGridListGetSelectedItem ( aManager.accounts )
		if ( row == -1 ) then return outputChatBox ( "You need to select an account", 255, 0, 0 ) end
		local acc = guiGridListGetItemText ( aManager.accounts, row, 1 )
		amCloseWindow ( )
		openVipEditWindow ( acc )
	end
end

function amOnGUIChange ( )
	if ( source == aManager.search ) then
		guiGridListClear ( aManager.accounts )
		local t = guiGetText ( source )
		
		local results = { ['valid'] = { }, ['invalid'] = { } }
		for i, v in pairs ( accounts ) do
			if ( string.find ( i:lower(), t:lower() ) ) then
				if ( v.reason ) then
					results['invalid'][i] = v
				else
					results['valid'][i] = v
				end
			end
		end
		
		local r = guiGridListAddRow ( aManager.accounts )
		guiGridListSetItemText ( aManager.accounts, r, 1, "Valid Accounts", true, true )
		guiGridListSetItemColor ( aManager.accounts, r, 1, 0, 255, 0 )
		if ( table.size ( results['valid'] ) > 0 ) then
			for i, v in pairs ( results['valid'] ) do
				local r = guiGridListAddRow ( aManager.accounts )
				guiGridListSetItemText ( aManager.accounts, r, 1, tostring ( i ), false, false )
			end
		else
			guiGridListSetItemText ( aManager.accounts, guiGridListAddRow ( aManager.accounts ), 1, "N/A", true, true )
		end
		
		guiGridListSetItemText ( aManager.accounts, guiGridListAddRow ( aManager.accounts ), 1, "", true, true )
		local r = guiGridListAddRow ( aManager.accounts )
		guiGridListSetItemText ( aManager.accounts, r, 1, "Invalid Accounts", true, true )
		guiGridListSetItemColor ( aManager.accounts, r, 1, 255, 0, 0 )
		if ( table.size ( results['invalid'] ) > 0 ) then
			for i, v in pairs ( results['invalid'] ) do
				local r = guiGridListAddRow ( aManager.accounts )
				guiGridListSetItemText ( aManager.accounts, r, 1, tostring ( i ), false, false )
			end
		else
			guiGridListSetItemText ( aManager.accounts, guiGridListAddRow ( aManager.accounts ), 1, "N/A", true, true )
		end
	end
end

function amOnConfirmCallback ( c )
	if c then
		triggerServerEvent ( "NGAdmin:amManager:removeAccountFromHistory", localPlayer, name )
	end
end

function amCloseWindow ( )
	guiGridListClear ( aManager.accounts ) 
	guiSetVisible ( aManager.window, false )
	showCursor ( false )
	removeEventHandler ( "onClientGUIClick", aManager.accounts, amOnGUIClick )
	removeEventHandler ( "onClientGUIClick", aManager.button['CloseWindow'], amOnGUIClick )
	removeEventHandler ( "onClientGUIClick", aManager.button['ExecuteSave'], amOnGUIClick )
	removeEventHandler ( "onClientGUIClick", aManager.button['DeleteAccount'], amOnGUIClick )
	removeEventHandler ( "onClientGUIClick", aManager.button['BanAccount'], amOnGUIClick )
	removeEventHandler ( "onClientGUIClick", aManager.button['EditVIP'], amOnGUIClick)
	removeEventHandler ( "onClientGUIChanged", aManager.search, amOnGUIChange )
end



function table.size ( tb )
	local s = 0
	for i, v in pairs ( tb ) do
		s =s + 1
	end
	return s
end