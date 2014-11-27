addEventHandler ( "onIRCUserJoin", root, function ( channel, host )
	print ( tostring ( host ) .. " connected to #".. tostring ( channel ) )
end )