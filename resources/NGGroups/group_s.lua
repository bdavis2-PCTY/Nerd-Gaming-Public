----------------------------------------
-- Developer Note:
--		THIS RESOURCE CANNOT BE RESTARTED
--		WHILE THE SERVER IS RUNNING, IT CAN
--		MAKE MINUTES OF NETWORK TROUBLE 
--		WHILE QUERYING ALL GROUPS DATA
-----------------------------------------


local groups = { }

addEventHandler ( "onResourceStart", resourceRoot, function ( ) 
	exports.NGSQL:db_exec ( "CREATE TABLE IF NOT EXISTS groups ( id INT, name VARCHAR(20), info TEXT )" );
	exports.NGSQL:db_exec ( "CREATE TABLE IF NOT EXISTS group_members ( id INT, member_name VARCHAR(30), rank VARCHAR(20), join_date VARCHAR(40) )");
	exports.NGSQL:db_exec ( "CREATE TABLE IF NOT EXISTS group_rank ( id INT, rank VARCHAR(30), perms TEXT )" )
	exports.NGSQL:db_exec ( "CREATE TABLE IF NOT EXISTS group_logs ( id INT, time VARCHAR(40), account VARCHAR(40), log TEXT )" )

	exports.scoreboard:scoreboardAddColumn ( "Group", getRootElement ( ), 90, "Group", 10 )
	exports.scoreboard:scoreboardAddColumn ( "Group Rank", getRootElement ( ), 90, "Group Rank", 12 )

	for i, v in pairs ( getElementsByType ( "player" ) ) do
		local g = getElementData ( v, "Group" )
		if ( not g ) then
			setElementData ( v, "Group", "None" )
			setElementData ( v, "Group Rank", "None")
		end

		if ( not getElementData ( v, "Group Rank" ) ) then
			setElementData ( v, "Group Rank", "None" )
		end
	end
end )

addEventHandler ( "onPlayerJoin", root, function ( )
	setElementData ( source, "Group", "None" )
	setElementData ( source, "Group Rank", "None")
end )


groups = { }
--[[ example: 

groups = { 
	['ownfexrf__s'] = {
		info = {
			founder = "xXMADEXx", -- this CANNOT change
			founded_time = "2014-06-18:01-35-57",
			desc = "This is my group",
			color = { 255, 255, 0 },
			type = "Gang",
			bank = 0,
			id = 0
		},

		members = { 
			["xXMADEXx"] = { rank="Founder", joined="2014-06-18:01-35-57" } 
		},

		ranks = {
			['Founder'] = {
				-- member access
				['member_kick'] = true,
				['member_invite'] = true,
				['member_setrank'] = true,
				['member_viewlog'] = true
				-- General group changes
				['group_modify_color'] = true,,
				['group_modify_motd'] = true,
				-- banks
				['bank_withdraw'] = true,
				['bank_deposit'] = true,
				-- logs
				['logs_view'] = true,
				['logs_clear'] = true,
				-- ranks
				['ranks_create'] = true,
				['ranks_delete'] = true,
				['ranks_modify'] = true
			}
		},
		log = {
			-- { time, log }
			{ time="2014-06-18  05:05:05", account="xXMADEXx", log="Group Created" }
		},

		pendingInvites = { 
			['account'] = { inviter = "Inviter Account", time="Time Invite Sent"}
		}
	}
}]]

function saveGroups ( )
	exports.NGSQL:db_exec ( "DELETE FROM groups" )
	exports.NGSQL:db_exec ( "DELETE FROM group_rank" )
	exports.NGSQL:db_exec ( "DELETE FROM group_members")
	exports.NGSQL:db_exec ( "DELETE FROM group_logs")

	for i, v in pairs ( groups ) do
		exports.NGSQL:db_exec ( "INSERT INTO groups ( id, name, info ) VALUES ( ?, ?, ? )", tostring ( v.info.id ), tostring ( i ), toJSON ( v.info ) )
		for k, val in pairs ( v.ranks ) do 
			exports.NGSQL:db_exec ( "INSERT INTO group_rank ( id, rank, perms ) VALUES ( ?, ?, ? )", tostring ( v.info.id ), k, toJSON ( val ) )
		end 
		for k, val in pairs ( v.members ) do
			exports.NGSQL:db_exec ( "INSERT INTO group_members ( id, member_name, rank, join_date ) VALUES ( ?, ?, ?, ? )", tostring ( v.info.id ), k, val.rank, val.joined )
		end 

		for k, val in ipairs ( v.log ) do
			exports.NGSQL:db_exec ( "INSERT INTO group_logs ( id, time, account, log ) VALUES ( ?, ?, ?, ? )", tostring ( v.info.id ), val.time, val.account, val.log )
		end 
	end
