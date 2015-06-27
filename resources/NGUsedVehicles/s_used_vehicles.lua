local usedVehicles = { }

function addVehicleFromId ( id, price, description )
	
	local query = exports.ngsql:db_query ( "SELECT * FROM vehicles WHERE VehicleID=?", id );
	
	if ( query and query [ 1 ] and price and description ) then 
		local query = query [ 1 ];
		if ( query.Visible == 0 and query.Impounded == 0 ) then 
			
			exports.ngsql:db_exec ( "DELETE FROM vehicles WHERE VehicleID=?", id );
			exports.ngsql:db_exec ( "INSERT INTO used_vehicles ( seller, veh_id, uniq_id, color, upgrades, handling, price, description ) VALUES ( ?, ?, ?, ?, ?, ?, ?, ? )",
				query.Owner, query.ID, query.VehicleID, query.Color, query.Upgrades, query.Handling, price, description );
			
			local temp = { }
			temp.seller = tostring ( query.Owner );
			temp.vehicle_id = tonumber ( query.ID );
			temp.unique_id = tonumber ( query.VehicleID );
			temp.upgrades = fromJSON ( query.Upgrades );
			temp.handling = fromJSON ( query.Handling );
			temp.price = tonumber ( price );
			temp.desc = tostring ( description );
			
			local color = fromJSON ( query.Color )
			local color = split ( color, ', ' )
			temp.color = { r=tonumber(color[1]), g=tonumber(color[2]), b=tonumber(color[3]) }
			
			usedVehicles[temp.unique_id] = temp;
			
			return true;
			
		end 
	end 
	
	return false;
	
end 

function getList ( ) 
	return usedVehicles;
end 

addEventHandler ( "onResourceStart", resourceRoot, function ( )
	exports.ngsql:db_exec ( "CREATE TABLE IF NOT EXISTS used_vehicles ( seller TEXT, veh_id INT, uniq_id INT, color TEXT, upgrades TEXT, handling TEXT, price INT, description TEXT )" );
	
	local query = exports.ngsql:db_query ( "SELECT * FROM used_vehicles" );
	
	if ( query and type ( query ) == "table" ) then
		for _, col in pairs ( query ) do 
			local temp = { }
			temp.seller = tostring ( col.seller );
			temp.vehicle_id = tonumber ( col.veh_id );
			temp.unique_id = tonumber ( col.uniq_id );
			temp.upgrades = fromJSON ( col.upgrades );
			temp.handling = fromJSON ( col.handling );
			temp.price = tonumber ( col.price );
			temp.desc = tostring ( col.description );

			local color = fromJSON ( col.color )
			local color = split ( color, ', ' )
			temp.color = { r=tonumber(color[1]), g=tonumber(color[2]), b=tonumber(color[3]) }
			
			usedVehicles[temp.unique_id] = temp;
		end 
	else 
		usedVehicles = { }
	end
	
end );


function setVehicleOwner ( id, account )
	if ( not id or not usedVehicles [ id ] or not account ) then 
		return false;
	end 
	
	local d = usedVehicles [ id ];
	
	local owner = account; 
	local vehicle_id = id; 
	local id = d.vehicle_id;
	local color = toJSON ( table.concat({d.color.r,d.color.g,d.color.b},", " ) );
	local upgrades = toJSON ( d.upgrades );
	local position = toJSON ( { } );
	local rotation = toJSON ( { 0, 0, 0 } );
	local health = "1000"
	local visible = 0;
	local fuel = 100;
	local impounded = 0;
	local handling = toJSON ( d.handling );
	
	local at = "Los Santos";
	
	local t = getVehicleType ( id ):lower();
	if ( t == "plane" or t == "helicopter" ) then 
		position = toJSON ( table.concat ( { 1949.38, -2400.59, 14.5 }, ", " ) );
		rotation = toJSON ( table.concat ( { 0, 0, 180 }, ", " ) );
		at = "Los Santos Airport"
	elseif ( t == "boat" ) then 
		position = toJSON ( table.concat ( { 626, -1942.6, 1.5 }, ", " ) );
		rotation = toJSON ( table.concat ( { 0, 0, 180 }, ", " ) );
		at = "Los Santos Beach"
	else 
		position = toJSON ( table.concat ( { 2276.05, -2329.12, 14.5 }, ", " ) );
		rotation = toJSON ( table.concat ( { 0, 0, 311.5 }, ", " ) );
		at = "Los Santos Recovery Point"
	end
	
	
	exports.ngsql:db_exec ( "INSERT INTO vehicles ( Owner, VehicleID, ID, Color, Upgrades, Position, Rotation, Health, Visible, Fuel, Impounded, Handling ) VALUES ( ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ? )",
		owner, vehicle_id, id, color, upgrades, position, rotation, health, visible, fuel, impounded, handling );
	
	exports.ngsql:db_exec ( "DELETE FROM used_vehicles WHERE uniq_id=?", vehicle_id );
	
	usedVehicles [ vehicle_id ] = nil 
	
	return at;
