local sx, sy = guiGetScreenSize ( )
local rsx, rsy = sx / 1280, sy / 960

--[[
	Drug Item Ids:
	drug_white -> 1575
	drug_orange -> 1576
	drug_yellow -> 1577
	drug_green -> 1578
	drug_blue -> 1579
	drug_red -> 1580
]]


local items = {
	['FuelCans'] = {
		nam = "Fuel Cans",
		dropable=true,
		itemid=1650,
		requiresInVehicle=true,
		useableInVehicle=true,
		img = ":NGVehicles/fuel/fuel_icon.png",
		desc = "This is a fuel can, bought at the gas station fuel markers (must be on foot) so you can give your vehicle 10% fuel when it runs out. It comes in very helpful if you don't know when you'll be able to get to the next station, and you're low on fuel."
	},

	['Drug.LSD'] = {
		nam = "Drug - LSD",
		dropable=true,
		itemid=1580,
		requiresInVehicle=false,
		useableInVehicle=false,
		img = ":NGDrugs/files/lsd_icon.png",
		desc = "When you use this drug, you'll be sucked into a world where aliens are chasing you. As they get close to you, they'll fade away but if you kill them you'll get paid!"
	},

	['Drug.Marijuana'] = {
		nam = "Drug - Marijuana",
		dropable=true,
		itemid=1578,
		requiresInVehicle=false,
		useableInVehicle=true,
		img = ":NGDrugs/files/weed_icon.png",
		desc = "When you use this drug, you'll get a greenish screen and every second you'll get 2% health."
	},

	['health_packs'] = {
		nam = "Health Packs",
		dropable = true,
		itemid = 1578,
		requiresInVehicle = false,
		useableInVehicle = true,
		img = ":NGHealthPack/pack.png",
		desc = "If your health is getting low, you can use this to re-generate!"
	}
}

local d = getElementData(localPlayer,"NGUser:Items")
if d then
	for i, v in pairs ( items ) do
		if ( v.requiresInVehicle ) then
			items [ i ].useableInVehicle = true
		end

		if ( not d [ i ] ) then
			d [ i ] = 0
			setElementData ( localPlayer, "NGUser:Items", d )
		end 
	end
end

function createInventoryWindow ( )
	if ( not exports.NGLogin:isClientLoggedin ( ) ) then return end
	inven = {}
	selectedItem = nil
	inven.window = guiCreateWindow((sx/2-514/2), (sy/2-380/2), 514, 380, "User Inventory", false)
	guiWindowSetSizable(inven.window, false)
	inven.list = guiCreateGridList(10, 33, 251, 337, false, inven.window)
	guiGridListAddColumn(inven.list, "Item", 0.65)
	guiGridListAddColumn(inven.list, "Amount", 0.25)
	guiGridListSetSortingEnabled ( inven.list, false )
	inven.citem = guiCreateLabel(271, 43, 188, 21, "No Item Selected", false, inven.window)
	inven.img = guiCreateStaticImage(400, 58, 80, 85, "none.png", false, inven.window)
	inven.camount = guiCreateLabel(271, 79, 188, 21, "Item Amount: N/A", false, inven.window)
	inven.temp1 = guiCreateLabel(271, 138, 188, 21, "Description:", false, inven.window)
	inven.desc = guiCreateLabel(271, 159, 230, 167, "N/A", false, inven.window)
	guiLabelSetHorizontalAlign(inven.desc, "left", true)
	inven.use = guiCreateButton(414, 342, 81, 28, "Use Item", false, inven.window)
	inven.drop = guiCreateButton(414, 310, 81, 28, "Drop Item", false, inven.window)
	inven.exit = guiCreateButton(319, 340, 81, 30, "Exit", false, inven.window)
	showCursor ( true )
	for i, v in pairs ( getElementData ( localPlayer, "NGUser:Items" ) or { } ) do
		if ( items [ i ] ) then
			local r = guiGridListAddRow ( inven.list )
			guiGridListSetItemText ( inven.list, r, 1, tostring ( items [ i ].nam ), false, false )
			guiGridListSetItemData ( inven.list, r, 1, i )
			guiGridListSetItemText ( inven.list, r, 2, tostring ( v ), false, false )
		end
	end
	addEventHandler ( "onClientGUIClick", inven.use, onClientGUIClick )
	addEventHandler ( "onClientGUIClick", inven.drop, onClientGUIClick )
	addEventHandler ( "onClientGUIClick", inven.exit, onClientGUIClick )
	addEventHandler ( "onClientGUIClick", inven.list, onClientGUIClick )
	
	guiSetEnabled ( inven.use, false )
	guiSetEnabled ( inven.drop, false )