end 

function loadGroups ( )
	local start = getTickCount ( )
	local groups_ = exports.NGSQL:db_query ( "SELECT * FROM groups" )
	for i, v in pairs ( groups_ ) do
		if ( v and v.name and not groups [ v.name ] ) then
			groups [ v.name ] = { }
			groups [ v.name ].info = { }
			groups [ v.name ].ranks = { }
			groups [ v.name ].members = { }
			groups [ v.name ].log = { }

			-- load info table
			groups [ v.name ].info = fromJSON ( v.info )
			groups [ v.name ].info.id = tonumber ( v.id )

			-- load rank table
			local ranks = exports.NGSQL:db_query ( "SELECT * FROM group_rank WHERE id=?", tostring ( v.id ) )
			for i, val in pairs ( ranks ) do
				if ( not groups [ v.name ].ranks[val.rank] ) then
					groups [ v.name ].ranks[val.rank] = fromJSON ( val.perms )
				end
			end 

			-- load member table
			local members = exports.NGSQL:db_query ( "SELECT * FROM group_members WHERE id=?", tostring ( v.id ) )
			for i, val in pairs ( members ) do
				groups [v.name].members[val.member_name] = { }
				groups [v.name].members[val.member_name].rank = val.rank
				groups [v.name].members[val.member_name].joined = val.join_date

				for _, player in pairs ( getElementsByType ( "player" ) ) do
					local a = getPlayerAccount ( player )
					if ( a and not isGuestAccount ( a ) ) then
						local acc = getAccountName ( a )
						if ( val.member_name == acc ) then
							setElementData ( player, "Group", tostring ( v.name ) )
							setElementData ( player, "Group Rank", tostring ( val.rank ) )
						end 
					end
				end 
			end 

			-- load logs table
			local log = exports.NGSQL:db_query ( "SELECT * FROM group_logs WHERE id=?", tostring ( v.id ) )
			for i, val in ipairs ( log ) do
				table.insert ( groups[v.name].log, { time=val.time, account=val.account, log=val.log } )
			end 

			groups [ v.name ].pendingInvites = { }
		else
			local reason = "Variable 'v' not set"
			if ( v and not v.name ) then
				reason = "Variable 'v.name' not set"
			elseif ( v and v.name and groups [ v.name ] ) then
				reason = "Group already exists in table"
			else
				reason = "Undetected"
			end
			outputDebugString ( "NGGroups: Failed to load group ".. tostring ( v.name ).." - "..  tostring ( reason ), 1 )
		end 
	end

	local load = math.ceil ( getTickCount()-start )
	local tLen = table.len ( groups )
	outputDebugString ( "NGGroups: Successfully loaded "..tLen.." groups from the sql database ("..tostring(load).."MS - About "..math.floor(load/tLen).."MS/group)" )

end 
addEventHandler ( "onResourceStart", resourceRoot, loadGroups )
addEventHandler ( "onResourceStop", resourceRoot, saveGroups )

function getGroups ( ) 
	return groups
end 


addEvent ( "NGGroups->Events:onClientRequestGroupList", true )
addEventHandler ( "NGGroups->Events:onClientRequestGroupList", root, function ( )
	local g = getGroups ( )
	triggerClientEvent ( source, "NGGroups->onServerSendClientGroupList", source, g )
	g = nil
end )

