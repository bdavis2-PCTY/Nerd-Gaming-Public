local sx, sy = guiGetScreenSize ( );

Inter = { };
Inter.btn = { };
Inter.grid = { };

Inter.window = guiCreateWindow((sx/2)-333, (sy/2)-333, 666, 510, "Mod Downloader Interface", false)
guiWindowSetSizable(Inter.window, false)
Inter.window.visible = false;
Inter.grid.list = guiCreateGridList(9, 24, 643, 364, false, Inter.window)
guiGridListAddColumn(Inter.grid.list, "Replace Vehicle", 0.3)
guiGridListAddColumn(Inter.grid.list, "New Vehicle", 0.35)
guiGridListAddColumn(Inter.grid.list, "Enabled", 0.15)
guiGridListAddColumn(Inter.grid.list, "Status", 0.15)
guiGridListSetSortingEnabled ( Inter.grid.list, false );
Inter.btn.enable = guiCreateButton(13, 397, 136, 39, "Enable", false, Inter.window)
Inter.btn.enableAll = guiCreateButton(13, 446, 136, 39, "Enable All", false, Inter.window)
Inter.btn.disable = guiCreateButton(159, 397, 136, 39, "Disable", false, Inter.window)
Inter.btn.disableAll = guiCreateButton(159, 446, 136, 39, "Disable All", false, Inter.window)
Inter.btn.refresh = guiCreateButton(516, 397, 136, 39, "Refresh", false, Inter.window)
Inter.btn.close = guiCreateButton(516, 446, 136, 39, "Exit", false, Inter.window)

function Inter.open ( b )
	if ( b == Inter.window.visible ) then return false; end
	
	Inter.window.visible = b;
	showCursor ( b );
	
	if ( b ) then 
		Inter.btn.enable.enabled = false;
		Inter.btn.disable.enabled = false;
		
		Inter.refresh ( );
		addEventHandler ( "onClientGUIClick", root, Inter.onEvent );
	else 
		removeEventHandler ( "onClientGUIClick", root, Inter.onEvent );
	end 
end 

function Inter.onEvent ( )

		if ( source == Inter.btn.close ) then 
			Inter.open ( false );
		elseif ( source == Inter.btn.refresh ) then 
			Inter.refresh ( );
		elseif ( source == Inter.grid.list ) then 
			local row, _ = guiGridListGetSelectedItem ( Inter.grid.list );
			Inter.btn.enable.enabled = ( ( row ~= -1 ) and ( guiGridListGetItemText( Inter.grid.list, row, 3 ) == "No" ) );
			Inter.btn.disable.enabled = ( ( row ~= -1 ) and ( guiGridListGetItemText( Inter.grid.list, row, 3 ) == "Yes" ) );
		elseif ( source == Inter.btn.enableAll or source == Inter.btn.disableAll ) then 
			if ( localPlayer:getOccupiedVehicle ( ) ) then 
				return outputChatBox ( "Please exit your vehicle before enabling or disabling mods", 255, 255, 0 );
			end
			
			for i, v in pairs ( Downloader.Mods ) do 
				Mods.SetModEnabled ( i, source == Inter.btn.enableAll );
			end 
			
			Inter.refresh ( );
		
		elseif ( source == Inter.btn.enable or source == Inter.btn.disable ) then 
			if ( localPlayer:getOccupiedVehicle ( ) ) then 
				return outputChatBox ( "Please exit your vehicle before enabling or disabling mods", 255, 255, 0 );
			end
			
			local row, _ = guiGridListGetSelectedItem ( Inter.grid.list );
			if ( row == - 1 ) then return end 
			Mods.SetModEnabled ( guiGridListGetItemText ( Inter.grid.list, row, 2 ), source == Inter.btn.enable  );
			Inter.refresh ( );
		end 
		
	--end 
end 

function Inter.refresh ( )
	local _row, col = guiGridListGetSelectedItem ( Inter.grid.list );

	guiGridListClear ( Inter.grid.list );
	
	local t = Downloader.Mods;
	table.sort ( t, function(a,b) 
		outputChatBox ( "a: "..tostring ( a ) );
		outputChatBox ( "b: "..tostring ( b ) );
		return a<b end 
	);
	
	for i, v in pairs ( t ) do
		local r, g, b = 0, 255, 0 -- Assume its downloaded and ready
		local enabled = v.enabled or false 
		local status = "Ready";
		
		if ( not enabled ) then 
			r, g, b = 255, 0, 0
			enabled = "No";
		else 
			enabled = "Yes";
		end 
		
		if ( not File.exists ( v.txd ) or not File.exists ( v.dff ) ) then
			status = "Downloading";
			r, g, b = 255, 255, 0
		end 
		
		local row = guiGridListAddRow ( Inter.grid.list );
		guiGridListSetItemText ( Inter.grid.list, row, 1, getVehicleNameFromModel ( v.replace ), false, false );
		guiGridListSetItemText ( Inter.grid.list, row, 2, tostring ( v.name ), false, false );
		guiGridListSetItemText ( Inter.grid.list, row, 3, tostring ( enabled ), false, false );
		guiGridListSetItemText ( Inter.grid.list, row, 4, tostring ( status ), false, false );
		for i = 1, 4  do 
			guiGridListSetItemColor ( Inter.grid.list, row, i, r, g, b );
		end 
		
		if ( row == _row )then 
			guiGridListSetSelectedItem ( Inter.grid.list, row, col );
			triggerEvent ( "onClientGUIClick", Inter.grid.list );
		end 
	end 
end 

addCommandHandler ( "mods", function ( )
	if ( not Downloader.gotResponse ) then 
		outputChatBox ( "We're still waiting for the server to accept our request. Please wait", 255, 255, 0 );
		return false;
	end

	Inter.open ( not Inter.window.visible );
end );