local sx, sy = guiGetScreenSize ( );

unban = {}
unban.gui = { }
unban.plr = { }

function unban:create ( ) 
	unban.gui.window = guiCreateWindow((sx/2-836/2), (sy/2-401/2), 836, 401, "Unban Menu", false)
	guiWindowSetSizable(unban.gui.window, false)

	unban.gui.list = guiCreateGridList(9, 21, 817, 296, false, unban.gui.window)
	guiGridListAddColumn(unban.gui.list, "Account", 0.25)
	guiGridListAddColumn(unban.gui.list, "Serial", 0.3)
	guiGridListAddColumn(unban.gui.list, "IP", 0.2)
	guiGridListAddColumn(unban.gui.list, "Banned on", 0.2)
	guiGridListSetSortingEnabled ( unban.gui.list, false );
	
	unban.gui.search = guiCreateEdit(10, 327, 309, 29, "", false, unban.gui.window)
	
	unban.gui.filter_acc = guiCreateRadioButton(14, 364, 115, 26, "Account", false, unban.gui.window)
	unban.gui.filter_serial = guiCreateRadioButton(129, 364, 115, 26, "Serial", false, unban.gui.window)
	unban.gui.filter_ip = guiCreateRadioButton(244, 364, 115, 26, "IP", false, unban.gui.window)
	guiRadioButtonSetSelected(unban.gui.filter_acc, true)
	
	unban.gui.close = guiCreateButton(678, 327, 148, 59, "Exit", false, unban.gui.window)
	-- unban.gui.add = guiCreateButton(520, 327, 148, 59, "Add Ban", false, unban.gui.window)
	
	
	unban.plr.window = guiCreateWindow((sx/2-467/2), (sy/2-331/2), 467, 331, "Banned Player", false)
	guiWindowSetSizable(unban.plr.window, false)
	guiSetVisible ( unban.plr.window, false );
	unban.plr.close = guiCreateButton(13, 272, 113, 36, "Close", false, unban.plr.window)
	
	unban.plr.info = guiCreateLabel(23, 31, 415, 226, [[Account: Account Name
	
Serial: Player Serial

IP: Player IP

Banned on: Date banned on

Banned until: Unban date

Banned by: Admin that banned this player

Reason: The reason they were banned]], false, unban.plr.window)

	guiLabelSetHorizontalAlign(unban.plr.info, "left", true)
	unban.plr.unban = guiCreateButton(136, 272, 113, 36, "Unban", false, unban.plr.window)
	guiSetProperty(unban.plr.unban, "HoverTextColour", "FFFFAAAA")
	guiSetProperty(unban.plr.unban, "NormalTextColour", "FFFF0000")
	
	
	for serial, info in pairs ( unban.bans ) do 
		local r = guiGridListAddRow ( unban.gui.list );
		guiGridListSetItemText ( unban.gui.list, r, 1, tostring ( info.account ), false, false );
		guiGridListSetItemText ( unban.gui.list, r, 2, tostring ( info.serial ), false, false );
		guiGridListSetItemText ( unban.gui.list, r, 3, tostring ( info.ip ), false, false );
		guiGridListSetItemText ( unban.gui.list, r, 4, table.concat ( { info.unban_day, info.unban_month, info.unban_year }, "/" ), false, false );
	end 
	
	showCursor ( true );
	addEventHandler ( "onClientGUIClick", root, unban.onClick );
	addEventHandler ( "onClientGUIDoubleClick", root, unban.onDoubleClick );
	addEventHandler ( "onClientGUIChanged", root, unban.onChanged );
end

function unban:onDoubleClick ( ) 
	
	if ( source == unban.gui.list ) then
	
		if ( guiGetVisible ( unban.plr.window ) ) then
			unban.selectedPlr = false;
			guiSetVisible ( unban.plr.window, false );
		end
		
		local r, c = guiGridListGetSelectedItem ( source )
		if ( r == -1 ) then return false end
	
		unban.selectedPlr = guiGridListGetItemText ( source, r, 2 );
		guiSetVisible ( unban.plr.window, true );
		
		local i = unban.bans [ unban.selectedPlr ];
		guiSetText ( unban.plr.info, string.format([[Account: %s
	
Serial: %s

IP: %s

Banned on: %s

Banned until: %s/%s/%s

Banned by: %s

Reason: %s]], i.account, i.serial, i.ip, i.banned_on, i.unban_day, i.unban_month, 
i.unban_year, i.banner, i.reason ) );

		guiBringToFront ( unban.plr.window );
		
		
	end 
	
