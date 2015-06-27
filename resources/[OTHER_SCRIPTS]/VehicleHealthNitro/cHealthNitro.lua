local settings = {
	healthAnimation = true,
	nitroAnimation = true,
	borderPadding = 5
}

local _sx, _sy = guiGetScreenSize ( ); 	
local sx, sy = _sx/1280, _sy/960; 


local Draw = { 
	--rectangle = function(x,y,w,h,col)return dxDrawRectangle(sx*x,sy*y,sx*w,sy*h,col)end,
	rectangle = dxDrawRectangle,
	--image = function (x,y,w,h,img) return dxDrawImage(sx*x,sy*y,sx*w,sy*h,img) end
	image = dxDrawImage
}

local Values = { 
	health = 0,
	nitro = 0
}

addEventHandler ( "onClientPreRender", root, function ( ) 
	if ( localPlayer:isInVehicle() and localPlayer.vehicle and not localPlayer.dead ) then
		--[[Draw.rectangle ( 1165, 55, 30, 100, tocolor ( 0, 0, 0 ) );
		Draw.rectangle ( 1170, (60+90)- Values.health*0.9, 20, Values.health*0.9, tocolor ( 255, 0, 0 ) );
		Draw.rectangle ( 1215, 55, 30, 100, tocolor ( 0, 0, 0 ) ); 
		Draw.rectangle ( 1220, (60+90)- Values.nitro*0.9, 20, Values.nitro*0.9, tocolor ( 0, 120, 255 ) );]]
		
		Draw.image ( _sx-170, 45, 146, 27, "hp_back.png" );
		Draw.rectangle ( _sx-135, 48, Values.health*1.05, 22, tocolor ( 0, 200, 0 ) );
		
		Draw.image ( _sx-170, 80, 146, 27, "nitro_back.png" );
		Draw.rectangle ( _sx-135, 83, Values.nitro*1.05, 22, tocolor ( 0, 120, 255 ) );
		
		local veh = localPlayer.vehicle;
		local health = math.floor ( veh.health / 10 );
		if ( health ~= Values.health ) then 
			if ( health > Values.health ) then 
				Values.health = Values.health + 1; 
			else 
				Values.health = Values.health - 1;
			end
		end
		
		--local nitro = ( getVehicleNitroLevel ( veh ) or 0 ) * 100;
		local nitro = tonumber ( getElementData ( veh, "_____nos" ) ) or 0
		if ( nitro ~= Values.nitro ) then 
			if ( nitro > Values.nitro ) then 
				Values.nitro = Values.nitro + 1; 
				if ( nitro < Values.nitro ) then 
					Values.nitro = nitro;
				end
			else 
				Values.nitro = Values.nitro - 1;
				if ( ntiro > Values.nitro ) then 
					Values.nitro = nitro;
				end
			end
		end
	else 
		Values.health = 0;
		Values.nitro = 0;
	end
end );

addEventHandler ( "onClientResourceStart", root, function ( )
	exports.scoreboard:scoreboardSetSortBy ( "Rank", false );
end );