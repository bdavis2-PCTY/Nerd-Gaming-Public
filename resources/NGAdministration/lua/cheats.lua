local enabled = false
addCommandHandler ( "fly", function ( )
	local d = getElementData ( localPlayer, "Job Rank" )
	if ( d and string.sub ( d, 1, 5 ) == "Level" ) then
		if ( enabled ) then
			setWorldSpecialPropertyEnabled ( "aircars", false )
			exports.NGMessages:sendClientMessage ( "Fly cars are now off...", 255, 255, 0 )
			enabled = false
		else
			setWorldSpecialPropertyEnabled ( "aircars", true )
			exports.NGMessages:sendClientMessage ( "Fly cars are now on...", 255, 255, 0 )
			enabled = true
		end
	end
end )