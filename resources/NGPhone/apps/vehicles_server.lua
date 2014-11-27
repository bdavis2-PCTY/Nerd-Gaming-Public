addEvent ( "NGPhone:App->Vehicles:onPanelOpened", true )
addEventHandler ( "NGPhone:App->Vehicles:onPanelOpened", root, function ( ) 
	local cars = exports.NGVehicles:getAccountVehicles ( getAccountName ( getPlayerAccount ( source ) ) )
	triggerClientEvent ( source, "NGPhone:App->Vehicles:onClientGetVehicles", source, cars )
end )

addEvent ( "NGPhone:Apps->Vehicles:SetVehicleVisible", true )
addEventHandler ( "NGPhone:Apps->Vehicles:SetVehicleVisible", root, function ( id, stat ) 
	local v = exports.NGVehicles:SetVehicleVisible ( id, stat, source )
end )

addEvent ( "NGPhone:Apps->Vehicles:AttemptRecoveryOnID", true )
addEventHandler ( "NGPhone:Apps->Vehicles:AttemptRecoveryOnID", root, function ( id )
	exports.NGVehicles:recoverVehicle ( source, id )
end ) 

addEvent ( "NGPhone:App->Vehicles:sellPlayerVehicle", true )
addEventHandler ( "NGPhone:App->Vehicles:sellPlayerVehicle", root, function ( plr, data )
	exports.NGVehicles:sellVehicle ( plr, data )
end )

addEvent ( "NGPhone:Apps->Vehicles:WarpThisVehicleToMe", true )
addEventHandler ( "NGPhone:Apps->Vehicles:WarpThisVehicleToMe", root, function ( id )
	if ( not exports.NGVehicles:warpVehicleToPlayer ( id, source ) ) then
		exports.NGMessages:sendClientMessage ( "Error: Unable to warp vehicle", source, 255, 0, 0 )
	end
end )