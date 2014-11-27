local updates = { button = {} }
function openUpdateWindow ( )
	if ( not exports.NGLogin:isClientLoggedin ( ) ) then return false end
	updates.window = guiCreateWindow((sx/2-(rSX*657)/2), (sy/2-(rSY*450)/2), rSX*657, rSY*450, "Updates", false)
	guiWindowSetSizable(updates.window, false)
	updates.list = guiCreateGridList(rSX*9, rSY*26, rSX*638, rSY*380, false, updates.window)
	guiGridListAddColumn(updates.list, "Date", 0.15)
	guiGridListAddColumn(updates.list, "Update", 0.8)
	guiGridListSetSortingEnabled ( updates.list, false )
	updates.button.close = guiCreateButton(rSX*543, rSY*415, rSX*104, rSY*32, "Close", false, updates.window)
	updates.button.report = guiCreateButton(rSX*429, rSY*415, rSX*104, rSY*32, "Report A Bug", false, updates.window)
	showCursor ( true )
	addEventHandler ( "onClientGUIClick", updates.button.close, onClientGUIClickUpdateWindow )
	addEventHandler ( "onClientGUIClick", updates.button.report, onClientGUIClickUpdateWindow )
	
	local r = guiGridListAddRow ( updates.list )
	guiGridListSetItemText ( updates.list, r, 2, "Loading updates... Please wait", true, true )
	triggerServerEvent ( "NGAdmin:Modules->Updates:OnClientRequestUpdateList", localPlayer )
end

function closeUpdateWindow ( )
	if ( isElement ( updates.button.close ) ) then
		removeEventHandler ( "onClientGUIClick", updates.button.close, onClientGUIClickUpdateWindow )
		destroyElement ( updates.button.close )
	end	if ( isElement ( updates.button.report ) ) then
		removeEventHandler ( "onClientGUIClick", updates.button.report, onClientGUIClickUpdateWindow )
		destroyElement ( updates.button.report )
	end if ( isElement ( updates.list ) ) then
		destroyElement ( updates.list )
	end if ( isElement ( updates.window ) ) then
		destroyElement ( updates.window ) 
	end
	showCursor ( false )
end

function onClientGUIClickUpdateWindow ( )
	if ( source == updates.button.close ) then
		closeUpdateWindow ( )
	elseif ( source == updates.button.report ) then
		closeUpdateWindow ( )
		updates_openReportWindow ( )
	end
end


