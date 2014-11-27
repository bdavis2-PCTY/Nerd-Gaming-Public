function giveWantedPoints ( p, amount )
	if ( p and isElement ( p ) and tonumber ( amount ) ) then
		local amount = tonumber ( amount )
		local wl = tonumber ( getElementData ( p, "WantedPoints" ) )
		setElementData ( p, "WantedPoints", tonumber ( wl ) + amount ) 
		return true
	end
	return false
end

addEventHandler ( "onPlayerDamage", root, function ( p, weap, loss )
	if ( isElement ( p ) and p ~= source ) then

		local x, y, z = getElementPosition ( source )
		--if ( getZoneName ( x, y, z, true ) == "Las Venturas" ) then return end

		if ( getElementData ( source, "NGEvents:IsPlayerInEvent" ) or getElementData ( p, "NGEvents:IsPlayerInEvent" ) ) then
			return
		end
		
		if ( getElementType ( p ) == 'vehicle' ) then
			if ( getVehicleOccupant ( p ) ) then
				p = getVehicleOccupant ( p )
			else
				return 
			end
		end

		local t = getPlayerTeam ( p )
		if t then
			local t = tostring ( getTeamName ( t ) )
			if weap then
				if ( t == "Emergency" and getElementHealth ( source ) < 100 and weap == 14 ) then
					if ( getElementData ( p, "Job" ) == "Medic" ) then
						return
					end
				elseif ( exports['NGPlayerFunctions']:isTeamLaw ( t ) and ( weap == 3 or weap == 23 ) and getPlayerWantedLevel ( source ) > 0 ) then
					return
				end
			end
		end
		giveWantedPoints ( p, math.floor ( loss * 3 ) )
	end
end )

local ticks = 0
local tickChange = 50
setTimer ( function ( )
	ticks = ticks + 1
	for i, v in ipairs ( getElementsByType ( 'player' ) ) do 
		if ( not getElementData ( v, "NGJobs:ArrestingOfficer" ) and not getElementData ( v, "isPlayerJailed" ) ) then
			local wl = tonumber ( getElementData ( v, "WantedPoints" ) ) or 0
			if ( wl >= 600 ) then
				setPlayerWantedLevel ( v, 6 )
			elseif ( wl >= 450 ) then
				setPlayerWantedLevel ( v, 5 )
			elseif ( wl >= 320 ) then
				setPlayerWantedLevel ( v, 4 )
			elseif ( wl >= 210 ) then
				setPlayerWantedLevel ( v, 3 )
			elseif ( wl >= 100 ) then
				setPlayerWantedLevel ( v, 2 )
			elseif ( wl > 0 ) then
				setPlayerWantedLevel ( v, 1 )
			elseif ( wl <= 0 ) then	
				setPlayerWantedLevel ( v, 0 )
			end
			if ( ticks >= tickChange ) then
				setElementData ( v, "WantedPoints", wl - 1 )
				if ( wl - 1 < 0 ) then
					setElementData ( v, "WantedPoints", 0 )
				end
			end
		end
		
		if ( getPlayerWantedLevel ( v ) > 0 ) then
			setPlayerNametagText ( v, tostring ( getPlayerName ( v ) ).."["..tostring ( getPlayerWantedLevel ( v ) ).."]" )
		else
			setPlayerNametagText ( v, tostring ( getPlayerName ( v ) ) )
		end
		
		local job = getElementData ( v, "Job" )
		if job  then
			local max_ = max_wanted[getJobType(job)] or 7
			local w_l = getPlayerWantedLevel ( v )
			if ( w_l ~= 0 and w_l > max_ ) then
				exports['NGMessages']:sendClientMessage ( "You've been resigned for having a high wanted level.", v, 255, 255, 0 )
				resignPlayer ( v )
			end
		end
	end
end, 3000, 0 )