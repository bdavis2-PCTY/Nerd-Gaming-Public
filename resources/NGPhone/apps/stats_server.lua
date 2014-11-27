addEvent ( "NGPhone:Modules->App:Stats->getServerStatsForClient", true )
addEventHandler ( "NGPhone:Modules->App:Stats->getServerStatsForClient", root, function ( )
	
	local eventInfo = "None"
	local eventinfo_ = exports.NGEvents:getEventInfo ( )
	if ( eventinfo_ ) then
		eventInfo = eventinfo_.name
	end
	
	local data = { }
	data.math = exports.NGPlayerFunctions:getRunningMathEquation ( ) or "None"
	data.event = eventInfo
	
	-- calculate next vip money payout --
	local payout_secs = math.floor ( exports.NGVIP:getVipPayoutTimerDetails ( ) / 1000 )
	local nextPayout = "";
	local payout_hours = 0;
	local payout_mins = 0;
	
	while ( payout_secs > 60 ) do
		payout_secs = payout_secs - 60;
		payout_mins = payout_mins + 1;
	end
	
	while ( payout_mins > 60 ) do
		payout_mins = payout_mins - 60;
		payout_hours = payout_hours + 1;
	end
	
	local nextPayout = payout_hours.."h "..payout_mins.."m "..payout_secs.."s"
	data.nextvipmoneypayout = nextPayout
	
	triggerClientEvent ( source, "NGPhone:Modules->App:Stats->ServerSendClientServerStats", source, data )
	
end )