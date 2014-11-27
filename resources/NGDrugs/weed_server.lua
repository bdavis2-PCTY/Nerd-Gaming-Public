addEvent ( "NGDrugs:Module->Marijuana:updatePlayerHealth", true )
addEventHandler ( "NGDrugs:Module->Marijuana:updatePlayerHealth", root, function ( )
	local h = math.floor ( getElementHealth ( source ) )
	if ( h == 199 ) then
		h = 198 
	end

	if ( h <= 198 ) then
		setElementHealth ( source, h + 2)
	end
end )