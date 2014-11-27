local skins = { 
	{ 0, "CJ" },
	{ 1, "The Truth" },
	{ 2, "Maccer" },
	{ 6, "Emmet" },
	{ 7, "Taxi/Train Driver" },
	{ 9, "Normal Ped" },
	{ 10, "Old Woman" },
	{ 11, "Casino Croupier" },
	{ 12, "Rich Woman" },
	{ 13, "Street Girl" },
	{ 14, "Normal Ped 2" },
	{ 15, "Mr. Whittaker" },
	{ 16, "Airport Ground Worker" },
	{ 18, "Beach Visitor" },
	{ 19, "DJ" },
	{ 20, "Madd Dogg's Manager" },
	{ 21, "Normal Ped 3" },
	{ 22, "Normal Ped 4" },
	{ 23, "BMXer" },
	{ 24, "Madd Dogg's Bodyguard" },
	{ 25, "Madd Dogg's Bodyguard 2" },
	{ 26, "Backpacker" },
	{ 27, "Construction Worker" },
	{ 28, "Drug Dealer" },
	{ 29, "Drug Dealer 2" },
	{ 30, "Drug Dealer 3" },
	{ 31, "Farm-Town Inhabitant" },
	{ 32, "Farm-Town Inhabitant 2" },
	{ 33, "Farm-Town Inhabitant 3" },
	{ 34, "Farm-Town Inhabitant 4" },
	{ 35, "Gardener" },
	{ 36, "Golfer" },
	{ 37, "Golfer 2" },
	{ 38, "Golfer 3" },
	{ 39, "Normal Ped 5" },
	{ 40, "Normal Ped 6" },
	{ 41, "Normal Ped 7" },
}


local SkinLocs = { 
	[1] = {
		outPos = { 1459.16, -1140.48, 24.06 },
		inPos = { 180.5, -88.39, 1002.02 },
		int = 18,
		dim = 1
	},
	
	[2] = {
		outPos = { 2244.91, -1662.91, 15.48 },
		inPos = { 180.5, -88.39, 1002.02 },
		int = 18,
		dim = 2
	}
}

exports.ngwarpmanager:makeWarp ( { pos = { 1457.73, -1137.21, 24.97 }, toPos = { 161.4, -93.15, 1002 }, cInt = 0, cDim = 0, tInt = 18, tDim = 1 } )
exports.ngwarpmanager:makeWarp ( { pos = { 161.28, -96.31, 1002.8 }, toPos = { 1459.16, -1140.48, 24.2 }, cInt = 18, cDim = 1, tInt = 0, tDim = 0 } )

exports.ngwarpmanager:makeWarp ( { pos = { 2244.48, -1664.79, 16.48 }, toPos = { 161.4, -93.15, 1002 }, cInt = 0, cDim = 0, tInt = 18, tDim = 2 } )
exports.ngwarpmanager:makeWarp ( { pos = { 161.28, -96.31, 1002.8 }, toPos = { 2245.4, -1661.95, 16 }, cInt = 18, cDim = 2, tInt = 0, tDim = 0 } )





local markers = { }
local sx, sy = guiGetScreenSize ( )
local org = { }

function onClientMarkerSkinHit ( p )
	if ( p ~= localPlayer or getElementDimension(localPlayer)~=getElementDimension(source) or getElementInterior(source)~=getElementInterior(localPlayer) ) then return end
	org.skin = getElementModel ( p )
	
	window = guiCreateWindow(10, (sy/2-403/2), 222, 403, "Skin Shop", false)
	guiWindowSetSizable(window, false)
	tmp2 = guiCreateLabel(14, 34, 98, 30, "Available Skins", false, window)
	list = guiCreateGridList(13, 64, 197, 278, false, window)
	guiGridListAddColumn(list, "", 0.9)
	tmp1 = guiCreateLabel(112, 34, 98, 30, "All Skins\nAre $1,200", false, window)
	cancel = guiCreateButton(13, 352, 85, 32, "Cancel", false, window)
	buy = guiCreateButton(102, 352, 85, 32, "Buy Skin", false, window)
	showCursor ( true )
	for i, v in pairs ( skins ) do
		local r = guiGridListAddRow ( list )
		guiGridListSetItemText ( list, r, 1, tostring ( v [ 2 ] ), false, false )
	end
	
	addEventHandler ( "onClientGUIClick", root, onClientGUIClick_Skin )