------------------------------
-- Group Creating			--
------------------------------
function createGroup ( name, color, type, owner )
	if ( doesGroupExist ( name ) ) then
		return false
	end

	local id = 0
	local ids = { }
	for i, v in pairs ( groups ) do
		ids [ v.info.id ] = true
	end 

	while ( ids [ id ] ) do
		id = id + 1
	end

	groups [ name ] = { 
		info = {
			founder = owner, -- this CANNOT change
			founded_time = getThisTime ( ),
			desc = "",
			color = color,
			type = type,
			bank = 0,
			id = id
		},

		members = { 
			[owner] = { rank="Founder", joined=getThisTime ( ) } 
		},

		ranks = {
			['Founder'] = {
				-- member access
				['member_kick'] = true,
				['member_invite'] = true,
				['member_setrank'] = true,
				['member_viewlog'] = true,
				-- General group changes
				['group_modify_color'] = true,
				['group_modify_motd'] = true,
				-- banks
				['bank_withdraw'] = true,
				['bank_deposit'] = true,
				-- logs
				['logs_view'] = true,
				['logs_clear'] = true,
				-- ranks
				['ranks_create'] = true,
				['ranks_delete'] = true,
				['ranks_modify'] = true
			}, ["Member"] = {
				-- button access
				['view_member_list'] = true,
				['view_ranks'] = false,
				['view_bank'] = true,
				-- member access
				['member_kick'] = false,
				['member_invite'] = false,
				['member_setrank'] = false,
				-- General group changes
				['group_modify_color'] = false,
				['group_modify_motd'] = false,
				-- banks
				['bank_withdraw'] = false,
				['bank_deposit'] = true,
				-- logs
				['logs_view'] = false,
				['logs_clear'] = false,
				-- ranks
				['ranks_create'] = false,
				['ranks_delete'] = false,
				['ranks_modify'] = false
			}
		},
		log = {
			-- { time, log }
			{ time=getThisTime ( ), account="Server", log="Group Created" }
		},

		pendingInvites = { }
	}
 	
 	return true, groups [ name ]
end

function deleteGroup ( group )
	if ( not doesGroupExist ( group ) ) then 
		return false
	end
	local id = groups [ group ].info.id
	groups [ group ] = nil
	exports.NGSQL:db_exec ( "DELETE FROM groups WHERE id=?", tostring ( id ) )
	exports.NGSQL:db_exec ( "DELETE FROM group_logs WHERE id=?", tostring ( id ) )
	exports.NGSQL:db_exec ( "DELETE FROM group_members WHERE id=?", tostring ( id ) )
	exports.NGSQL:db_exec ( "DELETE FROM group_rank WHERE id=?", tostring ( id ) )
	exports.NGLogs:outputServerLog ( "Group "..tostring ( group ).." deleted" )
	for i, v in pairs ( getElementsByType ( "player" ) ) do
		local gang = getElementData ( v, "Group" )
		if ( gang == group ) then
			setElementData ( v, "Group", "None" )
			setElementData ( v, "Group Rank", "None" )
		end
	end 
	exports.NGSQL:db_exec ( "UPDATE accountdata SET GroupName=?, GroupRank=? WHERE GroupName=?", "None", "None", tostring ( group ) )
end 
addEvent ( "NGGroups->Modules->Gangs->Force->DeleteGroup", true )
addEventHandler ( "NGGroups->Modules->Gangs->Force->DeleteGroup", root, deleteGroup )

addEvent ( "NGGroups->GEvents:onPlayerAttemptGroupMake", true )
addEventHandler ( "NGGroups->GEvents:onPlayerAttemptGroupMake", root, function ( data ) 
	--[[
	data = {
		name = "Group Name",
		type = "Group Type",
		color = { 
			r = GroupColorR,
			g = GroupColorG,
			b = GroupColorB
		}
	} ]]

	if ( doesGroupExist ( data.name ) or tostring ( data.name ):lower() == "none" ) then
		return exports.ngmessages:sendClientMessage ( "A group with this name already exists", source, 255, 255, 0 )
	end

	local created, __ = createGroup ( data.name, data.color, data.type, getAccountName ( getPlayerAccount ( source ) ) )
	if ( created ) then
	
		setElementData ( source, "Group", data.name );
		setElementData ( source, "Group Rank", "Founder" );
		
		--groups [ data.name ].members [ getAccountName ( getPlayerAccount ( source ) ) ].rank = "Founder";
		
		outputDebugString ( "CREATED GROUP "..tostring(data.name)..". Owner: "..getPlayerName(source) );
		
		refreshPlayerGroupPanel ( source )
		return true
	else 
		outputDebugString ( "FAILED TO CREATE GROUP "..tostring(data.name).." FROM "..getplayerName(source) );
	end
	return false
end )

addEvent ( "NGGroups->gEvents:onPlayerDeleteGroup", true )
addEventHandler ( "NGGroups->gEvents:onPlayerDeleteGroup", root, function ( group )
	deleteGroup ( group )
	exports.NGLogs:outputActionLog ( getPlayerName(source).." ("..getAccountName(getPlayerAccount(source))..") deleted the group: "..tostring(group).." | id: "..tostring ( id ) )
	refreshPlayerGroupPanel ( source )
end )

