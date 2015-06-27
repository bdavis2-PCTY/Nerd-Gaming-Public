Buy = { }

Buy.Info = { }
Buy.Info.Amounts = { }
Buy.Info.Prices = { }

Buy.Interface = { }
Buy.Interface.Label = { }
Buy.Interface.Edit = { }
Buy.Interface.Button = { }

addEvent ( "SellDrugs:onPlayerBeginBuy", true )
addEventHandler ( "SellDrugs:onPlayerBeginBuy", root, function ( dealer ) 
	if ( dealer == localPlayer ) then return end 

	Buy.from = dealer;
	local d = getElementData ( dealer, "SellingDrugs:Selling" );
	Buy.Info.Amounts = d.drugs;
	Buy.Info.Prices = d.price;
	addEventHandler ( "onClientElementDataChange", dealer, Buy.onDealerDataChange );
	Buy.Create ( );
end );

function Buy.Create ( )
	--if ( Buy.Interface.Window ) then return false; end
	showCursor( true );
	guiSetInputMode ( "no_binds_when_editing" );
	Buy.Interface.Window = guiCreateWindow((sx/2)-(342/2), (sy/2)-(466/2), 342, 466, "Buy Drugs", false)
	guiWindowSetSizable(Buy.Interface.Window, false)
	Buy.Interface.Label.secGod = guiCreateLabel(16, 52, 141, 26, "(0) God: $0/unit", false, Buy.Interface.Window)
	Buy.Interface.Edit.God = guiCreateEdit(16, 78, 109, 22, "0", false, Buy.Interface.Window)
	Buy.Interface.Label.prcGod = guiCreateLabel(16, 106, 141, 19, "$0", false, Buy.Interface.Window)
	Buy.Interface.Label.secWeed = guiCreateLabel(187, 52, 141, 26, "(0) Weed: $0/unit", false, Buy.Interface.Window)
	Buy.Interface.Edit.Weed = guiCreateEdit(187, 78, 109, 22, "0", false, Buy.Interface.Window)
	Buy.Interface.Label.prcWeed = guiCreateLabel(187, 106, 141, 19, "$0", false, Buy.Interface.Window)
	Buy.Interface.Label.secSpeed = guiCreateLabel(16, 161, 141, 26, "(0) Speed: $0/unit", false, Buy.Interface.Window)
	Buy.Interface.Edit.Speed = guiCreateEdit(16, 187, 109, 22, "0", false, Buy.Interface.Window)
	Buy.Interface.Label.prcSpeed = guiCreateLabel(16, 209, 141, 19, "$0", false, Buy.Interface.Window)
	Buy.Interface.Label.secLSD = guiCreateLabel(187, 161, 141, 26, "(0) LSD: $0/unit", false, Buy.Interface.Window)
	Buy.Interface.Edit.LSD = guiCreateEdit(187, 187, 109, 22, "0", false, Buy.Interface.Window)
	Buy.Interface.Label.prcLSD = guiCreateLabel(187, 214, 141, 19, "$0", false, Buy.Interface.Window)
	Buy.Interface.Label.secSteroids = guiCreateLabel(16, 262, 141, 26, "(0) Steroids: $0/unit", false, Buy.Interface.Window)
	Buy.Interface.Edit.Steroids = guiCreateEdit(16, 288, 109, 22, "0", false, Buy.Interface.Window)
	Buy.Interface.Label.prcSteroids = guiCreateLabel(16, 315, 141, 19, "$0", false, Buy.Interface.Window)
	Buy.Interface.Label.secHeroin = guiCreateLabel(187, 262, 141, 26, "(0) Heroin: $0/unit", false, Buy.Interface.Window)
	Buy.Interface.Edit.Heroin = guiCreateEdit(187, 288, 109, 22, "0", false, Buy.Interface.Window)
	Buy.Interface.Label.prcHeroin = guiCreateLabel(187, 315, 141, 19, "$0", false, Buy.Interface.Window)
	Buy.Interface.Label.Total = guiCreateLabel(20, 381, 127, 24, "Total: $0", false, Buy.Interface.Window)
	Buy.Interface.Button.Buy = guiCreateButton(16, 415, 92, 34, "Buy", false, Buy.Interface.Window)
	Buy.Interface.Button.Close = guiCreateButton(209, 415, 92, 34, "Close", false, Buy.Interface.Window)
	
	addEventHandler ( "onClientGUIClick", root, Buy.onGUIClick );
	
	for i, v in pairs ( Buy.Interface.Edit ) do 
		addEventHandler ( "onClientGUIChanged", v, Buy.onGUIChange );
	end
	
	Buy.UpdateLabels ( );
end 

