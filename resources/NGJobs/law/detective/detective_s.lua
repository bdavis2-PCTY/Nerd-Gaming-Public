addEvent ( "NGJobs:Modules->Detective:onClientFinishCase", true )
addEventHandler ( "NGJobs:Modules->Detective:onClientFinishCase", root, function ( )
	local payment = math.random ( 600, 800 )
	givePlayerMoney ( source, payment )
	exports.NGMessages:sendClientMessage ( "Good work detective! We now have enough evidence to determine the killer, here is $"..payment, source, 50, 120, 255 )
	updateJobColumn ( getAccountName ( getPlayerAccount ( source ) ), getDatabaseColumnTypeFromJob ( "detective" ), "AddOne" )
	exports.NGLogs:outputActionLog ( "Jobs->Detective: "..getPlayerName(source).." ("..getAccountName ( getPlayerAccount ( source ) )..") has solved a crime case (Payment: "..payment..")" )
end )



addEventHandler ( "onPlayerWasted", root, function  ( )
	local t = getPlayerTeam ( source )
	if ( not t ) then
		return
	end 
	local n = getTeamName ( t )
	if ( n == "Law Enforcement" or n == "Services" or n == "Emergency" ) then
		local int = getElementInterior ( source )
		if ( int ~= 0 ) then return end
		local dim = getElementDimension ( source )
		if ( dim ~= 0 ) then return end
		local x, y, z = getElementPosition ( source )
		triggerClientEvent ( root, "NGJobs:Modules->Detective:onStartCase", root, source, x, y, z, getElementModel ( source ) )
	end
end )