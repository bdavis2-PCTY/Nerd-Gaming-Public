local sx_, sy_ = guiGetScreenSize ( )
local sx, sy = 1, 1

function makeGui ( )
	Player.showHudComponent( "all", false )
	showChat ( false )

	im2 = GuiStaticImage.create ( 0, 0, sx_, sy_, ":NGlogin/files/back.png", false, nil)

	window = GuiWindow.create((sx_/2-(sx*710)/2), (sy_/2-(sy*479)/2), sx*710, sy*479, "Nerd Gaming Help", false)
	window.sizable  = false;
	window.movable = false;
	window.alpha = 0.95;

	grid = GuiGridList.create(sx*356, sy*34, sx*274, sy*150, false, window)
	guiGridListAddColumn(grid, "", 0.9)
	guiGridListSetSortingEnabled ( grid, false )

	img = GuiStaticImage.create(sx*61, sy*34, sx*272, sy*150, ":NGLogin/files/logo.png", false, window)

	scrollpane = guiCreateScrollPane ( sx*61, sy*234, sx*569, sy*186, false, window )
	
	info = GuiLabel.create(0,0, sx*500, sy*186, "This is my text", false, scrollpane)
	info:setFont  ( "default-bold-small" )
	info:setHorizontalAlign  ( "left", true )

	showCursor ( true )

	for i, v in pairs ( options2 ) do
		local r = guiGridListAddRow ( grid )
		guiGridListSetItemText ( grid, r, 1, tostring ( v [ 1 ] ), false, false)
		guiGridListSetItemData ( grid, r, 1, tostring  ( v [ 2 ] ), false, false )
	end 

	addEventHandler ( "onClientGUIClick", root, onGuiClick )
	guiGridListSetSelectedItem ( grid, 0, 1 )
	triggerEvent ( "onClientGUIClick", grid )
end

function onGuiClick ( )
	window:bringToFront ( )


	if ( source == grid ) then
		info.text = "No item selected.";
		local r, c = guiGridListGetSelectedItem ( source )
		if ( r ~= -1) then
			local txt = tostring ( guiGridListGetItemData ( grid, r, 1 ) );
			info.text = txt;
			
			-- Calculate the height of the label
			local height = (string.len(txt)-string.len(string.gsub(txt,'\n','')))*15
			
			if ( height < sy*186 ) then 
				height = sy*186
			end
			
			guiSetSize ( info, sx*500, height, false );
			
		end 
	elseif ( source == im2 ) then
		cancelEvent ( )
	end 
end 

function destroyGui ( )
	if ( window ) then
		removeEventHandler ( "onClientGUIClick", root, onGuiClick )
		destroyElement ( window );
		destroyElement ( im2 );
		showCursor ( false );
		window = nil
		im2 = nil;
		-- restore elements
		Player.showHudComponent( "all", true )
		showChat ( true )
	end 
end


bindKey ( "f1", "down", function ( )
	if ( not exports.nglogin:isClientLoggedin ( ) ) then return end

	if ( window ) then
		destroyGui ( );
	else
		makeGui ( );
	end
end )