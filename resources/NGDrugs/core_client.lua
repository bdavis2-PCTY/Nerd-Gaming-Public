--[[

	How does the script work?
	When the function useDrug() is called, it will check to see if the selected drug is already running. If
	the drug is already running, then it'll kill the timer and create a new timer with the doce time + the 
	remaining time. If the drug isn't running, then it'll just create a new timer. The function will call:
	drugs[drugName].func.load ( ) to start the drug, even if it's already running. The script will call:
	drugs[drugName].func.unload ( ) to stop the running drug
	




	GLOBAL VARIABLES:
		drugs
			Type: Table
			For: Storing all the drugs, along with their variables and functions
				Drug variables are stored in: drugs[drugName].var
				Drug functions are stored in: drugs[drugName].func

		sx_
			Type: Int
			For: Storing the clients X axis resolution


		sy_
			Type: Int
			For: Storing the clients Y axis resolution


		sx:
			Type: Float
			For: Storing the clients X offset, to make the effects same in all resolution


		sy:
			Type: Float
			For: Storing the clients X offset, to make the effects same in all resolution


		
]]


drugs = { }
sx_, sy_ = guiGetScreenSize ( )
sx, sy = sx_/1280, sy_/720


local var = { }
var.timers = { }
var.rendering = false


function useDrug ( drug, amount )
	if ( localPlayer.interior ~= 0 or localPlayer.dimension ~= 0 ) then
		return false, "You need to be outside"
	end


	local drug = tostring ( drug )
	if ( not drugs [ drug ] ) then return false end

	local d = drugs [ drug ] 
	rTime = 0
	if ( var.timers [ drug ] and isTimer ( var.timers [ drug ] ) ) then
		rTime = getTimerDetails ( var.timers [ drug ] )
		killTimer ( var.timers [ drug ] )
		var.timers [ drug ] = nil
	end

	drugs[drug].func.load ( )
	var.timers[drug] = setTimer ( drugs [drug].func.unload, ((drugs[drug].info.timePerDoce*amount)*1000)+rTime, 1 )

	if ( not var.rendering  ) then
		addEventHandler ( "onClientRender", root, var.render )
		var.rendering  = true
	end 
end 


function var.render ( )

	local id = 0
	local remove = { }
	for i, v in pairs ( var.timers ) do 
		if ( not v or not isTimer ( v ) ) then
			remove [ i ] = true
		else
			dxDrawRectangle ( sx*(300+(id*170)), sy*655, sx*160, sy*50, tocolor ( 0, 0, 0, 170  ) )
			dxDrawText ( tostring ( i ) .. " - ".. tostring ( math.floor ( getTimerDetails ( v ) / 1000 ) ),
				 sx*(300+(id*170)), sy*655,
				 (sx*(300+(id*170)))+(sx*160), (sy*655)+(sy*50),
				 tocolor ( 255, 255, 255, 255 ), 1.5, "default", "center", "center" )

			id = id + 1
		end
	end 

	for i, v in pairs ( remove ) do
		var.timers [ i ] = nil
	end

	if ( id == 0 or not var.rendering ) then
		removeEventHandler ( "onClientRender", root, var.render )
		var.rendering  = false
	end 
end 


function table.len ( table )
	local c = 0
	for i, v in pairs ( table ) do
		c = c + 1
	end
	return c
end