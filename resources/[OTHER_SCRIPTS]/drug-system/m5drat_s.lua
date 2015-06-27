--***********************************--
--***********************************--
--               M5drat              --
--            By Ahmedfef            --
--***********************************--
--***********************************--
----- doubleDammge
function playerDamage ( attacker, weapon, bodypart, loss )
if getElementData(attacker,"SteroidsUse") == true then
setElementHealth ( source, getElementHealth(source) - loss )
end
if getElementData(source,"HeroinUse") == true then
setElementHealth ( source, getElementHealth(source) + 3 )
end
end
addEventHandler ( "onPlayerDamage", getRootElement (), playerDamage )
----- settings
wepr = get("WeedPrice")
gopr = get("GodPrice")
sppr = get("SpeedPrice")
lspr = get("LsdPrice")
stpr = get("SteroidsPrice")
hepr = get("HeroinPrice")
---
addEventHandler("onPlayerJoin",root,
function()
setElementData(source,"Weed",0)
setElementData(source,"God",0)
setElementData(source,"Speed",0)
setElementData(source,"Lsd",0)
setElementData(source,"Steroids",0)
setElementData(source,"Heroin",0)
setElementData(source,"WeedMoney",0)
setElementData(source,"GodMoney",0)
setElementData(source,"SpeedMoney",0)
setElementData(source,"LsdMoney",0)
setElementData(source,"SteroidsMoney",0)
setElementData(source,"HeroinMoney",0)
setElementData(source,"ALLMoney",0)
setElementData(source,"WeedPrice",wepr)
setElementData(source,"GodPrice",gopr)
setElementData(source,"SpeedPrice",sppr)
setElementData(source,"LsdPrice",lspr)
setElementData(source,"SteroidsPrice",stpr)
setElementData(source,"HeroinPrice",hepr)
setElementData(source,"SteroidsUse",false)
setElementData(source,"HeroinUse",false)
setElementData(source,"WeedT",false)
setElementData(source,"GodT",false)
setElementData(source,"SpeedT",false)
setElementData(source,"LsdT",false)
setElementData(source,"SteroidsT",false)
setElementData(source,"HeroinT",false)
end)

