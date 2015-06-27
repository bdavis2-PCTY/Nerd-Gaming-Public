sx, sy = guiGetScreenSize ( );

local Setup = { }
Setup.Label = { }
Setup.Edit = { }
Setup.Button = { }
Setup.Price = { }

function Setup.Create ( ) 
	if ( isElement ( Setup.Window ) ) then return false end 
	local drugs = { 
		weed = tonumber ( getElementData ( localPlayer, "Weed" ) ) or 0,
		lsd = tonumber ( getElementData ( localPlayer, "Lsd" ) ) or 0,
		god = tonumber ( getElementData ( localPlayer, "God" ) ) or 0,
		heroin = tonumber ( getElementData ( localPlayer, "Heroin" ) ) or 0,
		speed = tonumber ( getElementData ( localPlayer, "Speed" ) ) or 0,
		steroids = tonumber ( getElementData ( localPlayer, "Steroids" ) ) or 0 }
	Setup.Window = guiCreateWindow((sx/2)-(325/2), (sy/2)-(363/2), 325, 363, "Sell Drugs", false)
	Setup.Window.Sizable = false;
	Setup.Label.God = guiCreateLabel(38, 53, 71, 17, MESSAGES.SHARED.DRUG_GOD .. ":", false, Setup.Window)
	Setup.Label.Weed = guiCreateLabel(38, 91, 71, 17, MESSAGES.SHARED.DRUG_WEED .. ":", false, Setup.Window)
	Setup.Label.Speed = guiCreateLabel(38, 132, 71, 17, MESSAGES.SHARED.DRUG_SPEED .. ":", false, Setup.Window)
	Setup.Label.LSD = guiCreateLabel(38, 173, 71, 17, MESSAGES.SHARED.DRUG_LSD .. ":", false, Setup.Window)
	Setup.Label.Steroids = guiCreateLabel(38, 215, 71, 17, MESSAGES.SHARED.DRUG_STEROIDS .. ":", false, Setup.Window)
	Setup.Label.Heroin = guiCreateLabel(38, 265, 71, 17, MESSAGES.SHARED.DRUG_HEROIN .. ":", false, Setup.Window)
	Setup.Label.Amount = guiCreateLabel ( 112, 30, 71, 17, MESSAGES.CLIENT.AMOUNT, false, Setup.Window );
	Setup.Label.Price = guiCreateLabel ( 188, 30, 71, 17, MESSAGES.CLIENT.PRICE_UNIT, false, Setup.Window );
	Setup.Button.Begin = guiCreateButton(38, 309, 101, 31, MESSAGES.CLIENT.BEGIN_SELL, false, Setup.Window)
	Setup.Button.Cancel = guiCreateButton(151, 309, 101, 31, MESSAGES.CLIENT.CANCEL, false, Setup.Window)
	Setup.Edit.God = guiCreateEdit(112, 52, 70, 18, tostring ( drugs.god ), false, Setup.Window)
	Setup.Edit.Weed = guiCreateEdit(112, 90, 70, 18, tostring ( drugs.weed ), false, Setup.Window)
	Setup.Edit.Speed = guiCreateEdit(112, 131, 70, 18, tostring ( drugs.speed ), false, Setup.Window)
	Setup.Edit.LSD = guiCreateEdit(112, 173, 70, 18, tostring ( drugs.lsd ), false, Setup.Window)
	Setup.Edit.Steroids = guiCreateEdit(112, 215, 70, 18, tostring ( drugs.steroids ), false, Setup.Window)
	Setup.Edit.Heroin = guiCreateEdit(112, 265, 70, 18, tostring ( drugs.heroin ), false, Setup.Window)  
	Setup.Price.God = guiCreateEdit ( 188, 52, 70, 18, "30", false, Setup.Window );
	Setup.Price.Weed = guiCreateEdit ( 188, 90, 70, 18, "30", false, Setup.Window );
	Setup.Price.Speed = guiCreateEdit ( 188, 131, 70, 18, "30", false, Setup.Window );
	Setup.Price.LSD = guiCreateEdit ( 188, 173, 70, 18, "30", false, Setup.Window );
	Setup.Price.Steroids = guiCreateEdit ( 188, 215, 70, 18, "30", false, Setup.Window );
	Setup.Price.Heroin = guiCreateEdit ( 188, 265, 70, 18, "30", false, Setup.Window );
	showCursor ( true );
	guiSetInputMode ( "no_binds_when_editing" );
	addEventHandler ( "onClientGUIClick", root, Setup.onClientGUIClick );
end

