local _setElementData = setElementData
function setElementData ( element, group, value )
	return _setElementData ( element, group, value, true )
end

local turfLocs = { }
function createTurf ( x, y, z, width, height, owner, forcedId )
	local owner = tostring ( owner or "server" )
	local r, g, b = exports.NGGroups:getGroupColor ( owner )
	if not r then r = 255 end
	if not g then g = 255 end
	if not b then b = 255 end

	if ( owner == "server" ) then
		r, g, b = 255, 255, 255
	end

	local rad = createRadarArea ( x, y, width, height, r, g, b, 170, getRootElement ( ) )
	local col = createColCuboid ( x, y, z-5, width, height, 35)
	if ( not forcedId or turfLocs [ id ] ) then
		id = 0
		while ( turfLocs [ id ] ) do
			id = id + 1
		end
	else
		id = forcedId
	end

	turfLocs[id] = { }
	turfLocs[id].col = col
	turfLocs[id].radar = rad
	turfLocs[id].owner = owner or "server"
	turfLocs[id].attackers = nil
	turfLocs[id].attackProg = 0
	turfLocs[id].prepProg = 0
	setElementData ( turfLocs[id].col, "NGTurf:TurfId", id )
	setElementData ( turfLocs[id].col, "NGTurf:TurffingTable", turfLocs [ id ] )
	addEventHandler ( "onColShapeHit", turfLocs[id].col, onColShapeHit )
	addEventHandler ( "onColShapeLeave", turfLocs[id].col, onColShapeLeave )
	return turfLocs[id];
end

function updateTurfGroupColor ( group )
	local r, g, b = exports.nggroups:getGroupColor ( group )
	for i, v in pairs ( turfLocs ) do
		if ( v.owner == group ) then
			setRadarAreaColor ( v.radar, r, g, b, 120 )
		end 
	end 
end 

function onColShapeHit ( player ) 
	if ( player and isElement ( player ) and getElementType ( player ) == "player" and not isPedInVehicle ( player ) ) then
		local gang = exports.NGGroups:getPlayerGroup ( player )
		
		triggerClientEvent ( player, "NGTurfs:onClientEnterTurfArea", player, turfLocs [ id ] )
		if ( not gang ) then
			return exports.NGMessages:sendClientMessage ( "You're not in a gang, you cannot turf.", player, 255, 255, 0 )
		end

		local id = tonumber ( getElementData ( source, "NGTurf:TurfId" ) )
		if ( turfLocs[id].owner == gang ) then
			return
		end

		if ( turfLocs[id].attackers and turfLocs[id].attackers ~= gang ) then
			return exports.NGMessages:sendClientMessage ( "The "..tostring(turfLocs[id].attackers).." gang is already trying to take this turf. Try again later.", player, 255, 0, 0 )
		end

		if ( not turfLocs[id].attackers ) then
			exports.NGMessages:sendClientMessage ( "You have started to prepare a turf war. Find cover, call backup, and wait for it to begin.", player, 255, 255, 0 )
			local x, y, z = getElementPosition ( source )
			exports.NGGroups:outputGroupMessage ( getPlayerName ( player ).." is preparing a turf war with "..tostring(turfLocs[id].owner).." in "..getZoneName(x,y,z)..", "..getZoneName(x,y,z,true).."! Get there to help him, the war will start in 2 minutes!", gang, 255, 255, 0 )
			setRadarAreaFlashing ( turfLocs[id].radar, true )
			turfLocs[id].attackers = gang
			turfLocs[id].attackProg = 0
			turfLocs[id].prepProg = 0
			setElementData ( turfLocs[id].col, "NGTurf:TurffingTable", turfLocs [ id ] )
		end
	end
end

function onColShapeLeave ( player ) 
	if ( player and getElementType ( player ) == "player" ) then
		triggerClientEvent ( player, "NGTurfs:onClientExitTurfArea", player, turfLocs [ getElementData ( source, "NGTurf:TurfId" ) ] )
	end