end

function onClientGUIClick_Skin ( )
	if ( source == list ) then
		local r, c = guiGridListGetSelectedItem ( list )
		if ( row == -1 ) then return end
		local t = guiGridListGetItemText ( source,  r, 1 )
		for i, v in pairs ( skins ) do
			if ( tostring ( v [ 2 ] ):lower ( ) == tostring ( t ):lower ( ) ) then
				setElementModel ( localPlayer, v [ 1 ] )
				break
			end
		end
	elseif ( source == cancel ) then
		closeSkinShop ( true )
	elseif ( source == buy ) then
		local r, c = guiGridListGetSelectedItem ( list )
		if ( row == -1 ) then return exports.NGMessages:sendClientMessage("No skin selected",255,255,255) end
		local t = guiGridListGetItemText ( list,  r, 1 )
		for i, v in pairs ( skins ) do
			if ( tostring ( v [ 2 ] ):lower ( ) == tostring ( t ):lower ( ) ) then
				sI = v [ 1 ]
				break
			end
		end
		
		if ( sI == org.skin ) then
			return exports.NGMessages:sendClientMessage ( "That is already your skin", 255, 255, 0 )
		end
		
		
		if ( getPlayerMoney ( localPlayer ) < 1200 ) then
			return exports.NGMessages:sendClientMessage ( "You don't have enough money to buy a new skin", 255, 0, 0 )
		end
		closeSkinShop ( true )
		triggerServerEvent ( "NGShops:Skin:UpdatePlayerDefaultSkin", localPlayer, sI )
	end
end

function closeSkinShop ( rSkin )
	removeEventHandler ( "onClientGUIClick", root, onClientGUIClick_Skin )
	destroyElement ( tmp2 )
	destroyElement ( tmp1 )
	destroyElement ( list )
	destroyElement ( buy )
	destroyElement ( cancel )
	destroyElement ( window )
	showCursor ( false )
	if ( rSkin ) then setElementModel ( localPlayer, org.skin ) end
end


for i, s in pairs ( SkinLocs ) do
	local x, y, z = unpack ( s.inPos )
	markers[i] = createMarker ( x, y, z - 1, "cylinder", 2.5, 255, 50, 50, 200 )
	setElementInterior ( markers[i], s.int )
	setElementDimension ( markers[i], s.dim )
	local d = {
		int = s.int,
		dim = s.dim
	}
	setElementData ( markers[i], "NGShops:Skins->MarkerInfo", d )
	addEventHandler ( "onClientMarkerHit", markers[i], onClientMarkerSkinHit )
end




addEvent ( "onClientPlayerLogin", true )
addEventHandler ( "onClientPlayerLogin", root, function  ()
	if ( exports.NGPhone:getSetting ( "usersetting_display_skinshopblips" ) ) then
		blips = { }
		for i, v in pairs ( SkinLocs ) do
			local x, y, z = unpack ( v.outPos )
			blips[i] = createBlip ( x, y, z, 45, 2, 255, 255, 255, 255, 0, 450 )
		end
	end
end )

addEvent ( "onClientUserSettingChange", true )
addEventHandler ( "onClientUserSettingChange", root, function ( g, v )
	if ( g == "usersetting_display_skinshopblips" )  then
		if ( v and not blips ) then
			blips = { }
			for i, v in pairs ( SkinLocs ) do
				local x, y, z = unpack ( v.outPos )
				blips[i] = createBlip ( x, y, z, 45, 2, 255, 255, 255, 255, 0, 450 )
			end
		elseif ( not v and blips ) then
			for i, v in pairs ( blips ) do
				destroyElement ( v )
			end
			blips = nil
		end
	end
end )