function Setup.BeginSell ( )
	local input = {
		God = tostring ( guiGetText ( Setup.Edit.God ) ),
		Weed = tostring ( guiGetText ( Setup.Edit.Weed ) ),
		Speed = tostring ( guiGetText ( Setup.Edit.Speed ) ),
		LSD = tostring ( guiGetText ( Setup.Edit.LSD ) ),
		Steroids = tostring ( guiGetText ( Setup.Edit.Steroids ) ),
		Heroin = tostring ( guiGetText ( Setup.Edit.Heroin ) ) }
	
	local Prices = {
		God = tostring ( guiGetText ( Setup.Price.God ) ),
		Weed = tostring ( guiGetText ( Setup.Price.Weed ) ),
		Speed = tostring ( guiGetText ( Setup.Price.Speed ) ),
		LSD = tostring ( guiGetText ( Setup.Price.LSD ) ),
		Steroids = tostring ( guiGetText ( Setup.Price.Steroids ) ),
		Heroin = tostring ( guiGetText ( Setup.Price.Heroin ) ) }
	
	local drugs = { 
		Weed = tonumber ( getElementData ( localPlayer, "Weed" ) ) or 0,
		LSD = tonumber ( getElementData ( localPlayer, "Lsd" ) ) or 0,
		God = tonumber ( getElementData ( localPlayer, "God" ) ) or 0,
		Heroin = tonumber ( getElementData ( localPlayer, "Heroin" ) ) or 0,
		Speed = tonumber ( getElementData ( localPlayer, "Speed" ) ) or 0,
		Steroids = tonumber ( getElementData ( localPlayer, "Steroids" ) ) or 0 }
	
	for index, value in pairs ( input ) do 
		-- Check drug inputs 
		input [ index ] = tonumber ( value );
		if ( not input [ index ] or input [ index ] < 0 ) then 
			outputChatBox ( MESSAGES.CLIENT.SETUP_NOT_NUMBERS, 255, 0, 0 );
			return;
		end 
		if ( math.floor ( input [ index ] ) ~= input [ index ] ) then 
			return outputChatBox ( MESSAGES.CLIENT.NOT_WHOLE, 255, 0, 0 );
		end 
		if ( input [ index ] > drugs [ index ] ) then 
			return outputChatBox ( MESSAGES.CLIENT.SETUP_INVALID_AMOUNT:format ( tostring ( input [ index ] ), MESSAGES.SHARED['DRUG_'..string.upper(index)] ), 255, 0, 0 );
		end 
		
		-- Check price inputs 
		Prices [ index ] = tonumber ( Prices [ index ] );
		if ( not Prices [ index ] or Prices [ index ] < 0 ) then 
			outputChatBox ( MESSAGES.CLIENT.SETUP_NOT_NUMBERS, 255, 0, 0 );
			return;
		end 
		if ( math.floor ( Prices [ index ] ) ~= Prices [ index ] ) then 
			return outputChatBox ( MESSAGES.CLIENT.NOT_WHOLE, 255, 0, 0 );
		end 
	end
	local data = { }
	data.drugs = input;
	data.price = Prices;
	setElementData ( localPlayer, "SellingDrugs:Selling", data );
	triggerServerEvent ( "SellDrugs:OnPlayerBeginSelling", localPlayer, localPlayer );
	Setup.Destroy ( );
end 

function Setup.onClientGUIClick ( )
	if ( source == Setup.Button.Cancel ) then 
		Setup.Destroy ( );
	elseif ( source == Setup.Button.Begin ) then 
		Setup.BeginSell ( );
	end 
end 

function Setup.Destroy ( )
	for i, v in pairs ( Setup ) do 
		if ( type ( v ) == "table" ) then 
			for _, element in pairs ( v ) do 
				if ( type ( element ) == "userdata" ) then 
					destroyElement ( element );
				end 
			end 
		end 
	end
	if ( isElement ( Setup.Window ) ) then 
		destroyElement ( Setup.Window );
	end
	removeEventHandler ( "onClientGUIClick", root, Setup.onClientGUIClick );
	showCursor ( false );
end 

addCommandHandler ( MESSAGES.CLIENT.COMMAND, function ( )
	if ( Setup.Window and isElement ( Setup.Window ) ) then 
		return outputChatBox ( MESSAGES.CLIENT.SETUP_WINDOW_ALREADY_OPEN, 255, 255, 0 );
	end 
	
	if ( Buy and Buy.from ) then 
		return outputChatBox ( MESSAGES.CLIENT.CANNOT_SELL_BUYING, 255, 0, 0 );
	end 
	
	Setup.Create ( );
end );