end


setTimer ( function ( ) 
	for id, data in pairs ( turfLocs ) do 
		if ( data.attackers ) then
			local players = { attackers = { }, owners = { } }
			local isGangInTurf = false
			local isOwnerInTurf = false
			for i, v in pairs ( getElementsWithinColShape ( data.col, "player" ) ) do
				local g = exports.NGGroups:getPlayerGroup ( v )
				if ( g == data.attackers ) then
					isGangInTurf = true
					table.insert ( players.attackers, v )
				elseif ( g == data.owner ) then
					isOwnerInTurf = true
					table.insert ( players.owners, v )
				end
			end

			local x, y, z = getElementPosition ( data.col )
			if ( isOwnerInTurf and isGangInTurf ) then
				exports.NGGroups:outputGroupMessage ( "The turf war in "..getZoneName ( x,y,z )..", "..getZoneName ( x,y,z, true ).." is paused due to both gangs in the turf", turfLocs[id].attackers, 255, 255, 255 )
				exports.NGGroups:outputGroupMessage ( "The turf war in "..getZoneName ( x,y,z )..", "..getZoneName ( x,y,z, true ).." is paused due to both gangs in the turf", turfLocs[id].owner, 255, 255, 255 )
			else
				-- Add Points To Attackers
				if ( isGangInTurf ) then 
					-- Prep the war 
					if ( turfLocs[id].attackProg == 0 ) then
						turfLocs[id].prepProg = data.prepProg + 2
						if ( turfLocs[id].prepProg >= 100 ) then
							turfLocs[id].prepProg = 0
							turfLocs[id].attackProg = 1
							beginTurfWarOnTurf ( id )
						end
					-- Attack War
					else
						turfLocs[id].attackProg = turfLocs[id].attackProg + 1
						if ( turfLocs[id].attackProg == 100 ) then 
							exports.NGGroups:outputGroupMessage ( "Your gang has captured a turf in "..getZoneName ( x,y,z )..", "..getZoneName ( x,y,z, true ).." from the "..turfLocs[id].owner.." gang! Great job!", turfLocs[id].attackers, 0, 255, 0)
							exports.NGGroups:outputGroupMessage ( "Your gang lost a turf in "..getZoneName ( x,y,z )..", "..getZoneName ( x,y,z, true ).." to the "..turfLocs[id].attackers.." gang.", turfLocs[id].owner, 255, 0, 0)
							setTurfOwner ( id, turfLocs[id].attackers )
						end
					end
					
				-- Take points from attackers
				else 
					-- Prepare war
					if ( turfLocs[id].attackProg == 0 ) then
						turfLocs[id].prepProg = data.prepProg - 2
						if ( turfLocs[id].prepProg <= 0 ) then
							exports.NGGroups:outputGroupMessage ( "Your gang lost the turf preparation war in "..getZoneName(x,y,z)..", "..getZoneName ( x,y,z, true ).." to the "..turfLocs[id].owner.." gang!", turfLocs[id].attackers, 255, 0, 0 )
							exports.NGGroups:outputGroupMessage ( "Your gang has defended the turf in "..getZoneName(x,y,z)..", "..getZoneName(x,y,z,true).."!", turfLocs[id].owner..", from the "..turfLocs[id].attackers.." gang, when it was being preped for a war", 0, 255, 0 )
							setTurfOwner ( id, turfLocs[id].owner )
						end 
					-- Attacking war
					else 
						turfLocs[id].attackProg = data.attackProg - 1
						if ( turfLocs[id].attackProg <= 0 ) then
							exports.NGGroups:outputGroupMessage ( "Your gang lost the turf war in "..getZoneName(x,y,z)..", "..getZoneName ( x,y,z, true ).." to the "..turfLocs[id].owner.." gang!", turfLocs[id].attackers, 255, 0, 0 )
							exports.NGGroups:outputGroupMessage ( "Your gang has defended the turf in "..getZoneName(x,y,z)..", "..getZoneName(x,y,z,true).." from the "..turfLocs[id].attackers.." gang", turfLocs[id].owner, 0, 255, 0 )
							setTurfOwner ( id, turfLocs[id].owner )
						end 
					end
				end
			end
			for i, v in pairs ( players ) do
				for k, p in pairs ( v ) do 
					triggerClientEvent ( p, "NGTurfs:upadateClientInfo", p, turfLocs [ id ] )
				end
			end
		end
	end
end, 800, 0 )
addEvent ( "NGTurfs:onTurfProgressChange", true )

