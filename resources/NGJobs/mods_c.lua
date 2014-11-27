addEventHandler ( "onClientResourceStart", resourceRoot, function ( )

	engineImportTXD ( engineLoadTXD ( "mods/17.txd" ), 17 )
	engineReplaceModel ( engineLoadDFF ( "mods/17.dff", 0 ), 17 )

end )