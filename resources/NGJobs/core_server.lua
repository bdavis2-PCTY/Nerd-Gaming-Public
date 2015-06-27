max_wanted = {
    community = 2,
    law = 1,
    criminal = 7
}

jobRanks = {
    ['criminal'] = {
        [0] = "L.G",
        [50] = "L.Y.G",
        [75] = "Y.G",
        [120] = "OYG",
        [200] = "O.G",
        [310] = "G.C.L",
        [499] = "G.L",
    },
    ['police officer'] = {
        [0] ="Officer",
        [90]="Corporal",
        [200]="Trooper",
        [310]="Sergeant",
        [450]="Captain",
        [600]="Commander",
        [900]="Chief of Police",
    },
    ['medic'] = {
        [0] = "Assistant",
        [50] = "Training",
        [100]= "Nurse",
        [130] = "Paramedic",
        [200] = "Doctor",
        [260] = "Surgeon"
    },
    ['mechanic'] = {
        [0] = "Rookie",
        [40] = "Wheel Specialist",
        [100]= "Engine Specialist",
        [140]= "Vehicle Professional",
        [200]= "Motorcycle Specialist",
        [245]= "Vehicle Master"
    },
    ['fisherman'] = {
        [0] = "Deck Hand",
        [20]= "Net Baiter",
        [75]= "Line Thrower",
        [100]="Line Roller",
        [140]="Boat Captain",
        [200]="Experienced Fisherman",
        [270]="Underwater Trap Setter"
    },
	['detective'] = {
		[0] = "Detective"
	},
	['pilot'] = {
		[0] = "Junior flight officer",
		[25] = "Flight Officer",
		[50] = "First Officer",
		[120] = "Captain",
		[180] = "Senior Captain",
		[250] = "Commercial First Officer",
		[310] = "Commercial Captain",
		[390] = "Commercial Commander",
		[460] = "Commercial Senior Commander",
	},
	['stunter'] = {
		[0] = "Crash Dummy",
		[50] = "Crash",
		[150] = "Experienced",
		[200] = "Professional",
		[300] = "Expert BMXer"
	}
}

function getJobRankTable ( )
	return jobRanks
end

exports['Scoreboard']:scoreboardAddColumn  ( "Job", root, 90, "Job", 4 )
exports['Scoreboard']:scoreboardAddColumn  ( "Job Rank", root, 90, "Job Rank", 5 )

function create3DText ( str, pos, color, parent, settings ) 
    if str and pos and color then
        local text = createElement ( '3DText' )
        local settings = settings or  { }
        setElementData ( text, "text", str )
        setElementData ( text, "position", pos )
        setElementData ( text, "color", color )
        if ( not parent ) then
            parent = nil
        else
            if ( isElement ( parent ) ) then
                parent = parent
            else
                parent = nil
            end
        end
        setElementData ( text, "Settings", settings )
        setElementData ( text, "parentElement", parent )
        setElementData ( text, "sourceResource", sourceResource or getThisResource ( ))
        return text
    end
    return false
end

addEventHandler ( "onResourceStop", root, function ( r )
    for i, v in pairs ( getElementsByType ( "3DText" ) ) do
        if ( r == getElementData ( v, "sourceResource" ) ) then
            destroyElement ( v )
        end 
    end 
end )

