sell = { }
myvehicles = { }

function createSellWindow ( ) 
	if ( isElement ( sell.window ) ) then 
		return false;
	end 
	
	sell.window = guiCreateWindow(sx*892, sy*367, sx*378, sy*391, "Sell Vehicle", false)
	guiWindowSetSizable(sell.window, false)
	guiWindowSetMovable ( sell.window, false );
	
	sell.list = guiCreateGridList(sx*9, sy*24, sx*359, sy*140, false, sell.window)
	guiGridListAddColumn(sell.list, "Vehicle", 0.4)
	guiGridListAddColumn(sell.list, "Visible", 0.25)
	guiGridListAddColumn(sell.list, "Impounded", 0.25)
	guiGridListSetSortingEnabled ( sell.list, false );
	sell.lbl1 = guiCreateLabel(sx*14, sy*173, sx*81, sy*18, "Price:", false, sell.window)
	sell.price = guiCreateEdit(sx*95, sy*172, sx*273, sy*19, "", false, sell.window)
	sell.lbl2 = guiCreateLabel(sx*14, sy*209, sx*317, sy*18, "Description (2000 characters max):", false, sell.window)
	sell.desc = guiCreateMemo(sx*15, sy*229, sx*353, sy*112, "", false, sell.window)
	sell.sell = guiCreateButton(sx*15, sy*351, sx*136, sy*27, "Sell", false, sell.window)
	sell.close = guiCreateButton(sx*232, sy*351, sx*136, sy*27, "Cancel", false, sell.window)
	
	for index, var in pairs ( myvehicles ) do 
		local r = guiGridListAddRow ( sell.list );
		local color = { 0, 255, 0 }
		
		local visible = ( tostring ( var.Visible ) == "1" and "Yes" ) or "No";
		local impounded = ( tostring ( var.Impounded ) == "1" and "Yes" ) or "No";
		
		if ( visible == "Yes" or impounded == "Yes" ) then 
			color = { 255, 0, 0 }
		end 
		
		guiGridListSetItemText ( sell.list, r, 1, getVehicleNameFromModel ( var.ID ), false, false );
		guiGridListSetItemText ( sell.list, r, 2, visible, false, false );
		guiGridListSetItemText ( sell.list, r, 3, impounded, false, false );
		guiGridListSetItemData ( sell.list, r, 1, var );
		
		for i=1,3 do 
			guiGridListSetItemColor ( sell.list, r, i, color[1], color[2], color[3] )
		end 
		
	end 
end

function closeSellWindow ( )
	if ( isElement ( sell.window ) ) then 
		destroyElement ( sell.window )
	end
end 

