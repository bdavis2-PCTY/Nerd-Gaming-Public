addEvent ( "onClientUserSettingChange", true )
addEventHandler ( "onClientUserSettingChange", root, function ( n, v )
	if ( n == "usersetting_shader_contrast" ) then
		if ( v ~= bEffectEnabled ) then
			switchContrast ( v )
		end
	end
end )
addEvent ( "onClientPlayerLogin", true )
addEventHandler ( "onClientPlayerLogin", root, function ( )
	local v = exports.NGPhone:getSetting ( "usersetting_shader_contrast" )
	if ( v ~= bEffectEnabled ) then
		switchContrast ( v )
	end
end )

function switchContrast( bOn )
	if bOn then
		enableContrast()
	else
		disableContrast()
	end
end