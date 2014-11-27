addEvent ( "NGPolice:Modules->Panel:RequestData", true )
addEventHandler ( "NGPolice:Modules->Panel:RequestData", root, function ( )
	local user = getAccountName ( getPlayerAccount ( source ) )
	local jobData = exports.NGJobs:getJobRankTable ( )['police officer']
	
	if ( getElementData ( source, "Job" ):lower( ) == "Detective" ) then
		jobData = exports.NGJobs:getJobRankTable ( )['police officer']
	end
	
	local data = { }
	data.mystats = { }
	data.mystats.arrests = exports.NGJobs:getJobColumnData ( user, "Arrests" )
	data.mystats.solvedCrims = exports.NGJobs:getJobColumnData ( user, "SolvedCrims" )
	data.mystats.rank = getElementData ( source, "Job Rank" )	
	
	local ranks = { }
	local ranks_ = { }
	for i, v in pairs ( jobData ) do table.insert ( ranks, { i, v } ) end
	table.sort ( ranks, function ( a, b, x ) return a[1] > b[1] end )
	for i=#ranks, 1, -1 do table.insert ( ranks_, ranks [ i ] ) end
	local ranks = ranks_
	local nextRank = "None"
	local nextRankArrests = "None"
	local isNext = false
	
	for i, v in ipairs ( ranks ) do
		if ( isNext ) then
			nextRank = v[2]
			nextRankArrests=v[1]
			break
		end
		if ( v[2] == data.mystats.rank ) then
			isNext = true
		end
	end
	
	data.mystats.nextRank = nextRank
	data.mystats.nextRankArrests = nextRankArrests
	data.criminals = { }
	for i, v in ipairs ( getElementsByType ( "player" ) ) do
		if ( getPlayerWantedLevel ( v ) > 0 ) then
			local wl = tostring ( getPlayerWantedLevel ( v ) )
			local wp = tostring ( getElementData ( v, "WantedPoints" ) )
			local x, y, z = getElementPosition ( v )
			local loc = getZoneName ( x, y, z )..", "..getZoneName(x,y,z,true)
			local d = {
				nam = getPlayerName ( v ),
				loc = loc,
				WL = wl,
				WP = wp
			}
			table.insert(data.criminals,d)
		end
	end
	triggerClientEvent ( source, "NGPolice:Modules->Panel:OnServerSendClientData", source, data )
end )

addEvent ( "NGPolice:Modules->Panel:onClientSendLawMessage", true )
addEventHandler ( "NGPolice:Modules->Panel:onClientSendLawMessage", root, function ( m )
	executeCommandHandler ( "r", source, m )
end )





function outputDispatchMessage ( msg )
	for i, v in pairs ( getElementsByType ( "player" ) ) do
		local t = getPlayerTeam ( v )
		if t and exports.NGPlayerFunctions:isTeamLaw ( getTeamName ( t ) ) then
			exports.NGMessages:sendClientMessage ( "(Dispatch) New message, check the computer (F5) -> Dispatch", v, 255, 255, 255 )
		end
		triggerClientEvent ( root, "NGPolice:Modules->Dispatch:onDispatchMessage", root, msg )
	end
	return true
end