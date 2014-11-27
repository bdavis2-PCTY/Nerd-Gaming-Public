----------------------------------------------------------
-- Confirmation WIndow									--
----------------------------------------------------------
local confirmWindowArgs = { } 
local confirm = {}
confirm.window = guiCreateWindow( (sx_/2-(sx*324)/2), (sy_/2-(sy*143)/2), sx*324, sy*143, "Confirm", false)
confirm.text = guiCreateLabel(sx*10, sy*35, sx*304, sy*65, "", false, confirm.window)
guiSetVisible ( confirm.window, false )
guiSetFont(confirm.text, "default-bold-small")
guiLabelSetHorizontalAlign(confirm.text, "left", true)
guiWindowSetSizable ( confirm.window, false )
confirm.yes = guiCreateButton(sx*10, sy*100, sx*108, sy*25, "Confirm", false, confirm.window)
confirm.no = guiCreateButton(sx*128, sy*100, sx*108, sy*25, "Deny", false, confirm.window)

function onConfirmClick( ) 
	if ( source ~= confirm.yes and source ~= confirm.no ) then return end
	removeEventHandler ( "onClientGUIClick", root, onConfirmClick )
	guiSetVisible ( confirm.window, false )
	confirmWindowArgs.callback ( source == confirm.yes, unpack ( confirmWindowArgs.args ) )
	confirmWindowArgs.args = nil
	confirmWindowArgs.callback = nil
	confirmWindowArgs = nil
end

function askConfirm ( question, callback_, ... )
	if ( not callback_ or type ( callback_ ) ~= "function" ) then
		return false
	end
	confirmWindowArgs = { }
	guiSetVisible ( confirm.window, true )
	guiSetText ( confirm.text, tostring ( question ) )
	confirmWindowArgs.callback = callback_
	confirmWindowArgs.args = { ... }
	addEventHandler ( "onClientGUIClick", root, onConfirmClick )
	guiBringToFront ( confirm.window )
	return true
end

