addEventHandler ( "onPlayerWasted", root, function ( _, killer )
	local d = tonumber ( getElementData ( source, "NGSQL:Deaths" ) ) or 0
	setElementData ( source, "NGSQL:Deaths", d + 1 )
	if ( isElement ( killer ) ) then
		local k = tonumber ( getElementData ( killer, "NGSQL:Kills" ) ) or 0
		setElementData ( killer, "NGSQL:Kills", k + 1 )
	end
end )