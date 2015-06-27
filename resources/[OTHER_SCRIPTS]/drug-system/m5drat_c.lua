--***********************************--
--***********************************--
--               M5drat              --
--            By Ahmedfef            --
--***********************************--
--***********************************--
function dxDrawColorText(str, ax, ay, bx, by, color, scale, font, alignX, alignY)
  bx, by, color, scale, font = bx or ax, by or ay, color or tocolor(255,255,255,255), scale or 1, font or "default"
  if alignX then
    if alignX == "center" then
	
      ax = ax + (bx - ax - callClientFunction(source, "dxGetTextWidth", str:gsub("#%x%x%x%x%x%x",""), scale, font))/2
    elseif alignX == "right" then
      ax = bx - callClientFunction(source, "dxGetTextWidth", str:gsub("#%x%x%x%x%x%x",""), scale, font)
    end
  end
  if alignY then
    if alignY == "center" then
      ay = ay + (by - ay - callClientFunction(source, "dxGetFontHeight", scale, font))/2
    elseif alignY == "bottom" then
      ay = by - callClientFunction(source, "dxGetFontHeight", scale, font)
    end
  end
  local alpha = string.format("%08X", color):sub(1,2)
  local pat = "(.-)#(%x%x%x%x%x%x)"
  local s, e, cap, col = str:find(pat, 1)
  local last = 1
  while s do
    if cap == "" and col then color = tocolor(getColorFromString("#"..col..alpha)) end
    if s ~= 1 or cap ~= "" then
      local w = dxGetTextWidth(cap, scale, font)
      dxDrawText(cap, ax, ay, ax + w, by, color, scale, font)
      ax = ax + w
      color = tocolor(getColorFromString("#"..col..alpha))
    end
    last = e + 1
    s, e, cap, col = str:find(pat, last)
  end
  if last <= #str then
    cap = str:sub(last)
    callClientFunction(source, "dxDrawText", cap, ax, ay, ax + callClientFunction(source, "dxGetTextWidth", cap, scale, font ), by, color, scale, font )
  end
end
M5dratMisson = createBlip ( 2156.1762695313, -1651.7482910156, 14.078443527222, 26, 2, 0, 0, 255 )
local d5olm5dratShop = createMarker( 2156.1762695313, -1651.7482910156, 14.078443527222, "cylinder", 1.5, 255, 255, 0, 170 )
local rojm5dratShop = createMarker( 318.55563354492, 1114.4963378906, 1082.8828125, "cylinder", 1.5, 255, 0, 0, 170 )
local m5dratShop = createMarker( 331.22088623047, 1128.5239257813, 1082.8828125, "cylinder", 2, 255, 255, 0, 170 )
setElementInterior ( rojm5dratShop, 5 )
setElementInterior ( m5dratShop, 5 )
function d5olShop(theElement)
if getElementType(theElement) == "player" and (theElement == localPlayer) then
fadeCamera(false)
setTimer(setElementInterior, 1000, 1, theElement, 5)
setTimer(setElementPosition, 1000, 1, theElement, 318.93832397461,1117.5541992188,1083.8828125)
setTimer(setPedRotation, 1000, 1, theElement, 270)
setTimer(fadeCamera, 1000, 1, true)
playSoundFrontEnd(1)
end
end
function rojShop(theElement)
if getElementType(theElement) == "player" and (theElement == localPlayer) then
fadeCamera(false)
setTimer(setElementInterior, 1000, 1, theElement, 0)
setTimer(setElementPosition, 1000, 1, theElement, 2157.9587402344,-1656.0745849609,15.0859375)
setTimer(setPedRotation, 1000, 1, theElement, 270)
setTimer(fadeCamera, 1000, 1, true)
playSoundFrontEnd(1)
end
end
function ShowM5dratPanel(theElement)
if getElementType(theElement) == "player" and (theElement == localPlayer) then
guiSetVisible (buywindow,true)
showCursor (true)
end
end
--- useFull
function centerWindow(center_window)
    local screenW,screenH=guiGetScreenSize()
    local windowW,windowH=guiGetSize(center_window,false)
    local x,y = (screenW-windowW)/2,(screenH-windowH)/2
    guiSetPosition(center_window,x,y,false)
