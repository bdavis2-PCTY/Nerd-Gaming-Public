local pt = { }

exports.scoreboard:scoreboardAddColumn ( "Playtime", root, 50 )
addEventHandler ( "onResourceStart", resourceRoot, function ( )
	for i, v in pairs ( getElementsByType ( "player" ) ) do
		pt [ v ] = 0
		local x = tonumber ( getElementData ( v, "PlayerFunct:HiddenPTMins" ) )
		if ( x ) then
			pt [ v ] = x
		end
	end
end )


addEventHandler ( "onResourceStop", resourceRoot, function  ( )
	for i, v in pairs ( getElementsByType ( "player" ) ) do
		local x = 0
		if ( pt [ v ] ) then
			x = pt [ v ]
		end
		setElementData ( v, "PlayerFunct:HiddenPTMins", x )
	end
end )

setTimer ( function ( ) 
	for i, v in pairs ( getElementsByType ( "player" ) ) do
		if ( not pt [ v ] ) then
			pt [ v ] = 0
		end
		pt [ v ] = pt [ v ]  + 1
		updatePlayerPlaytime ( v )
	end
end, 60000, 0 )

function updatePlayerPlaytime ( v) 
	if ( not ( pt [ v ] ) ) then
		return false
	end
	
	return setElementData ( v, "Playtime", tostring ( convertMinsToActualTime ( pt [ v ] ) ) )
end



function deletePlayerPlaytime ( p ) 
	if ( p and pt [ p ] ) then	
		pt [ p ]  = nil
		return true
	end
	return false
end 

function setPlayerPlaytime ( p, m )
	if ( p and m ) then
		pt [ p ] = m
		updatePlayerPlaytime ( p )
		return true
	end
	return false
end

function getPlayerPlaytime ( p )
	if ( p and pt [ p ] ) then
		return pt [ p ]
	end
	return false
end



function convertMinsToActualTime ( m )
	local hours = 0
	local days = 0
	local months = 0
	while ( m >= 60 ) do
		m = m - 59
		hours = hours + 1
		if ( hours >= 24 ) then
			hours = hours - 23
			days = days + 1
			if ( days >= 30 ) then
				days = days - 29
				months = months + 1
			end
		end
	end
	
	-- Minutes only
	if ( hours == 0 and days == 0 and months == 0 ) then
		return tostring(m).."m"
	-- Hours and minutes
	elseif ( hours > 0 and days == 0 and months == 0 ) then
		return tostring(hours).."h "..tostring(m).."m" 
		
	-- Days and Hours
	elseif ( hours > 0 and days > 0 and months == 0 ) then
		return tostring(days).."d "..tostring(hours).."h" 
		
	-- Months and Days 
	elseif ( days > 0 and months > 0 ) then
		return tostring(months).."mon "..tostring(days).."d"
	end
end


addCommandHandler ( "playtime", function ( p )
	if ( not pt [ p ] ) then
		pt [ p ] = 0
	end
	exports.NGMessages:sendClientMessage ( "You have a total of "..tostring(pt[p]).." minutes of online-time at Nerd Gaming", p, 0, 255, 0 )
end )