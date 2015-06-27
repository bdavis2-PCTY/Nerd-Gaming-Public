-- Don't store txd and dff files in the XML - Prevent hackers from changing file names


Mods = { };
Mods.FromXML = { };

-- Mods Constructor
function Mods:Mods ( )
	Mods:PhraseXML ( );
	
	if ( isTimer ( checkServerTimer ) ) then 
		killTimer ( checkServerTimer );
	end 
	
	setTimer ( function ( )	-- Did the server have time to load the list??
		Downloader:RequestList ( ); -- Get list from server
	end, 500, 1 );
end 

function Mods:PhraseXML ( )
	-- Create the user cmods.xml for saving of enabled/disabled
	
	-- Create if it doesn't exist
	if ( not File.exists ( "cmods.xml" ) ) then 
		local t = File.new ( "cmods.xml" );
		t:write ( "<mods></mods>" );
		t:close ( );
	end 
	
	-- Attempt to load XML file
	local xml = XML.load ( "cmods.xml" );
	
	-- if XML failed to load, delete it and try again 
	if ( not xml ) then 
		File.delete ( "cmods.xml" );
		Mods:Mods ( );
		return
	end 
	
	-- If it exists, loop the children and collect info 
	for index, child in pairs ( xml.children ) do 
		-- Is it a mod child?
		if ( child.name == "mod" ) then 
			
			local name = child:getAttribute ( "name" );
			local enabled = child:getAttribute ( "enabled" );
			-- Do all of our attributes exist?
			if ( name and enabled ) then 
				-- Was this already loaded?
				if ( not Mods.FromXML [ name ] ) then 
					Mods.FromXML [ name ] = ( tostring ( enabled ):lower ( ) == "true" );
				else 
					child:destroy ( );
				end 
			else 
				child:destroy ( );
			end
		end 
	end
	
	-- Save and unload xml file
	xmlSaveFile ( xml );
	xmlUnloadFile ( xml );
end 

function Mods.SaveXML ( )
	if ( File.exists ( "cmods.xml" ) ) then 
		File.delete ( "cmods.xml" );
	end 
	
	local str= "<mods>\n	<!-- It's suggested to not edit this file -->\n %s \n</mods>";
	local _str = "";
	for i, v in pairs ( Downloader.Mods ) do 
		_str = _str .. "\n" .. string.format ( '<mod name="%s" enabled="%s" />', i, tostring ( v.enabled ) );
	end 
	
	local f = File.new ( "cmods.xml" );
	f:write ( str:format ( _str ) );
	f:close ( );
	
end 
setTimer ( Mods.SaveXML, 5000000, 0 );
addEventHandler ( "onClientResourceStop", resourceRoot, Mods.SaveXML );


-- Mods:PhraseList -> Used to check mods list for enabled mods
function Mods:PhraseList ( )
	--Downloader.Mods = { }
	-- Loop through the list and find completed downloaded files
	for name, mod in pairs ( Downloader.Mods ) do 
		local txd = mod.txd;
		local dff = mod.dff;
		local replace = mod.replace;
		
		Downloader.Mods [ name ].enabled = false;
		
		-- Check if the txd file is downloaded
		local bothExist = false;
		if ( File.exists ( tostring ( txd ) ) ) then 
			-- if so, load it
			local temp = File( txd, true );
			-- is it out-dated?
			
			doDelete = ( tostring ( md5 ( temp:read ( temp.size ) ) ):lower ( ) ~= tostring ( mod.txd_hash ):lower( ) );
			temp:close ( );
			-- if outdated, then delete
			if ( doDelete ) then 
				File.delete ( txd );
				outputDebugString ( txd.." was deleted - hash doesn't match with server" );
				bothExist = false;
			else
				outputDebugString ( txd.." has been successfully listed" );
				bothExist = true;
			end 
		else 
			outputDebugString ( tostring ( txd ).. " not present - beginning download" );
			Downloader:AddDownload ( tostring ( txd ) );
		end 
		

		-- Check if the dff file is downloaded
		if ( File.exists ( tostring ( dff ) ) ) then 

			-- if so, load it
			local temp = File( dff, true );
			-- is it out-dated?
			doDelete = (  md5 ( temp:read ( temp.size ) ):lower() ~= mod.dff_hash:lower() );
			temp:close ( );
			-- if outdated, then delete
			if ( doDelete ) then 
				File.delete ( dff );
				outputDebugString ( dff.." was deleted - hash doesn't match with server" );
				bothExist = false;
			else 
				outputDebugString ( dff.." has been successfully listed" );
				if ( bothExist ) then 
					bothExist = true;
				end 
			end 
		else 
			outputDebugString ( tostring ( dff ).. " not present - beginning download" );
			Downloader:AddDownload ( tostring ( dff ) );
		end 
		
		if ( bothExist  ) then 
			--outputDebugString ( name.." - both files loaded. Enabled: "..tostring ( Mods.FromXML [ name ] ) );
			if ( Mods.FromXML [ name ] ) then 
				Mods.SetModEnabled ( name, true );
			end 
		end 
		
	end 
end 


function Mods.SetModEnabled ( mod, enabled )
	if ( not Downloader.Mods [ mod ] ) then 
		return outputDebugString ( string.format ( "Attempted to enable mod '%s' - doesn't exist in Downloader.Mods", mod ), 255, 0,  0 );
	end 
	
	if ( 
		( enabled and Downloader.Mods [ mod ].enabled ) or 
		( not enabled and not Downloader.Mods [ mod ].enabled ) 
	) then 
		-- check current state
		return false; -- cancel if is already current state 
	end 
	
	Downloader.Mods [ mod ].enabled = enabled;
	
	if ( enabled ) then 
		if ( 
			File.exists ( Downloader.Mods [ mod ].dff ) and 
			File.exists ( Downloader.Mods [ mod ].txd ) 
		) then 
		
			local txd = engineLoadTXD ( Downloader.Mods [ mod ].txd )
			engineImportTXD ( txd, Downloader.Mods [ mod ].replace )
			local dff = engineLoadDFF ( Downloader.Mods [ mod ].dff, 0 )
			engineReplaceModel ( dff, Downloader.Mods [ mod ].replace )
		
		end 
	else 
		engineRestoreModel ( Downloader.Mods [ mod ].replace );
	end 
	
end 



--addEventHandler ( "onClientResourceStart", resourceRoot, Mods.Mods );
addEvent ( "ModLoader:OnServerReadyAccepts", true );
addEventHandler ( "ModLoader:OnServerReadyAccepts", root, Mods.Mods );

checkServerTimer = setTimer ( function ( )
	outputDebugString ( "Sending server request" );
	triggerServerEvent ( "ModDownloader:TestServerReadyForClient", localPlayer );
end, 2000, 0 )