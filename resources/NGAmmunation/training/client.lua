local allowedWeapons = { 
	[22] = "9mm",
	[23] = "silenced",
	[24] = "deagle" ,
	[25] = "shotgun",
	[27] = "combat_shotgun",
	[28] = "micro_smg",
	[29] = "mp5",
	[30] = "ak47",
	[31] = "m4",
	[32] = "micro_smg",
	[34] = "sniper_rifle", 
}

local sx, sy  = guiGetScreenSize ( )
local rsx, rsy = sx / 1280, sy / 1024
local selectedOption = 0
local isRendering = false
local sourceMarker = nil
local selectedWeapon = nil
local isTraining = false
local winW = rsx * 250
local winX = rsx * 30
local winH = rsy * 220
local winY = (sy/2)-(winH/2)
local progWidth = 0
local progNum = 0
local training = { }
local dummyPeds = { }
local trainingWeapon = nil

addEvent ( "NGAmmunation:Module->Training:onClientHitMarker", true )
addEventHandler ( "NGAmmunation:Module->Training:onClientHitMarker", root, function ( s )
	if isTraining then return end
	local w = getPedWeapon ( localPlayer )
	local d = getElementData ( localPlayer, "NGSQL:WeaponStats" )
	if not ( d[allowedWeapons[w]] ) then 
		return exports.NGMessages:sendClientMessage ( "This weapon isn't allowed to be trained.", 255, 255, 0 )
	end
	if ( d[allowedWeapons[w]] > 90 ) then
		return exports.NGMessages:sendClientMessage ( "This weapon has maximum efficiency!", 255, 255, 0 )
	end
	
	sourceMarker = s
	local x, y, z = getElementPosition ( s )
	setElementPosition ( localPlayer, x, y, z + 0.2 )
	setPedRotation ( localPlayer, 0 )
	
	if not isRender then addEventHandler ( "onClientRender", root, Training_OnRender ) end
	isRender = true
	showCursor ( true )
	bindKey ( "arrow_d", "down", Training_Binds )
	bindKey ( "arrow_u", "down", Training_Binds )
	bindKey ( "space", "down", Training_Binds )
	selectedOption=0
	trainingWeapon = w
	addEventHandler ( "onClientMarkerLeave", s, Training_OnMarkerLeave )
end )

local windowX = rsx * 10
local windowW = rsx * 250
local windowH = rsy * 400
local windowY = ( sy / 2 - windowH / 2 )

local info = {
	accept = {
		x = windowX+(rsx*20),
		y = windowY+(rsy*300)
	},
	exit = {
		x = windowX+(rsx*20),
		y = windowY+(rsy*345)
	},
	rect = { }
}
info.rect.y = info.accept.y

function Training_OnRender ( )
	if not isRender or getKeyState("backspace") then
		Training_CloseWindow ( )
		return
	end
	
	dxDrawRectangle ( windowX, windowY, windowW, windowH, tocolor ( 0, 0, 0, 150 ) )
	dxDrawBorderedText ( "Training", windowX, windowY-(rsy*25), windowX+windowW, windowY+windowH, tocolor(255,255,255,255), rsy*2, "beckett", "center", "top", false, false, false, false, false )
	
	dxDrawText ( "Here at the Ammu-nation weapon training center, you can increase your weapon skills. Most of the weapons (Shown in F3 -> Stats) have a weapon rank of 0-100. Here, you can increase the weapon so that they can shoot faster, you can have duel, or many others.", windowX + ( rsx * 20 ), windowY + ( rsy * 40 ), ( windowX+windowW)-(rsx * 20 ), (windowY+windowH)-(rsy*50), tocolor ( 255, 255, 255, 255 ), rsy*1.1, "default-bold", "left", "top", false, true )
	dxDrawText ( "Selected Weapon: N/A\nSkill: 0/100\nSession Cost: $1,200", windowX + ( rsx * 20 ), windowY + ( rsy * 225 ), ( windowX+windowW)-(rsx * 20 ), (windowY+windowH)-(rsy*280), tocolor ( 255, 200, 65, 255 ), rsy*1.1, "default-bold", "left", "top", false, true )
	dxDrawRectangle ( windowX+(rsx*20), info.rect.y, windowW-(rsx*40), rsy*35, tocolor ( 0, 0, 0, 150 ) )
	
	dxDrawText ( "Accept & Train",  info.accept.x, info.accept.y, windowX+(windowW-(rsx*40)), info.accept.y+(rsy*35), tocolor(255,255,255,255), rsy*1.2, "default-bold", "center", "center" )
	dxDrawText ( "Exit",  info.exit.x, info.exit.y, windowX+(windowW-(rsx*40)), info.exit.y+(rsy*35), tocolor(255,255,255,255), rsy*1.2, "default-bold", "center", "center" )
	
	if ( selectedOption == 0 ) then
		if  ( info.rect.y ~= info.accept.y ) then
			if ( info.rect.y > info.accept.y ) then
				info.rect.y = info.rect.y - ( rsy * 2 )
				if ( info.rect.y < info.accept.y ) then
					info.rect.y = info.accept.y
				end
			else
				info.rect.y = info.rect.y + ( rsy * 2 )
				if ( info.rect.y > info.accept.y ) then	
					info.rect.y = info.accept.y
				end
			end
		end	
	else
		if  ( info.rect.y ~= info.exit.y ) then
			if ( info.rect.y > info.exit.y ) then
				info.rect.y = info.rect.y - ( rsy * 2 )
				if ( info.rect.y < info.exit.y ) then
					info.rect.y = info.exit.y
				end
			else
				info.rect.y = info.rect.y + ( rsy * 2 )
				if ( info.rect.y > info.exit.y ) then	
					info.rect.y = info.exit.y
				end
			end
		end
	end
