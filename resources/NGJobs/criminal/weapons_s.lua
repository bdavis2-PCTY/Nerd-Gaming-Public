local locations = {
	{ -2078.4, 1419.06, 7.31 },
	{ -1975.6, 1227.14, 31.83 },
	{ -2285.64, -12.7, 35.53 },
	{ -2147.59, -139.86, 36.73 },
	{ -2035.11, -43.72, 35.65 },
	{ -2120.84, -4.27, 35.53 },
	{ -2053.64, 82.59, 28.6 },
	{ -1917.56, 82.59, 28.6 },
	{ -1481, 686.4, 1.32 },
}

function makeWeaponCrate ( )
	if ( isElement ( criminalWeaponMarker ) ) then
		removeEventHandler ( "onMarkerHit", criminalWeaponMarker, onCriminalHitWeaponPickup )
		destroyElement ( criminalWeaponMarker )
	end if ( isElement ( criminalWeaponText ) ) then
		destroyElement ( criminalWeaponText )
	end if ( isElement ( criminalWeaponBlip ) ) then
		destroyElement ( criminalWeaponBlip )
	end if ( isElement ( criminalWeaponCrate ) ) then
		destroyElement ( criminalWeaponCrate )
	end
	
	local pos = locations[math.random(#locations)]
	local x,y,z = unpack ( pos )
	criminalWeaponMarker = createMarker ( x, y, z - 1.3, "cylinder", 2, 255, 50, 50, 120 )
	criminalWeaponBlip = createBlip ( x, y, z, 37, 2, 255, 255, 255, 255, 0, 350 )
	criminalWeaponCrate = createObject (2977, x, y, z-1.4 )
	criminalWeaponText = create3DText ( "Criminal Weapons", { 0, 0, 1 }, { 255, 50, 50 }, criminalWeaponCrate )
	outputTeamMessage ( "There is a weapon crate available for pickup in "..getZoneName ( x, y, z )..", "..getZoneName ( x, y, z, true )..". (The '?' blip.)", "Criminals", 255, 50,  50 )
	addEventHandler ( "onMarkerHit", criminalWeaponMarker, onCriminalHitWeaponPickup )
end

function onCriminalHitWeaponPickup ( p )
	if ( p and getElementType ( p ) == 'player' and not isPedInVehicle ( p ) ) then
		local team = getPlayerTeam ( p )
		if team and getTeamName ( team ) == "Criminals" then
		
			if ( isElement ( criminalWeaponMarker ) ) then
				removeEventHandler ( "onMarkerHit", criminalWeaponMarker, onCriminalHitWeaponPickup )
				destroyElement ( criminalWeaponMarker )
			end if ( isElement ( criminalWeaponText ) ) then
				destroyElement ( criminalWeaponText )
			end if ( isElement ( criminalWeaponBlip ) ) then
				destroyElement ( criminalWeaponBlip )
			end if ( isElement ( criminalWeaponCrate ) ) then
				destroyElement ( criminalWeaponCrate )
			end
			
			local weaponID = math.random ( 22, 34 )
			local ammo = math.random ( 400, 3000 )
			outputTeamMessage ( getPlayerName ( p ).." has captured the weapon pickup and got a(n) "..getWeaponNameFromID ( weaponID ).." with "..ammo.." bullets!", "Criminals", 255, 50, 50 )
			giveWeapon ( p, weaponID, ammo )
			giveWantedPoints ( p, 70 )
		else
			exports['NGMessages']:sendClientMessage ( "This is for criminals only.", p, 255, 50, 50 )
		end
	end
end
setTimer ( makeWeaponCrate, 1000, 1 )
setTimer ( makeWeaponCrate, 350000, 0 )

--[[
 2977
 3798
 944
 2912
 == 3014
 ]]