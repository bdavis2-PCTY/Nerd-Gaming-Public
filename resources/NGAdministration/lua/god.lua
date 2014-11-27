addEventHandler ( 'onClientPlayerDamage', root, function ( )
	if ( isElement ( source ) ) then
		if ( getElementModel ( source ) == 217 or getElementData ( source, "isGodmodeEnabled" ) == true ) then
			cancelEvent ( )
		end
	end
end )