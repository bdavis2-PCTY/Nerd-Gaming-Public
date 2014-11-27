local sx, sy = guiGetScreenSize ( )

local win = {
	btn = { },
	lbl = { },
	etc = { },
	tab = { },
	grd = { },
	edt = { }
}
-- window elements
policeWindow = guiCreateWindow( ( sx / 2 - 573 / 2 ), ( sy / 2 - 462 / 2 ), 573, 462, "Police Panel", false)
guiWindowSetSizable(policeWindow, false)
win.btn.close = guiCreateButton(493, 37, 67, 32, "Close", false, policeWindow)
win.btn.reload = guiCreateButton(416, 37, 67, 32, "Reload", false, policeWindow)
guiSetFont ( guiCreateLabel(17, 37, 321, 16, "My Stats", false, policeWindow), "default-bold-small" )
win.lbl.arrests = guiCreateLabel(0.03, 0.11, 0.28, 0.03, "Arrests: Loading...", true, policeWindow)
win.lbl.rank = guiCreateLabel(0.03, 0.15, 0.28, 0.03, "Rank: Loading...", true, policeWindow)
win.lbl.nextRank = guiCreateLabel(0.31, 0.15, 0.28, 0.03, "Next: Loading...", true, policeWindow)
win.lbl.nextArrests = guiCreateLabel(0.31, 0.11, 0.32, 0.03, "For next rank: Loading...", true, policeWindow)
win.lbl.solvedCrims = guiCreateLabel(0.03, 0.19, 0.32, 0.03, "Solved Crimes: Loading...", true, policeWindow)
guiSetFont(guiCreateLabel(17, 112, 321, 16, "Police Stats", false, policeWindow), "default-bold-small")
win.etc.tablPanel = guiCreateTabPanel(19, 131, 541, 317, false, policeWindow)
-- Criminals tab
win.tab.crims = guiCreateTab("Criminals", win.etc.tablPanel)
win.lbl.totalCrims = guiCreateLabel(9, 11, 380, 18, "Total Criminals: 0", false, win.tab.crims)
win.grd.crims = guiCreateGridList(0, 29, 541, 264, false, win.tab.crims)
guiGridListAddColumn(win.grd.crims, "Player", 0.4)
guiGridListAddColumn(win.grd.crims, "Location", 0.37)
guiGridListAddColumn(win.grd.crims, "WL", 0.08)
guiGridListAddColumn(win.grd.crims, "WP", 0.08)
-- Dispatch tab
win.tab.dispatch = guiCreateTab("Dispatch", win.etc.tablPanel)
win.grd.dispatch = guiCreateGridList(0, 0, 541, 293, false, win.tab.dispatch)
guiGridListAddColumn(win.grd.dispatch, "Message", 1.2)
-- Radio tab
win.tab.radio = guiCreateTab("Radio", win.etc.tablPanel)
win.grd.radio = guiCreateGridList(0, 0, 541, 248, false, win.tab.radio)
guiGridListAddColumn(win.grd.radio, "", 0.25)
guiGridListAddColumn(win.grd.radio, "", 0.8)
win.edt.msg = guiCreateEdit(0, 255, 468, 32, "", false, win.tab.radio)
win.btn.msgSend = guiCreateButton(470, 254, 71, 33, "Send", false, win.tab.radio)
-- properties
guiSetVisible ( policeWindow, false )
guiGridListSetSortingEnabled ( win.grd.crims, false )
guiGridListSetSortingEnabled ( win.grd.dispatch, false )
guiGridListSetSortingEnabled (win.grd.radio, false )

function openPoliceWindow ( )
	if ( guiGetVisible ( policeWindow ) ) then
		closePoliceWindow ( )
		return
	end
	
	local j = tostring ( getElementData ( localPlayer, "Job" ) ):lower ( )
	if ( j ~= "police officer" and j ~= "detective" ) then
		return
	end
	
	guiSetVisible ( policeWindow, true )
	showCursor ( true )
	guiGridListClear ( win.grd.crims )
	guiGridListSetItemText ( win.grd.crims, guiGridListAddRow ( win.grd.crims ), 1, "Loading stats, please wait...", true, true )
	triggerServerEvent ( "NGPolice:Modules->Panel:RequestData", localPlayer )
	addEventHandler ( "onClientGUIClick", win.btn.close, onClick )
	addEventHandler ( "onClientGUIClick", win.btn.reload, onClick )
	addEventHandler ( "onClientGUIClick", win.btn.msgSend, onClick )
end
bindKey( "f5", "down", openPoliceWindow )

function reloadPanel ( )
	closePoliceWindow ( )
	openPoliceWindow ( )
	if ( isElement ( source ) ) then
		guiSetEnabled ( source, false )
		setTimer ( function ( s )
			guiSetEnabled ( s, true )
		end, 3000, 1, source )
	end
