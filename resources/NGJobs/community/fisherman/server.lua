local netloads =  {
	["Deck Hand"] = 10,
	["Net Baiter"]= 35,
	["Line Thrower"]= 50,
	["Line Roler"]=70,
	["Boat Captain"]=90,
	["Experienced Fisherman"]=130,
	["Underwater Trap Setter"]=150
}

local col = getDatabaseColumnTypeFromJob ( "fisherman" )

addEvent ( "NGJobs:Fisherman:onClientSellCatch", true )
addEventHandler ( "NGJobs:Fisherman:onClientSellCatch", root, function ( t, items, prices )
	givePlayerMoney ( source, t )
	
	local totalFish = 0
	for i, v in pairs ( items ) do
		totalFish = totalFish + v
	end
	
	local c = ( getElementData(source,"NGJobs:Fisherman:CaughtFish") or 0 ) + totalFish
	
	updateJobColumn ( getAccountName ( getPlayerAccount ( source ) ), "CaughtFish", c )
	local cr = getElementData ( source, "Job Rank" )
	updateRank ( source, "fisherman" )
	setElementData ( source, "NGJobs:Fisherman:CaughtFish", c )
	
	exports.NGMessages:sendClientMessage ( "You sold $"..t.." worth of fish ("..totalFish.." fish)!", source, 0, 255, 0 )
	if ( cr ~= getElementData ( source, "Job Rank" ) ) then
		local netload = netloads [ getElementData ( source, "Job Rank" ) ]
		exports.NGMessages:sendClientMessage ( "You have ranked up for the Fisherman job (New net load: "..tostring(netload)..")!", source, 0, 255, 0 )
		triggerClientEvent ( source, "NGJobs:Fisherman:updateMaxNetCatch", source, netload )
	end
end )


function fisherman_refreshMaxCatch ( source )
	local limit = netloads [ getElementData ( source, "Job Rank" ) ]
	triggerClientEvent ( source, "NGJobs:Fisherman:updateMaxNetCatch", source, limit )
end
addEvent ( "NGJobs:Fisherman:getClientNetLimit", true )
addEventHandler ( "NGJobs:Fisherman:getClientNetLimit", root, fisherman_refreshMaxCatch )


addEvent ( "NGJobs:Fisherman:GetClientFisherStatsForInterface", true )
addEventHandler ( "NGJobs:Fisherman:GetClientFisherStatsForInterface", root, function ( )
	
	local account_ = getAccountName(getPlayerAccount(source))
	local job_ = getElementData ( source, "Job" )
	local rank_ = getElementData ( source, "Job Rank" )
	local caught = tonumber ( getJobColumnData ( account_, col ) ) or 0
	local nextRank_ = "None"
	local requiredCatchesForNext_ = "No"
	
	local k = 0
	local dn = false
	
	for i, v in pairs ( jobRanks [ 'fisherman' ] ) do
		k = k + 1
		if ( dn ) then
			nextRank_ = v
			requiredCatchesForNext_ = i - caught
		end
		if ( v == rank_ ) then dn = true end
	end
	local d = { job = job_, jobRank = rank_, caughtFish = caught, nextRank = nextRank_, requiredCatchesForNext = requiredCatchesForNext_, account = account_ }
	triggerClientEvent ( source, "NGJobs:Fisherman:OnServerSendClientJobInformationForInterface", source, d )
end )

for i, v in ipairs ( getElementsByType ( "player" ) ) do
	local a = getPlayerAccount ( v )
	if ( not isGuestAccount ( a ) ) then
		local catches = getJobColumnData ( getAccountName ( a ), col )
		setElementData ( v, "NGJobs:Fisherman:CaughtFish", catches )
	end
end


addEventHandler ( "onPlayerLogin", root, function ( _, acc )
	setTimer ( function ( source, acc )
		local j = getElementData ( source, "Job" )
		if ( job == "Fisherman" ) then
			local d = getJobColumnData ( getAccountName(acc), col )
			setElementData ( source, "NGJobs:Fisherman:CaughtFish", tonumber ( d ) )
		end
	end, 500, 1, source, acc )
end )


addEventHandler ( "NGJobs:onPlayerJoinNewJob", root, function ( j )
	if ( j == "fisherman" ) then
		local catches = getJobColumnData ( getAccountName ( getPlayerAccount ( source ) ), col )
		setElementData ( source, "NGJobs:Fisherman:CaughtFish", catches )
	end
end )