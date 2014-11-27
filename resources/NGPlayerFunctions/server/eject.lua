function print ( msg, p, r, g, b )
	return exports.NGMessages:sendClientMessage ( msg, p, r, g, b )
end


function ejectPlayer ( p, _, nab )
	if nab	then
		if isPedInVehicle ( p )	then
			if getPedOccupiedVehicleSeat ( p ) == 0	then
			local ej = getPlayerFromNamePart ( nab )
			local veh = getPedOccupiedVehicle ( p )
				if ej	then
					if ej ~= p	then
						if getPedOccupiedVehicle ( ej ) == veh	then
						removePedFromVehicle ( ej )
						print ( "You have ejected "..getPlayerName(ej).." from your vehicle!", p, 255, 255, 0, true, 8 )
						print ( "You have been ejected from your vehicle by "..getPlayerName(p), ej, 255, 255, 0, true, 8 )
						else print ( nab.." is not in this vehicle", p, 255, 255, 0, true, 8 )
						end
					else print ( "You cannot eject yourself.", p, 255, 255, 0, true, 8 )
					end
				else print ( nab.." is not in this vehicle", p, 255, 255, 0, true, 8 )
				end
			else print ( "You are not the driver of this vehicle", p, 255, 255, 0, true, 8 )
			end
		else print ( "You are not in a vehicle", p, 255, 255, 0, true, 8 )
		end
	else print ( "/eject [player]", p, 255, 255, 0, true, 8 )
	end
end
addCommandHandler ( "eject", ejectPlayer )