end

function Training_CloseWindow ( doBinds )
	if ( isRender ) then
		removeEventHandler ( "onClientRender", root, Training_OnRender )
	end
	
	if ( doBinds == nil ) then
		doBinds = true
	end
	
	isRender = false
	selectedWeapon = nil
	isTraining = false
	showCursor ( false )
	info.rect.y = info.accept.y
	unbindKey ( "arrow_d", "down", Training_Binds )
	unbindKey ( "arrow_u", "down", Training_Binds )
	unbindKey ( "space", "down", Training_Binds )
	if ( training.IsStatsRendering  ) then
		training.IsStatsRendering  = false
		removeEventHandler ( "onClientRender", root, Training_UserStats )
	end
	for i, v in pairs ( dummyPeds ) do
		if ( isElement ( v ) ) then
			destroyElement ( v ) 
		end
		dummyPeds[i] = nil
	end
	
	if doBinds then
		toggleControl ( "next_weapon", true )
		toggleControl ( "previous_weapon", true )
		toggleControl ( "aim_weapon", true )
		toggleControl ( "fire", true )

		toggleControl("forwards", true)
		toggleControl("backwards", true )
		toggleControl("left", true )
		toggleControl ( "right", true )
		toggleControl ( "jump", true )
		toggleControl ( "crouch", true )
	end
	
	if ( isElement ( sourceMarker ) ) then
		removeEventHandler ( "onClientMarkerLeave", sourceMarker, Training_OnMarkerLeave )
		sourceMarker = nil
	end
end

function Training_Binds ( k, s )
	if ( k == "space" ) then
		playSoundFrontEnd ( 33 )
		if ( selectedOption == 1 ) then
			Training_CloseWindow ( true )
		elseif ( selectedOption == 0 ) then
			
			if ( not allowedWeapons [ getPedWeapon ( localPlayer ) ] ) then
				return exports.NGMessages:sendClientMessage ( "This weapon isn't allowed" )
			end
			
			if ( getPlayerMoney ( ) < 1200 ) then
				return exports.NGMessages:sendClientMessage ( "You don't have $1,200 to train this weapon", 255, 255, 0 )
			end
			Training_CloseWindow ( false )
			Training_StartTraining ( )
		end
		return
	end
	playSoundFrontEnd ( 32 )
	if selectedOption == 0 then
		selectedOption = 1
	else
		selectedOption = 0
	end
end

function Training_StartTraining ( )
	if isTraining then return end
	isTraining = true
	
	toggleControl ( "next_weapon", false )
	toggleControl ( "previous_weapon", false )
	toggleControl ( "aim_weapon", false )
	toggleControl ( "fire", false )
		toggleControl("forwards", false)
		toggleControl("backwards", false )
		toggleControl("left",false )
		toggleControl ( "right", false )
		toggleControl ( "jump", false )
		toggleControl ( "crouch", false )
	
	training.textHeight = sy
	training.remainingTimeForCountdown = 5
	training.RequiredPeds = 15
	training.TargetShot = 0
	training.IsStatsRendering = false
	progNum = 0
	progWidth = 0
	addEventHandler ( "onClientRender", root, Training_CountdownRender )
	setTimer ( function ( ) 
		training.remainingTimeForCountdown = training.remainingTimeForCountdown - 1
	end, 1000, 5 )
	Training_SpawnDummyPeds ( )
	triggerServerEvent ( "NGAmmunation:Modules->Training:TakePlayerMoney", localPlayer, localPlayer, 1200 )