addEventHandler("onResourceStart",resourceRoot,
function()
local players = getElementsByType ( "player" )
for i,p in ipairs(players) do
setElementData(p,"WeedT",false)
setElementData(p,"GodT",false)
setElementData(p,"SpeedT",false)
setElementData(p,"LsdT",false)
setElementData(p,"SteroidsT",false)
setElementData(p,"HeroinT",false)
setElementData(p,"SteroidsUse",false)
setElementData(p,"HeroinUse",false)
setElementData(p,"ALLMoney",0)
setElementData(p,"WeedMoney",0)
setElementData(p,"GodMoney",0)
setElementData(p,"SpeedMoney",0)
setElementData(p,"LsdMoney",0)
setElementData(p,"SteroidsMoney",0)
setElementData(p,"HeroinMoney",0)
setElementData(p,"WeedPrice",wepr)
setElementData(p,"GodPrice",gopr)
setElementData(p,"SpeedPrice",sppr)
setElementData(p,"LsdPrice",lspr)
setElementData(p,"SteroidsPrice",stpr)
setElementData(p,"HeroinPrice",hepr)
local sourceAccount = getPlayerAccount ( p )
if isGuestAccount ( sourceAccount ) then
setElementData(p,"Weed",0)
setElementData(p,"God",0)
setElementData(p,"Speed",0)
setElementData(p,"Lsd",0)
setElementData(p,"Steroids",0)
setElementData(p,"Heroin",0)
else
if (getAccountData(sourceAccount, "Weed")) then
setElementData(p,"Weed",getAccountData(sourceAccount, "Weed"))
end
if (getAccountData(sourceAccount, "God")) then
setElementData(p,"God",getAccountData(sourceAccount, "God"))
end
if (getAccountData(sourceAccount, "Speed")) then
setElementData(p,"Speed",getAccountData(sourceAccount, "Speed"))
end
if (getAccountData(sourceAccount, "Lsd")) then
setElementData(p,"Lsd",getAccountData(sourceAccount, "Lsd"))
end
if (getAccountData(sourceAccount, "Steroids")) then
setElementData(p,"Steroids",getAccountData(sourceAccount, "Steroids"))
end
if (getAccountData(sourceAccount, "Heroin")) then
setElementData(p,"Heroin",getAccountData(sourceAccount, "Heroin"))
end
if not (getAccountData(sourceAccount, "Weed")) and not (getAccountData(sourceAccount, "God")) and not (getAccountData(sourceAccount, "Speed")) and not (getAccountData(sourceAccount, "Lsd")) and not (getAccountData(sourceAccount, "Steroids")) and not (getAccountData(sourceAccount, "Heroin")) then
setElementData(p,"Weed",0)
setElementData(p,"God",0)
setElementData(p,"Speed",0)
setElementData(p,"Lsd",0)
setElementData(p,"Steroids",0)
setElementData(p,"Heroin",0)
end
end
end
end
)
addEventHandler("onPlayerLogout",getRootElement(),
function (acc)
setAccountData(acc,"Weed",getElementData(source,"Weed"))
setAccountData(acc,"God",getElementData(source,"God"))
setAccountData(acc,"Speed",getElementData(source,"Speed"))
setAccountData(acc,"Lsd",getElementData(source,"Lsd"))
setAccountData(acc,"Steroids",getElementData(source,"Steroids"))
setAccountData(acc,"Heroin",getElementData(source,"Heroin"))
setElementData(source,"Weed",0)
setElementData(source,"God",0)
setElementData(source,"Speed",0)
setElementData(source,"Lsd",0)
setElementData(source,"Steroids",0)
setElementData(source,"Heroin",0)
end
)
addEventHandler("onPlayerLogin", root,
function ( _, theCurrentAccount)
if (getAccountData(theCurrentAccount, "Weed")) then
setElementData(source,"Weed",getAccountData(theCurrentAccount, "Weed"))
end
if (getAccountData(theCurrentAccount, "God")) then
setElementData(source,"God",getAccountData(theCurrentAccount, "God"))
end
if (getAccountData(theCurrentAccount, "Speed")) then
setElementData(source,"Speed",getAccountData(theCurrentAccount, "Speed"))
end
if (getAccountData(theCurrentAccount, "Lsd")) then
setElementData(source,"Lsd",getAccountData(theCurrentAccount, "Lsd"))
end
if (getAccountData(theCurrentAccount, "Steroids")) then
setElementData(source,"Steroids",getAccountData(theCurrentAccount, "Steroids"))
end
if (getAccountData(theCurrentAccount, "Heroin")) then
setElementData(source,"Heroin",getAccountData(theCurrentAccount, "Heroin"))
end
end
)