function createJob ( name, x, y, z, rz )
    if ( name == 'Criminal' ) then
        create3DText ( 'Criminal', { x, y, z }, { 255, 0, 0 }, { nil, true } )
        local p = createElement ( "GodmodePed" )
        setElementData ( p, "Model", 109 )
        setElementData ( p, "Position", { x, y, z, rz } )
        createBlip ( x, y, z, 59, 2, 255, 255, 255, 255, 0, 450 )
        addEventHandler ( 'onMarkerHit', createMarker ( x, y, z - 1, 'cylinder', 2, 0, 0, 0, 0 ), function ( p )
            if ( getElementType ( p ) == 'player' and not isPedInVehicle ( p ) and not isPedDead ( p ) ) then
                if ( getPlayerWantedLevel ( p ) > max_wanted.criminal ) then
                    return exports['NGMessages']:sendClientMessage ( "The max wanted level for this job is "..tostring ( max_wanted.criminal )..".", p, 255, 0, 0 )
                end 
                triggerClientEvent ( p, 'NGJobs:OpenJobMenu', p, 'criminal' )
            end
        end )
        
    ----------------------------------
	-- Law Jobs						--
	----------------------------------    
    elseif ( name == 'Police' ) then
        create3DText ( 'Police', { x, y, z }, { 0, 100, 255 }, { nil, true } )
        local p = createElement ( "GodmodePed" )
        setElementData ( p, "Model", 281 )
        setElementData ( p, "Position", { x, y, z, rz } )
        createBlip ( x, y, z, 61, 2, 255, 255, 255, 255, 0, 450 )
        addEventHandler ( 'onMarkerHit', createMarker ( x, y, z - 1, 'cylinder', 2, 0, 0, 0, 0 ), function ( p )
            if ( getElementType ( p ) == 'player' and not isPedInVehicle ( p ) and not isPedDead ( p ) ) then
                if ( getPlayerWantedLevel ( p ) > max_wanted.law ) then
                    return exports['NGMessages']:sendClientMessage ( "The max wanted level for this job is "..tostring ( max_wanted.law )..".", p, 255, 0, 0 )
                end
                triggerClientEvent ( p, 'NGJobs:OpenJobMenu', p, 'police' )
            end
        end )
		
	elseif ( name == 'Detective' ) then
        create3DText ( 'Detective', { x, y, z }, { 0, 120, 255 }, { nil, true } )
        local p = createElement ( "GodmodePed" )
        setElementData ( p, "Model", 17 )
        setElementData ( p, "Position", { x, y, z, rz } )
        createBlip ( x, y, z, 61, 2, 255, 255, 255, 255, 0, 450 )
        addEventHandler ( 'onMarkerHit', createMarker ( x, y, z - 1, 'cylinder', 2, 0, 0, 0, 0 ), function ( p )
            if ( getElementType ( p ) == 'player' and not isPedInVehicle ( p ) and not isPedDead ( p ) ) then
                if ( getPlayerWantedLevel ( p ) > max_wanted.law ) then
                    return exports['NGMessages']:sendClientMessage ( "The max wanted level for this job is "..tostring ( max_wanted.law )..".", p, 255, 0, 0 )
                end
				
				local arrests = getJobColumnData ( getAccountName ( getPlayerAccount ( p ) ), getDatabaseColumnTypeFromJob ( "police officer" ) )
				if ( arrests < 150 ) then
					return exports.NGMessages:sendClientMessage ( "This job requires at least 150 arrests", p, 255, 255, 0 )
				end
				
                triggerClientEvent ( p, 'NGJobs:OpenJobMenu', p, 'detective' )
            end
        end )
		
		
	----------------------------------
	-- Emergency Jobs				--
	----------------------------------
    elseif ( name == 'Medic' ) then
        create3DText ( 'Medic', { x, y, z }, { 0, 255, 255 }, { nil, true } )
        local p = createElement ( "GodmodePed" )
        setElementData ( p, "Model", 274 )
        setElementData ( p, "Position", { x, y, z, rz } )
        createBlip ( x, y, z, 58, 2, 255, 255, 255, 255, 0, 450 )
        addEventHandler ( 'onMarkerHit', createMarker ( x, y, z - 1, 'cylinder', 2, 0, 0, 0, 0 ), function ( p )
            if ( getElementType ( p ) == 'player' and not isPedInVehicle ( p ) and not isPedDead ( p ) ) then
                if ( getPlayerWantedLevel ( p ) > max_wanted.community ) then
                    return exports['NGMessages']:sendClientMessage ( "The max wanted level for this job is "..tostring ( max_wanted.community )..".", p, 255, 0, 0 )
                end
                triggerClientEvent ( p, 'NGJobs:OpenJobMenu', p, 'medic' )
            end
        end )
		
    ----------------------------------
	-- Community Jobs				--
	----------------------------------
	elseif ( name == 'Mechanic' ) then
        create3DText ( 'Mechanic', { x, y, z }, { 255, 255, 0 }, { nil, true } )
        local p = createElement ( "GodmodePed" )
        setElementData ( p, "Model", 30 )
        setElementData ( p, "Position", { x, y, z, rz } )
        createBlip ( x, y, z, 60, 2, 255, 255, 255, 255, 0, 450 )
        addEventHandler ( 'onMarkerHit', createMarker ( x, y, z - 1, 'cylinder', 2, 0, 0, 0, 0 ), function ( p )
            if ( getElementType ( p ) == 'player' and not isPedInVehicle ( p ) and not isPedDead ( p ) ) then
                if ( getPlayerWantedLevel ( p ) > max_wanted.community ) then
                    return exports['NGMessages']:sendClientMessage ( "The max wanted level for this job is "..tostring ( max_wanted.community )..".", p, 255, 0, 0 )
                end
                triggerClientEvent ( p, 'NGJobs:OpenJobMenu', p, 'mechanic' )
            end
        end )
    elseif ( name == 'Fisher' ) then
        create3DText ( 'Fisher', { x, y, z }, { 255, 255, 0 }, { nil, true } )
        local p = createElement ( "GodmodePed" )
        setElementData ( p, "Model", 45 )
        setElementData ( p, "Position", { x, y, z, rz } )
        createBlip ( x, y, z, 60, 2, 255, 255, 255, 255, 0, 450 )
        addEventHandler ( 'onMarkerHit', createMarker ( x, y, z - 1, 'cylinder', 2, 0, 0, 0, 0 ), function ( p )
            if ( getElementType ( p ) == 'player' and not isPedInVehicle ( p ) and not isPedDead ( p ) ) then
                if ( getPlayerWantedLevel ( p ) > max_wanted.community ) then
                    return exports['NGMessages']:sendClientMessage ( "The max wanted level for this job is "..tostring ( max_wanted.community )..".", p, 255, 0, 0 )
                end
                triggerClientEvent ( p, 'NGJobs:OpenJobMenu', p, 'fisherman' )
            end
        end )
	elseif ( name == "Pilot" ) then
		create3DText ( 'Pilot', { x, y, z }, { 255, 255, 0 }, { nil, true } )
        local p = createElement ( "GodmodePed" )
        setElementData ( p, "Model", 61 )
        setElementData ( p, "Position", { x, y, z, rz } )
        createBlip ( x, y, z, 60, 2, 255, 255, 255, 255, 0, 450 )
        addEventHandler ( 'onMarkerHit', createMarker ( x, y, z - 1, 'cylinder', 2, 0, 0, 0, 0 ), function ( p )
            if ( getElementType ( p ) == 'player' and not isPedInVehicle ( p ) and not isPedDead ( p ) ) then
                if ( getPlayerWantedLevel ( p ) > max_wanted.community ) then
                    return exports['NGMessages']:sendClientMessage ( "The max wanted level for this job is "..tostring ( max_wanted.community )..".", p, 255, 0, 0 )
                end
                triggerClientEvent ( p, 'NGJobs:OpenJobMenu', p, 'pilot' )
            end
        end )
	elseif ( name == 'Stunter' ) then
		create3DText ( 'Stunter', { x, y, z }, { 255, 255, 0 }, { nil, true } )
        local p = createElement ( "GodmodePed" )
        setElementData ( p, "Model", 23 )
        setElementData ( p, "Position", { x, y, z, rz } )
        createBlip ( x, y, z, 60, 2, 255, 255, 255, 255, 0, 450 )
        addEventHandler ( 'onMarkerHit', createMarker ( x, y, z - 1, 'cylinder', 2, 0, 0, 0, 0 ), function ( p )
            if ( getElementType ( p ) == 'player' and not isPedInVehicle ( p ) and not isPedDead ( p ) ) then
                if ( getPlayerWantedLevel ( p ) > max_wanted.community ) then
                    return exports['NGMessages']:sendClientMessage ( "The max wanted level for this job is "..tostring ( max_wanted.community )..".", p, 255, 0, 0 )
                end
                triggerClientEvent ( p, 'NGJobs:OpenJobMenu', p, 'stunter' )
            end
        end )
    end
