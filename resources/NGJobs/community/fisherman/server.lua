local netloads =  {
	["Deck Hand"] = 10,
	["Net Baiter"]= 35,
	["Line Thrower"]= 50,
	["Line Roler"]=70,
	["Boat Captain"]=90,
	["Experienced Fisherman"]=130,
	["Underwater Trap Setter"]=150
}

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
	
	local data = { }
	data.account = getAccountName(getPlayerAccount(source));
	data.job = getElementData ( source, "Job" );
	data.jobRank = getElementData ( source, "Job Rank" );
	data.caughtFish = tonumber ( getJobColumnData ( data.account, getDatabaseColumnTypeFromJob ( "fisherman" ) ) ) or 0
	data.nextRank = nil;
	data.requiredCatches = nil;
	
	local isNext = false;
	for _, v in ipairs ( foreachinorder ( jobRanks['fisherman'] ) ) do 
		if ( isNext ) then 
			data.nextRank = v[2];
			data.requiredCatches = v[1] - data.caughtFish;
			break;
		end 

		if ( v[2]:lower() == data.jobRank:lower() ) then 
			isNext = true;
		end 
	end 
	
	
	
	triggerClientEvent ( source, "NGJobs:Fisherman:OnServerSendClientJobInformationForInterface", source, data )
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