addEvent ( "NGAdmin:Modules->Updates:OnServerSendClientUpdateList", true )
addEventHandler ( "NGAdmin:Modules->Updates:OnServerSendClientUpdateList", root, function ( data )
	guiGridListClear ( updates.list )
	if ( #data == 0 ) then
		local r = guiGridListAddRow ( updates.list )
		guiGridListSetItemText ( updates.list, r, 2, "No updates found", true, true )
	else
		for i, v in pairs ( data ) do
			local r = guiGridListAddRow ( updates.list )
			guiGridListSetItemText ( updates.list, r, 1, v.added_on, false, false )
			guiGridListSetItemText ( updates.list, r, 2, "("..v.author..") "..v.description, false, false )
		end
	end
end )

addCommandHandler ( "updates", function ( )
	if ( isElement ( updates.window ) ) then
		closeUpdateWindow ( )
	else
		openUpdateWindow ( )
	end
end )





-- add/remove
local manager = { add = {}, remove = {} }
local rsx, rsy = rSX, rSY
function buildManagerWindow ( )
	manager.window = guiCreateWindow(sx/2-641/2, sy/2-382/2, 641, 382, "Update Manager", false)
	guiWindowSetSizable(manager.window, false )
	manager.add.lbl = guiCreateLabel(10, 26, 306, 31, "Add An Update\n_____________________________________________", false, manager.window)
	manager.add.label_date = guiCreateLabel(10, 82, 91, 23, "Date:", false, manager.window)
	manager.add.add_date = guiCreateEdit(99, 81, 217, 24, "", false, manager.window)
	manager.add.label_author = guiCreateLabel(10, 123, 91, 23, "Author:", false, manager.window)
	manager.add.edit_author = guiCreateEdit(99, 123, 217, 24, "", false, manager.window)
	manager.add.label_desc = guiCreateLabel(10, 173, 91, 23, "Description:", false, manager.window)
	manager.add.memo_desc = guiCreateMemo(11, 199, 305, 137, "", false, manager.window)
	manager.remove.lbl = guiCreateLabel(316, 26, 306, 31, "Remove An Update\n___________________________________________", false, manager.window)
	manager.add.add = guiCreateButton(10, 346, 114, 29, "Add Update", false, manager.window)
	manager.remove.list = guiCreateGridList(323, 63, 309, 273, false, manager.window)
	guiGridListAddColumn(manager.remove.list, "Description", 0.9)
	guiGridListSetSortingEnabled ( manager.remove.list, false )
	manager.remove.remove = guiCreateButton(518, 346, 114, 26, "Remove Update", false, manager.window)
	manager.exit = guiCreateButton(264, 348, 114, 24, "Exit", false, manager.window)
	addEventHandler ( "onClientGUIClick", manager.exit, onClientManagerGUIClick )
	addEventHandler ( "onClientGUIClick", manager.add.add, onClientManagerGUIClick )
	addEventHandler ( "onClientGUIClick", manager.remove.remove, onClientManagerGUIClick )
	showCursor ( true )
	guiSetText ( manager.add.add_date, exports.NGPlayerFunctions:getToday ( ) )
	guiSetText ( manager.add.edit_author, getPlayerName ( localPlayer ) )
	guiSetInputMode ( "no_binds_when_editing" )
end

function closeManagerWindow ( )
	removeEventHandler ( "onClientGUIClick", manager.exit, onClientManagerGUIClick )
	removeEventHandler ( "onClientGUIClick", manager.add.add, onClientManagerGUIClick )
	removeEventHandler ( "onClientGUIClick", manager.remove.remove, onClientManagerGUIClick )
	destroyElement ( manager.add.lbl )
	destroyElement ( manager.add.label_date )
	destroyElement ( manager.add.add_date )
	destroyElement ( manager.add.label_author )
	destroyElement ( manager.add.edit_author )
	destroyElement ( manager.add.label_desc )
	destroyElement ( manager.add.memo_desc )
	destroyElement ( manager.remove.lbl )
	destroyElement ( manager.add.add )
	destroyElement ( manager.remove.list )
	destroyElement ( manager.remove.remove )
	destroyElement ( manager.exit )
	destroyElement ( manager.window )
	showCursor ( false )
end

function onClientManagerGUIClick ( )
	if ( source == manager.exit ) then
		closeManagerWindow ( )
	elseif ( source == manager.add.add ) then
		local date = guiGetText ( manager.add.add_date )
		local author = guiGetText ( manager.add.edit_author )
		local desc = guiGetText ( manager.add.memo_desc )
		triggerServerEvent ( "NGAdmin:Modules->Updates:OnStaffCreateUpdate", localPlayer, { date=date, author=author, description=desc } )
	elseif ( source == manager.remove.remove ) then
		local r, c = guiGridListGetSelectedItem ( manager.remove.list )
		if ( r == -1 ) then
			return exports.NGMessages:sendClientMessage ( "No update is selected", 255, 255, 255 )
		end
		
		local id = guiGridListGetItemData ( manager.remove.list, r, 1 )
		triggerServerEvent ( "NGAdmin:Modules->Updates:OnStaffDeleteUpdate", localPlayer, id )
	end
end



addEvent ( "NGAdmin:Modules->Updates:OnAdminOpenManager", true )
addEventHandler ( "NGAdmin:Modules->Updates:OnAdminOpenManager",root, function ( d )
	if ( isElement ( manager.window ) ) then
		closeManagerWindow ( )
	end
	
	buildManagerWindow ( )
	for i, v in pairs ( d ) do
		local r = guiGridListAddRow(manager.remove.list)
		guiGridListSetItemText ( manager.remove.list, r, 1, v.description, false, false )
		guiGridListSetItemData ( manager.remove.list, r, 1, v.id )
	end
end )