local detective = { }
local runningCases = { }
local clues = {349, 350, 325, 335, 337, 347, 358, 2263, 2703, 2837, 928, 3082, 1946, 1025, 2647, 2702, 2769}

function detective.startCase ( skin, x, y, z )
	if ( getElementData ( localPlayer, "Job" ) ~= "Detective" or table.len ( runningCases ) >= 5 ) then
		return
	end
	
	local caseid = 0;
	while ( runningCases [ caseid ] ) do
		caseid = caseid + 1
	end
	
	runningCases[caseid] = { }
	local r = runningCases[caseid]
	r.skin = skin
	r.pos = { x = x, y = y, z = z }
	r.ped = createPed ( skin, x, y, z )
	setElementHealth ( r.ped, 0 )
	setElementData ( r.ped, "NGJobs->Detective:InvestigationID", caseid )
	
	r.objects = { }
	r.tempCols = { }
	r.blip = createBlip ( x, y, z, 25 )
	r.col = createColSphere(x, y, z, 4.5)
	setElementData ( r.col, "NGJobs->Detective:InvestigationID", caseid )
	addEventHandler ( "onClientColShapeHit", r.col, detective.startInvestigation )
	
	r.active = false
	r.evidence = 0
	runningCases[caseid] = r
	
	local msg = "Someone has been killed in the "..getZoneName(x,y,z)..", "..getZoneName(x,y,z,true).." area. Get to the scene (the dice icon) and solve the case"
	exports.NGMessages:sendClientMessage ( msg, 255, 0, 255 )
	exports.NGPolice:outputDispatchMessage ( msg )
end

function detective.startInvestigation ( p )
	if ( p ~= localPlayer ) then return end
	if ( isPedInVehicle ( p ) ) then return end
	local id = getElementData ( source, "NGJobs->Detective:InvestigationID" )
	removeEventHandler ( "onClientColShapeHit", source, detective.startInvestigation )
	destroyElement ( source )
	if ( isElement ( runningCases[id].blip ) ) then destroyElement ( runningCases[id].blip ) end
	exports.NGMessages:sendClientMessage ( "Search the area for clues of the killer...", 50, 150, 255 )
	runningCases[id].active = true
	
	local x = runningCases[id].pos.x
	local y = runningCases[id].pos.y
	local z = runningCases[id].pos.z
	for i=1, 15 do
		local f = math.random ( #clues )
		local obj1, obj2, obj3 = x + math.random(-30,30), y + math.random(-30,30), getGroundPosition(x, y, z)+0.1
		local obj = createObject ( clues[f], obj1, obj2, obj3, math.random ( 0, 360 ), math.random ( 0, 360 ), math.random ( 0, 360 ) )
		table.insert ( runningCases[id].objects, obj )
		local s = createColSphere(obj1, obj2, obj3, 1)
		table.insert ( runningCases[id].tempCols, s )
		setElementData ( s, "NGJobs->Detective:InvestigationObject", obj )
		setElementData ( s, "NGJobs->Detective:InvestigationID", id )
		addEventHandler ( "onClientColShapeHit", s, detective.onPlayerGatherEvidence )
	end
end

function detective.onPlayerGatherEvidence ( p )
	if ( p ~= localPlayer or isPedInVehicle ( p ) ) then
		return
	end
	
	if ( getElementData ( p, "Job" ) ~= "Detective" ) then
		for i, v in pairs ( runningCases ) do
			detective.stopCase ( i )
		end
	end
	
	local id = getElementData ( source, "NGJobs->Detective:InvestigationID" )
	local o = getElementData ( source, "NGJobs->Detective:InvestigationObject" )
	removeEventHandler ( "onClientColShapeHit", source, detective.onPlayerGatherEvidence )
	destroyElement ( source )
	if ( isElement ( o ) ) then
		destroyElement ( o )
	end
	runningCases[id].evidence = runningCases[id].evidence + 1
	if ( runningCases[id].evidence < 4 ) then
		exports.NGMessages:sendClientMessage ( "This seems to be a clue leading to a suspect. Keep searching until we can find who did this!", 0, 255, 0 )
	else
		detective.stopCase ( id )
	end
end


function detective.stopCase ( id )
	local d = runningCases[id]
	if ( isElement ( d.ped ) ) then
		destroyElement ( d.ped )
	end
	for i, v in pairs ( d.objects ) do
		if ( isElement ( v ) ) then
			destroyElement ( v )
		end
	end
	for i, v in pairs ( d.tempCols ) do
		if ( isElement ( v ) ) then
			removeEventHandler ( "onClientColShapeHit", v, detective.onPlayerGatherEvidence )
			destroyElement ( v )
		end
	end
	
	if ( isElement ( runningCases[id].blip ) ) then destroyElement ( runningCases[id].blip ) end
	triggerServerEvent ( "NGJobs:Modules->Detective:onClientFinishCase", localPlayer, id )
	runningCases[id] = nil
end

addEvent ( "NGJobs:Modules->Detective:onStartCase", true )
addEventHandler ( "NGJobs:Modules->Detective:onStartCase", root, function ( p, x, y, z, s )
	if ( p == localPlayer ) then
		return
	end
	detective.startCase ( s, x, y, z )
end )


function table.len ( t )
	local c = 0
	for i, v in pairs ( t ) do
		c = c + 1
	end
	return c
end