------------------------------
-- Group Banking Functions	--
------------------------------
function getGroupBank ( group )
	if ( groups [ group ] and groups [ group ].info ) then
		local a = groups [ group ].info.bank or 0
		return a
	end
	return false
end

function setGroupBank ( group, money )
	if ( groups [ group ] and groups [ group ].info ) then
		groups [ group ].info.bank = money
		local a = true
		return a
	end
	return false
end 


addEvent ( "NGGroups:Module->Bank:returnBankBalanceToClient", true )
addEventHandler ( "NGGroups:Module->Bank:returnBankBalanceToClient", root, function ( group )
	local bank = getGroupBank ( group ) or 0
	triggerClientEvent ( source, "NGGroups:Module->Bank:onServerSendClientBankLevel", source, bank )
end )

addEvent ( "NGGroups:Modules->BankSys:onPlayerAttemptWithdawl", true )
addEventHandler ( "NGGroups:Modules->BankSys:onPlayerAttemptWithdawl", root, function ( group, amount )
	if ( not doesGroupExist ( group ) ) then
		exports.ngmessages:sendClientMessage ( "Something went wrong with the server (Error Code: ngroup-1)", source, 255, 0, 0 );
		setElementData ( source, "Group", "None" );
		setElementData ( source, "Group Rank", "None" );
		refreshPlayerGroupPanel ( source );
		return false
	end
	local bank = getGroupBank ( group );
	if ( amount > bank ) then
		return exports.ngmessages:sendClientMessage ( "Your group doesn't have $"..tostring(amount).." in their bank account", source, 255, 0, 0 )
	end
	exports.ngmessages:sendClientMessage ( "You have withdrawn $"..tostring(amount).." from your groups bank... Actions logged", source, 0, 255, 0 )
	givePlayerMoney ( source, amount )
	setGroupBank ( group, bank - amount )
	outputGroupLog ( group, "Withdrew $"..tostring(amount).." from the group bank", source )
end )

addEvent ( "NGGroups:Modules->BankSys:onPlayerAttemptDeposit", true )
addEventHandler ( "NGGroups:Modules->BankSys:onPlayerAttemptDeposit", root, function ( group, amount ) 
	if ( not doesGroupExist ( group ) ) then
		exports.ngmessages:sendClientMessage ( "Something went wrong with the server (Error Code: ngroup-2)", source, 255, 0, 0 );
		setElementData ( source, "Group", "None" );
		setElementData ( source, "Group Rank", "None" );
		refreshPlayerGroupPanel ( source );
		return false
	end

	local m = source.money;
	if ( amount > m ) then
		return exports.ngmessages:sendClientMessage ( "You don't have $"..tostring(amount), source, 255, 0, 0 )
	end

	exports.ngmessages:sendClientMessage ( "You deposited $"..tostring(amount).." into your group bank", source, 0, 255, 0 )
	source.money = m - amount;
	outputGroupLog ( group, "Deposited $"..tostring(amount).." into the group bank", source )
	setGroupBank ( group, getGroupBank ( group ) + amount )
end )

------------------------------
-- Group Member Functions	--
------------------------------
function getPlayerGroup ( player ) 
	local g = getElementData ( player, "Group" ) or "None"
	if ( g:lower ( ) == "none" ) then
		g = nil
	end
	return g
end 


function refreshPlayerGroupPanel ( player )
	triggerClientEvent ( player, "NGGroups->pEvents:onPlayerRefreshPanel", player )

	-- memory sweep 
	player = nil
end 

function setPlayerGroup ( player, group )
	local acc = getPlayerAccount ( player )
	if ( isGuestAccount ( acc ) ) then
		return false
	end

	if ( not group ) then
		group = "None"
	end

	if ( group ~= "None" ) then
		if ( not groups [ group ] ) then
			return false
		end
	end 

	setElementData ( player, "Group", group )
	if ( group == "None" ) then
		return setElementData ( player, "Group Rank", "None" )
	else
		groups [ group ].members [ getAccountName ( acc ) ] = { rank="Member", joined=getThisTime() }
		return setElementData ( player, "Group Rank", "Member" )
	end

	return false
end 