end

function unban:onClick ( )
	
	if ( not source ) then return false end;
	
	if ( source == unban.gui.close ) then
		unban:hide ( );
		
	elseif ( source == unban.gui.filter_acc or source == unban.gui.filter_serial or source == unban.gui.filter_ip ) then
		triggerEvent ( "onClientGUIChanged", unban.gui.search );
	
	elseif ( source == unban.plr.close ) then
		guiSetVisible ( unban.plr.window, false );
		
	elseif ( source == unban.plr.unban ) then
		
		askConfirm ( "Are you sure you want to unban '".. unban.bans[unban.selectedPlr].account .."'?", function ( b )
			
			if ( not b ) then return false end
			
			exports.ngmessages:sendClientMessage ( "Unbanning ".. unban.bans[unban.selectedPlr].account.." ("..unban.selectedPlr..")..." );
			
			triggerServerEvent ( "NGBans->Administrative->onClientRequestPlayerUnban", localPlayer, unban.selectedPlr );
			
		end );
	
	end 
end 

function unban:onChanged ( )
	if ( source == unban.gui.search ) then 
		local t = guiGetText ( source ):lower( )
		
		local filter;
		
		if ( guiRadioButtonGetSelected ( unban.gui.filter_acc ) ) then
			filter = "account";
		elseif ( guiRadioButtonGetSelected ( unban.gui.filter_serial ) ) then
			filter = "serial";
		else
			filter = "ip";
		end
		
		guiGridListClear ( unban.gui.list );
		
		if ( t:gsub ( " ", "" ) == "" ) then 
			for serial, info in pairs ( unban.bans ) do 
				local r = guiGridListAddRow ( unban.gui.list );
				guiGridListSetItemText ( unban.gui.list, r, 1, tostring ( info.account ), false, false );
				guiGridListSetItemText ( unban.gui.list, r, 2, tostring ( info.serial ), false, false );
				guiGridListSetItemText ( unban.gui.list, r, 3, tostring ( info.ip ), false, false );
				guiGridListSetItemText ( unban.gui.list, r, 4, table.concat ( { info.unban_day, info.unban_month, info.unban_year }, "/" ), false, false );
			end 
		else 
			for serial, info in pairs ( unban.bans ) do 
				local passed = false;
				
				if ( filter == "account" and info.account:lower():find ( t ) ) then 
					passed = true
				elseif ( filter == "serial" and info.serial:lower():find ( t ) ) then
					passed = true;
				elseif ( filter == "ip" and info.ip:lower():find ( t ) ) then
					passed = true;
				end
				
				if ( passed ) then
					local r = guiGridListAddRow ( unban.gui.list );
					guiGridListSetItemText ( unban.gui.list, r, 1, tostring ( info.account ), false, false );
					guiGridListSetItemText ( unban.gui.list, r, 2, tostring ( info.serial ), false, false );
					guiGridListSetItemText ( unban.gui.list, r, 3, tostring ( info.ip ), false, false );
					guiGridListSetItemText ( unban.gui.list, r, 4, table.concat ( { info.unban_day, info.unban_month, info.unban_year }, "/" ), false, false );
				end
				
			end 
		end
		
		
	end 
end 

function unban:hide ( )
	unban.bans = nil
	
	if ( unban.plr and isElement ( unban.plr.window ) ) then
		destroyElement ( unban.plr.window )
	end
	
	if ( unban.gui and isElement ( unban.gui.window ) )then
		removeEventHandler ( "onClientGUIClick", root, unban.onClick );
		removeEventHandler ( "onClientGUIDoubleClick", root, unban.onDoubleClick );
		removeEventHandler ( "onClientGUIChanged", root, unban.onChanged );
		
		destroyElement ( unban.gui.window )
		showCursor ( false );
	end
	
end


addEvent ( "NGBans->Administrative->onPlayerOpenUnbanMenu", true );
addEventHandler ( "NGBans->Administrative->onPlayerOpenUnbanMenu", root, function ( _bans )	
	unban:hide ( );
	
	unban.bans = _bans;
	
	unban:create ( );
end );

