--[[
	DESCRIPTION:
		This script makes a pop-up when the function 'AskDropAmount' is called. When the client clicks continue,
		the script will run the callback function in the format: callback ( TheAmount, args... )
	
	VARIABLES - GLOBAL:
		n/a
		
	FUNCTIONS - GLOBAL:
		AskDropAmount ( )			->	Create the pop up window | Args: ( MaxNumber, LabelText, CallBackFunction, args... )
]]


local sx, sy = guiGetScreenSize ( )
local amount = { funct = { } }
function AskDropAmount ( a, text, callback, ... )	
	if not a then return end
	local id = 1
	while ( amount [ id ] ) do id = id + 1 end
	amount[id] = { }
	amount[id].window = guiCreateWindow((sx/2-313/2), (sy/2-153/2), 313, 153, "How much?", false)
	guiWindowSetSizable(amount[id].window, false)
	amount[id].tmpLbl = guiCreateLabel(22, 32, 266, 31, text, false, amount[id].window)
	amount[id].amnt = guiCreateEdit(22, 63, 266, 29, "", false, amount[id].window)
	amount[id].confirm = guiCreateButton(22, 102, 77, 28, "Continue ", false, amount[id].window)
	amount[id].cancel = guiCreateButton(123, 102, 77, 28, "Cancel", false, amount[id].window)
	setElementData ( amount[id].window, "TempID", id )
	setElementData ( amount[id].tmpLbl, "TempID", id )
	setElementData ( amount[id].amnt, "TempID", id )
	setElementData ( amount[id].confirm, "TempID", id )
	setElementData ( amount[id].cancel, "TempID", id )
	setElementData ( amount[id].cancel, "BtnType", "Cancel" )
	setElementData ( amount[id].confirm, "BtnType", "Confirm" )
	addEventHandler ( "onClientGUIClick", amount[id].confirm, amount.funct.onClick )
	addEventHandler ( "onClientGUIClick", amount[id].cancel, amount.funct.onClick )
	addEventHandler ( "onClientGUIChanged", amount[id].amnt, amount.funct.onClick )
	amount[id].misc = { }
	amount[id].misc.callBack = callback
	amount[id].misc.args = { ... }
	amount[id].misc.maxNum = a
	guiBringToFront ( amount[id].window  )
end

function amount.funct.onClick ( )
	local id = getElementData ( source, "TempID" )
	if not id then return end
	if ( eventName == "onClientGUIClick" ) then
		local t = getElementData ( source, "BtnType" ) 
		if not t then return end
		if ( source == amount[id].cancel ) then
			amount.funct.closeWindowID ( id )
		elseif ( source == amount[id].confirm ) then
			amount.funct.confirmWindow ( id )
		end
	elseif ( eventName == "onClientGUIChanged" ) then
		local t = guiGetText ( source )
		local m = amount[id].misc.maxNum
		if ( t == "" ) then return end
		local t = t:gsub ( "%a", "" );
		local t = t:gsub ( "%s", "" );
		local t = t:gsub ( "%p", "" );
		guiSetText ( source, t )
		if ( t ~= "" ) then
			local t = tonumber ( t )
			if ( t > m ) then
				guiSetText ( source, m )
			end
		end
	end
end

function amount.funct.confirmWindow ( id )
	local d = amount [ id ]
	if ( guiGetText(d.amnt) == "" ) then return end
	d.misc.callBack ( tonumber(guiGetText(d.amnt)), unpack ( d.misc.args ))
	amount.funct.closeWindowID ( id )
end

function amount.funct.closeWindowID ( id )
	if ( not amount [ id ] ) then
		return
	end
	if ( isElement ( amount[id].confirm ) ) then
		removeEventHandler ( "onClientGUIClick", amount[id].confirm, amount.funct.onClick )
	end if ( isElement ( amount[id].cancel ) ) then
		removeEventHandler ( "onClientGUIClick", amount[id].cancel, amount.funct.onClick )
	end
	
	for i, v in pairs ( amount[id] ) do
		if ( v and isElement ( v ) and string.sub ( getElementType ( v ), 0, 4 ) == "gui-" ) then
			destroyElement ( v )
		end
	end
	amount [ id ] = nil
end