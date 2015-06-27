exports.customblips:createCustomBlip(2149.34, -1586.64, 15, 15, "assets/images/icon-beaker.png");
exports.customblips:createCustomBlip(2216.16, 2715.12, 15, 15, "assets/images/icon-beaker.png");
--2149.34, -1586.64, 14.34

------------------
-- LS			--
------------------
exports.ngwarpmanager:makeWarp ( { 
	pos = { 2150.1, -1584.69, 15.34 }, 
	toPos = { 318.564971,1118.209960,1083.882812 }, 
	cInt = 0, cDim = 0, 
	tInt = 5, tDim = 2 } 
);

exports.ngwarpmanager:makeWarp ( { 
	pos = { 318.39, 1115.1, 1084.88 }, 
	toPos = { 2150.1, -1584.69, 15.34 }, 
	cInt = 5, cDim = 2, 
	tInt = 0, tDim = 0 } 
);


------------------
-- LV			--
------------------
exports.ngwarpmanager:makeWarp ( { 
	pos = { 2216.23, 2715.14, 11.81 }, 
	toPos = { 302.180999,300.722991,999.148437 }, 
	cInt = 0, cDim = 0, 
	tInt = 4, tDim = 2 } 
);

exports.ngwarpmanager:makeWarp ( { 
	pos = { 302.180999,300.722991,1000.148437 }, 
	toPos = { 2216.23, 2715.14, 11.81 }, 
	cInt = 4, cDim = 2, 
	tInt = 0, tDim = 0 } 
);



DR = { }
DR.GUI = { }

DR.Locations = { 
	[1] = {
		interior = 5,
		dimension = 2,
		locations = {
			{ 332.95, 1122.84, 1083.89 },
			{ 331.19, 1129.03, 1083.88 },
			{ 323.68, 1130.79, 1083.88 },
			{ 308.17, 1120.91, 1083.88 },
			{ 306.22, 1123.96, 1083.88 }
		}
	},
	
	[2] = {
		interior = 4,
		dimension = 2,
		locations = { 
			{ 301.09, 303.38, 1003.54 },
			{ 301.31, 301.33, 1003.54 },
			{ 303.56, 310.31, 999.15 },
			{ 304.44, 302.16, 1003.3 },
		}
	}
}

DR.gathering = {
	current = false,
	marker = nil,
	item = nil,
	timer = nil
}

addEventHandler ( "onClientResourceStart", resourceRoot, function ( )
	for _, info in pairs ( DR.Locations ) do 
		for _, pos in pairs ( info.locations ) do 
			local x, y, z = unpack ( pos );
			local m = createMarker ( x, y, z-1, "cylinder", 0.9, 50, 255, 50, 200 );
			m.interior = info.interior;
			m.dimension = info.dimension;
			
			addEventHandler ( "onClientMarkerHit", m, DR.onMarkerHit );
			addEventHandler ( "onClientMarkerLeave", m, DR.onMarkerLeave );
		end 
	end 
end );

function DR.onMarkerHit ( p )
	if ( p ~= localPlayer or isElement ( DR.GUI.window ) or p.interior ~= source.interior or p.dimension ~= source.dimension ) then return end	
	
	local x, y, z = getElementPosition ( source )
	local px, py, pz = getElementPosition ( p )
	if ( getDistanceBetweenPoints3D ( x, y, z, px, py, pz ) > 2 ) then return end
	
	if ( tostring ( getElementData ( p, "Job" ) ):lower() ~= "criminal" ) then
		return exports.ngmessages:sendClientMessage ( "Only criminals may use this marker", 255, 80, 80 );
	end
	
	
	DR.GUI.window = guiCreateWindow((sx/2-572/2), (sy/2-269/2), 572, 269, "Selection", false)
	guiWindowSetSizable(DR.GUI.window, false)

	DR.GUI.info = guiCreateLabel(19, 28, 391, 23, "What type of drug would you like to collect?", false, DR.GUI.window)
	guiSetFont(DR.GUI.info, "default-bold-small")
	DR.GUI.img_weed = guiCreateStaticImage(19, 88, 143, 131, ":NGDrugs/files/weed_icon.png", false, DR.GUI.window)
	DR.GUI.btn_weed = guiCreateButton(19, 225, 143, 24, "Marijuana", false, DR.GUI.window)
	DR.GUI.img_LSD = guiCreateStaticImage(189, 88, 143, 131, ":NGDrugs/files/lsd_icon.png", false, DR.GUI.window)
	DR.GUI.btn_LSD = guiCreateButton(189, 225, 143, 24, "LSD", false, DR.GUI.window)
	DR.GUI.close = guiCreateButton(506, 28, 39, 31, "[ X ]", false, DR.GUI.window)
	
	DR.GUI.prog = guiCreateProgressBar ( (sx/2-250), (sy/2-30), 500, 60, false, false );
	DR.GUI.progMsg = guiCreateLabel ( 0, 0, 500, 60, "Gathering ", false, DR.GUI.prog );
	guiSetProperty ( DR.GUI.progMsg, 'TextColours', 'FF000000' );
	
	guiLabelSetHorizontalAlign ( DR.GUI.progMsg, 'center' );
	guiLabelSetVerticalAlign ( DR.GUI.progMsg, 'center' );
	
	guiSetVisible ( DR.GUI.prog, false );
	
	showCursor ( true );
	
	addEventHandler ( "onClientGUIClick", root, DR.onClientGUIClick );
	
	DR.gathering = {
		current = false,
		marker = source,
		item = nil,
		timer = nil
	}
	
