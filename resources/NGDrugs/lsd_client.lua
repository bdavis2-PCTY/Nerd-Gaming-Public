drugs.LSD = {
	loaded = false,
	func = { },
	var = {
		bots = { },
		images = { }
	},

	info = {
		timePerDoce = 30,
		images = { "files/lsd_1.jpg", "files/lsd_2.jpg", "files/lsd_3.jpg" }
	}

}


local LSD = drugs.LSD
function LSD.func.load ( )
	if ( not LSD.loaded ) then
		triggerServerEvent ( "NGDrugs:Module->Core:setPlayerHeadText", localPlayer, "Trippin'", { 200, 30, 30 } )
		LSD.loaded = true
		fadeCamera ( false )
		setTimer ( function ( )
			LSD.func.initiate ( );
			fadeCamera ( true )
		end, 1300, 1 )
	end
	return true
end 

function LSD.func.initiate ( )
	LSD.var.usedIndex = { }
	if ( not LSD.var.bots ) then LSD.var.bots = { } end
	for i, v in pairs ( LSD.var.bots ) do destroyElement ( v ) end
	local x, y, z = getElementPosition ( localPlayer )
	for i=1,40 do
		LSD.func.makeBot ( )
	end 
	LSD.var.lastTick = getTickCount ( )
	LSD.var.lastTick2 = getTickCount ( )
	addEventHandler ( "onClientRender", root, LSD.func.onRender )
	LSD.var.tripSound = playSound ( "files/lsd_music.mp3", true )
	-- world effects
	LSD.var.bEffects = { 
		sunSize = getSunSize ( ),
		moonSize = getMoonSize ( ),
		sky = { getSkyGradient ( ) }
	}
	setSunSize ( 5 )
	setMoonSize ( 5 )
	setSkyGradient ( 255, 0, 0, 70, 70, 70 )
	engineImportTXD ( engineLoadTXD ( "files/lsd_monster.txd" ), 35 )
	engineReplaceModel ( engineLoadDFF ( "files/lsd_monster.dff", 0 ), 35 )
end 

function LSD.func.unload ( )
	if ( not LSD.loaded ) then return false end
	triggerServerEvent ( "NGDrugs:Module->Core:destroyPlayerHeadText", localPlayer )
	fadeCamera ( false )
	setTimer ( function ( )
		LSD.func.uninitiate ( );
		fadeCamera ( true )
	end, 1300, 1 )
	return true
end 

function LSD.func.uninitiate ( ) 
	LSD.loaded = false
	if ( LSD.var.bEffects ) then
		if ( LSD.var.bEffects.sunSize ) then
			setSunSize ( LSD.var.bEffects.sunSize )
		end

		if ( LSD.var.bEffects.moonSize ) then
			setMoonSize ( LSD.var.bEffects.moonSize )
		end

	end 

	resetSkyGradient ( )

	if ( isElement ( LSD.var.tripSound ) ) then
		LSD.var.volTime = setTimer ( function ( ) 
			if ( not isElement ( LSD.var.tripSound ) ) then
				killTimer ( LSD.var.volTime )
			else
				local v = getSoundVolume ( LSD.var.tripSound )
				v = math.round ( v - 0.1, 1 )
				if ( v <= 0 ) then
					destroyElement ( LSD.var.tripSound)
				else
					setSoundVolume ( LSD.var.tripSound, v )
				end
			end
		end, 200, 0 )
	end 

	LSD.var.usedIndex = nil
	for i, v in pairs ( LSD.var.bots ) do
		if ( isElement ( v ) ) then destroyElement ( v ) end
	end

	LSD.var.bots = { }
	removeEventHandler ( "onClientRender", root, LSD.func.onRender )

	engineRestoreModel ( 35 )
end 

