local original = ""

local edwindow = guiCreateWindow(288, 208, 795, 537, "Vehicle Spawner Editor", false)
guiWindowSetSizable(edwindow, false)
guiSetVisible ( edwindow, false )
local spawnerData = guiCreateMemo(9, 25, 776, 448, "", false, edwindow)
local btnSave = guiCreateButton(15, 486, 186, 38, "Save", false, edwindow)
local btnRestore = guiCreateButton(211, 483, 186, 38, "Restore", false, edwindow)
local btnCancel = guiCreateButton(599, 483, 186, 38, "Cancel", false, edwindow)

addEvent ( "NGSpawners:onStaffOpenEditor", true )
addEventHandler ( "NGSpawners:onStaffOpenEditor", root, function ( data ) 
	if ( not guiGetVisible ( edwindow ) ) then
		guiSetVisible ( edwindow, true )
		showCursor ( true )
		guiSetText ( spawnerData, tostring ( data ) )
		original = tostring ( data )
		addEventHandler ( "onClientGUIClick", btnSave, adminEditorClicking )
		addEventHandler ( "onClientGUIClick", btnRestore, adminEditorClicking )
		addEventHandler ( "onClientGUIClick", btnCancel, adminEditorClicking )
	else
		guiSetVisible ( edwindow, false )
		showCursor ( false )
		removeEventHandler ( "onClientGUIClick", btnSave, adminEditorClicking )
		removeEventHandler ( "onClientGUIClick", btnRestore, adminEditorClicking )
		removeEventHandler ( "onClientGUIClick", btnCancel, adminEditorClicking )
	end
end )

function adminEditorClicking ( )
	if ( source == btnCancel ) then
		guiSetVisible ( edwindow, false )
		showCursor ( false )
		removeEventHandler ( "onClientGUIClick", btnSave, adminEditorClicking )
		removeEventHandler ( "onClientGUIClick", btnRestore, adminEditorClicking )
		removeEventHandler ( "onClientGUIClick", btnCancel, adminEditorClicking )
	elseif ( source == btnRestore ) then
		guiSetText ( spawnerData, tostring ( original ) )
	elseif ( source == btnSave ) then
		triggerServerEvent ( "NGSpawners:onAdminEditSpawnerList", localPlayer, guiGetText ( spawnerData ) )
	end
end