end 

function DR.onMarkerLeave ( p )
	if ( p and p ~= localPlayer ) then return end
	
	if ( source ) then
		if ( p.interior ~= source.interior or p.dimension ~= source.dimension ) then return end

		local x, y, z = getElementPosition ( source )
		local px, py, pz = getElementPosition ( p )
		if ( getDistanceBetweenPoints3D ( x, y, z, px, py, pz ) > 2 ) then return end
	end
	
	if ( not isElement ( DR.GUI.window ) ) then return end
	
	if ( DR.gathering.current ) then 
	
		exports.ngmessages:sendClientMessage ( "You have failed to finish gathering "..DR.gathering.item.."!", 255, 80, 80 );
	
		if ( isTimer ( DR.gathering.timer ) )then
			killTimer ( DR.gathering.timer );
		end
	end
	
	removeEventHandler ( "onClientGUIClick", root, DR.onClientGUIClick );
	destroyElement ( DR.GUI.window );
	destroyElement ( DR.GUI.prog );
	showCursor ( false );
	
	DR.gathering = {
		current = false,
		marker = nil,
		item = nil,
		timer = nil,
		percent = nil
	}
	
end

function DR.onClientGUIClick ( )
	if ( source == DR.GUI.close ) then 
		DR.onMarkerLeave ( localPlayer )
		
	elseif ( source == DR.GUI.btn_weed or source == DR.GUI.btn_LSD ) then
	
		DR.gathering.current = true;
		DR.gathering.percent = 0;
		DR.gathering.timer = setTimer ( DR.onDrugPercentIncrease, 500, 0 );
		DR.GUI.window.visible = false;
		guiSetVisible ( DR.GUI.prog, true );
		giveWantedPoints ( 20 );
	
		if ( source == DR.GUI.btn_weed ) then 
			DR.gathering.item = "marijuana";
			guiSetText ( DR.GUI.progMsg, "Gathering marijuana.... 0%" );
		elseif ( source == DR.GUI.btn_LSD ) then
			DR.gathering.item = "LSD";
			guiSetText ( DR.GUI.progMsg, "Gathering LSD.... 0%" );
		end
		
	end	
end 


function DR.onDrugPercentIncrease ( )
	DR.gathering.percent = DR.gathering.percent + 1;
	guiSetText ( DR.GUI.progMsg, "Gathering "..DR.gathering.item..".... "..DR.gathering.percent.."%" );
	
	guiProgressBarSetProgress ( DR.GUI.prog, DR.gathering.percent );
	
	if ( DR.gathering.percent >= 100 ) then 
		local img = "";
		if ( DR.gathering.item == "marijuana" ) then
			img = ":NGDrugs/files/weed_icon.png";
		elseif ( DR.gathering.item == "LSD" ) then
			img = ":NGDrugs/files/lsd_icon.png";
		end
	
		triggerServerEvent ( "NGJobs->Criminal->DrugFactory->OnPlayerFinishProducingDrugs", localPlayer, DR.gathering.item, 2 );
		exports.ngmessages:sendClientMessage ( "You have finished gathering 2 "..DR.gathering.item.." drugs!", 80, 255, 80, img, false );
		DR.gathering.current = false;
		killTimer ( DR.gathering.timer );
		DR.onMarkerLeave ( localPlayer );
	end
	
end