end

function closeInventoryWindow ( )
	if ( isElement ( inven.use ) ) then
		removeEventHandler ( "onClientGUIClick", inven.use, onClientGUIClick )
		destroyElement ( inven.use )
	end if ( isElement ( inven.drop ) ) then
		removeEventHandler ( "onClientGUIClick", inven.drop, onClientGUIClick )
		destroyElement ( inven.drop )
	end if ( isElement ( inven.exit ) ) then
		removeEventHandler ( "onClientGUIClick", inven.exit, onClientGUIClick )
		destroyElement ( inven.exit )
	end if ( isElement ( inven.list ) ) then
		removeEventHandler ( "onClientGUIClick", inven.list, onClientGUIClick )
		destroyElement ( inven.list )
	end if ( isElement ( inven.citem ) ) then
		destroyElement ( inven.citem )
	end if ( isElement ( inven.camount ) ) then
		destroyElement ( inven.camount )
	end if ( isElement ( inven.temp1 ) ) then
		destroyElement ( inven.temp1 )
	end if ( isElement ( inven.desc ) ) then
		destroyElement ( inven.desc )
	end if ( isElement ( inven.window ) ) then
		destroyElement ( inven.window  )
	end
	inven = nil
	selectedItem = nil
	showCursor ( false )
end

function onClientGUIClick ( )
	if ( source == inven.exit ) then
		closeInventoryWindow ( )
	elseif ( source == inven.list ) then
		selectedItem = nil
		guiSetText ( inven.citem, "No Item Selected" )
		guiSetText ( inven.camount, "Item Amount: N/A" )
		guiSetText ( inven.desc, "N/A" )
		guiSetEnabled ( inven.use, false )
		guiSetEnabled ( inven.drop, false )
		local r, c = guiGridListGetSelectedItem ( source )
		guiStaticImageLoadImage ( inven.img, "none.png" )
		if ( r ~= -1 ) then
			local name = tostring ( guiGridListGetItemData ( source, r, 1 ) )
			local c = getElementData(localPlayer,"NGUser:Items")[name]
			guiSetText ( inven.citem, items[name].nam )
			guiSetText ( inven.camount, "Item Amount: "..c )
			guiSetText ( inven.desc, items[name].desc )
			guiSetEnabled ( inven.use, c > 0 )
			guiSetEnabled ( inven.drop, items[name].dropable and not isPedInVehicle ( localPlayer ) )
			selectedItem = name
			if ( items[name].img and fileExists ( items[name].img ) ) then
				guiStaticImageLoadImage ( inven.img, items[name].img )
			end

			if ( items[name].requiresInVehicle ) then
				guiSetText ( inven.desc, guiGetText ( inven.desc ) .."\n\nThis requires you to be in a vehicle." )
				if ( not isPedInVehicle ( localPlayer ) ) then
					guiSetEnabled ( inven.use, false )
				end
			end

			if ( isPedInVehicle ( localPlayer ) and not items [ name ].useableInVehicle ) then
				guiSetEnabled ( inven.use, false )
			elseif ( not isPedInVehicle ( localPlayer ) and not items[name].requiresInVehicle ) then
				guiSetEnabled ( inven.use, true )
			end
		end
	elseif ( source == inven.use ) then
		if ( not selectedItem ) then
			return
		end
		useItem ( selectedItem )
	elseif ( source == inven.drop ) then
		local r, _ = guiGridListGetSelectedItem ( inven.list )
		local name = guiGridListGetItemText ( inven.list, r, 1 )
		local max = tonumber ( guiGridListGetItemText ( inven.list, r, 2 ) )
		AskDropAmount ( max, "How much '"..tostring(name).."' would you like to drop?", function ( amount, _name )
			local id = ""
			for i, v in pairs ( items ) do
				if ( v.nam == _name ) then
					id = i
				end
			end
			local am = getElementData(localPlayer,"NGUser:Items")
			if ( amount > am[id] ) then
				return exports.NGMessages:sendClientMessage ( 'Insignificant amount', 255, 0, 0 )
			end
			am[id] = am[id] - amount
			setElementData ( localPlayer, "NGUser:Items", am )
			reloadInvenPanel ( )
			triggerServerEvent ( "NGInventory:onClientDropItem", localPlayer, items[id].itemid, amount, id )
		end, name )
	end
