function giveWantedPoints ( amount )
	if (tonumber ( amount ) ) then
		local amount = tonumber ( amount )
		local wl = tonumber ( getElementData ( localPlayer, "WantedPoints" ) )
		return setElementData ( localPlayer, "WantedPoints", wl + amount )  
	end
	return false
end