--[[
addCommandHandler ( "attackprog", function ( p )
	local gangAttacks = { }
	local g = exports.NGGroups:getPlayerGroup ( p )
	if ( not g ) then
		return exports.NGMessages:sendclientMessage ( "You're not in a gang", p, 255, 255, 0)
	end

	for i, v in pairs ( turfLocs ) do
		if ( v.attackers and v.attackers == g ) then
			gangAttacks [ i ] = true
		end 
	end 

	if ( table.len ( gangAttacks ) == 0 ) then
		return exports.NGMessages:sendClientMessage ( "Your gang isn't involved in any gang wars right now.", p, 255, 255, 0 )
	end 

	for id, _ in pairs ( gangAttacks ) do 
		local x ,y, z = getElementPosition ( turfLocs[id].col )
		outputChatBox ( "----Turf War Status---", p, 255, 255, 255, false )
		outputChatBox ( "Current owner: "..turfLocs[id].owner, p, 255, 255, 255, false )
		outputChatBox ( "Attacker: "..turfLocs[id].attackers, p, 255, 255, 255, false )
		outputChatBox ( "Prep Progress: "..turfLocs[id].prepProg.."%", p, 255, 255, 255, false )
		outputChatBox ( "Attack Progress: "..turfLocs[id].attackProg.."%", p, 255, 255, 255, false )
		outputChatBox ( "Turf Location: "..getZoneName ( x, y, z )..", "..getZoneName ( x, y, z, true ), p, 255, 255, 255, false )
		outputChatBox ( "Turf Server-ID: "..id, p, 255, 255, 255, false )
	end

end )]]

function table.len ( tb ) 
	local c = 0
	for i, v in pairs ( tb ) do
		c = c + 1
	end
	return c
end

function beginTurfWarOnTurf ( id )
	local d = turfLocs [ id ]
	local x, y, z = getElementPosition ( d.col ) 
	exports.NGGroups:outputGroupMessage ( "Your gang has begun a turf war in "..getZoneName ( x, y, z)..", "..getZoneName ( x, y, z, true ).." against the "..d.owner.." gang! Get there an help!", d.attackers, 255, 255, 0 )
	exports.NGGroups:outputGroupMessage ( "One of your turfs in "..getZoneName ( x, y, z)..", "..getZoneName ( x, y, z, true ).." is being attacked by the "..d.attackers.." gang!", d.owners, 255, 0, 0 )
	setRadarAreaColor ( d.radar, 255, 255, 255, 170 )
end

function setTurfOwner ( id, owner )
	setRadarAreaFlashing ( turfLocs[id].radar, false )
	turfLocs[id].owner = owner
	turfLocs[id].attackers = nil
	turfLocs[id].attackProg = 0
	local r, g, b = exports.NGGroups:getGroupColor ( owner )
	setRadarAreaColor ( turfLocs[id].radar, r, g, b, 120 )
	saveTurfs ( )
end

function getTurfs ( ) 
	return turfLocs
end 

function saveTurfs ( )
	for id, data in pairs ( turfLocs ) do 
		exports.NGSQL:db_exec ( "UPDATE turfs SET owner=? WHERE id=?", data.owner, id )
	end
	return true
end

