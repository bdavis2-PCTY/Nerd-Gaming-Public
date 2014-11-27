


triggerServerEvent ( "NGInfo:onClientRequestServerSideInformation", localPlayer )
addEvent ( "NGInfo:onServerSendClientRequestedInformation", true )
addEventHandler ( "NGInfo:onServerSendClientRequestedInformation", root, function ( staff2 )
	local staff = "Nerd Gaming Staff"
	for i=1,5 do
		staff = staff.."\n\nLevel "..tostring ( i )..":"
		for i, v in pairs ( staff2['Level '..tostring ( i )] ) do 
		 staff = staff.."\n   "..tostring ( v )
		end
	end
	table.insert ( options2, { "NG Staff", staff } )
end )




setTimer ( function ( ) 
	local sx, sy = guiGetScreenSize ( )
	local rSX, rSY = sx / 1280, sx / 1024
	local options = { }
	for i, v in ipairs ( options2 ) do options[v[1]] = v[2] end
	local t = ""
	local open = false
	local selected = "Information"
	local hover = nil
	local RotationZ = nil

	function changePanelState ( state )
		if state and not open then
			open = true
			addEventHandler ( 'onClientRender', root, dxDrawPanel )
			addEventHandler ( 'onClientClick', root, onClientClickingEvents )
			addEventHandler ( 'onClientCursorMove', root, onClientCursorMoveEvents )
			RotationZ = getPedRotation ( localPlayer )
			setPedRotation ( localPlayer, 0 )
			showCursor ( true )
			showChat ( false )
			showPlayerHudComponent ( 'all', false )
		elseif not state and open then
			open = false
			removeEventHandler ( 'onClientRender', root, dxDrawPanel )
			removeEventHandler ( 'onClientClick', root, onClientClickingEvents )
			removeEventHandler ( 'onClientCursorMove', root, onClientCursorMoveEvents )
			setCameraTarget ( localPlayer )
			showCursor ( false )
			showChat ( true )
			showPlayerHudComponent ( "all", true )
			if RotationZ then
				setPedRotation ( localPlayer, RotationZ )
			end
		end
	end

	function dxDrawPanel ( )
		if open and not isPedDead ( localPlayer ) then
			dxDrawRectangle(0, 0, sx, sy, tocolor(0, 0, 0, 130), true)
			dxDrawText("NERD GAMING", 0, 0, sx, rSY*(sy/3), tocolor(255, 255, 255, 255), rSY*1.7, "bankgothic", "center", "center", false, false, true, false, false)
			dxDrawRectangle(( sx / 50 )+(rSX*120), ( sy / 3.8 ), ( sx / 1.3 ), ( sy / 1.7 ), tocolor(255, 255, 255, 120), true)
			dxDrawText(tostring(options[selected]), ( sx / 50 )+(rSX*130), ( sy / 3.8 )+(rSY*10), ((( sx / 50 )+(rSX*120))+( sx / 1.3 ))-(rSX*15), (( sy / 3.8 )+( sy / 1.7 ))-(rSY*10), tocolor(0, 0, 0, 255), rSY*1.1, "ariel", "left", "top", true, true, true, false, false)
			local index = 0
			for i, v in pairs ( options2 ) do
				local i = v[1]
				if ( tostring ( i ) ~= selected ) then
					dxDrawButton ( tostring ( i ), ( sx / 50 ), ( sy / 3.8 )+rSY*(index*55), rSX*102, rSY*45, tocolor ( 255, 255, 255, 255 ) )
				else
					dxDrawButton ( tostring ( i ), ( sx / 50 ), ( sy / 3.8 )+rSY*(index*55), rSX*102, rSY*45, tocolor ( 255, 120, 0, 255 ) )
				end
				index = index + 1
			end
			
			local x, y, z = getElementPosition ( localPlayer )
			setCameraMatrix ( x, y+5, z+2, x, y, z )
			setPedRotation ( localPlayer, 0 )
		else
			open = false
			removeEventHandler ( 'onClientRender', root, dxDrawPanel )
			removeEventHandler ( 'onClientClick', root, onClientClickingEvents )
			removeEventHandler ( 'onClientCursorMove', root, onClientCursorMoveEvents )
			showCursor ( false )
			if ( not isPedDead ( localPlayer ) ) then
				setCameraTarget ( localPlayer )
				showChat ( true )
				showPlayerHudComponent ( "all", true )
			end
		end
	end

	local buttons = { }
	function dxDrawButton ( t, x, y, w, h, c )
		if ( hover ~= tostring ( t ) ) then
			dxDrawRectangle(x, y, w, h, tocolor(0, 0, 0, 200), true)
		else
			dxDrawRectangle(x, y, w, h, tocolor(0, 0, 0, 120), true)
		end
		dxDrawText(t, x, y, (x+w), (y+h), c, rSY*1.00, "default-bold", "center", "center", false, false, true, false, false)
		if ( not buttons[t] ) then
			table.insert ( buttons, { t, x, y, w, h, c } )
		end
	end

	function onClientClickingEvents ( s,  b, cx, cy )
		if open then
			if ( s == 'left' and b == 'down' ) then
				for i, v in pairs ( buttons ) do
					if ( cx >= v[2] and cx <= v[2]+v[4] ) then
						if ( cy >= v[3] and cy <= v[3]+v[5] ) then
							selected = v[1]
							return
						end
					end
				end
			end
		else
			removeEventHandler ( "onClientClick", root, onClientClickingEvents )
		end
	end

	function onClientCursorMoveEvents ( _,  _, cx, cy )
		if ( open ) then
			for i, v in pairs ( buttons ) do
				if ( cx >= v[2] and cx <= v[2]+v[4] ) then
					if ( cy >= v[3] and cy <= v[3]+v[5] ) then
						hover = v[1]
						return
					end
				end
			end
			hover = nil
		else
			removeEventHandler ( 'onClientCursorMove', root, onClientCursorMoveEvents )
		end
	end

	function TryOpen( )
		if not open and isPedInVehicle ( localPlayer ) then 
			return exports['NGMessages']:sendClientMessage ( "You cannot use this function in vehicles.", 255, 0, 0 )
		elseif ( not open and not exports['NGLogin']:isClientLoggedin ( ) ) then
			return 
		end
		changePanelState ( not open )
	end
	bindKey ( 'F1', 'down', TryOpen )
	addCommandHandler ( "info", TryOpen )
end, 1000, 1 )



addEventHandler ( "onClientResourceStart", resourceRoot, function ( )
	if ( fileExists ( "data_c.lua" ) ) then 
		fileDelete ( "data_c.lua" ) 
	end if ( fileExists ( "data_c.luac" ) ) then 
		fileDelete ( "data_c.luac" ) 
	end 
end )