addEvent ( "NGGroups->Modules->Gangs->kickPlayer", true )
addEventHandler ( "NGGroups->Modules->Gangs->kickPlayer", root, function ( group, account )
	exports.ngsql:db_exec ( "UPDATE accountdata SET GroupName=?, GroupRank=? WHERE Username=?", "None", "None", account )
	for i, v in pairs ( getElementsByType ( "player" ) ) do
		local a = getPlayerAccount ( v )
		if ( not isGuestAccount ( a ) and getAccountName ( a ) == account )  then
			setElementData ( v, "Group", "None" )
			setElementData ( v, "Group Rank", "None" )
			outputChatBox ( "You got kicked from your group.", v, 255, 0, 0)
			break
		end
	end 
	groups [ group ].members [ account ] = nil
	exports.ngmessages:sendClientMessage ( "You kicked "..tostring(account).." from "..tostring(group), source, 255, 255, 0 )
	outputGroupLog ( group, "Kicked account "..tostring(account), source )
	refreshPlayerGroupPanel ( source )
end )

addEvent ( "NGGroups->Modules->Groups->OnPlayerLeave", true )
addEventHandler ( "NGGroups->Modules->Groups->OnPlayerLeave", root, function ( g )
	groups[g].members[getAccountName(getPlayerAccount(source))] = nil
	setPlayerGroup ( source, nil )
	refreshPlayerGroupPanel ( source )
	outputGroupLog ( g, "Has left the group", source  )
end )

	------------------------------------------
	-- Players -> Group Ranking Functions 	--
	------------------------------------------
	function setAccountRank ( group, account, newrank )
		local account, newrank = tostring ( account ), tostring ( newrank )
		exports.ngsql:db_exec ( "UPDATE accountdata SET GroupRank=? WHERE Username=?", newrank, account )
		groups[group].members[account].rank = newrank
		for i, v in pairs ( getElementsByType ( "player" ) ) do
			local a = getPlayerAccount ( v )
			if ( a and not isGuestAccount ( a ) and a == account ) then
				setElementData ( v, "Group Rank", tostring ( newrank ) )
				outputChatBox ( "You rank has been changed to "..tostring ( newrank ), v, 255, 255, 0)
				break
			end
		end

		return true
	end

	addEvent ( "NGGroups->Modules->Gangs->Ranks->UpdatePlayerrank", true )
	addEventHandler ( "NGGroups->Modules->Gangs->Ranks->UpdatePlayerrank", root, function ( group, account, newrank )
		if ( not groups[group] or not groups[group].ranks[newrank] ) then
			exports.ngmessages:sendClientMessage ( "Oops, something went wrong. Please try again", source, 255, 0, 0 )
			refreshPlayerGroupPanel ( source )
			return false
		end
		outputGroupLog ( group, "Changed "..account.."'s rank from "..groups[group].members[account].rank.." to "..newrank, source )
		setAccountRank ( group, account, newrank )
		exports.ngmessages:sendClientMessage ( "You have changed "..tostring ( account ).."'s rank!", source, 255, 255, 0)
		refreshPlayerGroupPanel ( source )
	end )


	function sendPlayerInvite ( player, group, inviter )
		local a = getPlayerAccount ( player )
		if ( isGuestAccount( a ) ) then
			return  false
		end

		local a = getAccountName ( a )
		if ( groups [ group ].pendingInvites [ a ] ) then 
			return false
		end

		table.insert ( groups [ group ].pendingInvites, { to=getAccountName(getPlayerAccount(player)), inviter=getAccountName(getPlayerAccount(inviter)), time=getThisTime() } );
		
		return true
	end

	addEvent ( "NGGroups->Modules->Groups->InvitePlayer", true )
	addEventHandler ( "NGGroups->Modules->Groups->InvitePlayer", root, function ( group, plr )
		local a = getPlayerAccount ( plr )
		if ( isGuestAccount ( a ) ) then
			return exports.ngmessages:sendClientMessage ( "Your group request couldn't be sent to "..plr.name, source, 255, 0, 0 )
		end
		local a = getAccountName ( a )
		
		for _, info in pairs ( groups [ group ].pendingInvites ) do 
			if ( info.to == a ) then 
				return exports.ngmessages:sendClientMessage ( "This player is already invited by "..tostring(info.from), source, 255, 255, 0 )
			end
		end

		outputGroupLog ( group, "Invited "..plr.name.." ("..a..")", source )
		
		local r, g, b = getGroupColor ( group );
		exports.ngmessages:sendClientMessage ( source.name.." invited you to "..group..". Accept it in F2", plr, r, g, b )
		exports.ngmessages:sendClientMessage ( "You have invited "..plr.name.." to the group", source, r, g, b )
		sendPlayerInvite ( plr, group, source ) 
	end ) 

	addEvent ( "NGGroups->Modules->Groups->Invites->OnPlayerDeny", true )
	addEventHandler( "NGGroups->Modules->Groups->Invites->OnPlayerDeny", root, function ( g )
		local a = getAccountName ( getPlayerAccount ( source ) )
		groups [ g ].pendingInvites [ a ] = nil
		refreshPlayerGroupPanel ( source )
	end )

	addEvent ( "NGGroups->Modules->Groups->Invites->OnPlayerAccept", true )
	addEventHandler ( "NGGroups->Modules->Groups->Invites->OnPlayerAccept", root, function ( g )
		local a = getAccountName ( getPlayerAccount ( source ) )

		for index, info in pairs ( groups [ g ].pendingInvites ) do 
			if ( info.to == a ) then
				table.remove ( groups [ g ].pendingInvites, index )
			end 
		end 
		
		groups [ g ].members [ a ] = { rank="Member", joined = getThisTime() }
		setPlayerGroup ( source, g )
		outputGroupMessage ( getPlayerName ( source ).." has joined the group!", g )
		refreshPlayerGroupPanel ( source )
	end )

	function addRankToGroup ( group, name, info )
		if ( not groups [ group ] ) then return false end
		for i, v in pairs ( groups [ group ].ranks ) do
			if ( i:lower() == name:lower() ) then
				return false
			end
		end
		groups [ group ].ranks [ name ] = info
		return true
	end 

	addEvent ( "NGGroups->Modules->Groups->Ranks->AddRank", true )
	addEventHandler ( "NGGroups->Modules->Groups->Ranks->AddRank", root, function ( group, name, info )
		outputGroupLog ( group, "Added rank '"..tostring(name).."'", source )
		addRankToGroup ( group, name, info )
		refreshPlayerGroupPanel ( source )
		exports.ngmessages:sendClientMessage ( "The rank has been added.", source, 0, 255, 0 )
	end )

	function setGroupMotd ( group, motd )
		if ( groups [ group ] ) then
			groups[group].info.desc = tostring ( motd )
			return true
		end
		return false
	end

	addEvent ( "NGGroups->Modules->Groups->MOTD->Update", true )
	addEventHandler ( "NGGroups->Modules->Groups->MOTD->Update", root, function ( g, mo )
		outputGroupLog ( g, "Changed the group MOTD", source )
		setGroupMotd ( g, mo )
		refreshPlayerGroupPanel ( source )
	end )



