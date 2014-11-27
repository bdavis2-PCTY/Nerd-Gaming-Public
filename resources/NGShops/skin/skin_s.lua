addEvent ( "NGShops:Skins:ResetPlayerSkin", true )
addEventHandler ( "NGShops:Skins:ResetPlayerSkin", root, function ( )
	setElementModel ( source, getElementModel ( source ) ) 
end )

addEvent ( "NGShops:Skin:UpdatePlayerDefaultSkin", true )
addEventHandler ( "NGShops:Skin:UpdatePlayerDefaultSkin", root, function ( s )
	takePlayerMoney ( source, 1200 )
	exports.NGMessages:sendClientMessage ( "You have purchased a new skin!", source, 0, 255, 0 )
	local cur = tonumber ( getElementData ( source, "NGUser.UnemployedSkin" ) ) or 28
	setElementData ( source, "NGUser.UnemployedSkin", s )
	local t = getPlayerTeam ( source )
	if ( getElementModel ( source ) == cur ) then
		setElementModel ( source, s )
	else
		exports.NGMessages:sendClientMessage ( "To change your skin, quit your job", source, 255, 255, 0 )
	end
end )