end 


addEvent( "NGShops->UsedVehicles->onPlayerTryBuyVehicle", true );
addEventHandler ( "NGShops->UsedVehicles->onPlayerTryBuyVehicle", root, function ( id )
	if ( not usedVehicles [ id ] ) then 
		return exports.ngmessages:sendClientMessage ( "This vehicle is no longer available!", source, 200, 100, 130 );
	end 
	
	local data = usedVehicles [ id ];
	local acc = getPlayerAccount ( source );
	
	if ( getPlayerMoney ( source ) < data.price ) then 
		return exports.ngmessages:sendClientMessage ( "You don't have enough money for this vehicle", source, 200, 100, 130 );
	end 
	
	if ( isGuestAccount ( acc ) ) then 
		return exports.ngmessages:sendClientMessage ( "You need to be logged in to buy a vehicle", source, 200, 100, 130 );
	end 
	
	takePlayerMoney ( source, data.price );
	exports.ngmessages:sendClientMessage ( "You have purchased this "..getVehicleNameFromModel(data.vehicle_id).." for $"..data.price.."!", source, 0, 255, 0 );
	
	local loc = setVehicleOwner ( id, getAccountName ( acc ) );
	exports.ngmessages:sendClientMessage ( "Your vehicle will be available at "..tostring ( loc ), source, 0, 255, 0 );
	
	local foundPlayer = false;
	for _, p in pairs ( getElementsByType ( "player" ) ) do 
		if ( getAccountName ( getPlayerAccount ( p ) ) == data.seller ) then 
			givePlayerMoney ( p, data.price );
			exports.ngmessages:sendClientMessage ( getPlayerName ( source ).." bought your "..getVehicleNameFromModel(data.vehicle_id).." for $"..data.price.."!", p, 0, 255, 0 );
			foundPlayer = true;
			break;
		end 
	end

	if ( not foundPlayer ) then 
		local q = exports.ngsql:db_query ( "SELECT Money FROM accountdata WHERE Username=?", data.seller );
		if ( q and q[1] and q[1].Money ) then 
			local m = tonumber ( q[1].Money ) + data.price
			exports.ngsql:db_exec ( "UPDATE accountdata SET Money=? WHERE Username=?", m, data.seller );
		end 
	end 
	
	setClientWindowOpen ( source, false );
	
end );




addEvent ( "NGShops->UsedVehicles->onClientRequestUsedList", true )
addEventHandler ( "NGShops->UsedVehicles->onClientRequestUsedList", root, function ( )
	triggerClientEvent ( source, "NGShops->UsedVehicles->onServerSendClientList", source, getList ( ), exports.ngvehicles:getAllAccountVehicles ( getAccountName ( getPlayerAccount ( source ) ) ) );
end );

addEvent ( "NGUsedVehicles->SellVehicle->OnPlayerTrySellVehicle", true )
addEventHandler ( "NGUsedVehicles->SellVehicle->OnPlayerTrySellVehicle", root, function ( id, price, description )
	if ( id and price and description ) then 
		if ( addVehicleFromId ( id, price, description ) ) then
			exports.ngmessages:sendClientMessage ( "Your vehicle is now on the market for $"..price, source, 255, 255, 0 );
			refreshClientWindow ( source );
		else
			exports.ngmessages:sendClientMessage ( "Failed to add this vehicle to the market, something went wrong!", source, 255, 0, 0 );	
		end
	end 
end );


function refreshClientWindow ( player )
	setClientWindowOpen ( player, false );
	setClientWindowOpen ( player, true );
end

function setClientWindowOpen ( p, b )
	triggerClientEvent ( p, "NGUsedVehicles->Interface->SetInterfaceOpen", p, b );
end 