function LSD.func.makeBot ( )
	local x, y, z = getElementPosition ( localPlayer )
	local offX = math.random ( -20, 20 );
	local offY = math.random ( -20, 20 );
		
	while ( offX <= 7 and offX >= -7 ) do offX = math.random ( -20, 20 ); end
	while ( offY <= 7 and offY >= -7 ) do offY = math.random ( -20, 20 ); end
	
	local i = 1
	while ( LSD.var.usedIndex [ i ] ) do
		i = i + 1
	end

	LSD.var.usedIndex [ i ] = true
	LSD.var.bots [ i ] = createPed ( 35, x+offX, y+offY, z+0.2 )

	local ped = LSD.var.bots[ i ]

	if ( math.random ( 0, 100 ) < 20 ) then
		setPedOnFire ( LSD.var.bots [ i ], true )
		setElementData ( LSD.var.bots [ i ], "isPedOnFire", true )
	end

	addEventHandler("onClientPedWasted", ped, function ( kil )
		destroyElement ( source )
		if ( not kil or kil ~= localPlayer ) then return end
		triggerServerEvent ( "NGDrugs:Module->LSD:givePlayerCash", localPlayer )
	end )

	setPedControlState ( LSD.var.bots [ i ], "forwards", true )
	setPedControlState ( LSD.var.bots [ i ], "jump", true )

	return LSD.var.bots [ i ]
end 

function LSD.func.onRender ( )
	if ( getTickCount ( ) - LSD.var.lastTick >= 2000 ) then
		LSD.var.lastTick = getTickCount ( )
		LSD.func.makeBot ( )
	end

	if ( getTickCount ( ) - LSD.var.lastTick2 >= 2500 ) then
		table.insert ( LSD.var.images, { x = math.random ( 10, sx_/1.5 ), y = math.random ( 10, sy_/1.5 ), w=math.random(200,400), h=math.random(200,500), alpha = 200, rot = 0, src=LSD.info.images[math.random(#LSD.info.images)] } )
		LSD.var.lastTick2 = getTickCount ( )
	end 

	-- draw trippin' illusions 
	local remove = { }
	for i, v in pairs ( LSD.var.images ) do
		local alpha = math.floor ( v.alpha - 1 )

		v.x = v.x + math.random ( -8, 8 )
		v.y = v.y + math.random ( -8, 8 )
		v.rot = v.rot + math.random ( -2, 7 )
		if ( v.rot >= 360 ) then
			v.rot = 0
		end

		v.w = v.w + math.random ( -2, 2 )
		v.h = v.h + math.random ( -8, 8 )

		dxDrawImage ( sx*v.x, sy*v.y, sx*v.w, sy*v.h, v.src, v.rot, 0, 0, tocolor ( 255, 255, 255, alpha ) )
		LSD.var.images [ i ].alpha = alpha

		if ( alpha <= 0 ) then
			remove [ i ] = true
		end
	end 
	for i, v in pairs ( remove ) do
		LSD.var.images [ i ] = nil
	end

	-- update bots
	local remove = { }
	local x, y, z = getElementPosition ( localPlayer )
	for i, v in pairs ( LSD.var.bots ) do
		if ( isElement ( v ) ) then
			local px, py, _ = getElementPosition ( v )
			local rot = findRotation ( px, py, x, y )
			setPedRotation ( v, rot )

			local dist = math.floor ( getDistanceBetweenPoints2D ( x, y, px, py ) )
			local alpha = 255

			setPedOnFire ( v, getElementData ( v, "isPedOnFire" ) or false )

			if ( dist < 10 ) then
				local dist = 9 - dist 
				alpha = math.floor ( 255 - ( dist ^ 2.8 ) )
				if ( alpha <= 0 ) then
					destroyElement ( v )
					remove [ i ] = true
				end
			end 
			
			if ( isElement ( v ) ) then
				setElementAlpha ( v, alpha )
			end
		else 
			remove [ i ] = true
		end 
	end 

	for i, v in pairs (remove ) do
		LSD.var.bots [ i ] = nil
	end 

	dxDrawRectangle ( 0, 0, sx_, sy_, tocolor ( 200, 0, 0, 70 + math.random ( -10, 10 ) ) )
end 

function findRotation ( x1, y1, x2, y2 )
	local t = -math.deg(math.atan2(x2-x1,y2-y1))
	if t < 0 then t = t + 360 end;
	return t;
end



drugs.LSD = LSD