end

function closePoliceWindow ( )
	showCursor ( false )
	guiSetVisible ( policeWindow, false )
	removeEventHandler ( "onClientGUIClick", win.btn.close, onClick )
	removeEventHandler ( "onClientGUIClick", win.btn.reload, onClick )
	removeEventHandler ( "onClientGUIClick", win.btn.msgSend, onClick )
	guiSetText ( win.lbl.arrests, "Arrests: Loading..." )
	guiSetText ( win.lbl.rank, "Rank:  Loading..." )
	guiSetText ( win.lbl.nextRank, "Next:  Loading..." )
	guiSetText ( win.lbl.nextArrests, "For Next Rank:  Loading..." )
	guiSetText ( win.lbl.solvedCrims, "Solved Crimes:  Loading..." )
end


addEvent ( "NGPolice:Modules->Panel:OnServerSendClientData", true )
addEventHandler ( "NGPolice:Modules->Panel:OnServerSendClientData", root, function ( d )
	guiSetText ( win.lbl.arrests, "Arrests: "..tostring(d.mystats.arrests) )
	guiSetText ( win.lbl.rank, "Rank: "..tostring(d.mystats.rank) )
	guiSetText ( win.lbl.nextRank, "Next: "..tostring(d.mystats.nextRank) )
	guiSetText ( win.lbl.solvedCrims, "Solved Crimes: "..tostring(d.mystats.solvedCrims) )
	
	if tonumber ( d.mystats.nextRankArrests ) and d.mystats.arrests then
		needed = d.mystats.nextRankArrests-d.mystats.arrests
	else
		needed = "0"
	end
	
	guiSetText ( win.lbl.nextArrests, "For Next Rank: "..tostring(d.mystats.nextRankArrests or "None").." ("..needed.." needed)" )
	guiSetInputMode ( "no_binds_when_editing" )
	guiGridListClear ( win.grd.crims )
	if ( #d.criminals == 0 ) then
		guiGridListSetItemText(win.grd.crims,guiGridListAddRow(win.grd.crims),1,"No wanted players",true,true)
	else
		for i, v in ipairs ( d.criminals ) do
			local r = guiGridListAddRow ( win.grd.crims )
			guiGridListSetItemText ( win.grd.crims, r, 1, v.nam, false, false )
			guiGridListSetItemText ( win.grd.crims, r, 2, v.loc, false, false )
			guiGridListSetItemText ( win.grd.crims, r, 3, v.WL, false, false )
			guiGridListSetItemText ( win.grd.crims, r, 4, v.WP, false, false )
		end
	end
end )

function onClick ( )
	if ( source == win.btn.close ) then
		closePoliceWindow ( )
	elseif ( source == win.btn.reload ) then
		reloadPanel ( )
	elseif ( source == win.btn.msgSend ) then
		sendRadioText ( )
	end
end

addEvent ( "NGPolice:Modules->Panel:OnClientPoliceRadioChat", true )
addEventHandler ( "NGPolice:Modules->Panel:OnClientPoliceRadioChat", root, function ( plr, msg, r_, g, b )
	local r_, g, b = r_ or 0,  g or 120, b or 255
	local r = guiGridListAddRow ( win.grd.radio )
	guiGridListSetItemText ( win.grd.radio, r, 1, plr, false, false )
	guiGridListSetItemText ( win.grd.radio, r, 2, msg, false, false )
	guiGridListSetItemColor ( win.grd.radio, r, 1, r_, g, b )
end )

local lastMsgTick = getTickCount ( )
addEvent ( "NGPolice:Modules->Dispatch:onDispatchMessage", true )
addEventHandler ( "NGPolice:Modules->Dispatch:onDispatchMessage", root, function ( m )
	if ( getTickCount ( ) - lastMsgTick <= 500 ) then
		return
	end
	local r = guiGridListAddRow ( win.grd.dispatch )
	guiGridListSetItemText ( win.grd.dispatch, r, 1, tostring ( m ), false, false )
	lastMsgTick = getTickCount ( )
end )

function sendRadioText ( )
	local t = guiGetText ( win.edt.msg )
	if ( string.gsub ( t, " ", "" ) == "" ) then
		return exports.NGMessages:sendClientMessage ( "You need to enter a message before sending one.", 255, 255, 0 )
	end
	guiSetText ( win.edt.msg, "" )
	triggerServerEvent ( "NGPolice:Modules->Panel:onClientSendLawMessage", localPlayer, t )
end

function outputDispatchMessage ( msg ) 
	exports.NGMessages:sendClientMessage ( "(Dispatch) New message, check the computer (F5) -> Dispatch", 255, 255, 255 )
	guiGridListSetItemText ( win.grd.dispatch, guiGridListAddRow ( win.grd.dispatch ), 1, tostring ( msg ), false, false )
end
