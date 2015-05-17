addEvent ( "NGJobs->Module->Job->Pilot->OnClientRequestF5Data", true )
addEventHandler ( "NGJobs->Module->Job->Pilot->OnClientRequestF5Data", root, function ( )
	local data = { }
	local flights = getJobColumnData ( getAccountName ( getPlayerAccount ( source ) ), getDatabaseColumnTypeFromJob ( "pilot" ) )
	data.flights = flights or 0
	data.nextRank = "None"
	data.requiredFlights = 0
	data.rank = getElementData ( source, "Job Rank" ) or jobRanks [ 'pilot'] [ 0 ];

	local rankTable = { }
	local isNext = false;
	for i, v in pairs ( foreachinorder ( jobRanks [ 'pilot'] ) ) do 
		if ( isNext ) then 
			data.nextRank = v[2];
			data.requiredFlights = v[1] - data.flights;
			isNext = false;
			break;
		end 
		
		if ( v[2]:lower() == data.rank:lower() ) then 
			isNext = true;
		end 
	end 
	
	
	triggerClientEvent ( source, "NGJobs->Module->Job->Pilot->onServerSendClientJobInfo", source, data );
	
end )