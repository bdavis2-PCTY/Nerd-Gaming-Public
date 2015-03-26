
--[[
addEventHandler( "onClientResourceStart", getResourceRootElement( getThisResource()),
	function()
		--outputDebugString('/sSkyBox to switch the effect')
		triggerEvent( "switchSkyBox", resourceRoot, true )
		addCommandHandler( "sSkyBox",
			function()
				triggerEvent( "switchSkyBox", resourceRoot, not sbxEffectEnabled )
			end
		)
	end
)]]

-- handle the change
addEvent ( "onClientUserSettingChange", true )
addEventHandler ( "onClientUserSettingChange", root, function ( n, v )
	if ( n == "usersetting_shader_skybox" ) then
		if ( v ~= sbxEffectEnabled ) then
			switchSkyBox ( v )
		end
	end
end )
addEvent ( "onClientPlayerLogin", true )
addEventHandler ( "onClientPlayerLogin", root, function ( )
	local v = exports.NGPhone:getSetting ( "usersetting_shader_skybox" )
	if ( v ~= sbxEffectEnabled ) then
		switchSkyBox ( v )
	end
end )


function switchSkyBox( sbOn )
	if sbOn then
		startShaderResource()
	else
		stopShaderResource()
	end
end

addEvent( "switchSkyBox", true )
addEventHandler( "switchSkyBox", resourceRoot, switchSkyBox )
addEventHandler( "onClientResourceStop", getResourceRootElement( getThisResource()),stopShaderResource)

