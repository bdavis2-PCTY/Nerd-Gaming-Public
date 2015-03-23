local punishlist = { }
local sx, sy = guiGetScreenSize(  )

window = guiCreateWindow( ( sx / 2 - 759 / 2 ), ( sy / 2 - 455 / 2 ), 759, 455, "My Punishments", false)
guiWindowSetSizable(window, false)
window.visible = false
tabpanel = guiCreateTabPanel(10, 27, 739, 370, false, window)

tab1 = guiCreateTab("Punishments by account", tabpanel)
punishlist[1] = guiCreateGridList(6, 7, 723, 328, false, tab1)
guiGridListAddColumn(punishlist[1], "Account", 0.15)
guiGridListAddColumn(punishlist[1], "Administrator", 0.15)
guiGridListAddColumn(punishlist[1], "Time", 0.21)
guiGridListAddColumn(punishlist[1], "Serial", 0.34)
guiGridListAddColumn(punishlist[1], "Punishment", 0.55)

tab2 = guiCreateTab("Punishments by serial", tabpanel)
punishlist[2] = guiCreateGridList(6, 7, 723, 328, false, tab2)
guiGridListAddColumn(punishlist[2], "Account", 0.15)
guiGridListAddColumn(punishlist[2], "Administrator", 0.15)
guiGridListAddColumn(punishlist[2], "Time", 0.21)
guiGridListAddColumn(punishlist[2], "Serial", 0.34)
guiGridListAddColumn(punishlist[2], "Punishment", 0.55)

close = guiCreateButton(10, 407, 144, 33, "Close", false, window)
cdate = guiCreateLabel(215, 407, 700, 33, "Current Date: 000-00-00 | Account: None", false, window)
guiLabelSetVerticalAlign(cdate, "center")

function loadPanel ( )
	if ( not window.visible ) then 
		addEventHandler ( "onClientGUIClick", root, onGuiClick )
	end

	window.visible = true
	showCursor ( true )
	guiGridListClear ( punishlist[1] )
	guiGridListClear ( punishlist[2] )
	guiGridListSetItemText(punishlist[1],guiGridListAddRow(punishlist[1]),1,"Loading...",true,true)
	guiGridListSetItemText(punishlist[2],guiGridListAddRow(punishlist[2]),1,"Loading...",true,true)
	cdate.text = "Date: "..exports.ngplayerfunctions:getToday().." | Account: "..tostring(getElementData(localPlayer,"AccountData:Username")).. "\nIP: "..tostring ( getElementData ( localPlayer, "AccountData:IP" ) ).." | Serial: ".. localPlayer:getSerial()
	triggerServerEvent ( "NGPunishPanel->Modules->Punishments->RequestPlayerPunishList", localPlayer )
end 

function onGuiClick ( )
	if ( source == close ) then
		window.visible = false
		showCursor ( false )
		removeEventHandler ( "onClientGUIClick", root, onGuiClick )
	end
end 

addEvent ( "NGPunishPanel->Modules->Punishments->OnServerSendClientPunishments", true )
addEventHandler ( "NGPunishPanel->Modules->Punishments->OnServerSendClientPunishments", root, function ( list )
	guiGridListClear ( punishlist[1] )
	guiGridListClear ( punishlist[2] )
	if ( table.len ( list.account ) == 0 ) then
		guiGridListSetItemText(punishlist[1],guiGridListAddRow(punishlist[1]),1,"No Account Punishments",true,true)
	else
		local tmp = list.account
		list.account = { }
		for i= #tmp,1,-1 do  table.insert ( list.account, tmp [ i ] ) end
		for i, v in ipairs ( list.account ) do
			local r = guiGridListAddRow ( punishlist[1] )
			guiGridListSetItemText ( punishlist[1], r, 1, v.account, false, false )
			guiGridListSetItemText ( punishlist[1], r, 2, v.admin, false, false )
			guiGridListSetItemText ( punishlist[1], r, 3, v._time, false, false )
			guiGridListSetItemText ( punishlist[1], r, 4, v.serial, false, false )
			guiGridListSetItemText ( punishlist[1], r, 5, v.log, false, false )
			for k=1, 5 do 
				guiGridListSetItemColor ( punishlist[1], r, k, 255, 0, 0 )
			end 
		end 
	end 

	if ( table.len ( list.serial ) == 0 ) then
		guiGridListSetItemText(punishlist[2],guiGridListAddRow(punishlist[2]),1,"No Account Punishments",true,true)
	else
		local tmp = list.serial
		list.serial = { }
		for i= #tmp,1,-1 do  table.insert ( list.serial, tmp [ i ] ) end
		for i, v in ipairs ( list.serial ) do
			local r = guiGridListAddRow ( punishlist[2] )
			guiGridListSetItemText ( punishlist[2], r, 1, v.account, false, false )
			guiGridListSetItemText ( punishlist[2], r, 2, v.admin, false, false )
			guiGridListSetItemText ( punishlist[2], r, 3, v._time, false, false )
			guiGridListSetItemText ( punishlist[2], r, 4, v.serial, false, false )
			guiGridListSetItemText ( punishlist[2], r, 5, v.log, false, false )
			for k=1, 5 do 
				guiGridListSetItemColor ( punishlist[2], r, k, 255, 0, 0 )
			end 
		end 
	end 
end )

function table.len ( t )
	local c = 0
	for i, v in pairs ( t ) do
		c = c + 1
	end
	return c
end
addCommandHandler ( "punishments", loadPanel )