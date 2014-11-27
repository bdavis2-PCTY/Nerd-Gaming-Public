local locs = {  { 1565.48, -1694.23, 5.89 } }

local e = { ['blip'] = { }, ['marker'] = { } }

addEvent ( "onPlayerStartArrested", true )
addEventHandler ( "onPlayerStartArrested", root, function ( p, c)
	if ( c == localPlayer ) then
		for i, v in ipairs ( locs ) do
			local x, y, z = unpack ( v )
			e['marker'][i] = createMarker ( x, y, z - 1, "cylinder", 2.5, 0, 120, 255, 120 )
			e['blip'][i] = createBlip ( x, y,z, 30 ) 
			addEventHandler ( "onClientMarkerHit", e['marker'][i], function ( p )
				if ( p == localPlayer ) then
					for i, v in pairs ( e ) do 
						for i, v in pairs ( v ) do 
							if ( isElement ( v ) ) then
								destroyElement ( v )
							end
						end
					end 
					triggerServerEvent ( "ngpolice:onJailCopCrimals", localPlayer )
				end
			end )
		end
	end
end )

addEvent ( "onPlayerEscapeCop", true )
addEventHandler ( "onPlayerEscapeCop", root, function ( player, cop, arrestedCrims )
	if ( cop == localPlayer ) then
		if ( type ( arrestedCrims ) ~= "table" or #arrestedCrims <= 0 ) then
			for i, v in pairs ( e ) do 
				for i, v in pairs ( v ) do 
					if ( isElement ( v ) ) then
						destroyElement ( v )
					end
				end
			end 
		end
	end
end )