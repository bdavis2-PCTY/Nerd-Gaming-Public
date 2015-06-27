Downloader = { }
Downloader.Mods = { }
Downloader.Files = { }
Downloader.isRenderText = false;
Downloader.gotResponse = false;

-- Downloader Constructor
function Downloader:Downloader ( )

end 

-- Downloader:RequestList -> Used to request vehicle mod list from server
function Downloader:RequestList ( )
	triggerServerEvent ( "ModDownloader:RequestFilesFromServer", localPlayer, localPlayer );
end 

-- Downloader:GetList -> Used to get the mods list downloaded from server
function Downloader:GetList ( )
	return Downloader.Mods;
end 

-- Downloader:HandleRequest -> Used to handle response from the server for the mod list
function Downloader.HandleResponse ( list )
	Downloader.gotResponse = true;
	Downloader.Mods = list;
	Mods:PhraseList ( );
end 
addEvent ( "ModDownloader:OnServerSendClientModList", true );
addEventHandler ( "ModDownloader:OnServerSendClientModList", root, Downloader.HandleResponse );




function Downloader:AddDownload ( src )
	if ( Downloader.Files [ src ] ) then 
		return false;
	end 
	
	Downloader.Files [ src ] = true;
	
	if ( not Downloader.isRenderText ) then 
		Downloader.isRenderText = true;
		addEventHandler ( "onClientRender", root, Downloader.onClientRender );
	end 
	
	return downloadFile ( src );
end 

function Downloader:GetDownloads ( )
	return Downloader.Files;
end

function Downloader.onFinish ( file, success )
	if ( Downloader.Files [ file ] ) then 
		Downloader.Files [ file ] = nil;
	end 
	
	if ( success ) then 
		outputDebugString ( file.." has been downloaded!" );
	else 
		outputDebugString ( file .." has failed to download!" );
	end
	
	if ( table.len ( Downloader:GetDownloads ( ) ) == 0 and Downloader.isRenderText ) then 
		Downloader.isRenderText = false;
		removeEventHandler ( "onClientRender", root, Downloader.onClientRender );
	end
end 
addEventHandler ( "onClientFileDownloadComplete", root, Downloader.onFinish );

local sx, sy = guiGetScreenSize ( );
function Downloader.onClientRender ( )
	dxDrawText ( "Downloading "..tostring ( table.len(Downloader:GetDownloads()) ).." files...", 0, 0, sx/1.1+2, sy/1.1+2, tocolor ( 0, 0, 0, 200 ), 2, "default-bold", "right", "bottom" );
	dxDrawText ( "Downloading "..tostring ( table.len(Downloader:GetDownloads()) ).." files...", 0, 0, sx/1.1, sy/1.1, tocolor ( 0, 255, 255, 200 ), 2, "default-bold", "right", "bottom" );
end 