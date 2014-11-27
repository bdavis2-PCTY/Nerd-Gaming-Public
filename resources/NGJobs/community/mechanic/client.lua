local isFixing = false
local fixer = nil
local progress = nil
local sx, sy = guiGetScreenSize ( )
local rSX, rSY = sx / 1280, sx / 1024
addEventHandler ( "onClientClick", root, function ( btn, stat, _, _, _, _, _, el )
	if ( getElementData ( localPlayer, "Job" ) == "Mechanic" and btn == 'left' and stat == 'down' and isElement ( el ) and not isFixing ) then
		if ( getElementType ( el ) == 'vehicle' ) then
			local owner = getVehicleOccupant ( el )
			if ( owner ) then
				if ( owner == localPlayer ) then
					return exports['NGMessages']:sendClientMessage ( "You cannot fix your own vehicle.", 255, 255, 0 )
				end
				isFixing = true
				fixer = nil
				progress = 0
				client = nil
				triggerServerEvent ( "NGJobs:Mechanic_AttemptFixVehicle", localPlayer, el )
			else
				exports['NGMessages']:sendClientMessage ( "This vehicle has no driver.", 255, 255, 0 )
			end
		end
	end
end )

addEvent ( "NGJobs:Mechanic_CancelFixingRequest", true )
addEventHandler ( "NGJobs:Mechanic_CancelFixingRequest", root, function ( pos, msg )
	if ( msg == nil ) then
		msg = true
	end
	if ( pos == 'source' ) then
		isFixing = false
		client = nil
		if ( msg ) then
			exports['NGMessages']:sendClientMessage ( "Time expired.....", 255, 255, 0 )
		end
	else
		fixer = nil
	end
end )

addEvent ( "NGjobs:Mechanic_BindClientKeys", true )
addEventHandler ( "NGjobs:Mechanic_BindClientKeys", root, function ( p )
	bindKey ( "1", "down", Mech_AcceptRequest )
	bindKey ( "2", "down", Mech_DenyRequest )
	fixer = p
end )

function Mech_AcceptRequest ( c )
	triggerServerEvent ( "NGJobs:Mech_OnClientAcceptFixing", localPlayer, fixer )
	unbindKey ( "1", "down", Mech_AcceptRequest )
	unbindKey ( "2", "down", Mech_DenyRequest )
	fixer = nil
	client = c
end

function Mech_DenyRequest ( )
	triggerServerEvent ( "NGJobs:Mech_OnClientDenyFixing", localPlayer, fixer )
	unbindKey ( "1", "down", Mech_AcceptRequest )
	unbindKey ( "2", "down", Mech_DenyRequest )
	fixer = nil
	client = nil
end

addEvent ( "NGJobs:Mechanic_onDenied", true )
addEventHandler ( "NGJobs:Mechanic_onDenied", root, function ( )
	isFixing = false
	client = nil
	fixer = nil
end )








addEvent ( "NGMessages:Mechanic_OpenLoadingBar", true )
addEventHandler ( "NGMessages:Mechanic_OpenLoadingBar", root, function ( p )
	progress = 0
	l_tick = getTickCount ( )
	client = p
	isFixing = true
	addEventHandler ( "onClientRender", root, mechanic_drawProgressBar ) 
end )

local l_tick = getTickCount ( )
function mechanic_drawProgressBar ( )
	if ( getTickCount ( ) - l_tick >= 150 ) then
		progress = progress + 1
		l_tick = getTickCount ( )
	end
	dxDrawRectangle ( ( sx / 2 - (rSX*604) / 2 ), ( sy / 2 - (rSY*74) / 2 ), rSX*604, rSY*74, tocolor ( 0, 0, 0, 170 ) )
	dxDrawRectangle ( ( sx / 2 - (rSX*600) / 2 ), ( sy / 2 - (rSY*70) / 2 ), rSX*(progress*6), rSY*70, tocolor ( 0, 200, 0, 170 ) )
	dxDrawText ( "Fixing - "..tostring ( math.floor ( progress ) ).."%", ( sx / 2 - (rSX*600) / 2 ), ( sy / 2 - (rSY*70) / 2 ), ( sx / 2 - (rSX*600) / 2 )+(rSX*600), ( sy / 2 - (rSY*70) / 2 )+(rSY*70), tocolor ( 255, 255, 255, 255 ), rSY*1.5, 'bankgothic', 'center', 'center' )
	if ( progress >= 100 ) then
		removeEventHandler ( "onClientRender", root, mechanic_drawProgressBar )
		triggerServerEvent ( "NGJobs:Mechanic_onVehicleCompleteFinish", localPlayer, client )
		isFixing = false
	end
end








-- Recover
local recoverPrice = 1200
local marker = nil
local recover = {}
recover.window = guiCreateWindow( ( sx / 2 - (rSX*517) / 2 ), ( sy / 2 - (rSY*419) / 2 ), rSX*517, rSY*330, "Recover Vehicles", false)
recover.grid = guiCreateGridList(rSX*9, rSY*23, rSX*497, rSY*260, false, recover.window)
recover.close = guiCreateButton(rSX*11, rSY*285, rSX*153, rSY*45, "Close", false, recover.window)
recover.recover = guiCreateButton(rSX*174, rSY*285, rSX*153, rSY*45, "Recover ($"..recoverPrice..")", false, recover.window)
guiSetVisible ( recover.window, false )
guiWindowSetSizable(recover.window, false)
guiGridListAddColumn(recover.grid, "ID", 0.1)
guiGridListAddColumn(recover.grid, "Name", 0.85)
guiGridListSetSortingEnabled ( recover.grid, false )

addEvent ( "NGJobs:Mechanic.OpenRecovery", true )
addEventHandler ( "NGJobs:Mechanic.OpenRecovery", root, function ( cars, marker2 )
	addEventHandler ( "onClientGUIClick", root, onClientRecoverClick )
	guiGridListClear ( recover.grid )
	guiSetVisible ( recover.window, true )
	showCursor ( true )
	marker = marker2
	for i, v in ipairs ( cars ) do 
		local r = guiGridListAddRow ( recover.grid )
		guiGridListSetItemText ( recover.grid, r, 1, tostring ( v['VehicleID'] ), false, false )
		guiGridListSetItemText ( recover.grid, r, 2, tostring ( getVehicleNameFromModel ( v['ID'] ) ), false, false )
	end
end )

function onClientRecoverClick ( )
	if ( source == recover.close ) then
		executeClose ( )
	elseif ( source == recover.recover ) then
		local row, col = guiGridListGetSelectedItem ( recover.grid )
		if ( row ~= -1 ) then
			if ( getPlayerMoney ( localPlayer ) >= recoverPrice ) then
				local vID = tonumber ( guiGridListGetItemText ( recover.grid, row, 1 ) )
				triggerServerEvent ( "NGJobs:Mechanic.onPlayerRecoverVehicle", localPlayer, vID, marker, recoverPrice )
				executeClose ( )
			else
				exports['NGMessages']:sendClientMessage ( "You don't have enough money to recover your vehicle.", 255, 255, 255 )
			end
		else
			exports['NGMessages']:sendClientMessage ( "Select a vehicle to recover.", 255, 255, 255 )
		end
	end
end

function executeClose ( )
	guiGridListClear ( recover.grid )
	guiSetVisible ( recover.window, false )
	showCursor ( false )
	removeEventHandler ( "onClientGUIClick", root, onClientRecoverClick )
	marker = nil
end