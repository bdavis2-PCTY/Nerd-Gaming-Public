function isPlayerVIP ( )
	return tostring ( getElementData ( localPlayer, "VIP" ) ):lower ( ) ~= "none"
end 


function getVipLevelFromName ( l )
	local levels = { ['none'] = 0, ['bronze'] = 1, ['silver'] = 2, ['gold'] = 3, ['diamond'] = 4 }
	return levels[l:lower()] or 0;
end
