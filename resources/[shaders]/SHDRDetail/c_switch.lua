function handleOnClientSwitchDetail( bOn )
	if bOn then
		enableDetail()
	else
		disableDetail()
	end
end


addEvent ( "onClientUserSettingChange", true )
addEventHandler ( "onClientUserSettingChange", root, function ( n, v )
	if ( n == "usersetting_shader_detail" ) then
		handleOnClientSwitchDetail ( v )
	end
end )
addEvent ( "onClientPlayerLogin", true )
addEventHandler ( "onClientPlayerLogin", root, function ( )
	local v = exports.NGPhone:getSetting ( "usersetting_shader_detail" )
	handleOnClientSwitchDetail ( v )
end )