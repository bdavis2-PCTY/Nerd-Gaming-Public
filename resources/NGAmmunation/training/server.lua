local warpLocs = { 
	--[[ format:
	{ 
		{ the create position },
		{ the warp position },
		{ int, dim }
	} ]]
	
	-- LS
	{{286.33, -30.39, 1001.52},{286.19, -27, 1002},{1,0}},
	{{286.16, -28.5, 1001.52},{286.19, -32, 1002},{1,0}},
	{{286.33, -30.39, 1001.52},{286.19, -27, 1002},{1,1}},
	{{286.16, -28.5, 1001.52},{286.19, -32, 1002},{1,1}},
}

local trainingLocs = {
	
	--[[ Format;
		["Interior|Dimension"] = {
			{ x, y, z },
			{ x, y, z }
		}
	]]
	
	-- LS:
	["1|0"] = {
		{ 289.26, -24.97, 1001.52 },
		{ 290.78, -24.97, 1001.52 },
		{ 292.25, -24.97, 1001.52 },
		{ 293.72, -24.97, 1001.52 },
		{ 295.25, -24.97, 1001.52 },
		{ 296.58, -24.97, 1001.52 },
		{ 298.32, -24.97, 1001.52 },
		{ 299.69, -24.97, 1001.52 },
	},

	["1|1"] = {
		{ 289.26, -24.97, 1001.52 },
		{ 290.78, -24.97, 1001.52 },
		{ 292.25, -24.97, 1001.52 },
		{ 293.72, -24.97, 1001.52 },
		{ 295.25, -24.97, 1001.52 },
		{ 296.58, -24.97, 1001.52 },
		{ 298.32, -24.97, 1001.52 },
		{ 299.69, -24.97, 1001.52 },
	}
}

for i, v in pairs ( warpLocs ) do
	local x, y, z = unpack ( v [ 1 ] )
	local m = createMarker ( x, y, z + 0.9, "arrow", 1.5, 255, 255, 255, 150 )
	setElementInterior ( m, v[3][1] )
	setElementDimension ( m, v[3][2] )
	setElementData(m,"NGAmmunation:markerWarpInformation",{v[2],v[3]})
	addEventHandler ( "onMarkerHit", m, function ( p )
		local d = getElementData ( source, "NGAmmunation:markerWarpInformation" )
		if ( isElement ( p ) and not isPedInVehicle ( p ) and getElementInterior(p)==d[2][1] and getElementDimension(p)==d[2][2] ) then
			setElementPosition ( p, unpack ( d [ 1 ] ) )
		end
	end )
end



for int_, locs in pairs ( trainingLocs ) do
	local s = split ( int_, "|" )
	local interior = tonumber ( s [ 1 ] )
	local dimension = tonumber ( s [ 2 ] )
	for i, v in pairs ( locs ) do
		local x, y, z = unpack ( v )
		local m = createMarker ( x, y, z-0.5, "cylinder", 1.3, 0, 0, 0, 0 )
		local m_ = createMarker ( x, y, z-1, "cylinder", 1, math.random(100,255), math.random(100,255), 255, 100 )
		setElementData ( m, "NGAmmunation:TrainingMarkerInformation", { int = interior, dim = dimension } )
		setElementInterior ( m, interior )
		setElementInterior ( m_, interior )
		setElementDimension ( m, dimension )
		setElementDimension ( m_, dimension )
		addEventHandler ( "onMarkerHit", m, function ( p )
			local d = getElementData ( source, "NGAmmunation:TrainingMarkerInformation" )
			if not d then return end
			if ( getElementInterior ( p ) == d.int and getElementDimension ( p ) == d.dim ) then
				triggerClientEvent ( p, "NGAmmunation:Module->Training:onClientHitMarker", p, source )
			end
		end )
	end
end

local weaponRankData = { 
	['9mm'] = 69,
	['silenced'] = 70,
	['deagle'] = 71,
	['shotgun'] = 72,
	['combat_shotgun'] = 74,
	['micro_smg'] = 75,
	['mp5'] = 76,
	['ak47'] = 77,
	['m4'] = 78,
	['tec-9'] = 75,
	['sniper_rifle'] =79
}

addEvent ( "NGAmmunation:Modules->Training:onClientLevelWeaponUp", true )
addEventHandler ( "NGAmmunation:Modules->Training:onClientLevelWeaponUp", root, function ( wn, nsl, wid )
	local lID = weaponRankData [ wn ]
	setPedStat ( source, lID, nsl * 10 );
end )

addEventHandler ( "onPlayerLogin", root, function ( )
	setTimer ( function ( p )
		local data = getElementData ( p, "NGSQL:WeaponStats" )
		if ( data and isElement ( p ) ) then
			for i, v in pairs ( data ) do
				if ( weaponRankData [ i ] ) then
					setPedStat ( p, weaponRankData [ i ], v * 10 );
				end
			end
		end
	end, 1000, 1, source )
end )


addEvent ( "NGAmmunation:Modules->Training:TakePlayerMoney", true )
addEventHandler ( "NGAmmunation:Modules->Training:TakePlayerMoney", root, function ( p, m )
	takePlayerMoney ( p, m )
end )