------------- Buy
addEvent("giveWeed",true) 
addEventHandler("giveWeed",root, 
function (money,number)
if (tonumber(number) > 0) then
if ( getPlayerMoney (source) >= money ) then
takePlayerMoney(source, money)
local acc = getPlayerAccount ( source )
setElementData(source,"Weed",getElementData(source,"Weed")+number)
setAccountData(acc,"Weed",getElementData(source,"Weed"))
else
outputChatBox("No tienes dinero suficiente",source,255,0,0,false)
end
end
end 
)  
addEvent("giveGod",true) 
addEventHandler("giveGod",root, 
function (money,number)
if (tonumber(number) > 0) then
if ( getPlayerMoney (source) >= money ) then
takePlayerMoney(source, money)
local acc = getPlayerAccount ( source )
setElementData(source,"God",getElementData(source,"God")+number)
setAccountData(acc,"God",getElementData(source,"God"))
else
outputChatBox("No tienes dinero suficiente",source,255,0,0,false)end
end
end 
)  
addEvent("giveSpeed",true) 
addEventHandler("giveSpeed",root, 
function (money,number)
if (tonumber(number) > 0) then
if ( getPlayerMoney (source) >= money ) then
takePlayerMoney(source, money)
local acc = getPlayerAccount ( source )
setElementData(source,"Speed",getElementData(source,"Speed")+number)
setAccountData(acc,"Speed",getElementData(source,"Speed"))
else
outputChatBox("No tienes dinero suficiente",source,255,0,0,false)
end
end
end 
)  
addEvent("giveLsd",true) 
addEventHandler("giveLsd",root, 
function (money,number)
if (tonumber(number) > 0) then
if ( getPlayerMoney (source) >= money ) then
takePlayerMoney(source, money)
local acc = getPlayerAccount ( source )
setElementData(source,"Lsd",getElementData(source,"Lsd")+number)
setAccountData(acc,"Lsd",getElementData(source,"Lsd"))
else
outputChatBox("No tienes dinero suficiente",source,255,0,0,false)
end
end
end 
)  
addEvent("giveSteroids",true) 
addEventHandler("giveSteroids",root, 
function (money,number)
if (tonumber(number) > 0) then
if ( getPlayerMoney (source) >= money ) then
takePlayerMoney(source, money)
local acc = getPlayerAccount ( source )
setElementData(source,"Steroids",getElementData(source,"Steroids")+number)
setAccountData(acc,"Steroids",getElementData(source,"Steroids"))
else
outputChatBox("No tienes dinero suficiente",source,255,0,0,false)
end
end
end 
)  
addEvent("giveHeroin",true) 
addEventHandler("giveHeroin",root, 
function (money,number)
if (tonumber(number) > 0) then
if ( getPlayerMoney (source) >= money ) then
takePlayerMoney(source, money)
local acc = getPlayerAccount ( source )
setElementData(source,"Heroin",getElementData(source,"Heroin")+number)
setAccountData(acc,"Heroin",getElementData(source,"Heroin"))
else
outputChatBox("No tienes dinero suficiente",source,255,0,0,false)
end
end
end 
)  
addEvent("giveALL",true) 
addEventHandler("giveALL",root, 
function (money,number)
if (tonumber(number) > 0) then
if ( getPlayerMoney (source) >= money ) then
takePlayerMoney(source, money)
local acc = getPlayerAccount ( source )
setElementData(source,"Weed",getElementData(source,"Weed")+number)
setAccountData(acc,"Weed",getElementData(source,"Weed"))
setElementData(source,"God",getElementData(source,"God")+number)
setAccountData(acc,"God",getElementData(source,"God"))
setElementData(source,"Speed",getElementData(source,"Speed")+number)
setAccountData(acc,"Speed",getElementData(source,"Speed"))
setElementData(source,"Lsd",getElementData(source,"Lsd")+number)
setAccountData(acc,"Lsd",getElementData(source,"Lsd"))
setElementData(source,"Steroids",getElementData(source,"Steroids")+number)
setAccountData(acc,"Steroids",getElementData(source,"Steroids"))
setElementData(source,"Heroin",getElementData(source,"Heroin")+number)
setAccountData(acc,"Heroin",getElementData(source,"Heroin"))
else
outputChatBox("No tienes dinero suficiente",source,255,0,0,false)
end
end
end 
)  
addEvent("takeWeed",true) 
addEventHandler("takeWeed",root, 
function()
setPedGravity ( source, 0.003 )
local acc = getPlayerAccount ( source )
setElementData(source,"Weed",getElementData(source,"Weed")-1)
setAccountData(acc,"Weed",getElementData(source,"Weed"))
setElementData( source,"TextS","تم استخدام مخدرات weed" )
setElementData( source,"colourR",0 )
setElementData( source,"colourG",255 )
setElementData( source,"colourB",0 )
setPedAnimation( source, "BAR", "dnk_stndM_loop")
setTimer(setPedAnimation,3000,1,source, nil, nil)
local x, y, z = getElementPosition ( source ) 
sigarette = createObject ( 1485, 0, 0, 0 )
attachElements ( sigarette, source, 0.05, 0, 0.7, 0, 45, 118 ) 
end 
)  
addEvent("takeGod",true) 
addEventHandler("takeGod",root, 
function()
local acc = getPlayerAccount ( source )
setElementData(source,"God",getElementData(source,"God")-1)
setAccountData(acc,"God",getElementData(source,"God"))
outputChatBox("Usaste Ruedas",source,0,255,0,false)
setPedAnimation( source, "BAR", "dnk_stndM_loop")
setTimer(setPedAnimation,3000,1,source, nil, nil)
local x, y, z = getElementPosition ( source ) 
sigarGod = createObject ( 1485, 0, 0, 0 )
attachElements ( sigarGod, source, 0.05, 0, 0.7, 0, 45, 118 ) 
setPedStat(source, 24, 1000)
setElementHealth ( source, 200 )
end 
) 
addEvent("takeSpeed",true) 
addEventHandler("takeSpeed",root, 
function()
local acc = getPlayerAccount ( source )
setElementData(source,"Speed",getElementData(source,"Speed")-1)
setAccountData(acc,"Speed",getElementData(source,"Speed"))
outputChatBox("Usaste Perica",source,0,255,0,false)
setPedAnimation( source, "BAR", "dnk_stndM_loop")
setTimer(setPedAnimation,3000,1,source, nil, nil)
local x, y, z = getElementPosition ( source ) 
sigarSpeed = createObject ( 1485, 0, 0, 0 )
attachElements ( sigarSpeed, source, 0.05, 0, 0.7, 0, 45, 118 ) 
end 
) 
addEvent("takeLsd",true) 
addEventHandler("takeLsd",root, 
function()
local acc = getPlayerAccount ( source )
setElementData(source,"Lsd",getElementData(source,"Lsd")-1)
setAccountData(acc,"Lsd",getElementData(source,"Lsd"))
outputChatBox("Usaste Lsd",source,0,255,0,false)
setPedAnimation( source, "BAR", "dnk_stndM_loop")
setTimer(setPedAnimation,3000,1,source, nil, nil)
local x, y, z = getElementPosition ( source ) 
sigarLsd = createObject ( 1485, 0, 0, 0 )
attachElements ( sigarLsd, source, 0.05, 0, 0.7, 0, 45, 118 ) 
end 
)
addEvent("takeSteroids",true) 
addEventHandler("takeSteroids",root, 
function()
local acc = getPlayerAccount ( source )
setElementData(source,"Steroids",getElementData(source,"Steroids")-1)
setAccountData(acc,"Steroids",getElementData(source,"Steroids"))
outputChatBox("Usaste Esteroides",source,0,255,0,false)
setPedAnimation( source, "BAR", "dnk_stndM_loop")
setTimer(setPedAnimation,3000,1,source, nil, nil)
local x, y, z = getElementPosition ( source ) 
sigarSteroids = createObject ( 1485, 0, 0, 0 )
attachElements ( sigarSteroids, source, 0.05, 0, 0.7, 0, 45, 118 ) 
setElementData(source,"SteroidsUse",true)
end 
)
addEvent("takeHeroin",true) 
addEventHandler("takeHeroin",root, 
function()
local acc = getPlayerAccount ( source )
setElementData(source,"Heroin",getElementData(source,"Heroin")-1)
setAccountData(acc,"Heroin",getElementData(source,"Heroin"))
outputChatBox("Usaste rivotril",source,0,255,0,false)
setElementData( source,"colourR",0 )
setElementData( source,"colourG",255 )
setElementData( source,"colourB",0 )
setPedAnimation( source, "BAR", "dnk_stndM_loop")
setTimer(setPedAnimation,3000,1,source, nil, nil)
local x, y, z = getElementPosition ( source ) 
sigarHeroin = createObject ( 1485, 0, 0, 0 )
attachElements ( sigarHeroin, source, 0.05, 0, 0.7, 0, 45, 118 ) 
setElementData(source,"HeroinUse",true)
end 
)

