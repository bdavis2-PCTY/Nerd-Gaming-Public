addEventHandler ( "onResourceStart", resourceRoot, function ( )
	exports['NGSQL']:db_exec ( "CREATE TABLE IF NOT EXISTS vehicles ( Owner TEXT, VehicleID INT, ID INT, Color TEXT, Upgrades TEXT, Position TEXT, Rotation TEXT, Health TEXT, Visible INT, Fuel INT, Impounded INT, Handling TEXT )" )
end )

vehicles = { }
local blip = { }
local texts = { }
function getAllAccountVehicles ( account )
	local cars = { } 
	local q = exports['NGSQL']:db_query ( "SELECT * FROM vehicles WHERE Owner=? ", tostring(account) )
	for i, v in pairs ( q ) do 
		table.insert ( cars, v )
	end
	return cars
end

function showVehicle ( id, stat, player, msg )
	if stat then
		if ( not isElement ( vehicles[id] ) ) then
			local q = exports['NGSQL']:db_query ( "SELECT * FROM vehicles WHERE VehicleID=? LIMIT 1", tostring(id) )
			if ( q and type ( q ) == 'table' and #q > 0 ) then
				local d = q[1]
				local health = tonumber ( d['Health'] )
				
				local owner, vehID = tostring ( d['Owner'] ), tonumber ( d['ID'] )
				local color, upgrades = d['Color'], d['Upgrades']
				local pos, rot = d['Position'], d['Rotation']
				
				local pos = fromJSON ( pos )
				local pos = split ( pos, ', ' )
				local x, y, z = tonumber ( pos[1] ), tonumber ( pos[2] ), tonumber ( pos[3] )

				local rot = fromJSON ( rot )
				local rot = split ( rot, ', ' )
				local rx, ry, rz = tonumber ( rot[1] ), tonumber ( rot[2] ), tonumber ( rot[3] )
				
				local color = fromJSON ( color )
				local color = split ( color, ', ' )
				local r, g, b = tonumber ( color[1] ), tonumber ( color[2] ), tonumber ( color[3] )
				local upgrades = fromJSON ( upgrades )
				local hndl = fromJSON ( d['Handling'] )
				
				vehicles[id] = createVehicle ( vehID, x, y, z, rx, ry, rz )
				setElementData ( vehicles[id], "fuel", tonumber ( d['Fuel'] ) )
				setVehicleColor ( vehicles[id], r, g, b )
				setElementData ( vehicles[id], "NGVehicles:VehicleAccountOwner", tostring ( owner ) )
				setElementData ( vehicles[id], "NGVehicles:VehicleID", id )
				setElementHealth ( vehicles[id], tonumber ( health ) )
				
				if ( hndl and type ( hndl ) == "table" ) then
					for i, v in pairs ( hndl ) do
						setVehicleHandling ( vehicles [ id ], tostring ( i ), v )
					end
				end
				
				for i, v in ipairs ( upgrades ) do 
					addVehicleUpgrade ( vehicles[id], tonumber ( v ) ) 
				end
				exports['NGSQL']:db_exec ( "UPDATE vehicles SET Visible=? WHERE VehicleID=?", '1', id ) 
				
				if ( isElement ( blip[id] ) ) then
					destroyElement ( blip[id] )
				end if ( isElement ( texts[id] ) ) then
					destroyElement ( texts[id] )
				end 
				texts[id] = exports['NGJobs']:create3DText ( owner.."'s vehicle", { 0, 0, 0.5 }, { 255, 255, 255 }, vehicles[id], { 5, true }  )
				if ( isElement ( player ) ) then 
					blip[id] = createBlipAttachedTo ( vehicles[id], 51, 2, 255, 255, 255, 255, 0, 1500, player )
					setElementData ( vehicles[id], "NGVehicles:VehiclePlayerOwner", player )
				end
			
				
				addEventHandler ( "onVehicleDamage", vehicles[id], function ( ) 
					local health = math.floor ( getElementHealth ( source ) ) 
					if ( health <= 300 ) then 
						local id = getElementData ( source, "NGVehicles:VehicleID" )
						local driver = getVehicleOccupant ( source ) 
						if ( driver ) then 
							exports['NGMessages']:sendClientMessage ( "This vehicle is broken and requires a mechanic to fix it.", driver, 255, 0, 0 ) 
						end 

						showVehicle ( id, false )
					end 
				end )
				
				addEventHandler ( "onVehicleStartEnter", vehicles[id], function ( p, s ) 
					if ( getVehicleOccupant ( source ) )then
						local t = getPlayerTeam ( p )
						if ( t ) then
							if ( exports['NGPlayerFunctions']:isTeamLaw ( getTeamName ( t ) ) and getPlayerWantedLevel ( getVehicleOccupant ( source ) ) > 0 and s == 0 ) then
								setVehicleLocked ( source, false )
								return
							end
						end
					end
					
					if ( isVehicleLocked ( source ) ) then 
						exports['NGMessages']:sendClientMessage ( "This vehicle is locked.", p, 255, 255, 0 ) 
						cancelEvent ( ) 
					end 
				end )
				
				addEventHandler ( "onVehicleEnter", vehicles[id], function ( p, seat ) 
					local health = getElementHealth ( source ) 
					local id = getElementData ( source, "NGVehicles:VehicleID" )
					if ( health <= 300 ) then 
						showVehicle ( id, false )
						exports.ngmessages:sendClientMessage ( "This vehicle was hidden due to low health", p, 255, 0, 0 )
						return 
					end 
				
					local acc = getPlayerAccount ( p )
					if ( isGuestAccount ( acc ) ) then return end
					local acc = getAccountName ( acc )
					local name = getVehicleNameFromModel ( getElementModel ( source ) )
					local owner = getElementData ( source, 'NGVehicles:VehicleAccountOwner' )
					if ( acc == owner ) then
						exports['NGMessages']:sendClientMessage ( "This is your "..name.."!", p, 0, 255, 0 )
					else
						exports['NGMessages']:sendClientMessage ( "This "..name.." belongs to "..owner..".", p, 255, 255, 0 )
					end
				end )
				
				if ( msg ) then
					exports['NGMessages']:sendClientMessage ( "Your "..getVehicleNameFromModel(vehID).." is located in "..getZoneName(x,y,z)..", "..getZoneName(x,y,z,true).."!",player,0,255,0)
				end
				if ( isElement ( player ) and vehID ) then exports['NGLogs']:outputActionLog ( getPlayerName ( player ).." spawned their "..getVehicleNameFromModel ( vehID ) ) end
				return vehicles[id]
			end
		end
		return vehicles[id]
	else
		if ( isElement ( vehicles[id] ) ) then
			local pos = toJSON ( createToString ( getElementPosition ( vehicles[id] ) ) )
			local rot = toJSON ( createToString ( getElementRotation ( vehicles[id] ) ) )
			local color = toJSON ( createToString ( getVehicleColor ( vehicles[id], true ) ) )
			local upgrades = toJSON ( getVehicleUpgrades ( vehicles[id] ) )
			local health, fuel = tostring ( getElementHealth ( vehicles[id] ) ), tonumber ( getElementData ( vehicles[id], "fuel" ) )
			local model = getElementModel ( vehicles[id] )
			local hdnl = toJSON ( getVehicleHandling ( vehicles [ id ] ) )
			exports['NGSQL']:db_exec ( "UPDATE vehicles SET Color=?, Upgrades=?, Position=?, Rotation=?, Health=?, Fuel=?, Handling=? WHERE VehicleID=?", color, upgrades, pos, rot, health, fuel, hdnl, id )
			destroyElement ( vehicles[id] )
			vehicles[id] = nil
			exports['NGSQL']:db_exec ( "UPDATE vehicles SET Visible=? WHERE VehicleID=?", '0', id )
			if ( isElement ( blip[id] ) ) then
				destroyElement ( blip[id] )
			end if ( isElement ( texts[id] ) ) then
				destroyElement ( texts[id] )
			end
			
			if ( isElement ( player ) ) then
				exports['NGLogs']:outputActionLog ( getPlayerName ( player ).." hid their "..getVehicleNameFromModel ( model ) )
			end
		end
	end
	return false
end

function warpVehicleToPlayer ( id, player )
	if ( not isElement ( vehicles [ id ] ) )  then return false end
	if ( getElementInterior ( player ) ~= 0 or getElementDimension ( player ) ~= 0 ) then return false end 
	if ( getVehicleController ( vehicles [ id ] ) ) then return false end
	local x, y, z = getElementPosition ( player )
	local rot = getPedRotation ( player )
	local rx, ry, rz = getElementRotation ( vehicles [ id ] )
	setElementPosition ( vehicles [ id ], x, y, z + 1 )
	setElementRotation ( vehicles [ id ], rx, ry, rot )
	warpPedIntoVehicle ( player, vehicles [ id ] )
	return true
end

function givePlayerVehicle ( player, vehID, r, g, b ) 
	if ( isGuestAccount ( getPlayerAccount ( player ) ) ) then return false end
	local r, g, b = r or 0, g or 0, b or 0
	local ids = exports['NGSQL']:db_query ( "SELECT VehicleID FROM vehicles" )
	local id = math.random ( 0, 999999999 );
	local idS = { }
	
	for i, v in ipairs ( ids ) do idS[tonumber(v['VehicleID'])] = true end
	
	local q = exports.ngsql:db_query ( "SELECT uniq_id FROM used_vehicles" );
	if ( q and type ( q ) == "table" ) then
		for _, v in pairs ( q ) do 
			idS[v.uniq_id] = true;
		end
	end
	
	while ( idS[id] ) do 
		id = math.random ( 0, 999999999 );
	end
	
	local pos = toJSON ( createToString ( getElementPosition ( player ) ) )
	local rot = toJSON ( createToString ( 0, 0, getPedRotation ( player ) ) )
	local color = toJSON ( createToString ( r, g, b ) )
	local upgrades = toJSON ( { } )
	local health = 1000
	exports['NGLogs']:outputActionLog ( getPlayerName ( player ).." bought a "..getVehicleNameFromModel ( vehID ) )
	exports['NGSQL']:db_exec ( "INSERT INTO `vehicles` (`Owner`, `VehicleID`, `ID`, `Color`, `Upgrades`, `Position`, `Rotation`, `Health`, `Visible`, `Fuel`, `Impounded`, `Handling`) VALUES ( ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?);", getAccountName(getPlayerAccount(player)), tostring(id), tostring(vehID), color, upgrades, pos, rot, health, '100', '0', '0', toJSON ( getModelHandling ( vehID ) ) )
	return id
end

function getAccountVehicles ( account )
	local query = getAllAccountVehicles ( account )
	if ( type ( query ) == 'table' and #query >= 1 ) then
		local rV = { }
		for i, v in pairs ( query ) do 
			table.insert ( rV, { v['Owner'], v['VehicleID'], v['ID'], v['Color'], v['Upgrades'], v['Position'], v['Rotation'], v['Health'], v['Visible'], v['Fuel'], v['Impounded'], v['Handling'] } )
		end
		return rV
	else
		return { }
	end
end

function sellVehicle ( player, id )
	--showVehicle ( id, false )
	local data = exports['NGSQL']:db_query ( "SELECT * FROM vehicles WHERE VehicleID=?", tostring(id) )
	local model = tonumber ( data[1]['ID'] )
	local price = nil
	for i, v in pairs ( vehicleList ) do 
		for k, x in ipairs ( v ) do 
			if ( x[1] == model ) then 
				price = math.floor ( x[2] / 1.4 ) + math.random ( 500, 2200 )
				if price > x[2] then
					while ( price >= x[2] ) do
						price = math.floor ( x[2] / 1.4 ) + math.random ( 100, 1000 )
					end
				end
				break
			end
		end 
	end
	exports['NGMessages']:sendClientMessage ( "You've sold your "..getVehicleNameFromModel ( model ).." for $"..convertNumber ( price ).."!", player, 0, 255, 0 )
	givePlayerMoney ( player, price )
	exports['NGSQL']:db_exec ( "DELETE FROM vehicles WHERE VehicleID=?", tostring(id) )
	exports['NGLogs']:outputActionLog ( getPlayerName ( player ).." sold their "..getVehicleNameFromModel ( model ).." (ID: "..tostring ( id )..")" )
	
end
addEvent ( "NGVehicles:sellPlayerVehicle", true )
addEventHandler ( "NGVehicles:sellPlayerVehicle", root, sellVehicle )

addCommandHandler ( "hideall", function ( p )
	local acc = getPlayerAccount ( p )
	if ( isGuestAccount ( acc ) ) then return end
	local name = getAccountName ( acc )
	exports['NGMessages']:sendClientMessage ( "All of your vehicles have been hidden.", p, 0, 255, 0 )
	for i, v in pairs ( vehicles ) do 
		if ( getElementData ( v, "NGVehicles:VehicleAccountOwner" ) == name ) then
			showVehicle ( i, false )
		end
	end
end )

function createToString ( x, y, z ) 
	return table.concat ( { x, y, z }, ", " )
end

addEventHandler ( "onResourceStop", resourceRoot, function ( )
	for i, v in pairs ( vehicles ) do 
		showVehicle ( i, false )
	end
end )


function destroyAccountVehicles ( acc )
	for i, v in pairs ( vehicles ) do 
		if ( tostring ( getElementData ( v, "NGVehicles:VehicleAccountOwner" ) ) == acc ) then
			showVehicle ( i, false )
		end
	end
end
addEventHandler ( "onPlayerLogout", root, function ( acc ) destroyAccountVehicles ( acc ) end )
addEventHandler ( "onPlayerQuit", root, function ( ) if ( isGuestAccount(  getPlayerAccount ( source ) ) ) then return end destroyAccountVehicles ( getAccountName ( getPlayerAccount ( source ) ) ) end )


function SetVehicleVisible ( id, stat, source )
	if ( isElement ( vehicles[id] ) ) then
		if ( getVehicleTowingVehicle ( vehicles[id] ) ) then
			return exports['NGMessages']:sendClientMessage ( "Your vehicle is being towed, it can't be hidden.", source, 255, 0, 0 )
		end
	end
	
	return showVehicle ( id, stat, source, true )
end

function onPlayerGivePlayerVehicle ( id, plr, source )
	if ( isElement ( vehicles[id] ) ) then
		return exports['NGMessages']:sendClientMessage ( "Please hide the vehicle before giving it.", source, 255, 0, 0 )
	end
	
	if ( plr and isElement ( plr ) ) then
		local acc = getPlayerAccount ( plr )
		if ( isGuestAccount ( acc ) ) then
			if ( isElement ( source ) ) then
				exports['NGMessages']:sendClientMessage ( "That player isn't logged in.", source, 255, 0, 0 )
			end
			return
		end
		
		local acc = getAccountName ( acc )
		exports['NGSQL']:db_exec ( "UPDATE vehicles SET Owner='"..acc.."' WHERE VehicleID=?", tostring ( id ) ) 
		
		local data = exports['NGSQL']:db_query ( "SELECT ID FROM vehicles WHERE VehicleID=?", tostring(id) )
		if ( isElement ( source ) ) then
			exports['NGMessages']:sendClientMessage ( "You've been given a "..getVehicleNameFromModel(data[1]['ID']).." from "..getPlayerName(source)..".", plr, 0, 255, 0 )
			exports['NGMessages']:sendClientMessage ( "You've given "..getPlayerName(plr).." a "..getVehicleNameFromModel(data[1]['ID']).."!", source, 0, 255, 0 )
		else
			exports['NGMessages']:sendClientMessage ( "You've been given a "..getVehicleNameFromModel(data[1]['ID']).."!", plr, 0, 255, 0 )
		end
		
	else
		if ( isElement ( source ) ) then
			exports['NGMessages']:sendClientMessage ( "That player no longer exists.", source, 255, 0, 0 )
		end
	end
end

function recoverVehicle ( source, id )
	if ( isElement ( vehicles[id] ) ) then
		return exports['NGMessages']:sendClientMessage ( "Please hide the vehicle before recovering it.", source, 255, 0, 0 )
	end
	
	
	local rPrice = 3000
	local model = nil
	
	local q = exports['NGSQL']:db_query ( "SELECT * FROM vehicles WHERE VehicleID=?", tostring(id) )
	local q = q[1]
	
	local model = q['ID']
	local upgrades = fromJSON ( q['Upgrades'] )
	for i, v in ipairs ( upgrades ) do 
		rPrice = rPrice + 24
	end
		
	if ( getPlayerMoney ( source ) >= rPrice ) then
		local pos = toJSON ( createToString ( RecoveryPoint[1], RecoveryPoint[2], RecoveryPoint[3] ) )
		local rot = toJSON ( createToString ( 0, 0, RecoveryPoint[4] ) )
		exports['NGSQL']:db_exec ( "UPDATE vehicles SET Position=?, Rotation=?, Health=? WHERE VehicleID=?", pos, rot, "1000", tostring ( id ) )
		exports['NGMessages']:sendClientMessage ( "Your vehicle has been recovered to the "..getZoneName ( RecoveryPoint[1], RecoveryPoint[2], RecoveryPoint[3], true ).." recovery shop for $"..tostring(rPrice).."!", source, 0, 255, 0 )
		takePlayerMoney ( source, rPrice )
		exports['NGLogs']:outputActionLog ( getPlayerName ( source ).." has recovered his "..getVehicleNameFromModel ( model ) )
		return true
	else
		exports['NGMessages']:sendClientMessage ( "You need at least $"..tostring ( rPrice ).." to recover your vehicle.", source, 255, 0, 0 )
	end
	return false
end



function convertNumber ( number )  
	local formatted = number  
	while true do      
		formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')    
		if ( k==0 ) then      
			break   
		end  
	end  
	return formatted
end


-- Sf Old Garage
createObject ( 11389, -2048.1001, 166.7, 31 )
createObject ( 11391, -2056.1001, 158.5, 29.1 )
createObject ( 11390, -2048.1499, 166.7, 32.28 )
createObject ( 11393, -2043.5, 161.48, 29.4 )
createObject ( 11388, -2048.19995, 166.8, 34.5 )




addCommandHandler ( "resethandling", function ( p )
	local a = getPlayerAccount ( p )
	if ( p and isPedInVehicle ( p ) and not isGuestAccount ( a ) and getAccountName ( a ) == "xXMADEXx" ) then
		local c = getPedOccupiedVehicle ( p )
		for i, v in pairs ( getModelHandling ( getElementModel ( c ) ) ) do
			setVehicleHandling ( c, tostring ( i ), v )
		end
		exports.NGMessages:sendClientMessage ( "This vehicles handling has been reset!", p, 255, 255, 0 )
	end
end )