end
createJob ( 'Criminal', 1625.92, -1508.65, 13.6, 180 )
createJob ( 'Criminal', 2141.75, -1733.94, 17.28, 0 )
createJob ( 'Criminal', 2460.31, 1324.94, 10.82, -90 )
createJob ( 'Criminal', 1042.26, 2154.03, 10.82, -90 )
createJob ( 'Criminal', -1832.49, 584.03, 35.16, 0 )
createJob ( 'Criminal', 2124.29, 889.1, 11.18, -90 )
createJob ( 'Criminal', -2530.02, -624.22, 132.75, 0 )
createJob ( 'Mechanic', 2276.12, -2359.67, 13.55, 318 )
createJob ( 'Mechanic', -1710.16, 403.56, 7.42, 140.4 )
createJob ( 'Mechanic', 1658.34, 2199.65, 10.82, 180 )
createJob ( 'Pilot', 2003.13, -2294.49, 13.55, 90 )
createJob ( 'Pilot', 1651.48, 1614.14, 10.82, -90 )
createJob ( 'Pilot', -1253.7, 16.99, 14.15, 131 )
createJob ( 'Police', 1576.59, -1634.24, 13.56, 90 )
createJob ( 'Police', -1614.66, 682.42, 7.19, 90 )
createJob ( 'Police', 2297.12, 2463.87, 10.82, 90 )
createJob ( 'Medic', 1177.88, -1329.2, 14.08, 0 )
createJob ( 'Medic', 1615.18, 1819.67, 10.83, 0 )
createJob ( 'Fisher', 2158.27, -98.15, 2.81, 27.44 )
createJob ( "Detective", 1559.69, -1690.48, 5.89, 180 )
createJob ( "Detective",-1573.45, 653.08, 7.19, 90 )
createJob ( "Detective", 2297.12, 2455.66, 10.82, 90 )
createJob ( "Stunter", 1948.64, -1364.5, 18.58, 90 )
createJob ( "Criminal", 2143.14, -1583.53, 14.35, 180 );
createJob ( "Criminal", 2216.16, 2711.91, 10.82, -90 );