------------ Help events
addEvent("removeWeed",true) 
addEventHandler("removeWeed",root, 
function()
setPedGravity ( source, 0.008)
destroyElement(sigarette) 
end 
)  
addEvent("removeGod",true) 
addEventHandler("removeGod",root, 
function()
setPedStat(source, 24, 570)
destroyElement(sigarGod) 
end 
)  
addEvent("removeSpeed",true) 
addEventHandler("removeSpeed",root, 
function()
destroyElement(sigarSpeed) 
end 
)  
addEvent("removeLsd",true) 
addEventHandler("removeLsd",root, 
function()
destroyElement(sigarLsd) 
end 
)  
addEvent("removeSteroids",true) 
addEventHandler("removeSteroids",root, 
function()
destroyElement(sigarSteroids) 
setElementData(source,"SteroidsUse",false)
end 
)  
addEvent("removeHeroin",true) 
addEventHandler("removeHeroin",root, 
function()
destroyElement(sigarHeroin) 
setElementData(source,"HeroinUse",false)
end 
)  
function quitPlayer ( quitType )
if getElementData(source,"HeroinUse") == true then
destroyElement(sigarHeroin) 
end
if getElementData(source,"SteroidsUse") == true then
destroyElement(sigarSteroids) 
end
if (sigarLsd) then
destroyElement(sigarLsd)
end 
if (sigarSpeed) then
destroyElement(sigarSpeed)
end 
if (sigarGod) then
destroyElement(sigarGod)
end 
if (sigarette) then
destroyElement(sigarette)
end 
end
addEventHandler ( "onPlayerQuit", getRootElement(), quitPlayer )