end 

bindKey ( "F6", "down", function ( )
	if ( inven and isElement ( inven.window ) ) then
		closeInventoryWindow ( )
	else
		createInventoryWindow ( )
	end
end )

function useItem ( item )
	local rv = false
	
	local d = getElementData ( localPlayer, "NGUser:Items" )
	if not d then return false end
	if not d[item] then return false end
	local amount = d[item]

	if ( amount <= 0 ) then 
		return false 
	end
	
	if ( item == 'FuelCans' ) then
		local c = getPedOccupiedVehicle ( localPlayer )
		if ( getVehicleController ( c ) == localPlayer ) then
			local f = getElementData ( c, "fuel" )
			if ( f <= 90 ) then
				rv = true
				setElementData ( c, "fuel", f + 10 )
				exports.NGMessages:sendClientMessage ( "You have used a fuel can... +10% fuel", 0, 255, 0 )
			else
				exports.NGMessages:sendClientMessage ( "Your fuel must be below 90% to use this item", 255, 0, 0 )
			end
		else
			exports.NGMessages:sendClientMessage ( "You're not the driver of this vehicle.", 255, 255, 0 )
		end
	elseif ( item == "Drug.LSD" )  then
		exports.NGDrugs:useDrug ( "LSD", 1 )
		exports.NGMessages:sendClientMessage ( "You have decided to use LSD. Get ready for some crazy shit", 255, 255, 0 )
		rv = true
	elseif ( item == "Drug.Marijuana" ) then
		exports.NGDrugs:useDrug ( "Marijuana", 1 )
		--exports.NGMessages:sendClientMessage ( "~~~~~ Stoner ~~~~~", 0, 255, 0 )
		--exports.NGMessages:sendClientMessage ( "You smoked some that grade A shit, man!", 255, 255, 0)
		exports.NGMessages:sendClientMessage ( "You'll get 2% health every second", 255, 0, 0 )
		rv = true
	elseif ( item == "health_packs" ) then
		if ( exports.nghealthpack:useHealthPack ( ) ) then
			rv = true
		else
			exports.ngmessages:sendClientMessage ( "You don't need a health pack right now!", 255, 255, 0 )
		end
	end
	
	triggerServerEvent ( "NGInventory:onClientUseItem", localPlayer, item )
	
	if rv then
		d[item] = d[item] - 1
		setElementData ( localPlayer, "NGUser:Items", d )
		reloadInvenPanel ( )
	end
	return rv
end


function reloadInvenPanel ( )
	local d = getElementData ( localPlayer, "NGUser:Items" )
	local c = selectedItem
	closeInventoryWindow ( )
	createInventoryWindow ( )
	for i=0, guiGridListGetRowCount ( inven.list ) do
		local d = guiGridListGetItemData ( inven.list, i, 1 )
		if ( d == c ) then
			guiGridListSetSelectedItem ( inven.list, i, 1 )
			triggerEvent ( "onClientGUIClick", inven.list )
			break
		end
	end
	c=nil
	return true
end