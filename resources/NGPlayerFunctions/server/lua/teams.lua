local teams = { 
	{ "Staff", 255, 140, 0 },
	{ "Criminals", 255, 0, 0 },
	{ "Law Enforcement", 0, 100, 255 },
	{ "Services", 255, 255, 0 },
	{ "Emergency", 0, 255, 255 },
	{ "Unemployed", 255, 92, 0 },
}

local lawTeams = { 
	['Law Enforcement'] = true
}

local team = { }
for i, v in ipairs ( teams ) do
	team[v[1]] = createTeam ( unpack ( v ) )
end

function setTeam ( p, tem ) 
	if ( p and getElementType ( p ) == 'player' and tem and type ( tem ) == 'string' ) then
		for i, v in ipairs ( teams ) do 
			if ( v[1] == tem ) then
				return setPlayerTeam ( p, getTeamFromName ( v[1] ) )
			end
		end
	end
	return false
end

addEventHandler ( "onResourceStop", root, function ( )
	for i, v in ipairs ( getElementsByType ( 'player' ) ) do 
		if ( getPlayerTeam ( v ) ) then
			setElementData ( v, "NGPlayers:SavedTeam", getTeamName ( getPlayerTeam ( v ) ) )
		end
	end
end )

addEventHandler ( 'onResourceStart', resourceRoot, function ( )
	for i, v in ipairs ( getElementsByType ( 'player' ) ) do 
		local t = getElementData ( v, 'NGPlayers:SavedTeam' )
		if t and getTeamFromName ( t ) then 
			setPlayerTeam ( v, getTeamFromName ( t ) )
		else
			setPlayerTeam ( v, getTeamFromName ( t, "Unemployed" ) )
		end
	end
end )

function isTeamLaw ( team )
	local team = tostring ( team )
	if ( lawTeams[team] ) then
		return true
	end
	return false
end