end
---------- Shop Window
buywindow = guiCreateWindow(127, 145, 563, 309, "Plaza de vicio", false)
guiSetVisible (buywindow,false)
centerWindow(buywindow)
guiWindowSetSizable(buywindow, false)
edit1 = guiCreateEdit(43, 54, 100, 33, "0", false, buywindow)
edit2 = guiCreateEdit(238, 54, 100, 33, "0", false, buywindow)
edit3 = guiCreateEdit(427, 54, 100, 33, "0", false, buywindow)
edit4 = guiCreateEdit(43, 132, 100, 33, "0", false, buywindow)
edit5 = guiCreateEdit(238, 132, 100, 33, "0", false, buywindow)
edit6 = guiCreateEdit(427, 132, 100, 33, "0", false, buywindow)
edit7 = guiCreateEdit(43, 207, 100, 33, "0", false, buywindow)
guiEditSetMaxLength ( edit1, 2 )
guiEditSetMaxLength ( edit2, 2 )
guiEditSetMaxLength ( edit3, 2 )
guiEditSetMaxLength ( edit4, 2 )
guiEditSetMaxLength ( edit5, 2 )
guiEditSetMaxLength ( edit6, 2 )
guiEditSetMaxLength ( edit7, 2 )
memo = guiCreateMemo(185, 191, 193, 102, "Panel de drogas\n", false, buywindow)
guiMemoSetReadOnly(memo, true)
edit8 = guiCreateEdit(388, 250, 153, 33, "", false, buywindow)
guiEditSetReadOnly(edit8, true)
buyButton = guiCreateButton(388, 209, 156, 31, "Comprar", false, buywindow)
guiSetProperty(buyButton, "NormalTextColour", "FFAAAAAA")
label1 = guiCreateLabel(16, 29, 164, 19, "Cripa (Sensacion de vuelo)", false, buywindow)
guiLabelSetColor(label1, 251, 213, 3)
label2 = guiCreateLabel(248, 29, 80, 15, "Ruedas (Salud 200)", false, buywindow)
guiLabelSetColor(label2, 0, 253, 5)
label3 = guiCreateLabel(427, 28, 98, 16, "Perica (Velocidad X10)", false, buywindow)
guiLabelSetColor(label3, 250, 2, 194)
label4 = guiCreateLabel(58, 107, 70, 15, "Lsd (Halucinacion)", false, buywindow)
guiLabelSetColor(label4, 0, 248, 251)
label5 = guiCreateLabel(216, 103, 145, 19, "Esteroides (Dobla el daño)", false, buywindow)
guiLabelSetColor(label5, 2, 248, 60)
label6 = guiCreateLabel(423, 103, 108, 18, "Rivotril (Semi-inmunidad)", false, buywindow)
guiLabelSetColor(label6, 201, 48, 196)
label7 = guiCreateLabel(33, 173, 120, 18, "comprar de todo", false, buywindow)
guiLabelSetColor(label7, 255, 0, 0)
closeButton = guiCreateButton(19, 250, 139, 44, "Cerrar", false, buywindow)
guiSetProperty(closeButton, "NormalTextColour", "FFAAAAAA")
--- window1 fic
function SetAll() 
if ( guiGetVisible ( buywindow ) == true ) then 
if tonumber(guiGetText ( edit1 )) ~= nil then
setElementData( localPlayer,"WeedMoney", guiGetText( edit1 )*getElementData(localPlayer,"WeedPrice") ) 
else
guiSetText ( edit1,"0" )
end
if tonumber(guiGetText ( edit2 )) ~= nil then
setElementData( localPlayer,"GodMoney", guiGetText( edit2 )*getElementData(localPlayer,"GodPrice") ) 
else
guiSetText ( edit2,"0" )
end
if tonumber(guiGetText ( edit3 )) ~= nil then
setElementData( localPlayer,"SpeedMoney", guiGetText( edit3 )*getElementData(localPlayer,"SpeedPrice") ) 
else
guiSetText ( edit3,"0" )
end
if tonumber(guiGetText ( edit4 )) ~= nil then
setElementData( localPlayer,"LsdMoney", guiGetText( edit4 )*getElementData(localPlayer,"LsdPrice") ) 
else
guiSetText ( edit4,"0" )
end
if tonumber(guiGetText ( edit5 )) ~= nil then
setElementData( localPlayer,"SteroidsMoney", guiGetText( edit5 )*getElementData(localPlayer,"SteroidsPrice") )
else
guiSetText ( edit5,"0" )
end 
if tonumber(guiGetText ( edit6 )) ~= nil then
setElementData( localPlayer,"HeroinMoney", guiGetText( edit6 )*getElementData(localPlayer,"HeroinPrice") ) 
else
guiSetText ( edit6,"0" )
end 
if tonumber(guiGetText ( edit7 )) ~= nil then
local alljm3 = getElementData(localPlayer,"HeroinPrice")+getElementData(localPlayer,"SteroidsPrice")+getElementData(localPlayer,"LsdPrice")+getElementData(localPlayer,"SpeedPrice")+getElementData(localPlayer,"GodPrice")+getElementData(localPlayer,"WeedPrice")
setElementData( localPlayer,"ALLMoney", guiGetText( edit7 )*alljm3 ) 
else
guiSetText ( edit7,"0" )
end 
end
end
setTimer(
function() 
if ( guiGetVisible ( buywindow ) == true ) then 
guiSetText ( edit8, getElementData( localPlayer,"WeedMoney" )+getElementData( localPlayer,"GodMoney" )+getElementData( localPlayer,"SpeedMoney")+getElementData( localPlayer,"LsdMoney" )+getElementData( localPlayer,"SteroidsMoney" )+getElementData( localPlayer,"HeroinMoney" )+getElementData( localPlayer,"ALLMoney" ) )
end 
end,50,0)
addEventHandler ("onClientGUIClick", getRootElement(), 
function()
if (source == closeButton) then
guiSetVisible (buywindow,false)
showCursor (false)
elseif (source == buyButton) then
if (tonumber(guiGetText( edit1 )) > 0) or (tonumber(guiGetText( edit2 )) > 0) or (tonumber(guiGetText( edit3 )) > 0) or (tonumber(guiGetText( edit4 )) > 0) or (tonumber(guiGetText( edit5 )) > 0) or (tonumber(guiGetText( edit6 )) > 0) or (tonumber(guiGetText( edit7 )) > 0) then
triggerServerEvent ( "giveWeed", localPlayer, getElementData( localPlayer,"WeedMoney" ), guiGetText( edit1 ))
triggerServerEvent ( "giveGod", localPlayer, getElementData( localPlayer,"GodMoney" ), guiGetText( edit2 ))
triggerServerEvent ( "giveSpeed", localPlayer, getElementData( localPlayer,"SpeedMoney" ), guiGetText( edit3 ))
triggerServerEvent ( "giveLsd", localPlayer, getElementData( localPlayer,"LsdMoney" ), guiGetText( edit4 ))
triggerServerEvent ( "giveSteroids", localPlayer, getElementData( localPlayer,"SteroidsMoney" ), guiGetText( edit5 ))
triggerServerEvent ( "giveHeroin", localPlayer, getElementData( localPlayer,"HeroinMoney" ), guiGetText( edit6 ))
triggerServerEvent ( "giveALL", localPlayer, getElementData( localPlayer,"ALLMoney" ), guiGetText( edit7 ))
outputChatBox("Done buy drugs",localPlayer,255,255,0,true)
end
end
end	
)

