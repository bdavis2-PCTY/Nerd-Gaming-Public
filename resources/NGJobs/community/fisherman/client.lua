local Fisherman = { GUI = {}, GUI2 = {} }
local sx, sy = guiGetScreenSize ( )
Fisherman.GUI.window = guiCreateWindow( ( sx / 2 - 437 / 2 ), ( sy / 2 - 340 / 2 ), 437, 340, "My Catches ", false)
guiWindowSetSizable(Fisherman.GUI.window, false)
guiSetVisible ( Fisherman.GUI.window, false )
Fisherman.GUI.list = guiCreateGridList(9, 26, 420, 254, false, Fisherman.GUI.window)
guiGridListAddColumn(Fisherman.GUI.list, "Item", 0.5)
guiGridListAddColumn(Fisherman.GUI.list, "Amount", 0.2)
guiGridListAddColumn(Fisherman.GUI.list, "Worth", 0.2)
guiGridListSetSortingEnabled ( Fisherman.GUI.list, false )
Fisherman.GUI.close = guiCreateButton(286, 290, 143, 41, "Close", false, Fisherman.GUI.window)

local fisherman_maxCatch = 10
local fisherman_nextCatchTick = nil

local shopLocations = {
	{ 2109.32, -102.33, 0.89 }
}

local fisherman_itemsToCatch = { 
	["Trout"]=15, 
	["Rainbow Trout"]=35, 
	["Catfish"]=50, 
	["Shark"]=60, 
	["Octopus"]=30, 
	["Squid"]=25,
	["Star Fish"]=15,
	["Boot"]=0, 
	["Coral"]=0, 
	["Sea Weed"]=0 
}

function fisherman_onSellMarkerHit ( p )
	if ( p ~= localPlayer ) then 
		return
	end
	if ( getElementData ( p, "Job" ) ~= "Fisherman" ) then
		return exports.NGMessages:sendClientMessage ( "You're not a fisherman", 255, 255, 255 )
	end
	if ( isPedInVehicle ( p ) ) then
		return exports.NGMessages:sendClientMessage ( "You cannot be in a vehicle to sell your goods", 255, 255, 255 )
	end
	
	if ( fisherman_getClientCatchTotal ( ) == 0 ) then
		return exports.NGMessages:sendClientMessage ( "You don't have any goods to sell", 255, 255, 255 )
	end
	
	local total = fisherman_getClientCatchTotal ( )
	local items = fisherman_catch
	triggerServerEvent ( "NGJobs:Fisherman:onClientSellCatch", localPlayer, total, items, fisherman_itemsToCatch )
	fisherman_setCatch ( )
end

function fisherman_setCatch ( )
	fisherman_catch = { }
	for i, v in pairs ( fisherman_itemsToCatch ) do
		fisherman_catch [ i ] = 0
	end
	return fisherman_catch
end
addEvent ( "NGJobs:Fisherman:executeFunction->fisherman_setCatch", true )
addEventHandler ( "NGJobs:Fisherman:executeFunction->fisherman_setCatch", root, fisherman_setCatch )

function fisherman_getClientCatchTotal ( )
	local total = 0
	for i, v in pairs ( fisherman_catch ) do
		local total_ = fisherman_itemsToCatch [ i ] * v
		total = total + total_
	end
	return total
end

for i, v in ipairs ( shopLocations ) do
	local x, y, z = unpack ( v )
	local m = createMarker ( x, y, z, "cylinder", 3.5, 200, 200, 200, 120 )
	create3DText ( "Fisherman Sell Marker", { x, y, z+0.5 }, { 200, 200, 200 } )
	addEventHandler ( "onClientMarkerHit", m, fisherman_onSellMarkerHit )
end


-- Rendering The Catch --
local fisherman_isRenderTextActive = false
local tick = getTickCount ( )
addEventHandler ( "onClientPlayerVehicleEnter", root, function ( v, s )
	if ( source == localPlayer and getElementData ( source, "Job" ) == "Fisherman" and not fisherman_isRenderTextActive and getElementModel( v ) == 453 and s == 0 ) then
		fisherman_isRenderTextActive = true
		exports.NGMessages:sendClientMessage ( "To catch fish, drive around the lake.", 0, 255, 255 )
		addEventHandler ( "onClientRender", root, fisherman_onClientCatchRender )
		fisherman_nextCatchTick = ( getTickCount ( ) + 10000 ) + math.random ( -2000, 2000 )
	end
end )

function fisherman_getItemCountInNet ( )
	local c = 0
	for i, v in pairs ( fisherman_catch ) do
		c = c + v
	end
	return c
end