function setPlayerJob ( p, job, prtyJob )
    if ( isGuestAccount ( getPlayerAccount ( p ) ) ) then
        return exports['NGMessages']:sendClientMessage ( "You need to be logged in to take a job.", p, 255, 0, 0 )
    end

    exports['NGLogs']:outputActionLog ( getPlayerName ( p ).." is now employed as a "..tostring ( job ) )
    addPlayerToJobDatabase ( p )

    local weapons = { }
	for i=1,12 do 
		weapons[i] = { 
			weap = getPedWeapon ( source, i ),
			ammo = getPedTotalAmmo ( source, i ) 
		} 
	end

    if ( job == 'criminal' ) then
		local skin = getElementData ( p, 'NGUser.UnemployedSkin' )
		if ( not tonumber ( skin ) ) then skin = 109
		else skin = tonumber ( skin ) end
	
        setElementData ( p, 'Job', 'Criminal' )
        exports['NGPlayerFunctions']:setTeam ( p, "Criminals" )
        setElementModel ( p, skin )
        job = "Criminal"
    elseif ( job == 'mechanic' ) then
        setElementData ( p, 'Job', 'Mechanic' )
        exports['NGPlayerFunctions']:setTeam ( p, "Services" )
        setElementModel ( p, 30 )
        job = "Mechanic"
    elseif ( job == 'police' ) then
        setElementData ( p, 'Job', 'Police Officer' )
        exports['NGPlayerFunctions']:setTeam ( p, "Law Enforcement" )
        setElementModel ( p, 281 )
        job = "Police Officer"
       weapons[1] = { weap=3, ammo=2 }
    elseif ( job == "medic" ) then
        job = "Medic"
        setElementData ( p, "Job", "Medic" )
        setElementModel ( p, 274 )
        exports['NGPlayerFunctions']:setTeam ( p, "Emergency" )
    elseif ( job == "fisherman" ) then
        job = "Fisherman"
        setElementData ( p, "Job", "Fisherman" )
        setElementModel ( p, 45 )
        exports['NGPlayerFunctions']:setTeam ( p, "Services" )
	elseif ( job == "detective" ) then
		job = "Detective"
        setElementData ( p, "Job", "Detective" )
        setElementModel ( p, 17 )
        exports['NGPlayerFunctions']:setTeam ( p, "Law Enforcement" )
        weapons[1] = { weap=3, ammo=2 }
	elseif ( job == "pilot" ) then
		job = "Pilot"
        setElementData ( p, "Job", "Pilot" )
        setElementModel ( p, 61 )
        exports['NGPlayerFunctions']:setTeam ( p, "Services" )
    elseif ( job == 'stunter' ) then
		job = "Stunter"
		local skin = tonumber ( getElementData ( p, "NGUser.UnemployedSkin" ) ) or 23
        setElementData ( p, "Job", "Stunter" )
        setElementModel ( p, skin )
        exports['NGPlayerFunctions']:setTeam ( p, "Services" )
	end
    if ( prtyJob ) then
        job = prtyJob 
    end

   	takeAllWeapons ( p )
   	for i, v in pairs ( weapons ) do
   		giveWeapon ( p, v.weap, v.ammo )
   	end 

    exports['NGMessages']:sendClientMessage ( "You're now employed as a "..tostring ( job ).."!", p, 0, 255, 0 )
    updateRank ( p, job )
	
	triggerEvent ( "NGJobs:onPlayerJoinNewJob", p, tostring ( job ):lower ( ) )
	weapons = nil