------------------------------
-- Group Checking Functions	--
------------------------------
function doesGroupExist ( group )
	local group = tostring ( group ):lower ( )
	for i, v in pairs ( groups ) do
		if ( tostring ( i ):lower ( ) == group ) then
			group = nil
			return true
		end
	end 
	group = nil
	return false
end

function isRankInGroup ( group, rank )
	local group = tostring ( group ):lower ( )
	for i, v in pairs ( groups ) do
		if ( i:lower() == group ) then
			if ( v.ranks and v.ranks [ rank ] ) then
				return true
			end 
			break
		end 
	end 
	return false
end 


------------------------------
-- Group Logging			--
------------------------------
function groupClearLog ( group )
	if ( groups [ group ] ) then
		groups [ group ].log = nil
		exports.NGSQL:db_exec ( "DELETE FROM group_logs WHERE id=?", groups[group].info.id )
		groups [ group ].log = { }
		group = nil
		return true
	end 
	group = nil
	return false
end

function outputGroupLog ( group, log, element )
	if ( not groups[group] ) then return end
	if ( not groups[group].log ) then groups[group].log = { } end

	local e = "Server"
	if ( element ) then
		e = element
		if ( type ( element ) == "userdata" ) then
			if ( getElementType ( element ) == "player" ) then
				local a = getPlayerAccount ( element )
				if ( not isGuestAccount ( a ) ) then
					e = getAccountName ( a )
				end 
				a = nil
			end 
		end 
	end 

	table.insert ( groups[group].log, 1, { time=getThisTime(), account=e, log=log } )
