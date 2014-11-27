function appFunctions.settings:onSettingsLoad ( )
	exports.NGMessages:sendClientMessage ( "Loading user settings...", 0, 255, 0 )
	for i, v in pairs ( pages['settings'] ) do
		if ( doesSettingExist ( i ) ) then
			guiCheckBoxSetSelected ( v, getSetting ( i ) )
		end
	end
end


function onSettingButtonClick( )
	if ( source == pages['settings']['background_download_btn'] ) then
		local url = guiGetText ( pages['settings']['background_download_url'] )
		local form = string.sub ( url, string.len(url)-3, string.len(url) ):lower();
		
		if ( string.sub ( url, 1, 7 ):lower() ~= "http://" and string.sub ( url, 1, 8 ):lower() ~= "https://" ) then
			return exports.NGMessages:sendClientMessage ( "Invalid url", 255, 0, 0 )
		end
		
		if ( form ~= ".png" and form ~= ".jpg" ) then
			return exports.NGMessages:sendClientMessage ( "The file format MUST be .png or .jpg format", 255, 0, 0 )
		end
		exports.NGMessages:sendClientMessage ( "We're going to try to download that image... Please wait....", 255, 255, 0 )
		triggerServerEvent ( "NGPhone:Modules->Apps:Settings->DownloadUserImage", localPlayer, url )
		guiSetEnabled ( pages['settings']['background_download_btn'], false )
		
	elseif ( source == pages['settings']['background_download_del'] ) then
		if ( fileExists ( "custombg.png" ) ) then
			fileDelete ( "custombg.png" )
		end if ( fileExists ( "custombg.jpg" ) ) then
			fileDelete ( "custombg.jpg" )
		end
		
		exports.NGMessages:sendClientMessage ( "File removed. Reconnect to restore the background", 255, 255, 0 )
		guiSetEnabled ( source, false )
	end
end
--addEventHandler ( "onClientGUIClick", pages['settings']['background_download_btn'], onSettingButtonClick )
--addEventHandler ( "onClientGUIClick", pages['settings']['background_download_del'], onSettingButtonClick )

addEvent ( "NGPhone:Modules->Apps:Settings->SendClientNewBackground", true )
addEventHandler ( "NGPhone:Modules->Apps:Settings->SendClientNewBackground", root, function ( data, url )
	if ( fileExists ( "custombg.png" ) ) then
		fileDelete ( "custombg.png" )
	end
	
	local f = fileCreate ( "custombg.png" )
	fileWrite ( f, data )
	fileClose ( f )
	
	exports.NGMessages:sendClientMessage ( "The file has been downloaded. To enable it, please reconnect.", 0, 255, 0 )
	guiSetEnabled ( pages['settings']['background_download_btn'], true )
end )