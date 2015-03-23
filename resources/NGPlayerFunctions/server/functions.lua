function getPlayerFromNamePart ( str )
	if ( str ) then
		local players = { }
		for i, v in ipairs ( getElementsByType ( 'player' ) ) do
			if ( string.find ( string.lower (  getPlayerName ( v ) ), string.lower ( str ) ) ) then
				table.insert ( players, v )
			end
		end
		if ( #players == 0 or #players > 1 ) then
			return false
		end
		return players[1]
	end
	return false
end 

function getPlayerFromAcocunt ( accnt )
	local p = false
	for i, v in ipairs ( getElementsByType ( 'player' ) ) do 
		if ( getAccountName ( getPlayerAccount ( v ) ) == accnt ) then
			p = v
			break
		end
	end
	return p
end
