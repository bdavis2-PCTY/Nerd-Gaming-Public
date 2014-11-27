function appFunctions.stats:onPanelLoad ( resetLabelsBeforeTrigger )
	
	if ( resetLabelsBeforeTrigger == nil ) then
		resetLabelsBeforeTrigger = true
	end

	-- user info
	guiSetText ( pages['stats']['user_account'], tostring ( getElementData ( localPlayer, "AccountData:Username" ) ) )
	guiSetText ( pages['stats']['user_serial'], tostring ( getElementData ( localPlayer, "AccountData:Serial" ) ) )
	guiSetText ( pages['stats']['user_ip'], tostring ( getElementData ( localPlayer, "AccountData:IP" ) ) )
	guiSetText ( pages['stats']['user_kills'], tostring ( getElementData ( localPlayer, "NGSQL:Kills" ) or 0 ) )
	guiSetText ( pages['stats']['user_deaths'], tostring ( getElementData ( localPlayer, "NGSQL:Deaths" ) or 0 ) )
	-- weapons
	local data = getElementData ( localPlayer, "NGSQL:WeaponStats" )
	for i, v in pairs ( pages['stats'] ) do
		if ( string.sub ( i, 1, 7 ) == "weapon_" ) then
			local class = string.sub ( i, 8, string.len ( i ) )
			if ( data [ class ] ) then
				guiSetText ( v, tostring ( data [ class ] ).."/100" )
			end
		end
	end
	-- VIP
	local vip = tostring ( getElementData ( localPlayer, "VIP" ) or "None" );
	guiSetText ( pages['stats']['vip_vip'], vip );
	if ( vip:lower() == "none" ) then
		guiSetText ( pages['stats']['vip_expDate'], "N/A" );
	else
		guiSetText ( pages['stats']['vip_expDate'], tostring ( getElementData ( localPlayer, "NGVIP.expDate" ) ) );
	end
	-- Server
	if ( resetLabelsBeforeTrigger ) then
		guiSetText ( pages['stats']['server_mathEquation'], "Loading..." )
		guiSetText ( pages['stats']['server_currentEvent'], "Loading..." )
		guiSetText ( pages['stats']['server_netvippayout'], "Loading..." )
	end
	triggerServerEvent ( "NGPhone:Modules->App:Stats->getServerStatsForClient", localPlayer )
	
	
	-- Refresh Timer
	if ( isTimer ( app_stats_refreshTimer ) ) then killTimer ( app_stats_refreshTimer ); end
	if ( guiGetVisible ( base ) and LoadedPage == "stats" ) then
		app_stats_refreshTimer = setTimer ( function ( )
			appFunctions.stats:onPanelLoad ( false )
		end, 2000, 1 )
	end
end 

addEvent ( "NGPhone:Modules->App:Stats->ServerSendClientServerStats", true )
addEventHandler ( "NGPhone:Modules->App:Stats->ServerSendClientServerStats", root, function ( data )
	guiSetText ( pages['stats']['server_mathEquation'], data.math )
	guiSetText ( pages['stats']['server_currentEvent'], data.event )
	guiSetText ( pages['stats']['server_netvippayout'], data.nextvipmoneypayout )
end )