end 

function getGroupLog ( group )
	if ( group and groups [ group ] ) then
		local f = groups [ group ].log
		return f
	end 
end 


addEvent ( "NGGroups->GEvents:onPlayerClearGroupLog", true )
addEventHandler ( "NGGroups->GEvents:onPlayerClearGroupLog", root, function ( group ) 
	groupClearLog ( group )
	outputGroupLog ( group, "Cleared the logs", source )
	refreshPlayerGroupPanel ( source )
	-- memory sweep
	group = nil
end ) 

addEvent( "NGGroups->GroupStaff:OnAdminDeleteGroup", true );
addEventHandler ( "NGGroups->GroupStaff:OnAdminDeleteGroup", root, function ( group )
	exports.nglogs:outputActionLog ( "Staff "..source.name.." ("..source.account.name..") delete the '"..group.."' group" );
	
	for _, p in pairs ( getElementsByType ( "player" ) ) do 
		if ( tostring ( getElementData ( p, "Group" ) ) == group ) then 
			outputChatBox ( "Admin "..tostring(source.name).." has deleted your group.", p, 255, 0, 0 );
		end 
	end 
	
	deleteGroup ( group );
	
	refreshPlayerGroupPanel ( source );
end );


------------------------------
-- Misc Functions			--
------------------------------
function getThisTime ( )
	local time = getRealTime ( )
	local year = time.year + 1900
	local month = time.month + 1
	local day = time.monthday
	local hour = time.hour
	local min = time.minute
	local sec = time.second

	if ( month < 10 ) then month = 0 .. month end
	if ( day < 10 ) then day = 0 .. day end
	if ( hour < 10 ) then hour = 0 .. hour end
	if ( min < 10 ) then min = 0 .. min end
	if ( sec < 10 ) then sec = 0 .. sec end
	return table.concat ( { year, month, day }, "-") .. " "..table.concat ( { hour, min, sec }, ":" )
end 

function getGroupColor ( group )
	local r, g, b = 0, 0, 0
	if ( groups [ group ] ) then
		r, g, b  = groups[group].info.color.r, groups[group].info.color.g, groups[group].info.color.b
	end
	return r, g, b
end 

function setGroupColor ( group, r, g, b )
	if ( groups [ group ] ) then
		groups[group].info.color.r = r
		groups[group].info.color.g = g
		groups[group].info.color.b = b
		exports.ngturf:updateTurfGroupColor ( group )
		return true
	end 
	return false
end 

addEvent("NGGroups->Modules->Groups->Colors->UpdateColor",true)
addEventHandler("NGGroups->Modules->Groups->Colors->UpdateColor",root,function(group,r,g,b)
	outputGroupLog ( group, "Changed group color to ".. table.concat ( { r, g, b }, ", " ), source )
	setGroupColor ( group, r, g, b )
	refreshPlayerGroupPanel ( source )
end )


function isRankInGroup ( group, rank )
	if ( doesGroupExist ( group ) ) then
		if ( groups [ group ].ranks [ rank ] ) then
			return true
		end
	end
	return false
end 

function outputGroupMessage ( message, group, blockTag )

	local blockTag = blockTag or false

	if ( not blockTag ) then
		message = "("..tostring(group)..") "..tostring(message)
	end

	local r, g, b = getGroupColor ( group )
	local group = tostring ( group ):lower ( )
	for i, v in ipairs ( getElementsByType ( "player" ) ) do
		if ( tostring ( getElementData ( v, "Group" ) ):lower ( ) == group:lower() ) then
			outputChatBox ( message, v, r, g, b, true )
		end 
	end 
end 

function table.len ( t )
	local c = 0
	for i in pairs ( t ) do
		c = c + 1
	end
	return c
end

-- group chat --
addCommandHandler ( "gc", function ( plr, _, ... )
	local message = table.concat ( { ... }, " " )
	local g = getPlayerGroup ( plr )
	if ( not g ) then
		return exports.ngmessages:sendClientMessage ( "You cannot use this command, you're not in a group", plr, 255, 0, 0 )
	end

	if ( message:gsub ( " ", "" ) == "" ) then
		return exports.ngmessages:sendClientMessage ( "You didn't enter a message. Syntax: /gc message", plr, 255, 0, 0 )
	end

	outputGroupMessage("[Group] ".. exports.ngchat:getChatLine ( plr, message ), g, true )
end )