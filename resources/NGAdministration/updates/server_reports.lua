exports.NGSQL:db_exec ( "CREATE TABLE IF NOT EXISTS reports ( id INT, user_from TEXT, priority TEXT, title TEXT, description TEXT, submittedon DATE, status TEXT )" )

addEvent ( "NGAdmin:Reports:onClientSubmitReport", true )
addEventHandler ( "NGAdmin:Reports:onClientSubmitReport", root, function ( prior, title, desc )
	if not prior or not title or not desc then
		return false
	end
	local from = tostring ( getAccountName ( getPlayerAccount ( source ) ) )
	local today = exports.NGPlayerFunctions:getToday ( )
	local status = "open"
	
	local id = 1
	local q = exports.NGSQL:db_query ( "SELECT * FROM reports" )
	local usedIDS = { }
	for i, v in pairs ( q ) do
		usedIDS[v.id] = true
	end
	
	while ( usedIDS [ id ] ) do
		id = id + 1
	end
	
	exports.NGSQL:db_exec ( "INSERT INTO reports ( `id`, `user_from`, `priority`, `title`, `description`, `submittedon`, `status` ) VALUES ( ?, ?, ?, ?, ?, ?, ? )",
		id, from, prior, title, desc, today, status )
	for i, v in pairs ( getOnlineStaff ( ) ) do
		exports.NGMessages:sendClientMessage(getPlayerName(source).." has submitted a report!", v, 255, 255, 0 )
	end
end )

addCommandHandler ( "reports", function ( p )
	if ( isPlayerStaff ( p ) ) then
		local reports = exports.NGSQL:db_query ( "SELECT * FROM reports ORDER BY priority AND status" )
		-- sort the table: High, Medium, Low
		local new = { }
		local _high = { }
		local _med = { }
		local _low = { }
		for i, v in pairs ( reports ) do
			local x = v.priority
			if ( x == "High" ) then
				table.insert ( _high, v )
			elseif ( x == "Low" ) then
				table.insert ( _low, v )
			elseif ( x == "Medium" ) then
				table.insert ( _med, v )
			end
		end
		for i, v in pairs ( _low ) do table.insert ( new, 1, v ) end
		for i, v in pairs ( _med ) do table.insert ( new, 1, v ) end
		for i, v in pairs ( _high ) do table.insert ( new, 1, v ) end
		local deleteAccess = isPlayerInACL ( p, "Level 5" )
		triggerClientEvent ( p, "NGAdmin:Reports:onStaffViewReportsList", p, new, deleteAccess )
	end
end )

addEvent ( "NGAdmin:Module->reports:OpenPanelFromSource", true )
addEventHandler ( "NGAdmin:Module->reports:OpenPanelFromSource", root, function ( )
	executeCommandHandler ( "reports", source )
end )


addEvent ( "NGAdmin:Module->Report:UpdateReportInformation", true )
addEventHandler ( "NGAdmin:Module->Report:UpdateReportInformation", root, function ( id, group, to )
	exports.NGLogs:outputActionLog ( getPlayerName(source).." ("..getAccountName(getPlayerAccount(source))..") is updating report #"..tostring(id).." "..group.." to "..to )
	exports.NGSQL:db_exec ( "UPDATE reports SET status=? WHERE id=?", tostring ( to ), tostring ( id ) )
	executeCommandHandler ( "reports", source )
end )

addEvent ( "NGAdmin:Module->reports:DumpReport", true )
addEventHandler ( "NGAdmin:Module->reports:DumpReport", root, function ( id )
	exports.NGLogs:outputActionLog ( getPlayerName(source).." ("..getAccountName(getPlayerAccount(source))..") deleted report #"..tostring(id) )
	exports.NGSQL:db_exec ( "DELETE FROM reports WHERE id=?", tostring ( id ) )
	executeCommandHandler ( "reports", source )
	exports.NGMessages:sendClientMessage ( "Report #"..tostring(id).." has been dumped.", source, 255, 255, 0 )
end )
















--- fuck it, just make updates in here too
local updates = { }
exports.NGSQL:db_exec ( "CREATE TABLE IF NOT EXISTS server_updates ( id INT, author TEXT, added_on TEXT, description TEXT )" )

local data = exports.NGSQL:db_query ( "SELECT * FROM server_updates" )
updates = data

-- reverse table
local temp = updates
updates =  { }
for i=#temp, 1, -1 do
	table.insert ( updates, temp [ i ] )
end

addEvent ( "NGAdmin:Modules->Updates:OnClientRequestUpdateList", true )
addEventHandler ( "NGAdmin:Modules->Updates:OnClientRequestUpdateList", root, function ( )
	triggerClientEvent ( source, "NGAdmin:Modules->Updates:OnServerSendClientUpdateList", source, updates )
end )

function addUpdate ( date, author, description )
	local usedIds = { }
	local id = 1;
	for i, v in pairs ( updates ) do usedIds [ v.id ] = true end
	while ( usedIds [ id ] ) do id = id + 1 end
	exports.NGSQL:db_exec ( "INSERT INTO server_updates ( id, author, added_on, description ) VALUES ( ?, ?, ?, ? )",
		tostring ( id ), tostring ( author ), tostring ( date ), tostring ( description ) )
	local tb = { id=id, author=author, added_on=date, description=description }
	table.insert ( updates, 1, tb )
end

function removeUpdate ( id )
	exports.NGSQL:db_exec ( "DELETE FROM server_updates WHERE id=?", tostring ( id ) )
	for i, v in pairs ( updates ) do
		if ( tostring ( v.id ):lower ( ) == tostring ( id ):lower ( ) ) then
			table.remove ( updates, i )
			break
		end
	end
end



addEvent ( "NGAdmin:Modules->Updates:OnStaffDeleteUpdate", true )
addEventHandler ( "NGAdmin:Modules->Updates:OnStaffDeleteUpdate", root, function ( id )
	removeUpdate ( id )
	executeCommandHandler ( "addupdate", source )
end )

addEvent ( "NGAdmin:Modules->Updates:OnStaffCreateUpdate", true )
addEventHandler ( "NGAdmin:Modules->Updates:OnStaffCreateUpdate", root, function ( data )
	addUpdate ( data.date, data.author, data.description )
	exports.NGMessages:sendClientMessage ( "A new update has been added! Check /updates.", root, 255, 120, 0 )
	executeCommandHandler ( "addupdate", source )
end )

addEvent ( "NGAdmin:Module->Updates:OpenPanelFromSource", true )
addEventHandler ( "NGAdmin:Module->Updates:OpenPanelFromSource", root, function ( )
	executeCommandHandler ( "addupdate", source )
end )


addCommandHandler ( "addupdate", function ( p )
	if ( getPlayerStaffLevel ( p, 'int' ) >= 4 ) then
		triggerClientEvent ( p, "NGAdmin:Modules->Updates:OnAdminOpenManager", p, updates )
	end
end )