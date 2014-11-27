local cruise = false
local cruiseEnabled = false

addEventHandler("onClientResourceStart",resourceRoot,
function ()
	if isPedInVehicle(localPlayer) then
		setCruiseControlState(true)
	end
end)

addEventHandler("onClientVehicleEnter", getRootElement(),
    function(thePlayer, seat)
        if (thePlayer == localPlayer and seat == 0) then
			setCruiseControlState(true)
        end
    end
)
addEventHandler("onClientVehicleExit", getRootElement(),
    function(thePlayer, seat)
        if (thePlayer == localPlayer and seat == 0) then
			setCruiseControlState(false)
        end
    end
)

function setCruiseControlState(state)
	if (state) then
        bindKey("c","down",cruiseControlData)
		cruise = true
	else
		cruiseEnabled = false
		cruise = false
		removeEventHandler("onClientRender",getRootElement(),cruiseControl)
		unbindKey("c","down",cruiseControlData)
		unbindKey("s","down",cruiseControlOff)
		unbindKey("space","down",cruiseControlOff)
		unbindKey("f","down",cruiseControlOff)
		unbindKey("enter","down",cruiseControlOff)
		unbindKey("num_add","down",increaseCruiseSpeed)
		unbindKey("num_sub","down",decreaseCruiseSpeed)
		setControlState("accelerate",false)
		if isTimer(infoTimer) then killTimer(infoTimer) end
	end
end

function cruiseControlData()
	if (not cruiseEnabled) then
		vehicle = getPedOccupiedVehicle(getLocalPlayer())
		local speed = getCurrentSpeed ( vehicle )
		if ( speed < 0.1 ) then
			return exports.NGMessages:sendClientMessage ( "You're going to slow to cruise", 255, 255, 0 )
		end
		
		cruiseEnabled = true
		local cruisedata = setElementData(vehicle,"vehicle.cruisespeed",speed)
		cruise = true
		addEventHandler("onClientRender",getRootElement(),cruiseControl)
		bindKey("s","down",cruiseControlOff)
		bindKey("space","down",cruiseControlOff)
		bindKey("f","down",cruiseControlOff)
		bindKey("enter","down",cruiseControlOff)
		bindKey("num_add","down",increaseCruiseSpeed)
		bindKey("num_sub","down",decreaseCruiseSpeed)
		exports["NGMessages"]:sendClientMessage("Cruise Control has been enabled.",0,255,0)
	else
		cruiseEnabled = false
		removeEventHandler("onClientRender",getRootElement(),cruiseControl)
		unbindKey("s","down",cruiseControlOff)
		unbindKey("space","down",cruiseControlOff)
		unbindKey("f","down",cruiseControlOff)
		unbindKey("enter","down",cruiseControlOff)
		unbindKey("num_add","down",increaseCruiseSpeed)
		unbindKey("num_sub","down",decreaseCruiseSpeed)
		setControlState("accelerate",false)
		exports["NGMessages"]:sendClientMessage("Cruise Control has been disabled.",0,255,0)
	end
end

function cruiseControlOff()
	setCruiseControlState(false)
end

function cruiseControl()
	required = getElementData(vehicle,"vehicle.cruisespeed")
	local currentspeed = getCurrentSpeed ( vehicle )
	if (currentspeed <= required) then
		setControlState("accelerate",true)
	elseif (currentspeed >= required) then
		setControlState("accelerate",false)
	end
end

function getCurrentSpeed ( vehicle )
	local currentX,currentY,currentZ = getElementVelocity(vehicle)
	return (currentX^2 + currentY^2 + currentZ^2)^(0.5)
end

function increaseCruiseSpeed(key,keyState)
	required = required + 0.025
	setElementData(vehicle,"vehicle.cruisespeed",required)
end

function decreaseCruiseSpeed(key, keyState)
	required = required - 0.025
	if (required >= 0) then
		setElementData(vehicle,"vehicle.cruisespeed",required)
	end
end

function dxDrawBorderedText( text, x, y, w, h, color, scale, font, alignX, alignY, clip, wordBreak, postGUI )
	dxDrawText ( text, x - 1, y - 1, w - 1, h - 1, tocolor ( 0, 0, 0, 255 ), scale, font, alignX, alignY, clip, wordBreak, false ) -- black
	dxDrawText ( text, x + 1, y - 1, w + 1, h - 1, tocolor ( 0, 0, 0, 255 ), scale, font, alignX, alignY, clip, wordBreak, false )
	dxDrawText ( text, x - 1, y + 1, w - 1, h + 1, tocolor ( 0, 0, 0, 255 ), scale, font, alignX, alignY, clip, wordBreak, false )
	dxDrawText ( text, x + 1, y + 1, w + 1, h + 1, tocolor ( 0, 0, 0, 255 ), scale, font, alignX, alignY, clip, wordBreak, false )
	dxDrawText ( text, x - 1, y, w - 1, h, tocolor ( 0, 0, 0, 255 ), scale, font, alignX, alignY, clip, wordBreak, false )
	dxDrawText ( text, x + 1, y, w + 1, h, tocolor ( 0, 0, 0, 255 ), scale, font, alignX, alignY, clip, wordBreak, false )
	dxDrawText ( text, x, y - 1, w, h - 1, tocolor ( 0, 0, 0, 255 ), scale, font, alignX, alignY, clip, wordBreak, false )
	dxDrawText ( text, x, y + 1, w, h + 1, tocolor ( 0, 0, 0, 255 ), scale, font, alignX, alignY, clip, wordBreak, false )
	dxDrawText ( text, x, y, w, h, color, scale, font, alignX, alignY, clip, wordBreak, postGUI )
end