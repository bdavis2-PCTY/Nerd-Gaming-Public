local gui = { }
local sx, sy = guiGetScreenSize ( )

function openBuyWindow ( )
	if ( isElement ( gui.window ) ) then
		destroyBuyWindow ( )
	end 
	gui.window = guiCreateWindow((sx/2-359/2), (sy/2-193/2), 359, 193, "Health Packs", false)
	guiWindowSetSizable(gui.window, false)
	gui.Image = guiCreateStaticImage(10, 28, 100, 112, "pack.png", false, gui.window)
	gui.Label = guiCreateLabel(128, 28, 215, 85, "You can buy a health pack for $500, and use it if your health is starting to get low. It will re-generate 10% health.", false, gui.window)
	guiLabelSetHorizontalAlign ( gui.Label, "left", true )
	gui.Buy = guiCreateButton(249, 134, 94, 36, "Buy Health Pack", false, gui.window)
	gui.Close = guiCreateButton(149, 134, 94, 36, "Close", false, gui.window)
	showCursor ( true )

	addEventHandler ( "onClientGUIClick", gui.Close, destroyBuyWindow )
	addEventHandler ( "onClientGUIClick", gui.Buy, onClientBuyHealthPack )
end

function destroyBuyWindow ()
	removeEventHandler ( "onClientGUIClick", gui.Close, destroyBuyWindow )
	removeEventHandler ( "onClientGUIClick", gui.Buy, onClientBuyHealthPack )
	destroyElement ( gui.window )
	showCursor ( false )
	gui = { }
end 

function onClientBuyHealthPack ( )
	triggerServerEvent ( "NGHealthPacks->Modules->Packs->onPlayerBuypack", localPlayer )
end 

function useHealthPack ( )
	if ( localPlayer.health > 90 ) then return false end

	triggerServerEvent ( "NGHealthPacks->Modules->Packs->UseHealthPack", localPlayer, localPlayer )
	return true
end 



local packs = { }
function createHealthPackPickup ( x, y, z, int, dim )
	if not int then int = 0 end
	if not dim then dim = 0 end
	local i = 0

	while ( packs [ i ] ) do
		i = i + 1
	end

	packs [ i ] = createPickup ( x, y, z, 0, 0, 0 )
	packs[i].interior = int
	packs[i].dimension = dim 
	addEventHandler ( "onClientPickupHit", packs[i], function ( p )
		if ( p == localPlayer and p.interior == source.interior and p.dimension == source.dimension and not isPedInVehicle ( localPlayer ) ) then
			openBuyWindow ( )
		end 
	end )
end 


createHealthPackPickup ( 1603.42, 1818.13, 10.82 )
createHealthPackPickup ( 2538.63, 1971.21, 10.82 )
createHealthPackPickup ( 1367.78, 396.36, 19.7 )
createHealthPackPickup ( -321.54, 1056.34, 19.74 )
createHealthPackPickup ( -1505.13, 2519.84, 55.9 )
createHealthPackPickup ( -2666.77, 608.39, 14.45 )
createHealthPackPickup ( -2204.79, -2290.08, 30.63 )
createHealthPackPickup ( 1183.29, -1315.31, 13.58 )
createHealthPackPickup ( 2041.37, -1426.31, 17.16 )