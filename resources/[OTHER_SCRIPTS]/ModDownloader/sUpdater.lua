Updater = { }

function Updater.Notify ( msg )
	outputDebugString ( msg );
end 

function Updater.Check  ( )
	Updater.Notify ( "Checking for Mod Downloader updates ");
	local called = callRemote("http://community.mtasa.com/mta/resources.php", function(_, version) 
		if ( md5 ( tostring ( version ) ) ~= md5 ( getResourceInfo ( getThisResource(), "version" ) ) ) then 
			Updater.Notify ( "====================================" );
			Updater.Notify ( "= ModDownloader version doesn't match community" );
			Updater.Notify ( "====================================" );
			Updater.Notify ( "= Your version: ".. getResourceInfo ( getThisResource(), "version" ) )
			Updater.Notify ( "= Current version: ".. version )
			Updater.Notify ( "= View http://forum.mtasa.com/viewtopic.php?f=108&t=86587" );
			Updater.Notify ( "====================================" ); 
		end 
	end, "version", "moddownloader" )
	
	if not called then
		outputDebugString ( "FAILED TO CHECK VERSION UPDATE! PLEASE ALLOW ".. getResourceName(getThisResource()) .." ACCESS TO function.callRemote", 1 );
	end
end

Updater.Check ( );
setTimer ( Updater.Check, 1000000, 0 );