function Buy.UpdateLabels ( ) 
	guiSetText ( Buy.Interface.Label.secGod, "("..Buy.Info.Amounts.God..") "..MESSAGES.SHARED.DRUG_GOD..": $"..Buy.Info.Prices.God.."/unit" );
	guiSetText ( Buy.Interface.Label.secWeed, "("..Buy.Info.Amounts.Weed..") "..MESSAGES.SHARED.DRUG_WEED..": $"..Buy.Info.Prices.Weed.."/unit" );
	guiSetText ( Buy.Interface.Label.secSpeed, "("..Buy.Info.Amounts.Speed..") "..MESSAGES.SHARED.DRUG_SPEED..": $"..Buy.Info.Prices.Speed.."/unit" );
	guiSetText ( Buy.Interface.Label.secLSD, "("..Buy.Info.Amounts.LSD..") "..MESSAGES.SHARED.DRUG_LSD..": $"..Buy.Info.Prices.LSD.."/unit" );
	guiSetText ( Buy.Interface.Label.secSteroids, "("..Buy.Info.Amounts.Steroids..") "..MESSAGES.SHARED.DRUG_STEROIDS..": $"..Buy.Info.Prices.Steroids.."/unit" );
	guiSetText ( Buy.Interface.Label.secHeroin, "("..Buy.Info.Amounts.Heroin..") "..MESSAGES.SHARED.DRUG_HEROIN..": $"..Buy.Info.Prices.Heroin.."/unit" );
end 

function Buy.getTotal ( )
	local t = 0;
	for _, drg in ipairs ( getDrugTable ( ) ) do 
		local unit = Buy.Info.Prices[drg];
		local amount = tonumber ( guiGetText ( Buy.Interface.Edit[drg] ) ) or 0
		t = t + ( amount * unit );
	end 
	return t;
end 

function Buy.onGUIChange ( )
	guiSetText ( source, guiGetText(source):gsub ( "%p", "" ) );
	guiSetText ( source, guiGetText(source):gsub ( "%s", "" ) );
	guiSetText ( source, guiGetText(source):gsub ( "%a", "" ) );
	
	local t = tonumber ( guiGetText ( source ) );
	if ( not t ) then return end
	
	local pcLbl, unit;
	for _, drg in ipairs ( getDrugTable ( ) ) do 
		if ( source == Buy.Interface.Edit[drg] ) then 
			pcLbl = Buy.Interface.Label["prc".. drg ];
			unit = Buy.Info.Prices[ drg ];
			if ( t > Buy.Info.Amounts [ drg ] ) then 
				guiSetText ( source, Buy.Info.Amounts [ drg ] );
				return triggerEvent ( "onClientGUIChanged", source );
			end
		end 
	end 

	if ( pcLbl and unit ) then 
		if ( t == "" ) then 
			guiSetText ( pcLbl, "$0" );
		else 
			guiSetText ( pcLbl, "$".. tostring ( unit * tonumber ( t ) ) );
		end 
	end 
	
	guiSetText ( Buy.Interface.Label.Total, MESSAGES.CLIENT.TOTAL .. ": $".. tostring ( Buy.getTotal ( ) ) );
end

function Buy.onGUIClick ( )
	if ( source == Buy.Interface.Button.Close ) then
		Buy.Destroy ( );
	elseif ( source == Buy.Interface.Button.Buy ) then 
		local buying = { }
		for _, drg in ipairs ( getDrugTable ( ) ) do 
			buying [ drg ] = tonumber ( guiGetText ( Buy.Interface.Edit[ drg ] ) ) or 0;
		end 
		
		local total = Buy.getTotal ( );
		triggerServerEvent ( "SellDrugs:onPlayerBuyDrugs", localPlayer, buying, total, Buy.from );
	end 
end 

function Buy.onDealerDataChange ( d )
	if ( d == "SellingDrugs:Selling" ) then
		local d = getElementData ( source, "SellingDrugs:Selling" );
		Buy.Info.Amounts = d.drugs;
		for i, v in pairs ( getDrugTable ( ) ) do
			triggerEvent ( "onClientGUIChanged", Buy.Interface.Edit[ v ] , Buy.onGUIChange );
		end 
		Buy.UpdateLabels ( );
	end 
end 

addEvent ( "SellingDrugs:updateDealerDrugs", true );
addEventHandler ( "SellingDrugs:updateDealerDrugs", root, function ( dealer )
	if ( Buy and Buy.from and isElement ( Buy.from ) ) then 
		local d = getElementData ( dealer, "SellingDrugs:Selling" );
		Buy.Info.Amounts = d.drugs;
		
		for i, v in pairs ( getDrugTable ( ) ) do
			triggerEvent ( "onClientGUIChanged", Buy.Interface.Edit[ v ] , Buy.onGUIChange );
		end 
		
		Buy.UpdateLabels ( );
	end 
end );

function Buy.Destroy ( )
	showCursor ( false );
	removeEventHandler ( "onClientGUIClick", root, Buy.onGUIClick );
	removeEventHandler ( "onClientElementDataChange", Buy.from, Buy.onDealerDataChange );
	
	--[[for i, v in pairs ( Buy.Interface.Edit ) do 
		if ( v ) then removeEventHandler ( "onClientGUIChanged", v, Buy.onGUIChange ); end 
	end]]
	
	destroyElement ( Buy.Interface.Window )
	
	Buy.from = nil
	Buy.Info.Amounts = { }
	Buy.Info.Prices = { }
end 

addEvent ( "SellDrugs:onPlayerStopSelling", true );
addEventHandler ( "SellDrugs:onPlayerStopSelling", root, function ( dealer )
	if ( Buy.from and Buy.from == dealer ) then 
		Buy.Destroy();
		Buy.from = nil;
	end 
end );




function getDrugTable ( )
	return { "God", "Weed", "Speed", "LSD", "Steroids", "Heroin" }
end 
