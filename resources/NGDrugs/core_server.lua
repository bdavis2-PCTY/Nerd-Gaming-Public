local texts = { }
addEvent ( "NGDrugs:Module->Core:setPlayerHeadText", true )
addEventHandler ( "NGDrugs:Module->Core:setPlayerHeadText", root, function ( text, color )
	if ( isElement ( texts[source]  ) ) then destroyElement ( texts[source]  ) end
	texts[source] = exports.ngjobs:create3DText ( text, { 0, 0, 0 }, color, source, { 15, false } )
end )

addEvent ( "NGDrugs:Module->Core:destroyPlayerHeadText", true )
addEventHandler ( "NGDrugs:Module->Core:destroyPlayerHeadText", root, function ( )
	if ( isElement ( texts [ source ] ) ) then
		destroyElement( texts [ source ] )
	end
end )