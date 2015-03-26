local enabled = true
local blips = { }


addEventHandler ( "onClientPlayerSpawn", root, function ( )
	createBlipForPlayer ( source )
end )

addEventHandler ( "onClientPlayerQuit", root, function ( )
	destroyBlipForPlayer ( source )
end )

addEventHandler ( "onClientPlayerWasted", root, function ( )
	destroyBlipForPlayer ( source )
end )

function destroyBlipForPlayer ( player )
	if ( isElement ( blips [ player ] ) ) then
		destroyElement ( blips [ player ] )
	end
end

function createBlipForPlayer ( player )
	if ( isElement ( blips [ player ] ) ) then
		destroyElement ( blips [ player ] )
		blips [ player ] = nil
	end
	if ( enabled ) then
		local team = getPlayerTeam ( player )
		local r, g, b = 255, 255, 255
		if ( team ) then
			r, g, b = getTeamColor( team )
		end
		blips [ player ] =createBlipAttachedTo ( player, 0, 2, r, g, b, 255, 0, 700 )
	end
end 


addEventHandler ( "onClientResourceStart", resourceRoot, function ( )
	for i, v in pairs ( getElementsByType ( "player" ) ) do 
		createBlipForPlayer ( v )
	end
end )

setTimer ( function ( )
	for i, v in pairs ( blips ) do
		if ( isElement ( v ) and ( not i or not isElement ( i ) ) ) then
			destroyBlipForPlayer ( v )
		else
			if ( isElement ( v ) and i and isElement ( i ) and getElementType ( i ) == "player" ) then
				local r, g, b = 255, 255, 255
				local t = getPlayerTeam ( i )
				if ( t ) then
					r, g, b = getTeamColor ( t )
				end
				setBlipColor ( v, r, g, b, 255 )
			else
				destroyBlipForPlayer ( v )
			end 
		end 
	end

	for i, v in pairs ( getElementsByType ( "player" ) ) do
		if ( not isElement ( blips [ v ] ) ) then 
			createBlipForPlayer ( v )
		end 
	end 
end, 5000, 0 )