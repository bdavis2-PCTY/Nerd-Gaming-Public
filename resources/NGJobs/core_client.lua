local _guiSetVisible = guiSetVisible
function guiSetVisible ( window, visible )
	--outputChatBox ( tostring ( window )..": "..tostring( visible ) )
	_guiSetVisible ( window, visible );
end



local do3dtextrender = false
setTimer ( function ( )
	do3dtextrender = exports.NGLogin:isClientLoggedin ( )
end, 1000, 1 )

addEvent ( "onClientPlayerLogin", true )
addEventHandler ( "onClientPlayerLogin", root, function ( )
	do3dtextrender = true
end )


jobDescriptions = { 
	['fisherman'] = [[With the Fisher job, you will be able to spawn a boat and drive around the water to collect caught items. To catch items, you need to be in a boat that's in the water, and you MUST be moving, or else you will just be wasting time. Once your holding area is full, you'll need to return to port to sell your fish.\n\nTo view your net, use the command /net]],
	['medic'] = [[When you're a medic, you can go around healing other players and getting paid for it. The money that you get for healing the player, depends on the amount of the health that they had before.]], 
	['police'] = [[When you're a cop, you will be able to arrest wanted players, so they have to pay the tiem for their crime. To know if a player is wanted, you can check for their name in F5, or look at their name tag, and it will be (theirName)[wantedLevel]. They will also have a police star floating over their head. If a player decides to run from you, you can used the silenced pistol as a taser, and when you shoot them, they'll be put into a tased animation, so you can arrest them.]],
	['mechanic'] = [[When you're employed as a mechanic, you can go around anywhere in Los Santos fixing players cars. To fix a car, you just need to click on it and then it'll ask the client if they'd like to fix it. If they accept, a progress bar will start and then when it finishes, their car will be fix and you'll be paid.]],
	['criminal'] = [[As a criminal, you can go around stealing cars in Los Santos, picking up free weapons in San Fierron and turfing in Las Ventures, but be careful, the police are always after you.]],	
	['detective'] = [[When you are a detective in the Nerd Gaming server, you will still have all of the features availble to you as being a normal police officer (police panel, radio chat, arrests),  other than when you are a detective you will be called on to crime cases when a fellow police officer is murdered. When you arive at the crime scene, you just have to look around for clues of the killer. You will also have the ability to spawn faster vehicles]],
	['pilot'] = [[When you're a pilot, you will fly an aircraft around San Andreas, picking up and delivering passengers from waypoint to waypoint. You will also be able to pick up other players, they will be able to set a waypoint when you deliver them to their waypoint you'll be paid]],
	['stunter'] = [[If you're a stunter, you can go around San Andreas doing tricks on bikes or motorcycles. For every stunt that you do, you'll be paid]],
}


sx, sy = guiGetScreenSize ( )
rSX, rSY = sx / 1280, sx / 1024
local JobWindow = guiCreateWindow( ( sx / 2 - (rSX*500) / 2 ), (sy-(rSY*230))-rSY*15, rSX*500, rSY*230, "Nerd Gaming Job System", false)
local JobDescription = guiCreateMemo((rSX*10), (rSY*23), (rSX*480), (rSY*150), "Job Description", false, JobWindow)
local JobAccept = guiCreateButton((rSX*10), ((rSY*230)-(rSY*25))-rSY*10, (rSX*150), (rSY*25), "Accept Job", false, JobWindow)
local JobDeny = guiCreateButton((rSX*170), ((rSY*230)-(rSY*25))-rSY*10, (rSX*150), (rSY*25), "Deny Job", false, JobWindow)
guiSetVisible ( JobWindow, false )
guiWindowSetSizable(JobWindow, false)
guiWindowSetMovable ( JobWindow, false )
guiSetFont(JobDeny, "default-bold-small")
guiSetFont(JobAccept, "default-bold-small")
guiMemoSetReadOnly ( JobDescription, true )
--guiSetFont(JobDescription, "default-bold-small")
-- settings: { maxDist = 17, showBoarder & Hide rectangle = false }


addEventHandler ( 'onClientPreRender', root, function ( )
	if ( do3dtextrender ) then
		for ind, v in ipairs ( getElementsByType ( '3DText' ) ) do
			local continueRender = true
			local text = getElementData ( v, 'text' )
			local pos = getElementData ( v, 'position' )
			local color = getElementData ( v, 'color' )
			local parent = getElementData ( v, 'parentElement' )
			
			if ( parent ) then
				if ( isElement ( parent ) ) then
					if ( isPedInVehicle ( localPlayer ) and getElementType ( parent ) == 'vehicle' and getPedOccupiedVehicle ( localPlayer ) == parent ) then return end
					local offset = pos
					local px, py, pz = getElementPosition ( parent )
					pos = { px+offset[1], py+offset[2], pz+offset[3] }
					if ( parent == localPlayer ) then
						continueRender = false
					end
				else
					destroyElement ( v )
				end
			end
				
			
			if continueRender and text and pos and color then
				local x, y, z = unpack ( pos )
				local z = z + 1.15
				local settings = getElementData ( v, 'Settings' ) or { }
				local maxDist = settings[1] or 17
				
				if ( settings[2] ) then
					showBoarder = true
				else
					showBoarder = false
				end
				
				local px, py, pz = getElementPosition ( localPlayer )
				local _3DDist = getDistanceBetweenPoints3D ( x, y, z, px, py, pz )
				if ( _3DDist <= maxDist and isLineOfSightClear ( x, y, z, px, py, pz, true, false, false, true, false, false ) ) then
					local x, y = getScreenFromWorldPosition ( x, y, z )
					local r, g, b = unpack ( color )
					if x then
						local textSize = rSY*2
						local textSize = textSize * ( ( maxDist - _3DDist ) / maxDist )
						--local textSize = 2
						local textWidth = dxGetTextWidth(text,textSize,'default')
						local height = dxGetFontHeight ( textSize, 'default' )
						local x = x-(textWidth/2)
						if x and y and r and g and b then
							if ( showBoarder ) then 
								dxDrawRectangle ( x-6, y+1, textWidth+12, height+2, tocolor ( 0, 0, 0, 120 ) )
								dxDrawText ( tostring ( text ), x, y, 0, 0, tocolor ( r, g, b, 255 ), textSize )
							else
								dxDrawBoarderedText ( tostring ( text ), x, y, 0, 0, tocolor ( r, g, b, 255 ), textSize )
							end
						end
					end
				end
			end
		end
	end
end )

function dxDrawBoarderedText ( text, x, y, endX, endY, color, size, font, alignX, alignY, clip, wordBreak, postGUI, colorCode, subPixelPos, fRot, fRotCX, fRotCY, offSet )
	local text = tostring ( text )
	local x = tonumber(x) or 0
	local y = tonumber(y) or 0
	local endX = tonumber(endX) or x
	local endY = tonumber(endY) or y
	local color = color or tocolor ( 255, 255, 255, 255 )
	local size = tonumber(size) or 1
	local font = font or "default"
	local alignX = alignX or "left"
	local alignY = alignY or "top"
	local clip = clip or false
	local wordBreak = wordBreak or false
	local postGUI = postGUI or false
	local colorCode = colorCode or false
	local subPixelPos = subPixelPos or false
	local fRot = tonumber(fRot) or 0
	local fRotCX = tonumber(fRotCX) or 0
	local fRotCY = tonumber(fRotCy) or 0
	local offSet = tonumber(offSet) or 1
	local t_g = text:gsub ( "#%x%x%x%x%x%x", "" )
	dxDrawText ( t_g, x-offSet, y-offSet, endX, endY, tocolor(0,0,0,255), size, font, alignX, alignY, clip, wordBreak, postGUI, colorCode, subPixelPos, fRot, fRotCX, fRotCY, offSet )
	dxDrawText ( t_g, x-offSet, y, endX, endY, tocolor(0,0,0,255), size, font, alignX, alignY, clip, wordBreak, postGUI, colorCode, subPixelPos, fRot, fRotCX, fRotCY, offSet )
	dxDrawText ( t_g, x, y-offSet, endX, endY, tocolor(0,0,0,255), size, font, alignX, alignY, clip, wordBreak, postGUI, colorCode, subPixelPos, fRot, fRotCX, fRotCY, offSet )
	dxDrawText ( t_g, x+offSet, y+offSet, endX, endY, tocolor(0,0,0,255), size, font, alignX, alignY, clip, wordBreak, postGUI, colorCode, subPixelPos, fRot, fRotCX, fRotCY, offSet )
	dxDrawText ( t_g, x+offSet, y, endX, endY, tocolor(0,0,0,255), size, font, alignX, alignY, clip, wordBreak, postGUI, colorCode, subPixelPos, fRot, fRotCX, fRotCY, offSet )
	dxDrawText ( t_g, x, y+offSet, endX, endY, tocolor(0,0,0,255), size, font, alignX, alignY, clip, wordBreak, postGUI, colorCode, subPixelPos, fRot, fRotCX, fRotCY, offSet )
	return dxDrawText ( text, x, y, endX, endY, color, size, font, alignX, alignY, clip, wordBreak, postGUI, colorCode, subPixelPos, fRot, fRotCX, fRotCY, offSet )
end


function create3DText ( str, pos, color, parent, settings ) 
	if str and pos and color then
		local text = createElement ( '3DText' )
		local settings = settings or  { }
		setElementData ( text, "text", str )
		setElementData ( text, "position", pos )
		setElementData ( text, "color", color )
		if ( not parent ) then
			parent = nil
		else
			if ( isElement ( parent ) ) then
				parent = parent
			else
				parent = nil
			end
		end
		setElementData ( text, "Settings", settings )
		setElementData ( text, "parentElement", parent )
		return text
	end
	return false
end

local peds = { }
function refreshGodmodePeds ( )
	for i, v in ipairs ( peds ) do
		destroyElement ( v )
	end
	
	for i, v in ipairs ( getElementsByType ( 'GodmodePed' ) ) do 
		local id = getElementData ( v, "Model" )
		local x, y, z, rz = unpack ( getElementData ( v, "Position" ) )
		peds[i] = createPed ( id, x, y, z, rz )
		setElementFrozen ( peds[i], true )
		addEventHandler ( 'onClientPedDamage', peds[i], function ( ) cancelEvent ( ) end )
	end
	
end
refreshGodmodePeds ( )
setTimer ( refreshGodmodePeds, 30000, 0 )


openedJob = nil
addEvent ( 'NGJobs:OpenJobMenu', true )
addEventHandler ( 'NGJobs:OpenJobMenu', root, function ( job )
	openedJob = job
	guiSetVisible ( JobWindow, true )
	showCursor ( true )
	local desc = jobDescriptions [ job ] 
	guiSetText ( JobDescription, tostring ( desc ) )
	addEventHandler ( "onClientGUIClick", root, clickingevents_jobmenu )
	
end )

function clickingevents_jobmenu ( )
	if ( source == JobDeny ) then
		desc = nil
		openedJob = nil
		guiSetVisible ( JobWindow, false )
		showCursor ( false )
		removeEventHandler ( "onClientGUIClick", root, clickingevents_jobmenu )
	elseif ( source == JobAccept ) then
		
		triggerServerEvent ( "NGJobs:SetPlayerJob", localPlayer, openedJob )
	
		desc = nil
		openedJob = nil
		guiSetVisible ( JobWindow, false )
		showCursor ( false )
		removeEventHandler ( "onClientGUIClick", root, clickingevents_jobmenu )
	end
end

addEventHandler ( 'onClientPlayerWasted', root, function ( )
	if ( source == localPlayer ) then
		showCursor ( false )
		guiSetVisible ( JobWindow, false )
	end
end )










addEvent ( "onPlayerResign", true )