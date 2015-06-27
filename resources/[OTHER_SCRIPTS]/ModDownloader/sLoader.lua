Loader = { }
local mods = { }
local isReady = false;

--[[
Format:
mods['New Mod Name'] = {
	name = "New Mod Name",
	dff = "file_to_dff.dff",
	txd = "file_to_txd.txd",
	replace = vehicle_replace_id,
	dff_hash = MD5_of_dff_file,
	txd_hash = MD5_of_txd_file
}
]]

-- Loader Constructor 
function Loader:Loader ( )
	mods = { }
	if ( not ( File.exists ( "smods.xml" ) ) ) then 
		-- File functions are a lot easier to use than XML functions
		
		-- smods.xml doesnt exist - create new
		local t = File.new ( "smods.xml" );
		local str = [[
<mods>
	<!-- 
	
	This is the mod list file.
	This file is used to get the modded files for the clients
	Add your mod by adding:
	<mod name="Modded Vehicle Name" txd="path to txd file" dff="path to dff file" replace="replace vehicle id" />
	
	name: This is the name of the new vehicle, the name that the clients will see
	txd: This is the load path for the modded vehicles txd file
	dff: This is the load path for the modded vehicles dff file 
	replace: The vehicle replace ID. Find GTA SA vehicle ids @ http://wiki.multitheftauto.com/wiki/Vehicle_IDs 
	
	-->
	
</mods>
]]
		t:write ( str );
		t:close ( );
		t = nil;
		
		outputDebugString ( "smods.xml wasn't detected, but has been created!" );
		
	end 
	
	local metaFiles = { }
	local meta = XML.load ( "meta.xml" );
	
	for i, v in pairs ( meta.children ) do 
		if ( v.name == "file" and v:getAttribute ( "src" ) ) then 
			metaFiles [ v:getAttribute ( "src" ) ] = true;
		end 
	end 
	
	
	-- Load server-side mod list file (smods.xml)
	local xml = XML.load ( "smods.xml" );
	
	-- Check to make sure the XML was successfully loaded, if not delete & retry
	if ( not xml ) then 
		File.delete ( "smods.xml" );
		Loader:Loader ( );
		outputDebugString ( "smods.xml was unable to be loaded. Deleted file, retrying." );
		return;
	end 
	
	-- Loop all the "mod" children 
	local changesMade = false;
	for index, childNode in pairs ( xml.children ) do 
		-- Confirm it's a "mod" child
		if ( childNode.name == "mod" ) then 
			-- Check if it has all the attributes
			local temp = { }
			temp.name = childNode:getAttribute ( "name" );
			temp.txd = childNode:getAttribute ( "txd" );
			temp.dff = childNode:getAttribute ( "dff" );
			temp.replace = childNode:getAttribute ( "replace" );
			if ( temp.name and temp.txd and temp.dff and temp.replace ) then 
				-- confirm txd file exists 
				if ( File.exists ( "mods/" .. temp.txd ) ) then 
					temp.txd = "mods/" .. temp.txd;
					-- confirm dff file exists 
					if ( File.exists ( "mods/" .. temp.dff ) ) then
						temp.dff =  "mods/" .. temp.dff;
						-- confirm replace is an integer, and a valid vehicle model 
						temp.replace = tonumber ( temp.replace );
						if ( temp.replace and math.floor ( temp.replace ) == temp.replace and temp.replace >= 400 and temp.replace <= 611 ) then 
							-- Confirm there's actually a name 
							if ( temp.name:gsub ( " ", "" ) ~= "" ) then 
								-- Confirm name isn't already in use 
								if ( not mods [ temp.name ] ) then
									-- all checks are OK -- Encrypt and add to mod list 
									local tmp = File( temp.txd, true );
									temp.txd_hash = md5 ( tmp:read ( tmp.size ) );
									tmp:close ( );
									
									local tmp = File( temp.dff, true );
									temp.dff_hash = md5 ( tmp:read ( tmp.size ) );
									tmp:close ( );
									
									tmp = nil;
									
									if ( not metaFiles [ temp.txd ] ) then 
										outputDebugString ( temp.txd.. " not found in meta -- adding now" );
										
										local c = meta:createChild ( "file" );
										c:setAttribute ( 'src', temp.txd );
										c:setAttribute ( "download", "false" );
										changesMade = true;
									end 
									
									if ( not metaFiles [ temp.dff ] ) then 
										outputDebugString ( temp.dff.. " not found in meta -- adding now" );
										
										local c = meta:createChild ( "file" );
										c:setAttribute ( 'src', temp.dff );
										c:setAttribute ( "download", "false" );
										changesMade = true;
									end 
									
									
									outputDebugString ( "Successfully loaded mod #"..tostring(index).." - "..tostring ( temp.name ).. "!" );
									
									mods [ temp.name ] = temp;
								else 
									outputDebugString ( "Failed to load #"..tostring(index).." ("..tostring(temp.name)..") - Mod name already used" );
								end
									
							else
								outputDebugString ( "Failed to load #"..tostring(index).." ("..tostring(temp.name)..") - Invalid name" );
							end 
						else 
							outputDebugString ( "Failed to load #"..tostring(index).." ("..tostring(temp.name)..") - replace must be an integer from 400-611" );
						end 
					else
						outputDebugString ( "Failed to load #"..tostring(index).." ("..tostring(temp.name)..") - dff file not found on server" );
					end 
				else 
					outputDebugString ( "Failed to load #"..tostring(index).." ("..tostring(temp.name)..") - txd file not found on server" );
				end 
			else 
				outputDebugString ( "Failed to load #"..tostring(index).." ("..tostring(temp.name)..") - not all attributes found" );
			end 
		end 
	end 
	
	
	xmlSaveFile( meta );
	xmlUnloadFile ( meta );
	
	xmlSaveFile ( xml );
	xmlUnloadFile ( xml );
	
	if ( changesMade ) then 
		outputDebugString ( "CHANGES HAVE BEEN MADE TO META.XML! RESTARTING RESOURCE...", 0, 255, 255, 255 );
		restartResource ( getThisResource ( ) );
		return;
	end 
	
	isReady = true;
	
end 
Loader.Loader ( );

-- Loader:HandleRequest -> Handles request of mod files from client
-- Sends client new mod list
function Loader:HandleRequest ( plr )
	triggerClientEvent ( source, "ModDownloader:OnServerSendClientModList", source, mods );
end 
addEvent ( "ModDownloader:RequestFilesFromServer", true );
addEventHandler ( "ModDownloader:RequestFilesFromServer", root, Loader.HandleRequest );

--addEventHandler ( "onResourceStart", resourceRoot, Loader.Loader );

addEvent ( "ModDownloader:TestServerReadyForClient", true );
addEventHandler ( "ModDownloader:TestServerReadyForClient", root, function ( )
	if ( not isReady ) then return; end -- Make sure we're ready for a connection
	triggerClientEvent ( source, "ModLoader:OnServerReadyAccepts", source );
end );