end
addEvent ( 'NGJobs:SetPlayerJob', true )
addEventHandler ( 'NGJobs:SetPlayerJob', root, function ( j ) setPlayerJob ( source, j ) end )

function getJobType ( job )
    local job = string.lower ( tostring ( job ) )
    if ( job == "criminal" or job == "unemployed" ) then
        return "criminal"
    elseif ( job == "medic" or job == "mechanic" or job == "fisherman" or job == 'pilot' or job == "stunter" ) then
        return "community"
    elseif ( job == "police officer" or job == "detective" ) then
        return "law" 
    end
end

function updateRank ( p, job )
    local job = tostring ( job ):lower ( )
    local rank = "None"
    local current = 0
    local column = getDatabaseColumnTypeFromJob ( job )
    local data = getJobColumnData ( getAccountName ( getPlayerAccount ( p ) ), column or "" )
    if ( jobRanks[job] ) then
        for i, v in pairs ( jobRanks[job] ) do 
            if ( data >= i and i >= current ) then
                rank = v
                current = i
            end
        end
    end
    setElementData ( p, "Job Rank",tostring ( rank ) )
    if ( job == "fisherman" ) then
        fisherman_refreshMaxCatch ( p )
    end
end

function getDatabaseColumnTypeFromJob ( job )
    local column = "None"
    local job = tostring ( job ):lower ( )
    if ( job == "criminal" ) then
        column="CriminalActions"
    elseif ( job == "mechanic" ) then
        column = "FixedVehicles"
    elseif ( job == "police officer" ) then
        column = "Arrests"
    elseif ( job == "medic" ) then
        column = "HealedPlayers"
    elseif ( job == "fisherman" ) then
        column = "CaughtFish"
	elseif ( job == "detective" ) then
		column = "SolvedCrims"
	elseif ( job == "pilot" ) then
		column = "completeflights"
	elseif ( job == "stunter" ) then
		column = "stunts"
    end
    return column
end

