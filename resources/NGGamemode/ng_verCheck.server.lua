-- Used to check the version of the current GM with the most recently uploaded one
-- Make sure this resource has access to function.callRemote


function NG.SERVER.CHECK_VERSION ( )
	NG.SERVER.NOTIFY ( "Checking for NG Gamemode updates ");
	local called = callRemote("http://community.mtasa.com/mta/resources.php", function(_, version) 
		if ( md5 ( tostring ( version ) ) ~= NG.SERVER.VERSION_HASH ) then 
			if ( NG.MIX.TOBOOL ( get("*notify_ng_updates") ) ) then 
				NG.SERVER.NOTIFY ( "\n\n====================================" );
				NG.SERVER.NOTIFY ( "= NERD-GAMING GAMEMODE IS OUTDATED!" );
				NG.SERVER.NOTIFY ( "====================================" );
				NG.SERVER.NOTIFY ( "= Your version: ".. NG.SERVER.VERSION )
				NG.SERVER.NOTIFY ( "= Current version: ".. version )
				NG.SERVER.NOTIFY ( "= Download: https://github.com/braydondavis/Nerd-Gaming-Public" );
				NG.SERVER.NOTIFY ( "====================================\n\n" ); 
			end
		else 
			NG.SERVER.NOTIFY ( "The NG Gamemode is up-to date! Version: "..tostring ( version ) )
		end 
	end, "version", "ng-gamemode" )
	
	if not called then
		outputDebugString ( "FAILED TO CHECK VERSION UPDATE! PLEASE ALLOW ".. getResourceName(getThisResource()) .." ACCESS TO function.callRemote", 1 );
	end
end

if ( NG.MIX.TOBOOL ( get ( "*check_ng_updates" ) ) ) then 
	NG.SERVER.CHECK_VERSION ( );
	setTimer ( _G['NG'].SERVER.CHECK_VERSION, 60*60*1000, 0 ) -- Every hour
end 
