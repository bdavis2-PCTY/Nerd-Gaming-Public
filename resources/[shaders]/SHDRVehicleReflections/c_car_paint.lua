	function doTheShaderStuff( )
		if getVersion ().sortable < "1.1.0" then
			return
		end
		myShader, tec = dxCreateShader ( "car_paint.fx" )
		if myShader then
			textureVol = dxCreateTexture ( "images/smallnoise3d.dds" );
			textureCube = dxCreateTexture ( "images/cube_env256.dds" );
			dxSetShaderValue ( myShader, "sRandomTexture", textureVol );
			dxSetShaderValue ( myShader, "sReflectionTexture", textureCube );
			engineApplyShaderToWorldTexture ( myShader, "vehiclegrunge256" )
			engineApplyShaderToWorldTexture ( myShader, "?emap*" )
		end
	end


local enabled = false
function setShaderEnabled ( b )
	if not b and enabled then
		enabled = false
		engineRemoveShaderFromWorldTexture ( myShader, "vehiclegrunge256" )
		engineRemoveShaderFromWorldTexture ( myShader, "?emap" )
		destroyElement ( myShader )
		destroyElement ( textureVol )
		destroyElement ( textureCube )
	else
		doTheShaderStuff ( )
		enabled = true
	end
end

-- load user settings
addEvent ( "onClientUserSettingChange", true )
addEventHandler ( "onClientUserSettingChange", root, function ( n, v ) 
	if ( n == "usersetting_shader_vehiclereflections" ) then
		if ( enabled and not v ) then 
			setShaderEnabled ( false )
		elseif ( not enabled and v ) then 
			setShaderEnabled ( true )
		end 
	end
end )

addEvent ( "onClientPlayerLogin", true )
addEventHandler ( "onClientPlayerLogin", root, function ( )
	if ( exports.NGPhone:getSetting ( "usersetting_shader_vehiclereflections" ) ) then
		setShaderEnabled ( true )
	end
end )