function addPlayerToJobDatabase ( p )
    local acc = getPlayerAccount ( p )
    if ( isGuestAccount ( acc ) ) then
        return false
    end
    local data = exports['NGSQL']:db_query ( "SELECT * FROM jobdata WHERE Username=? LIMIT 1", getAccountName ( acc ) )
    if ( type ( data ) ~= "table" or #data < 1 ) then
        exports['NGSQL']:db_exec ( "INSERT INTO jobdata ( `Username`, `Arrests`, `TimesArrested`, `CriminalActions`, `FixedVehicles`, `HealedPlayers`, `TowedVehicles`, `CaughtFish`, `SolvedCrims`, `completeflights`, `stunts` ) VALUES ( '"..getAccountName ( acc ) .."', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0' );" )
        return true
    end
    return false
end

exports['NGSQL']:db_exec ( "CREATE TABLE IF NOT EXISTS jobdata ( Username TEXT, Arrests INT, TimesArrested INT, CriminalActions INT, FixedVehicles INT, HealedPlayers INT, TowedVehicles INT, CaughtFish INT, SolvedCrims INT, completeflights INT, stunts INT )" )
function updateJobColumn ( user, col, to ) 
    if ( user and col and to ) then
        if ( type ( user ) == 'string' and type ( col ) == 'string' ) then
            if ( to ~= "AddOne" ) then
                exports['NGSQL']:db_exec ( "UPDATE jobdata SET "..tostring ( col ).."='"..to.."' WHERE Username='"..user.."'" )
                return true
            elseif ( to == "AddOne" ) then
                local q = exports['NGSQL']:db_query ( "SELECT "..tostring ( col ).." FROM jobdata WHERE Username='"..user.."'" )
                local to = q[1][col]+1
                exports['NGSQL']:db_exec ( "UPDATE jobdata SET "..tostring ( col ).."='"..to.."' WHERE Username='"..user.."'" )
                return true
            end
        end
    end
    return false
end

function getJobColumnData ( user, col )
    if user and col then
        local user, col = tostring ( user ), tostring ( col )
        local q = exports['NGSQL']:db_query ( "SELECT * FROM jobdata WHERE Username=?", user )
        if ( q and q[1] ) then
        	return q[1][col] or 0
        else
        	return 0
        end
    end
end

function outputTeamMessage ( msg, team, r, g, b )
    for i, v in ipairs ( getPlayersInTeam ( getTeamFromName ( team ) ) ) do
        exports['NGMessages']:sendClientMessage ( msg, v, r, g, b )
    end
    return true
end

function resignPlayer ( player, forced )
    if ( player and isElement ( player ) and getElementType ( player ) == 'player' ) then
		if ( forced == nil ) then
			forced = true
		end
		
		local j = getElementData ( player, "Job" )
		local r = getElementData ( player, "Job Rank" )
        setElementData ( player, "Job", "UnEmployed" )
        exports['NGPlayerFunctions']:setTeam ( player, "Unemployed" )
        setElementData ( player, "Job Rank", "None" )
		if ( isPedInVehicle ( player ) ) then removePedFromVehicle ( player ) end
		local skin = tonumber ( getElementData ( player, "NGUser.UnemployedSkin" ) )
		if ( not skin ) then
			setElementData ( player, "NGUser.UnemployedSkin", 28 )
			skin = 28
		end
		
		triggerClientEvent ( player, "onPlayerResign", player, j, r, skin )
        setPedSkin ( player, skin )
    end
end

addCommandHandler ( "resign", function ( player )
	if ( isPedInVehicle ( player ) ) then
		return exports.NGMessages:sendClientMessage ( "Get out of your vehicle to use this command.", player, 255, 255, 0 )
	end
	resignPlayer ( player )
end )


function createJobPickup ( x, y, z, id, jobs )
    local e = createPickup ( x, y, z, 2, id, 50, 1 )
    setElementData ( e, "NGJobs:pickup.jobLock", jobs )
    addEventHandler ( "onPickupHit", e, function ( p )
        if ( getElementType ( p ) ~= "player" or isPedInVehicle ( p ) ) then return end
        local jobs = getElementData ( source, "NGJobs:pickup.jobLock" )
        local job = getElementData ( p, "Job" ) or ""
        local done = false
        for i, v in ipairs ( jobs ) do
            if ( v == job ) then
                done = true
                break
            end
        end 
        if ( not done or isPedInVehicle ( p ) ) then
            if ( not isPedInVehicle ( p ) ) then
                exports['NGMessages']:sendClientMessage ( "You don't have access to this pickup.", p, 255, 255, 0 )
            end
            cancelEvent ( )
        end
    end )
end
createJobPickup ( 1576.18, -1620.43, 13.55, 3, { "Police Officer", "Detective" } )
createJobPickup ( 1177.97, -1319.01, 14.1, 14, { "Medic" } )





function table.size(tab)
    local length = 0
    for _ in pairs(tab) do length = length + 1 end
    return length
end

function table.nextIndex ( tab, i2 )
    local isTHis = false
    for i, v in pairs ( tab ) do
        if ( isThis ) then
            return i
        end
        if ( i == i2 ) then
            isThis = true
        end
    end
end


addEvent ( "NGJobs->GivePlayerMoney", true )
addEventHandler ( "NGJobs->GivePlayerMoney", root, function ( player, amount, msg ) 
	givePlayerMoney ( player, amount )
	if ( msg ) then
		exports.NGMessages:sendClientMessage ( msg, player, 0, 255, 0 )
	end
end )


addEvent ( "NGJobs->SQL->UpdateColumn", true )
addEventHandler ( "NGJobs->SQL->UpdateColumn", root, function ( player, column, to )
	updateJobColumn ( getAccountName ( getPlayerAccount ( player ) ), column, to )
	
	local j = tostring ( getElementData ( player, "Job" ):lower ( ) )
	updateRank ( player, j )
end )

addEvent ( "NGJobs:onPlayerJoinNewJob", true )

function foreachinorder(t, f, cmp)
    local keys = {}
    for k,_ in pairs(t) do
        keys[#keys+1] = k
    end
    table.sort(keys,cmp)
    local data = { }
    for _, k in ipairs ( keys ) do 
    	table.insert ( data, { k, t[k] } )
    end 
    return data
end