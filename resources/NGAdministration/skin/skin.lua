addEventHandler ( "onClientResourceStart", resourceRoot, function ( )
	engineImportTXD ( engineLoadTXD ( "skin/217.txd" ), 217 )
	engineReplaceModel ( engineLoadDFF ( "skin/217.dff", 0 ), 217 )
end )