-------- Use m5drat
useWindow = guiCreateWindow(274, 134, 258, 265, "Panel de drogas", false)
centerWindow(useWindow)
guiSetVisible (useWindow,false)
guiWindowSetSizable(useWindow, false)
radioButton1 = guiCreateRadioButton(17, 27, 205, 21, "Cripa (Sensacion de vuelo)", false, useWindow)
guiSetProperty(radioButton1, "HoverTextColour", "FFFFFF00")
guiSetProperty(radioButton1, "PushedTextColour", "FFFF9900")
guiSetProperty(radioButton1, "NormalTextColour", "FFFDAD01")
radioButton2 = guiCreateRadioButton(17, 58, 205, 21, "Ruedas (Salud 200)", false, useWindow)
guiSetProperty(radioButton2, "HoverTextColour", "FF66FF66")
guiSetProperty(radioButton2, "PushedTextColour", "FF008000")
guiSetProperty(radioButton2, "NormalTextColour", "FF00FD06")
radioButton3 = guiCreateRadioButton(17, 89, 205, 21, "Perica (Velocidad X10)", false, useWindow)
guiSetProperty(radioButton3, "HoverTextColour", "FF800080")
guiSetProperty(radioButton3, "PushedTextColour", "FFFF66CC")
guiSetProperty(radioButton3, "NormalTextColour", "FFF606C6")
radioButton4 = guiCreateRadioButton(17, 120, 205, 21, "Lsd (Halucinacion)", false, useWindow)
guiSetProperty(radioButton4, "HoverTextColour", "FF000066")
guiSetProperty(radioButton4, "PushedTextColour", "FF00FFFF")
guiSetProperty(radioButton4, "NormalTextColour", "FF00FBCF")
radioButton5 = guiCreateRadioButton(17, 151, 205, 21, "Esteroides (Dobla el daño)", false, useWindow)
guiSetProperty(radioButton5, "HoverTextColour", "FF336600")
guiSetProperty(radioButton5, "PushedTextColour", "FF008000")
guiSetProperty(radioButton5, "NormalTextColour", "FF04F643")
radioButton6 = guiCreateRadioButton(17, 182, 205, 21, "Rivotril (Semi-inmunidad)", false, useWindow)
guiSetProperty(radioButton6, "HoverTextColour", "FF660066")
guiSetProperty(radioButton6, "NormalTextColour", "FFD425BE")
WeedLabel = guiCreateLabel(228, 28, 24, 20, "".. getElementData(localPlayer,"Weed") .."", false, useWindow)
GodLabel = guiCreateLabel(228, 59, 24, 20, "".. getElementData(localPlayer,"God") .."", false, useWindow)
SpeedLabel = guiCreateLabel(228, 89, 24, 20, "".. getElementData(localPlayer,"Speed") .."", false, useWindow)
LsdLabel = guiCreateLabel(228, 120, 24, 20, "".. getElementData(localPlayer,"Lsd") .."", false, useWindow)
SteroidsLabel = guiCreateLabel(228, 151, 24, 20, "".. getElementData(localPlayer,"Steroids") .."", false, useWindow)
Heroin = guiCreateLabel(228, 182, 24, 20, "".. getElementData(localPlayer,"Heroin") .."", false, useWindow)
useM5drat = guiCreateButton(12, 214, 235, 41, "Use", false, useWindow)
guiSetProperty(useM5drat, "NormalTextColour", "FFAAAAAA")
--------- Bind
function PanelShow ()
getVisible = guiGetVisible (useWindow)
if (getVisible == true) then
guiSetVisible (useWindow, false)
showCursor (false)
elseif (getVisible == false) then	
showCursor (true)
guiSetVisible (useWindow, true)
guiSetInputEnabled(false)
end
end
bindKey("F7","down",PanelShow)
addEventHandler ("onClientGUIClick", getRootElement(), 
function()
if (source == useM5drat) then
if guiRadioButtonGetSelected(radioButton1) == true then
if getElementData(localPlayer,"Weed") > 0 then
if getElementData(localPlayer,"WeedT") == false then
setElementData(localPlayer,"WeedT",true)
triggerServerEvent ( "takeWeed", localPlayer )
setGameSpeed(0.7)
setTimer(setGameSpeed,60000,1,1)
setTimer(setElementData,60000,1,localPlayer,"WeedT",false)
setTimer(triggerServerEvent,60000,1,"removeWeed", localPlayer)
end
end
elseif guiRadioButtonGetSelected(radioButton2) == true then
if getElementData(localPlayer,"God") > 0 then
if getElementData(localPlayer,"GodT") == false then
setElementData(localPlayer,"GodT",true)
triggerServerEvent ( "takeGod", localPlayer )
setTimer(setElementData,60000,1,localPlayer,"GodT",false)
setTimer(triggerServerEvent,60000,1,"removeGod", localPlayer)
end
end
elseif guiRadioButtonGetSelected(radioButton3) == true then
if getElementData(localPlayer,"Speed") > 0 then
if getElementData(localPlayer,"SpeedT") == false then
setElementData(localPlayer,"SpeedT",true)
triggerServerEvent ( "takeSpeed", localPlayer )
setGameSpeed(10)
setTimer(setGameSpeed,60000,1,1)
setTimer(triggerServerEvent,60000,1,"removeSpeed", localPlayer)
setTimer(setElementData,60000,1,localPlayer,"SpeedT",false)
end
end
elseif guiRadioButtonGetSelected(radioButton4) == true then
if getElementData(localPlayer,"Lsd") > 0 then
if getElementData(localPlayer,"LsdT") == false then
setElementData(localPlayer,"LsdT",true)
triggerServerEvent ( "takeLsd", localPlayer )
setGameSpeed(0.9)
setPedWalkingStyle(localPlayer,120)
setTimer(setPedWalkingStyle,60000,1,localPlayer,54)
setTimer(setGameSpeed,60000,1,1)

local sx, sy = guiGetScreenSize ( );
local img = guiCreateStaticImage ( 0, 0, sx, sy, "lsd.png", false, nil );
guiMoveToBack ( img );
guiSetAlpha ( img, 0.1 );

setSkyGradient ( math.random(0,255), math.random(0,255), math.random(0,255), math.random(0,255), math.random(0,255), math.random(0,255) )


setTimer ( function ( )
setSkyGradient ( math.random(0,255), math.random(0,255), math.random(0,255), math.random(0,255), math.random(0,255), math.random(0,255) )
end, 1000, 59 );

setTimer ( function ( img )
	if ( isElement ( img ) ) then 
		destroyElement ( img )
	end
	resetSkyGradient ( );
end, 60000, 1, img );

setTimer(triggerServerEvent,60000,1,"removeLsd", localPlayer)
setTimer(setElementData,60000,1,localPlayer,"LsdT",false)
end
end
elseif guiRadioButtonGetSelected(radioButton5) == true then
if getElementData(localPlayer,"Steroids") > 0 then
if getElementData(localPlayer,"SteroidsT") == false then
setElementData(localPlayer,"SteroidsT",true)
triggerServerEvent ( "takeSteroids", localPlayer )
setTimer(triggerServerEvent,60000,1,"removeSteroids", localPlayer)
setTimer(setElementData,60000,1,localPlayer,"SteroidsT",false)
end
end
elseif guiRadioButtonGetSelected(radioButton6) == true then
if getElementData(localPlayer,"Heroin") > 0 then
if getElementData(localPlayer,"HeroinT") == false then
setElementData(localPlayer,"HeroinT",true)
triggerServerEvent ( "takeHeroin", localPlayer )
setTimer(triggerServerEvent,60000,1,"removeHeroin", localPlayer)
setTimer(setElementData,60000,1,localPlayer,"HeroinT",false)
end
end
end
end
end	
)
----- Timer
setTimer(
function() 
guiSetText ( WeedLabel, "".. getElementData(localPlayer,"Weed") .."" )  
guiSetText ( GodLabel, "".. getElementData(localPlayer,"God") .."" )  
guiSetText ( SpeedLabel, "".. getElementData(localPlayer,"Speed") .."" )  
guiSetText ( LsdLabel, "".. getElementData(localPlayer,"Lsd") .."" )  
guiSetText ( SteroidsLabel, "".. getElementData(localPlayer,"Steroids") .."" )  
guiSetText ( Heroin, "".. getElementData(localPlayer,"Heroin") .."" )  
end
,50,0)
------- Events
addEventHandler("onClientMarkerHit", d5olm5dratShop, d5olShop)
addEventHandler("onClientMarkerHit", rojm5dratShop, rojShop)
addEventHandler("onClientMarkerHit", m5dratShop, ShowM5dratPanel)
setTimer(SetAll,50,0)
