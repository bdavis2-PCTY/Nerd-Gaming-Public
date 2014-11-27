----------------------------------------------------------
-- Variables											--
----------------------------------------------------------
appFunctions = { }
appFunctions.vehicles = { }
appFunctions.settings = { }
appFunctions.stats = { }
appFunctions.bank = { }
appFunctions.flappy = { }
appFunctions._2048 = { }
appFunctions.waypoints = { }

----------------------------------------------------------
-- shared functions										--
----------------------------------------------------------
function tobool ( input )
	local input = tostring ( input ):lower ( )
	if ( input == "true" ) then
		return true
	elseif ( input == "false" ) then
		return false
	else
		return nil
	end
end