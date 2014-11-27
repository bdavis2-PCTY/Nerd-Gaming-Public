local track = {
     { 1291.0234375, -1400.220703125, 12.834917068481 }, 
     { 1209.0712890625, -1400.2080078125, 12.950634002686 }, 
     { 1066.4375, -1400.5810546875, 13.187698364258 }, 
     { 921.9189453125, -1400.4501953125, 12.981587409973 }, 
     { 803.11328125, -1400.53515625, 13.129157066345 }, 
     { 684.9609375, -1400.662109375, 13.077233314514 }, 
     { 626.322265625, -1503.068359375, 14.422187805176 }, 
     { 629.43359375, -1613.876953125, 15.624945640564 }, 
     { 633.2099609375, -1738.125, 13.203499794006 }, 
     { 766.3671875, -1779.2041015625, 12.546010971069 }, 
     { 950.607421875, -1793.447265625, 13.723156929016 }, 
     { 1098.953125, -1853.7001953125, 13.06219291687 }, 
     { 1241.5361328125, -1852.7353515625, 13.062483787537 }, 
     { 1387.880859375, -1872.8505859375, 13.065240859985 }, 
     { 1567.46875, -1872.5458984375, 13.067772865295 }, 
     { 1739.787109375, -1858.90234375, 13.093430519104 }, 
     { 1820.9814453125, -1907.72265625, 13.071494102478 }, 
     { 1884.791015625, -1932.02734375, 13.06192779541 }, 
     { 1975.9697265625, -1932.5771484375, 13.06259059906 }, 
     { 2081.7998046875, -1928.5419921875, 12.989346504211 }, 
     { 2082.6162109375, -1848.6669921875, 13.06257724762 }, 
     { 2093.1669921875, -1750.5078125, 13.084528923035 }, 
     { 2144.541015625, -1725.78125, 13.218618392944 }, 
     { 2239.6865234375, -1733.5673828125, 13.062660217285 }, 
     { 2331.119140625, -1734.138671875, 13.062545776367 }, 
     { 2430.8310546875, -1719.4951171875, 13.576020240784 }, 
     { 2431.603515625, -1634.9287109375, 27.118701934814 }, 
     { 2431.1435546875, -1527.634765625, 23.516151428223 }, 
     { 2430.646484375, -1445.9794921875, 23.508810043335 }, 
     { 2394.62109375, -1439.892578125, 23.515399932861 }, 
     { 2391.123046875, -1397.3076171875, 23.52074432373 }, 
     { 2290.935546875, -1382.7490234375, 23.793895721436 }, 
     { 2159.1298828125, -1384.515625, 23.507797241211 }, 
     { 2072.8369140625, -1377.083984375, 23.505920410156 }, 
     { 2069.0322265625, -1344.390625, 23.499979019165 }, 
     { 1998.09765625, -1340.591796875, 23.500026702881 }, 
     { 1918.9892578125, -1340.2939453125, 15.141540527344 }, 
     { 1849.5224609375, -1340.9853515625, 13.078939437866 }, 
     { 1849.2412109375, -1413.6298828125, 13.070357322693 }, 
     { 1829.234375, -1460.1201171875, 13.046419143677 }, 
     { 1737.2451171875, -1441.1865234375, 13.045866966248 }, 
     { 1596.6611328125, -1440.701171875, 13.062530517578 }, 
     { 1479.109375, -1440.734375, 13.062534332275 }, 
     { 1409.2880859375, -1420.13671875, 13.881724357605 }, 
     { 1324.7490234375, -1399.8310546875, 13.014247894287 }, 
}
addEvent ( "NGEvents:Modules->LSStreetRace:CreateCheckpoints", true )
addEventHandler ( "NGEvents:Modules->LSStreetRace:CreateCheckpoints", root, function ( f, d )
	if ( f == "CreateElements" ) then
		RaceTableIndex = 1
		RaceDimension = d
		if ( isElement ( LSTrackMarker ) ) then
			removeEventHandler ( "onClientMarkerHit", LSTrackMarker, OnLSRaceMarkerHit )
			destroyElement ( LSTrackMarker )
			destroyElement ( LSTrackBlip )
		end
		LSRace_LoadMarkerId ( 1 )
	else
		if ( isElement ( LSTrackMarker ) ) then
			removeEventHandler ( "onClientMarkerHit", LSTrackMarker, OnLSRaceMarkerHit )
			destroyElement ( LSTrackMarker )
			destroyElement ( LSTrackBlip )
		end
	end
end )

function LSRace_LoadMarkerId ( i, isWin )
	if ( isElement ( LSTrackMarker ) ) then
		removeEventHandler ( "onClientMarkerHit", LSTrackMarker, OnLSRaceMarkerHit )
		destroyElement ( LSTrackMarker )
		destroyElement ( LSTrackBlip )
	end
	local x, y, z = track[i][1], track[i][2], track[i][3]
	if ( not isWin ) then
		LSTrackBlip = createBlip ( x, y, z, 0, 3, 255, 255, 0 )
		LSTrackMarker = createMarker ( x, y, z, "checkpoint", 9, 255, 255, 0, 120 )
	else
		LSTrackBlip = createBlip ( x, y, z, 0, 3, 0, 255, 0 )
		LSTrackMarker = createMarker ( x, y, z, "checkpoint", 9, 0, 255, 0, 120 )
	end
	
	setElementDimension ( LSTrackMarker, RaceDimension )
	setElementDimension ( LSTrackBlip, RaceDimension )
	addEventHandler ( "onClientMarkerHit", LSTrackMarker, OnLSRaceMarkerHit )
end

function OnLSRaceMarkerHit ( p )
	if ( p and p == localPlayer ) then
		RaceTableIndex = RaceTableIndex + 1
		if ( RaceTableIndex > #track ) then
			ThisPlayerWinsRace ( )
			return
		end
		
		LSRace_LoadMarkerId ( RaceTableIndex, RaceTableIndex == #track )
		
	end
end 

function ThisPlayerWinsRace  ( )
	triggerServerEvent ( "NGEvents:Modules->LSRace:ThisPlayerWinsRace", localPlayer )
end