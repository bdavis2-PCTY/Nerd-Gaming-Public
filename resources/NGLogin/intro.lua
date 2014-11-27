local sx_, sy_ = guiGetScreenSize ( )
local sx, sy = sx_ / 1280, sy_ / 720

function startIntro ( )
	ThemeSong = playSound ( "files/song.mp3" )

	fadeCamera ( false )
	drawImage = true
	alpha = 255
	width = sx*math.floor ( sx_ / 1.8 )
	height = sy*math.floor ( sy_ / 1.8 )
	addEventHandler ( "onClientRender", root, drawAnimatedImage)
end

function drawAnimatedImage ( )
	if ( drawImage ) then
		dxDrawImage ( (sx_/2-width/2), (sy_/2-height/2), width, height, "files/logo.png", 0, 0, tocolor ( 0, 0, 0, alpha ) ) 
		height = height - ( sy*1 )
		width = width - ( sx*1.7 )
		if ( height <= 0 or width <= 0 ) then
			drawImage = false
			width = nil
			height = nil

			text_y = 0
			text_alpha = 0
			hasDoneTextLoad = false
		end
	else
		dxDrawText ( "Welcome to\nNerd Gaming!", 0, text_y, sx_, text_y+sy_, tocolor ( 255, 255, 0, text_alpha ), sy*3, "pricedown", "center", "center" )
		if ( not hasDoneTextLoad and text_alpha < 255 ) then
			text_alpha = text_alpha + 1 
		else
			if ( not textFinishTick and not hasDoneTextLoad ) then
				textFinishTick = getTickCount ( )
			end

			if( getTickCount ( ) > textFinishTick + 7000 ) then
				hasDoneTextLoad = true
				if ( text_alpha > 0 ) then
					text_alpha = text_alpha - 1
				else 
					text_alpha = nil
					text_y = nil
					hasDoneTextLoad = nil
					removeEventHandler ( "onClientRender", root, drawAnimatedImage )
					executePlayerRegisterSpawn ( )
				end
			end 
		end
	end
end

function executePlayerRegisterSpawn ( )
	triggerServerEvent ( "Login:onPlayerFinishIntro", localPlayer )
	isLoggedin = true

	volTime = setTimer ( function ( ) 
		if ( not isElement ( ThemeSong ) ) then
			killTimer ( volTime )
		else
			local v = getSoundVolume ( ThemeSong )
			v = math.round ( v - 0.1, 1 )
			if ( v <= 0 ) then
				destroyElement ( ThemeSong )
			else
				setSoundVolume ( ThemeSong, v )
			end
		end
	end, 200, 0 )
end


function math.round(number, decimals, method)
    decimals = decimals or 0
    local factor = 10 ^ decimals
    if (method == "ceil" or method == "floor") then return math[method](number * factor) / factor
    else return tonumber(("%."..decimals.."f"):format(number)) end
end
