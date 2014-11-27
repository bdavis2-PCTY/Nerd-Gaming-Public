addEvent ( "NGHealthPacks->Modules->Packs->onPlayerBuypack", true )
addEventHandler ( "NGHealthPacks->Modules->Packs->onPlayerBuypack", root, function ( )

	if ( source.money < 500 ) then
		return exports.ngmessages:sendClientMessage ( "You need to have at least $500 to buy a health pack.", source, 255, 0, 0 )
	end

	source:takeMoney ( 500 )

	local inv = getElementData ( source, "NGUser:Items" ) or { }
	local h = inv.health_packs or 0
	inv.health_packs = h + 1
	setElementData ( source, "NGUser:Items", inv )

	exports.ngmessages:sendClientMessage ( "You bought a health pack for $500", source, 0, 255, 0 )

end )


function useHealthPack ( p  )
	if ( p.health > 90 ) then return false end 
	setPedAnimation ( p, "BOMBER", "BOM_Plant", -1, true )

	exports.ngmessages:sendClientMessage ( "Healing...", p, 255, 255, 0 )
	setTimer ( function ( p )
		if ( isElement ( p ) and not isPedDead ( p ) ) then
			setPedAnimation ( p )
			exports.ngmessages:sendClientMessage ( "Healed!", p, 0, 255, 0 )
			p.health = p.health + 10
		end 
	end, 4000, 1, p )

	return true
end 
addEvent ( "NGHealthPacks->Modules->Packs->UseHealthPack", true )
addEventHandler ( "NGHealthPacks->Modules->Packs->UseHealthPack", root, useHealthPack )
