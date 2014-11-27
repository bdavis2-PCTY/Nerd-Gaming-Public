function startIntro ( )
	isLoggedin = false
	introPed = { cop = { } }
	copCars = { }
	textChange = 4300
	width=500
	height=450
	alpha = 50
	lockAlpha = true
	drawImage = true
	l_tick = getTickCount ( )
	pos_y = 0


	messageText = "what the fuck are you doing, mate?"
	if ( isElement ( introVeh ) ) then
		destroyElement ( introVeh )
	end if ( isElement ( introPed.a ) ) then
		destroyElement ( introPed.a )
	end if ( isElement ( introPed.b ) ) then
		destroyElement ( introPed.b ) 
	end
	l_tick = getTickCount ( )
	msg_id = 0
	showChat ( false )
	showPlayerHudComponent ( 'all', false )
	addEventHandler ( "onClientPreRender", root, renderCurrentText )
	
	-- set dimension
	dim = math.random ( 200, 200000 );
	for i, v in ipairs ( getElementsByType ( "player" ) ) do
		local x = getElementDimension ( v )
		if ( x == dim and getElementInterior ( v ) == 0 ) then
			while ( dim == x ) do
				dim = math.random ( 200, 200000 )
			end
		end
	end
	
	--[[for i, v in pairs ( introPed.cop ) do
		local weapon = createWeapon ( 31, getElementPosition ( v ) )
		setElementDimension ( weapon, dim )
		setWeaponTarget ( weapon, localPlayer )
		--setWeaponOwner ( weapon, v )
		if ( i >= 8 and i <= 11 ) then
			setElementRotation ( v, 0, 0, -90 )
		end
		setElementDimension ( v, dim )
	end
	]]
	setElementInterior ( localPlayer, 0 )
	setElementDimension ( localPlayer, dim )
	
	fadeCamera ( false, 0 )
	
	setTimer ( function ( )
		
		introVeh = createVehicle ( 439, 1373.95, -1398, 13.38, 0, 0, 90 )
		
		copCars[7] = createVehicle ( 599, 1393, -1398, 13.38, 0, 0, 90 )
		introPed.cop[1] = createPed ( 280, 1373.95, -1400.59, 13.38 )
		introPed.cop[2] = createPed ( 287, 1373.95, -1400.59, 13.38 )
		setElementDimension ( introPed.cop[1], dim )
		setElementDimension ( introPed.cop[2], dim )
		warpPedIntoVehicle ( introPed.cop[2], copCars[7], 1 )
		warpPedIntoVehicle ( introPed.cop[1], copCars[7], 0 )
		
		setElementDimension ( introVeh, dim )
		setElementPosition ( localPlayer, 1387.74, -1449.55, 13.55 )
		setElementFrozen  ( localPlayer, true )
		introPed.a = createPed ( 20, 1373.95, -1400.59, 13.38 )
		introPed.b = createPed ( 28, 1373.95, -1400.59, 13.38 )
		setElementDimension ( introPed.a, dim )
		setElementDimension ( introPed.b, dim )
		warpPedIntoVehicle ( introPed.a, introVeh, 0 )
		warpPedIntoVehicle ( introPed.b, introVeh, 1 )
		setVehicleColor ( introVeh, 0, 0, 0 )
		
		setPedControlState ( introPed.a, 'steer_forward', true )
		setPedControlState ( introPed.cop[1], 'steer_forward', true )
		setPedControlState ( introPed.a, 'accelerate', true )
		setPedControlState ( introPed.cop[1], 'accelerate', true )
		
		
		-- barricaded area --
		copCars[1] = createVehicle ( 597, 615.3, -1405.49, 13.2 )
		copCars[2] = createVehicle ( 433, 614.86, -1398.32, 13.7, 0, 0, 180 )
		copCars[3] = createVehicle ( 596, 614.83, -1389.7, 13.2 )
		copCars[4] = createVehicle ( 432, 632.45, -1419.95, 13.5 )
		copCars[5] = createVehicle ( 470, 638, -1416.48, 13.43, 0, 0, 95 )
		copCars[6] = createVehicle ( 470, 626.75, -1417.96, 13.48, 0, 0, -82 )
		--[[introPed.cop[5] = createPed ( 287, 641.54, -1416.66, 13.43 )
		introPed.cop[6] = createPed ( 287, 635.11, -1417.08, 13.45 )
		introPed.cop[7] = createPed ( 287, 629.58, -1416.76, 13.44 )
		introPed.cop[8] = createPed ( 285, 619.31, -1412.79, 13.51 )
		introPed.cop[9] = createPed ( 285, 615.95, -1409.27, 13.41 )
		introPed.cop[10] = createPed ( 285, 617.68, -1402.91, 13.4 )
		introPed.cop[11] = createPed ( 285, 617.92, -1391.67, 13.4 )]]
		for i=1000,1193 do
			addVehicleUpgrade ( introVeh, i )
		end for i, v in pairs ( copCars ) do
			setElementDimension ( v, dim )
			setVehicleSirensOn ( v, true )
			if ( i ~= 7 ) then 
				setElementFrozen ( v, true )
			end
		end for i=1,7 do
			local i = i - 1
			local start_x = 646.6
			local obj = createObject ( 973, start_x-(i*5), -1384.5, 13.4, 0, 0, 180 )
			setElementDimension ( obj, getElementDimension ( localPlayer ) )
		end
		
		setTimer ( function ( )
			fadeCamera ( true )
		end, 1700, 1 )
	end, 1000, 1 )
	
end
addCommandHandler ( 'intro', startIntro )