addEventHandler( "onResourceStart", resourceRoot, function ( )
	exports.NGSQL:db_exec ( "CREATE TABLE IF NOT EXISTS turfs ( id INT, owner VARCHAR(50), x FLOAT, y FLOAT, z FLOAT, width INT, height INT )" )
	local query = exports.NGSQL:db_query ( "SELECT * FROM turfs" )
	if ( #query == 0 ) then 
		local data = { 
			{ -1867.8, -107.43, 15.1, 58, 65 },
			{ -1866.5, -26.36, 15.29, 49, 200 },
			{ -1811.33, 743.43, 20, 85, 85 },
			{ -1991.5, 862.62, 34, 79, 42 },
			{ -2799.25, -200.6, 7.19, 83, 120 },
			{ -2136.84, 120.12, 30, 120, 190 },
			{ -2516.52, 718.16, 27.97, 118, 80 },
			{ -2516.41, 578.19, 16.62, 117, 120 },
			{ -2596.49, 818.05, 49.98, 59, 80 },
			{ -2453.17, 947.58, 45.43, 54, 80  },
			{ -2740.6, 344.59, 4.41, 68, 61 },
			{ -2696.24, 227.35, 4.33, 39.5, 50.5 },
			{ -2397.31, 82.99, 35.3, 133, 160 },
			{ -2095.33, -280.06, 35.32, 84, 176 },
			{ -1980.58, 107.69, 27.68, 59, 62 },
			{ -2129.01, 741.71, 48, 112, 57 },
			{ -2243.24, 928.4, 66.65, 87, 154 },
			{ -1701.62, 743.44, 10, 129, 83 },
			{ -2696.23, -59.88, 4.73, 83, 89 },
			{ -2541.18, -720.16, 135, 55, 125 }
		}
		outputDebugString ( "NGTurf: 0 Turfs found -- Generating ".. tostring ( #data ) )
		for i, v in pairs ( data ) do 
			x = { 
				['x'] = v[1],
				['y'] = v[2],
				['z'] = v[3],
				['width'] = v[4],
				['height'] = v[5],
				['owner'] = "server"
			}
			
			query[i] = x;
			
			exports.NGSQL:db_exec ( "INSERT INTO turfs ( id, owner, x, y, z, width, height ) VALUES ( ?, ?, ?, ?, ?, ?, ? )",
				tostring ( i ), "server", tostring ( x['x'] ), tostring ( x['y'] ), tostring ( x['z'] ), tostring ( x['width'] ), x['height'] );
		end
	end 
	
	for i, v in pairs ( query ) do
		local id, owner, x, y, z, width, height = tonumber ( v['id'] ), v['owner'], tonumber ( v['x'] ), tonumber ( v['y'] ), tonumber ( v['z'] ), tonumber ( v['width'] ), tonumber ( v['height'] )
		createTurf ( x, y, z, width, height, owner, id )
	end
end )




-- Group payout timer 
function sendTurfPayout ( ) 
	local groupTurfs = { }
	for i, v in pairs ( turfLocs ) do 
		if ( not groupTurfs [ v.owner ] ) then 
			groupTurfs [ v.owner ] = 0
		end 

		if ( not v.attackers ) then 
			groupTurfs [ v.owner ] = groupTurfs [ v.owner ] + 1
		end   
	end

	for i, v in pairs ( getElementsByType ( 'player' ) ) do 
		local g = exports.NGGroups:getPlayerGroup ( v ) 
		if ( g and groupTurfs [ g ] and groupTurfs [ g ] > 0 ) then 
			local c = groupTurfs [ g ] * tonumber ( get ( "*PAYOUT_CASH" ) )
			givePlayerMoney ( v, c )
			exports.NGMessages:sendClientMessage ( "Turfing: Here is $"..tostring(c).." for having "..tostring ( groupTurfs [ g ] ).." turfs ($700/turf)", v, 0, 255, 0 )
		end
	end
end 
setTimer ( sendTurfPayout, (60*tonumber(get("*PAYOUT_TIME")))*1000, 0 )