function fisherman_getRandomItem ( )
	local indexCount = 0
	for i, v in pairs ( fisherman_itemsToCatch ) do
		indexCount = indexCount + 1
	end
	
	local indexToReturn = math.random ( indexCount )
	local i2 = 0
	local rV = nil
	for i, v in pairs ( fisherman_itemsToCatch ) do
		i2 = i2 + 1
		if ( i2 == indexToReturn ) then
			rV = i
			break
		end
	end
	return rV
end

function fisherman_onClientCatchRender ( )
	if not fisherman_isRenderTextActive or getElementData ( localPlayer, "Job" ) ~= "Fisherman" or not isPedInVehicle ( localPlayer ) then
		fisherman_isRenderTextActive = false
		removeEventHandler ( "onClientRender", root, fisherman_onClientCatchRender )
		fisherman_nextCatchTick = nil
		return false
	end
	dxDrawText ( "Net Catch: "..fisherman_getItemCountInNet().."/"..fisherman_maxCatch.."\nUse /net to view your catch", 32, 2, 0, sy, tocolor ( 0, 0, 0 ), 2, "default-bold", "left", "center" )
	dxDrawText ( "Net Catch: "..fisherman_getItemCountInNet().."/"..fisherman_maxCatch.."\nUse /net to view your catch", 30, 0, 0, sy, tocolor ( 255, 255, 255 ), 2, "default-bold", "left", "center" )
	if ( fisherman_nextCatchTick and getTickCount ( ) >= fisherman_nextCatchTick ) then
		fisherman_nextCatchTick = ( getTickCount ( ) + 12000 ) + math.random ( -2000, 2000 )
		if ( fisherman_getItemCountInNet ( ) == fisherman_maxCatch ) then
			return exports.NGMessages:sendClientMessage ( "Your catch is full, go to a sell shop and sell your goods!", 0, 255, 0 )
		end
		local item = fisherman_getRandomItem ( )
		exports.NGMessages:sendClientMessage ( "You caught a(n) "..item.." worth $"..tostring(fisherman_itemsToCatch[item]).."!", 255, 255, 0 )
		fisherman_catch [ item ] = fisherman_catch [ item ] + 1
	end
end

addEvent ( "NGJobs:Fisherman:updateMaxNetCatch", true )
addEventHandler ( "NGJobs:Fisherman:updateMaxNetCatch", root, function ( x )
	fisherman_maxCatch = x
end )

if ( getElementData ( localPlayer, "Job" ) == "Fisherman" and isPedInVehicle ( localPlayer ) and getVehicleController ( getPedOccupiedVehicle ( localPlayer ) ) == localPlayer ) then
	fisherman_isRenderTextActive = true
	exports.NGMessages:sendClientMessage ( "To catch fish, drive around the lake.", 0, 255, 255 )
	addEventHandler ( "onClientRender", root, fisherman_onClientCatchRender )
	fisherman_nextCatchTick = ( getTickCount ( ) + 12000 ) + math.random ( -2000, 2000 )
end

fisherman_setCatch ( )



addCommandHandler ( "net", function ( )
	if ( getElementData ( localPlayer, "Job" ) ~= "Fisherman" ) then
		return exports.NGMessages:sendClientMessage ( "You're not a fisherman", 255, 255, 255 )
	end
	guiGridListClear ( Fisherman.GUI.list )
	if ( guiGetVisible ( Fisherman.GUI.window ) ) then
		guiSetVisible ( Fisherman.GUI.window, false )
		showCursor ( false )
		removeEventHandler ( "onClientGUIClick", Fisherman.GUI.close, fisherman_onClientGUIClick )
	else
		guiSetVisible ( Fisherman.GUI.window, true )
		showCursor ( true )
		addEventHandler ( "onClientGUIClick", Fisherman.GUI.close, fisherman_onClientGUIClick )
		
		local totalPrice = 0
		for i, v in pairs ( fisherman_catch ) do
			local r = guiGridListAddRow ( Fisherman.GUI.list )
			guiGridListSetItemText ( Fisherman.GUI.list, r, 1, tostring ( i ), false, false )
			guiGridListSetItemText ( Fisherman.GUI.list, r, 2, tostring ( v ), false, false )
			local worth = fisherman_itemsToCatch [ i ] * v
			totalPrice = totalPrice + worth
			guiGridListSetItemText ( Fisherman.GUI.list, r, 3, "$"..tostring ( worth ), false, false )
		end
		
		local r = guiGridListAddRow ( Fisherman.GUI.list )
		guiGridListSetItemText ( Fisherman.GUI.list, r, 1, "", true, true )
		guiGridListSetItemText ( Fisherman.GUI.list, r, 2, "", true, true )
		guiGridListSetItemText ( Fisherman.GUI.list, r, 3, "", true, true )
		
		local r = guiGridListAddRow ( Fisherman.GUI.list )
		guiGridListSetItemText ( Fisherman.GUI.list, r, 3, "", true, true )
		guiGridListSetItemText ( Fisherman.GUI.list, r, 2, "", true, true )
		guiGridListSetItemText ( Fisherman.GUI.list, r, 1, "Total: $"..tostring(totalPrice), true, true )
	end
end )