function cancelOutEvent ( )
	return cancelEvent ( )
end

local sx, sy = guiGetScreenSize ( )
function renderCurrentText ( )
	if ( tostring ( messageText ) ~= "" ) then
		local messageText = string.upper ( tostring ( messageText ) )
		local width = dxGetTextWidth ( messageText, 1.5, 'default-bold' )+10
		dxDrawRectangle ( (sx/2)-(width/2), (sy/1.133), width+5, 30,tocolor ( 0, 0, 0, 255 ) )
		dxDrawText ( messageText, 0, 0, sx, sy/1.1, tocolor ( 255, 255, 0, 255 ), 1.5, 'default-bold', 'center', 'bottom' )
	end
	
	if ( getTickCount ( ) - l_tick >= textChange ) then
		msg_id = msg_id + 1
		l_tick = getTickCount ( )
		if ( msg_id == 1 ) then
			messageText = "i'm not going back to prison!"
		elseif ( msg_id == 2 ) then
			messageText = "stop the fucking car!"
		elseif ( msg_id == 3 ) then
			messageText = "no!"
		elseif ( msg_id == 4 ) then
			messageText = "do it now! They have a fucking tank!"
			setTimer ( function ( )
				setPedControlState ( introPed.a, 'accelerate', false )
				setPedControlState ( introPed.a, 'vehicle_left', true )
				setPedControlState ( introPed.a, 'handbrake', true )
				
				setPedControlState ( introPed.cop[1], 'accelerate', false )
				setTimer ( function ( )
					setPedControlState ( introPed.a, 'vehicle_left', false )
					setPedControlState ( introPed.a, 'handbrake', false )
				end, 900, 1 )
			end, 2500, 1 )
		elseif ( msg_id == 5 ) then
			messageText = "shit bro! We're screwed!"
			textChange = 650
		elseif ( msg_id == 6 ) then
			setElementHealth ( copCars[1], 100 )
			setElementHealth ( copCars[3], 100 )
			createExplosion ( 618, -1398, 13.7, 4 )
			for i=1,3 do
				setElementFrozen ( copCars[i], false )
			end
			blowVehicle ( copCars[7] )
			blowVehicle ( copCars[2] )
			messageText = "Go forward!"
			textChange = 1000
			setPedControlState ( introPed.a, 'accelerate', true )
		elseif ( msg_id == 7 ) then
			blowVehicle ( copCars[1] )
			blowVehicle ( copCars[3] )
			setPedControlState ( introPed.a, 'accelerate', false )
			setPedControlState ( introPed.a, 'handbrake', true )
		elseif ( msg_id == 8 ) then
			blowVehicle ( copCars[1] )
			blowVehicle ( copCars[3] )
			messageText = "Oh my god..."
			setPedControlState ( introPed.a, 'enter_exit', true )
			setPedControlState ( introPed.b, 'enter_exit', true )
			textChange = 2000
		elseif ( msg_id == 9 ) then
			messageText = "Been nice knowin' you."
			fadeCamera ( false )
		elseif ( msg_id == 10 ) then
			messageText = ""
			if ( isElement ( introVeh ) ) then destroyElement ( introVeh ) end
			if ( isElement ( introPed.a ) ) then destroyElement ( introPed.a ) end
			if ( isElement ( introPed.b ) ) then destroyElement ( introPed.b ) end
			for i, v in pairs ( introPed.cop ) do
				if ( isElement ( v ) ) then
					destroyElement ( v )
				end
			end for i, v in pairs ( copCars ) do
				if ( isElement ( v ) ) then
					destroyElement ( v )
				end
			end 
			l_tick = getTickCount ( )
			removeEventHandler ( 'onClientPreRender', root, renderCurrentText )
			addEventHandler ( 'onClientRender', root, drawAnimatedImage )
		end
	end
	
	if ( isElement ( introVeh ) ) then
		local x, y, z = getElementPosition ( introVeh )
		setCameraMatrix ( x+8, y, z+3, x, y, z )
	end
end

function drawAnimatedImage ( )
	if ( drawImage ) then
		dxDrawImage ( ( sx / 2 - width / 2 ), ( sy / 2 - height / 2 ), width, height, 'logo.png', 0, 0, 0, tocolor ( 255, 255, 255, alpha ) )
		width = width - 0.5
		height = height - 0.5
		
		if ( height < 250 ) then
			lockAlpha = false
		end
		
		if ( lockAlpha and alpha < 255 ) then
			alpha = alpha + 0.5
		elseif ( not lockAlpha and alpha > 0 ) then
			alpha = alpha - 1
			if ( alpha < 30 ) then
				lockAlpha = false
				drawImage = false
				alpha = 0
			end
		end
	else 
		if ( alpha < 255 and not lockAlpha ) then
			alpha = alpha + 1
		end
		dxDrawText ( "Welcome to\nNerd Gaming!", 0, pos_y, sx, sy, tocolor ( 255, 255, 255, alpha ), 3, "pricedown", "center", "center" )
		if ( getTickCount ( ) - l_tick >= 9000 ) then
			lockAlpha = true
			alpha = alpha - 1 
			if ( alpha < 90 ) then
				--alpha = 49
				pos_y = pos_y - 12
				if ( pos_y < -sy ) then
					setTimer ( function ( )
						executePlayerRegisterSpawn ( )
					end, 1500, 1 )
					removeEventHandler ( 'onClientRender', root, drawAnimatedImage )
				end
			end
		end
	end
end

function executePlayerRegisterSpawn ( )
	triggerServerEvent ( "Login:onPlayerFinishIntro", localPlayer )
	isLoggedin = true
end