end

--[[ -- For developers
addCommandHandler ( 'rest', function ( )
	toggleControl ( "next_weapon", true )
	toggleControl ( "previous_weapon", true )
	toggleControl ( "forwards", true )
	toggleControl ( "backwards", true )
	toggleControl ( "left", true )
	toggleControl ( "right", true )
	toggleControl ( "aim_weapon", true )
	toggleControl ( "crouch", true )
	toggleControl ( "jump", true )
	toggleControl ( "sprint", true )
	toggleControl ( "fire", true )
end )
]]

function Training_UserStats ( )
	if not training.IsStatsRendering or not isTraining then
		return removeEventHandler ( "onClientRender", root, Training_UserStats )
	end
	
	dxDrawRectangle ( winX, winY, winW, winH, tocolor ( 0, 0, 0, 150 ) )
	local prog = 0
	local killed = training.TargetShot
	local required = training.RequiredPeds
	
	local prog = 10 * ( (100 * killed) / ( required .. 0 ) )
	if ( prog ~= progNum ) then
		if ( progNum < prog ) then
			progNum = progNum + 1
		else
			progNum = progNum - 1
		end
	end
		
	
	local prog2 = (winW-(rsx*58))*(prog*0.01)
	if ( progWidth ~= prog2 ) then
		if ( prog2 > progWidth ) then
			progWidth = progWidth + ( rsx * 1 )
			if ( progWidth > prog2 ) then
				progWidth = prog2
			end
		else
			progWidth = progWidth - ( rsx * 1 )
			if ( progWidth < prog2 ) then
				progWidth = prog2
			end
		end
	end

	if ( localPlayer.interior ~= 1 ) then
		Training_OnMarkerLeave ( )
	end 
	
	dxDrawText ( "Stats", winX, winY+(rsy*5), winX+winW, winY+winH, tocolor ( 255, 255, 255, 255 ), rsy*2, "default-bold", "center" )
	dxDrawText ( "Killed Peds: "..tostring(training.TargetShot), winX+(rsx*25), winY+(rsy*50), 0, 0, tocolor ( 255, 160, 0, 255 ), rsy*1.5, "default-bold" )
	dxDrawText ( "Required Peds: "..tostring(training.RequiredPeds), winX+(rsx*25), winY+(rsy*90), 0, 0, tocolor ( 255, 160, 0, 255 ), rsy*1.5, "default-bold" )
	dxDrawRectangle ( winX+(rsx*25), (winY+winH)-(rsx*60), winW-(rsx*50), rsy*35, tocolor ( 0, 0, 0, 150 ) )
	dxDrawRectangle ( winX+(rsx*29), (winY+winH)-(rsx*56), progWidth, rsy*27, tocolor ( 255, 140, 0, 255 ) )
	dxDrawText ( progNum.."%", winX+(rsx*25), (winY+winH)-(rsx*60), (winX+(rsx*25))+(winW-(rsx*50)), ((winY+winH)-(rsx*60))+(rsy*35), tocolor ( 255, 255, 255, 255 ), rsy * 1.3, "default-bold", "center", "center" )
end


local pedLocs = {
	{ 297.59, -17.63, 1001.52, 180 },
	{ 294.49, -19.36, 1001.52, 180 },
	{ 292.03, -15.71, 1001.52, 180 },
	{ 290.52, -12.82, 1001.52, 180 },
	{ 291.51, -9.1, 1001.52, 180 },
	{ 296.64, -10.78, 1001.52, 180 },
	{ 298.07, -14.06, 1001.52, 180 },
	{ 286.5, -7.54, 1001.52, 180 },
	{ 293.74, -12.63, 1001.52, 180 },
	{ 288.79, -17.26, 1001.52, 180 },
	{ 286, -11.67, 1001.52, 180 },
	{ 296.87, -6.78, 1001.52, 180 },
	{ 295.56, -15.8, 1001.52, 180 },
	{ 287, -13.9, 1001.52, 180 },
	{ 288.47, -8.96, 1001.52, 180 },
	{ 290.22, -14.57, 1001.52, 180 },
	{ 293.42, -10.2, 1001.52, 180 },
	{ 292.02, -18, 1001.52, 180 },
	{ 286.01, -17, 1001.52, 180 },
}

