local locations = { }
local shopBlips = { }
local areBlipsEnabled = false;

addEvent ( "NGModshop:sendClientShopLocations", true );
addEventHandler ( "NGModshop:sendClientShopLocations", root, function ( l )
	locations = l;
end );

addEvent ( "onClientPlayerLogin", true );
addEventHandler ( "onClientPlayerLogin", root, function ( )
	setTimer ( function ( )
		setBlipsEnabled ( exports.NGPhone:getSetting ( "usersetting_display_modshopblips" ) );
	end, 1000, 1 );
end );

addEvent ( "onClientUserSettingChange", true );
addEventHandler ( "onClientUserSettingChange", root, function ( setting, value )
	if ( setting == "usersetting_display_modshopblips" ) then
		if ( value and not areBlipsEnabled ) then
			setBlipsEnabled ( true );
		elseif ( not value and areBlipsEnabled ) then 
			setBlipsEnabled ( false );
		end
	end 
end );

function setBlipsEnabled ( b ) 
	if ( b and not areBlipsEnabled ) then 
		for i, v in pairs ( locations ) do 
			local x, y, z = unpack ( v );
			shopBlips [ i ] = createBlip ( x, y, z, 27, 2, 255, 255, 255, 255, 0, 450 )
		end 
	elseif ( not b and areBlipsEnabled ) then
		for i, v in pairs ( shopBlips ) do 
			destroyElement ( v );
		end 
		
		shopBlips = { }
	end
	areBlipsEnabled = b;
end 