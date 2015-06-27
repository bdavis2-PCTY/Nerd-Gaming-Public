local dealing = { }
addEvent ( "SellDrugs:OnPlayerBeginSelling", true );
addEventHandler ( "SellDrugs:OnPlayerBeginSelling", root, function ( p )
	if ( dealing [ source ] and isElement ( dealing [ source ] ) ) then 
		return outputChatBox ( MESSAGES.SERVER.ALREADY_DEALING, source, 255, 0, 0 );
	end 
	
	local x, y, z = getElementPosition ( source );
	dealing [ source ] = createMarker ( x, y, z - 1, "cylinder", 2, 200, 50, 50, 200 );
	setElementData ( dealing [ source ], "SellDrugs:owner", source );
	
	outputChatBox ( MESSAGES.SERVER.ON_BEGIN_SELLING:format ( MESSAGES.SERVER.CMD_STOP_SELLING ), p, 0, 255, 0 );
	toggleAllControls ( source, false, true, false );
	
	addEventHandler ( "onMarkerHit", dealing [ source ], onDealerMarkerHit );
end );

function onDealerMarkerHit ( player )
	local dealer = getElementData ( source, "SellDrugs:owner" );
	if ( not isElement ( dealer ) ) then 
		removeEventHandler ( "onMarkerHit", source, onDealerMarkerHit );
		destroyElement ( dealing [ dealer ] );
		dealing [ dealer ] = false;
		return;
	end 
	
	if ( isPedInVehicle ( player ) ) then return false; end 
	triggerClientEvent ( player, "SellDrugs:onPlayerBeginBuy", player, dealer );
end

addEventHandler ( "onPlayerQuit", root, function ( )
	if ( dealing [ source ] and isElement ( dealing [ source ] ) ) then 
		destroyElement ( dealing [ source ] );
		dealing [ source ] = false;
		triggerClientEvent ( root, "SellDrugs:onPlayerStopSelling", root, source );
	end 
end );

addCommandHandler ( MESSAGES.SERVER.CMD_STOP_SELLING, function ( p )
	if ( not dealing [ p ] ) then
		return outputChatBox ( MESSAGES.SERVER.NOT_SELLING, p, 255, 255, 0 );
	end 
	
	destroyElement ( dealing [ p ] );
	dealing [ p ] = false;
	toggleAllControls ( p, true, true, false );
	outputChatBox ( MESSAGES.SERVER.NO_LONGER_SELLING, p, 255, 255, 0 );
	
	triggerClientEvent ( root, "SellDrugs:onPlayerStopSelling", root, p );
end );

addEvent ( "SellDrugs:onPlayerBuyDrugs", true )
addEventHandler ( "SellDrugs:onPlayerBuyDrugs", root, function ( drugs, total, from )
	if ( total > getPlayerMoney ( source ) ) then 
		return outputChatBox ( MESSAGES.SERVER.NOT_ENOUGH_MONEY:format ( total ), source, 255, 0, 0 );
	end 
	
	if ( not from or not isElement ( from ) ) then return end 
	givePlayerMoney ( from, total );
	takePlayerMoney ( source, total );
	
	local dealerDrugs = getElementData ( from, "SellingDrugs:Selling" );

	for i, v in pairs ( drugs ) do 
		if ( v > 0 ) then 
			local d = string.lower ( i );
			d = string.upper ( string.sub ( d, 0, 1 ) ).. string.sub ( d, 2, string.len ( d ) );
			--[[---------------
			outputChatBox ( "-------------------" );
			outputChatBox ( "Drug: "..tostring ( i ) );
			outputChatBox ( "Sell Amount: "..tostring ( v ) );
			outputChatBox ( "d: "..tostring ( d ) );
			outputChatBox ( "dealerDrugs['drugs']["..tostring(i).."]: ".. dealerDrugs [ "drugs" ] [ i ] - v );
			outputChatBox ( "New dealer: ".. ( getElementData ( from, d ) or 0 ) - v );
			-----------------]]
			setAccountData ( getPlayerAccount ( from ), d, ( getElementData ( from, d ) or 0 ) - v );
			setAccountData ( getPlayerAccount ( source ), d, ( getElementData ( source, d ) or 0 ) + v );
			setElementData ( source, d, ( getElementData ( source, d ) or 0 ) + v );
			setElementData ( from, d, ( getElementData ( from, d ) or 0 ) - v );
			dealerDrugs  [ "drugs" ] [ i ] = dealerDrugs [ "drugs" ] [ i ] - v;
			outputChatBox ( MESSAGES.SERVER.ON_SALE_CLIENT:format(tostring(v), tostring(i), getPlayerName(from) ), source, 0, 255, 0 );
			outputChatBox ( MESSAGES.SERVER.ON_SALE_DEALER:format(getPlayerName(source),tostring(v),tostring(i)), from, 0, 255, 0 );
		end 
	end 
	
	setElementData ( from, "SellingDrugs:Selling", dealerDrugs );
	triggerClientEvent ( root, "SellingDrugs:updateDealerDrugs", root, from );
end );