function Training_SpawnDummyPeds ( )
	local usedIndexs = { }
	local int = getElementInterior ( localPlayer )
	for i=1,training.RequiredPeds do
		local n = math.random ( #pedLocs )
		while ( usedIndexs [ n ] ) do
			n = math.random ( #pedLocs )
		end
		usedIndexs [ n ] = true
		local x, y, z, r = unpack ( pedLocs [ n ] )
		local p = createPed ( 0, x, y, z )
		setPedRotation ( p, r )
		setElementInterior ( p, int )
		p.dimension = localPlayer.dimension
		addEventHandler ( "onClientPedDamage", p, Training_OnDummyDamage )
		addEventHandler ( "onClientPedWasted", p, Training_OnDummyWasted )
		dummyPeds[i] = p
	end
end

function Training_OnDummyDamage ( attacker )
	if ( not attacker or getElementType ( attacker ) ~= "player" or attacker ~= localPlayer ) then
		cancelEvent ( )
		return
	end
end

function Training_OnDummyWasted ( attacker )
	if ( attacker and attacker == localPlayer ) then
		training.TargetShot = training.TargetShot + 1
		
		if ( training.TargetShot == training.RequiredPeds ) then
			
			setTimer ( function ( )
				Training_CloseWindow ( )
				
				if ( trainingWeapon ~= getPedWeapon ( localPlayer ) ) then
					return exports.NGMessages:sendClientMessage ( "You have changed your weapon.... No skills added.", 255, 0, 0 )
				end
				
				local w = getPedWeapon ( localPlayer )
				local d = getElementData ( localPlayer, "NGSQL:WeaponStats" )
				d[allowedWeapons[w]] = d[allowedWeapons[w]] + 10
				setElementData ( localPlayer, "NGSQL:WeaponStats", d )
				exports.NGMessages:sendClientMessage ( "Weapon ranked up! New level: "..d[allowedWeapons[w]].."/100", 0, 255, 0 )
				triggerServerEvent ( "NGAmmunation:Modules->Training:onClientLevelWeaponUp", localPlayer, allowedWeapons[w], d[allowedWeapons[w]], w )
																									--	  weapon name		, new skill level	 , weapon ID )
				trainingWeapon = nil
			end, 1000, 1 )
		end
	end
end


function Training_OnMarkerLeave ( )
	Training_CloseWindow ( )
	trainingWeapon = nil
end




function Training_CountdownRender ( )
	local t = training.remainingTimeForCountdown
	local h = training.textHeight
	
	local alpha = 255
	if not training.CountdownTextAlpha then
		training.CountdownTextAlpha = alpha
	else
		alpha = training.CountdownTextAlpha
	end
	
	if ( t == 0 ) then
		t = "Begin Shooting The Targets"
		if ( h > ( rsy * 75 ) ) then
			h = h - ( rsy * 10 )
			training.textHeight = h
		end
		
		if not training.IsStatsRendering then
			training.IsStatsRendering = true
			addEventHandler ( "onClientRender", root, Training_UserStats )
			toggleControl ( "aim_weapon", true )
			toggleControl ( "fire", true )
			toggleControl("forwards", true)
			toggleControl("backwards", true )
			toggleControl("left",true )
			toggleControl ( "right", true )
			toggleControl ( "jump", true )
			toggleControl ( "crouch", true )
			return
		end
		
		if not training.removeCountdownTick then
			training.removeCountdownTick = getTickCount ( ) + 3000
		elseif ( training.removeCountdownTick <= getTickCount ( ) ) then
			alpha = alpha - 2
			training.CountdownTextAlpha = alpha
			if ( alpha < 20 ) then
				training.remainingTimeForCountdown = nil
				training.textHeight = nil
				training.CountdownTextAlpha = nil
				training.removeCountdownTick = nil
				removeEventHandler ( "onClientRender", root, Training_CountdownRender )
				return
			end
		end
	end
	dxDrawBorderedText ( tostring ( t ), 0, 0, sx, h, tocolor ( 255, 255, 0, alpha ), rsy*2.5, "pricedown", "center", "center", false, true )
end 