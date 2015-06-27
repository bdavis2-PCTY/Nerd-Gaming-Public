-- Setting Change Event:
-- onClientUserSettingChange


local defaultSettings = {
    { "notes", "This is your note page." },
    { "usersettings_usecustomradio", "false" },
    { "usersettings_usecustomhud", "false" },
    { "usersettings_usecustomvehiclenames", "false" },
    { "usersettings_showspeedgraph", "false" },
    { "usersettings_showspeedmeter", "true" },
    { "usersettings_usetopbar", "true" },
    { "usersetting_display_createfuelblips", "true" },
    { "usersetting_display_createpnsblips", "true" },
    { "usersetting_display_createammunationblips", "true" },
    { "usersetting_notification_joinquitmessages", "true" },
    { "usersetting_shader_bloom", "false" },
    { "usersetting_shader_skybox", "true" },
    { "usersetting_shader_water", "true" },
    { "usersetting_shader_wetroad", "false" },
    { "usersetting_shader_contrast", "false" },
    { "usersetting_shader_vehiclereflections", "false" },
    { "usersetting_notification_nickchangemessages", "true" },
    { "usersettings_showmoneylogs", "false" },
    { "usersetting_shader_roadshine", "true" },
    { "usersetting_shader_detail", "false" },
    { "usersetting_display_clubblips", "true" },
    { "usersetting_display_skinshopblips", "true" },
    { "usersetting_display_hospitalblips", "true" },
    { "usersetting_display_vehicleshopblips", "true" },
    { "usersetting_display_modshopblips", "true" },
	{ "user_waypoints", toJSON ( { } ) },
	{ "usersetting_misc_playsoundonguiclick", "true" },
	{ "usersettings_display_clouds", "false" },
	{ "usersetting_display_usershopblips", "true" },
	{ "usersetting_display_vipchat", "true" },
    { "usersettings_display_clienttoserverstats", "true"},
    { "usersettings_display_lowfpswarning", "true" },
    { "usersetting_display_gymblips", "true" },
    { "usersetting_display_usedvehicleshopblips", "true" },
}

function doesSettingExist ( name )
    local e = false
    for i, v in pairs ( defaultSettings ) do
        if ( tostring ( v [ 1 ] ):lower ( ) == tostring ( name ):lower ( ) ) then
            e = v [ 2 ]
            break
        end
    end
    return e
end

function createClientSettingsFile ( doReturn, replace ) 
    if ( fileExists ( "@xml/settings.xml" ) ) then
        if ( replace ) then
            fileDelete ( "@xml/settings.xml" )
        else
            if ( doreturn ) then
                return xmlLoadFile ( "@xml/settings.xml" )
            else
                return nil
            end
        end
    end
    local file = xmlCreateFile ( "@xml/settings.xml", "settings" )
    for i, v in ipairs ( defaultSettings ) do 
        local child = xmlCreateChild ( file, tostring ( v [ 1 ] ) )
        xmlNodeSetAttribute ( child, "value", tostring ( v [ 2 ] ) )
    end
    xmlSaveFile ( file )
    if ( doReturn ) then
        return file
    else
        xmlUnloadFile ( file )
        return true
    end
end

if ( not fileExists ( "@xml/settings.xml" ) ) then
    createClientSettingsFile ( false, false )
end

function getSetting ( name )
    local file = xmlLoadFile ( "@xml/settings.xml" ) or createClientSettingsFile ( true, false )
    local rV = false
    local name = string.lower ( tostring ( name ) )
    for i, v in ipairs ( xmlNodeGetChildren ( file ) ) do 
        if ( tostring ( xmlNodeGetName ( v ) ):lower() == name ) then
            rV = tostring ( xmlNodeGetAttribute ( v, "value" ) )
            break
        end
    end
    if rV == false then
        for i, v in pairs ( defaultSettings ) do
            if ( tostring ( v [ 1 ] ):lower ( ) == tostring ( name ):lower ( ) ) then
                local c = xmlCreateChild ( file, name )
                xmlNodeSetAttribute ( c, "value", v [ 2 ] ) 
                xmlSaveFile ( file )
                rV = v [ 2 ]
            end
        end
    end
    
	local rV = tostring ( rV );
    if ( rV:lower ( ) == "true" ) then
        rV = true
    elseif ( rV:lower( ) == "false" ) then
        rV = false
    end
    
    xmlUnloadFile ( file )
    return rV
end

function updateSetting ( name, value )
    local file = xmlLoadFile ( "@xml/settings.xml" ) or createClientSettingsFile ( true, false )
    local done = false
    local children =  xmlNodeGetChildren ( file )
    local name = tostring ( name ):lower ( )
    local oldValue = getSetting ( name )
    if not children then
        xmlUnloadFile ( file )
        fileDelete ( "@xml/settings.xml" )
        file = createClientSettingsFile ( true, false )
        children = xmlNodeGetChildren ( file )
    end
    
    local done = false
    for i, v in ipairs ( children ) do 
        local nName = tostring ( xmlNodeGetName ( v ) )
        if ( nName == tostring ( name ) ) then
            --xmlDestroyNode ( v )
            xmlNodeSetAttribute ( v, "value", value )
            done = true
            break
        end
    end
    
    if not done then
        local child = xmlCreateChild ( file, tostring ( name ) )
        xmlNodeSetAttribute ( child, "value", tostring ( value ) )
    end
	
	local value = tostring ( value ):lower();
	local oldValue = tostring ( oldValue ):lower();
    if ( value == "true" ) then
		value = true
	elseif ( value == "false" ) then
		value = false
	end if ( oldValue == "true" ) then
		oldValue=true
	elseif ( oldValue == "false" ) then
		oldValue = false
	end
	
	local setts = getElementData ( localPlayer, "userSettings" )
	setts [ name ] = value
	setElementData ( localPlayer, "userSettings", setts )

	
    triggerEvent ( "onClientUserSettingChange", localPlayer, tostring ( name ), value, oldValue )
    xmlSaveFile ( file )
    xmlUnloadFile ( file )
end

addEvent ( "onClientUserSettingChange", true )











addEventHandler ( "onClientResourceStart", resourceRoot, function ( )
	setCloudsEnabled ( getSetting ( 'usersettings_display_clouds' ) )
	-- set default settings to data --
	local settings = { }
	for _, i in pairs ( defaultSettings ) do
		local v = getSetting ( i [ 1 ] )
		settings [ i [ 1 ] ] = v
        triggerEvent ( "onClientUserSettingChange", localPlayer, i[1], v )
	end
	setElementData ( localPlayer, "userSettings", settings )
end )


addEventHandler ( "onClientUserSettingChange", root, function ( setting, value )
	if ( setting == "usersettings_display_clouds" ) then
		setCloudsEnabled ( value )
	end
end )