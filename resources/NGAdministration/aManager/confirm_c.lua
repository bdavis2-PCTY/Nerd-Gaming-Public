local confirm = {}
local callback = nil
local args = nil
local sx, sy = guiGetScreenSize ( )
confirm.window = guiCreateWindow( ( sx / 2 - 324 / 2 ), ( sy / 2 - 143 /2 ), 324, 143, "Confirm", false)
confirm.text = guiCreateLabel(10, 35, 304, 65, "", false, confirm.window)
guiSetVisible ( confirm.window, false )
guiSetFont(confirm.text, "default-bold-small")
guiLabelSetHorizontalAlign(confirm.text, "left", true)
guiWindowSetSizable ( confirm.window, false )
confirm.yes = guiCreateButton(10, 100, 108, 25, "Confirm", false, confirm.window)
confirm.no = guiCreateButton(128, 100, 108, 25, "Deny", false, confirm.window)

function onConfirmClick( ) 
	if ( source ~= confirm.yes and source ~= confirm.no ) then return end
	
	removeEventHandler ( "onClientGUIClick", root, onConfirmClick )
	guiSetVisible ( confirm.window, false )
	local v = false
	if ( source == confirm.yes ) then
		v = true
	end
	callback ( v, unpack ( args ) )
	args = nil
	callback = nil
end

function askConfirm ( question, callback_, ... )
	if ( not callback_ or type ( callback_ ) ~= "function" ) then
		return false
	end
	
	guiSetVisible ( confirm.window, true )
	guiSetText ( confirm.text, tostring ( question ) )
	callback = callback_
	args = { ... }
	addEventHandler ( "onClientGUIClick", root, onConfirmClick )
	guiBringToFront ( confirm.window )
	return true
end
