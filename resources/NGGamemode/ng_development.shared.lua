NG.DEVELOPERS = {

	['xXMADEXx'] = true

}

NG.IS_IN_DEVELOPMENT = false; 

local isClient = ( _G['triggerServerEvent'] ~= nil );

if ( isClient ) then 

	function isDeveloper ( )
		local acc = getElementData ( localPlayer, "AccountData:Username" );
		return NG.IS_IN_DEVELOPMENT and NG.DEVELOPERS [ acc ] 
	end 

else 

	function isDeveloper ( p )
		local acc = getElementData ( p, "AccountData:Username" );
		return NG.IS_IN_DEVELOPMENT and NG.DEVELOPERS [ acc ] 
	end 
	
	
	----------------------------------
	-- Development warp cmds 		--
	----------------------------------
	local dev_x, dev_y, dev_z = nil, nil, nil
	local dev_int, dev_dim = nil, nil
	
	addCommandHandler ( "devsetpos", function ( p )
		if ( isDeveloper ( p ) ) then 
			dev_x, dev_y, dev_z = getElementPosition ( p )
			dev_int, dev_dim = getElementInterior ( p ), getElementDimension ( p )
			
			outputChatBox ( "Coordinates, interior and dimension saved. Use /devgopos to warp back", p, 0, 255, 0 );
		end 
	end );
	
	addCommandHandler ( "devgopos", function ( p )
		if ( isDeveloper ( p ) ) then 
			
			if ( dev_x and dev_y and dev_z ) then 
				outputChatBox ( "Travelling to "..table.concat({dev_x,dev_y,dev_z},", "), p, 0, 255, 0 );
				setElementPosition  ( p, dev_x, dev_y, dev_z + 2 );
				
				if ( dev_int ) then 
					p.interior = dev_int 
				else 
					outputChatBox ( "Old interior not saved, restoring to 0", p, 255, 0, 0 );
					p.interior = 0;
				end 
				
				if ( dev_dim ) then 
					p.dimension = dev_dim
				else 
					outputChatBox ( "Old dimension not saved, restoring to 0", p, 255, 0, 0 );
					p.dimension = 0;
				end
			else 
				outputChatBox ( "No coordinates are saved....", p, 255, 0, 0 );
			end 
			
		end 
	end );
	
end 


function isGameInDevelopment ( ) 
	return NG.IS_IN_DEVELOPMENT
end 
