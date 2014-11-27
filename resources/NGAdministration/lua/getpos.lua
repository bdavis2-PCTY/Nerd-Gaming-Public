addCommandHandler ( 'getpos', function ( _, round )
	if not round then round = 'yes' end
	local x, y, z = getElementPosition ( localPlayer )
	local pos = nil
	if ( round == 'yes' ) then
		pos = table.concat ( { math.round ( x, 2 ), math.round ( y, 2 ), math.round ( z, 2 ) }, ", " );
	else
		pos = table.concat ( { x, y, z }, ', ' )
	end
	
	outputChatBox ( "Coordinates: "..pos.." (Copied!)", 255, 255, 0 )
	setClipboard ( pos )
	
end )


function math.round(number, decimals, method)
    decimals = decimals or 0
    local factor = 10 ^ decimals
    if (method == "ceil" or method == "floor") then return math[method](number * factor) / factor
    else return tonumber(("%."..decimals.."f"):format(number)) end
end