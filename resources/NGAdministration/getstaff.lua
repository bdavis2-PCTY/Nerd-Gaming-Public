function isPlayerStaff ( p )
	if ( p and getElementType ( p ) == 'player' ) then
		if ( isPlayerInACL ( p, "Level 1" ) or isPlayerInACL ( p, "Level 2" ) or isPlayerInACL ( p, "Level 3" ) or isPlayerInACL ( p, "Level 4" ) or isPlayerInACL ( p, "Level 5" ) or isPlayerInACL ( p, "Admin" ) or isPlayerInACL ( p, "Console" ) ) then
			return true
		end
		return false
	end
end

function getPlayerStaffLevel ( p, var )
	if ( isPlayerStaff ( p ) ) then
		local str = nil
		local num = nil
		for i=1,5 do
			if ( isPlayerInACL ( p, 'Level '..tostring ( i ) ) ) then
				num = i
				str = 'Level '..tostring ( i )
				break 
			end
		end
		if ( var == 'string' ) then
			return str
		elseif ( var == 'int' ) then
			return num
		else
			return str, num
		end
		
	end
	return 0,0
end

function getAllStaff ( )
	local staff = { 
		['Level 1'] = { },
		['Level 2'] = { },
		['Level 3'] = { },
		['Level 4'] = { },
		['Level 5'] = { },
	}
	
	for i=1,5 do
		for k, v in ipairs ( aclGroupListObjects ( aclGetGroup ( "Level "..tostring ( i ) ) ) ) do
			if ( string.find ( tostring ( v ), 'user.' ) ) then
				local name = tostring ( v:gsub ( "user.", "" ) )
				staff['Level '..tostring ( i )][#staff['Level '..tostring ( i )]+1] = name
			end
		end
	end
	
	return staff
end

function isPlayerInACL ( player, acl )
	local account = getPlayerAccount ( player )
	if ( isGuestAccount ( account ) ) then
		return false
	end
	if ( aclGetGroup ( acl ) ) then
		return isObjectInACLGroup ( "user."..getAccountName ( account ), aclGetGroup ( acl ) )
	end 
	
	return false;
end

function getOnlineStaff ( )
	local online = { }
	for i, v in ipairs ( getElementsByType ( "player" ) ) do
		if ( isPlayerStaff ( v ) ) then
			table.insert ( online, v )
		end
	end
	return online
end


-- NG 1.1.4 --
-- Set element data to make getting staff on client side --
function setNewPlayerStaffData ( p )
	if ( isPlayerStaff ( p ) ) then 
		setElementData ( p, "staffLevel", getPlayerStaffLevel ( p, 'int' ) )
	else 
		setElementData ( p, 'staffLevel', 0 );
	end 
end

addEventHandler ( "onPlayerLogin", root, function ( )
	setNewPlayerStaffData ( source )
end );

addEventHandler ( "onResourceStart", resourceRoot, function ( )
	for _, p in pairs ( getElementsByType ( "player" ) ) do 
		setNewPlayerStaffData ( p );
	end 
end );