function fisherman_onClientGUIClick ( )
	executeCommandHandler ( "net" )
end 


if ( getElementData ( localPlayer, "Job" ) == "Fisherman" ) then
	setTimer ( triggerServerEvent, 500, 1, "NGJobs:Fisherman:getClientNetLimit", localPlayer, localPlayer )
end


-- Stats Window
Fisherman.GUI2.window = guiCreateWindow( ( sx / 2 - 471 / 2 ), ( sy / 2 - 330 / 2 ), 471, 330, "Fisherman", false)
guiWindowSetSizable(Fisherman.GUI2.window, false)
guiSetVisible ( Fisherman.GUI2.window, false )
Fisherman.GUI2.close = guiCreateButton(353, 295, 108, 25, "Close", false, Fisherman.GUI2.window)
Fisherman.GUI2.username = guiCreateLabel(10, 34, 437, 18, "Username: N/A", false, Fisherman.GUI2.window)
Fisherman.GUI2.job = guiCreateLabel(10, 62, 437, 18, "Job: Fisherman", false, Fisherman.GUI2.window)
Fisherman.GUI2.caughtFish = guiCreateLabel(10, 118, 437, 18, "Caught Fish: N/A", false, Fisherman.GUI2.window)
Fisherman.GUI2.jobRank = guiCreateLabel(10, 90, 437, 18, "Job Rank: N/A", false, Fisherman.GUI2.window)
Fisherman.GUI2.neededFish = guiCreateLabel(10, 146, 437, 18, "Next Rank: N/A  || N/A Fish Needed", false, Fisherman.GUI2.window)
Fisherman.GUI2.jobDesc = guiCreateMemo(12, 187, 449, 98, "", false, Fisherman.GUI2.window)
guiMemoSetReadOnly(Fisherman.GUI2.jobDesc, true)


bindKey ( "F5", "down", function ( )
	local j = getElementData ( localPlayer, "Job" )
	if ( j ~= "Fisherman" ) then
		guiSetVisible ( Fisherman.GUI2.window, false )
		showCursor ( false )
		return
	end
	
	local n = not guiGetVisible ( Fisherman.GUI2.window )
	guiSetVisible ( Fisherman.GUI2.window, n )
	showCursor ( n )
	if n then
		triggerServerEvent ( "NGJobs:Fisherman:GetClientFisherStatsForInterface", localPlayer )
		addEventHandler ( "onClientGUIClick", Fisherman.GUI2.close, fisherman_onClientGUIClickUSerStats )
	else
		removeEventHandler ( "onClientGUIClick", Fisherman.GUI2.close, fisherman_onClientGUIClickUSerStats )
	end
end )


addEvent ( "NGJobs:Fisherman:OnServerSendClientJobInformationForInterface", true )
addEventHandler ( "NGJobs:Fisherman:OnServerSendClientJobInformationForInterface", root, function ( data )
	guiSetText ( Fisherman.GUI2.username, "Username: ".. tostring ( data.account ) )
	guiSetText ( Fisherman.GUI2.job, "Job: ".. tostring ( data.job ) )
	guiSetText ( Fisherman.GUI2.caughtFish, "Caught Fish: ".. tostring ( data.caughtFish ) )
	guiSetText ( Fisherman.GUI2.jobRank, "Job Rank: ".. tostring ( data.jobRank ) )
	guiSetText ( Fisherman.GUI2.neededFish, "Next Rank: "..tostring(data.nextRank).."  ||  ".. tostring(data.requiredCatches) .." Fish Needed" )
	guiSetText ( Fisherman.GUI2.jobDesc, jobDescriptions [ 'fisherman' ] )
end )

function fisherman_onClientGUIClickUSerStats ( ) 
	if source == Fisherman.GUI2.window then return end
	guiSetVisible ( Fisherman.GUI2.window, false )
	showCursor ( false )
	removeEventHandler ( "onClientGUIClick", Fisherman.GUI2.close, fisherman_onClientGUIClickUSerStats )
end

addEventHandler ( "onClientResourceStart", resourceRoot, function ( )
	setTimer ( function ( )
		guiSetVisible ( Fisherman.GUI.window, false );
		guiSetVisible ( Fisherman.GUI2.window, false );
	end, 1000, 1 );
end );