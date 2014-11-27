user_shop = { 
	items = { },
	functions  = { },
	spamTimers = { }
}

addEventHandler ( "onResourceStart", resourceRoot, function ( )
	exports.NGSQL:db_exec ( "CREATE TABLE IF NOT EXISTS user_shop ( seller_account VARCHAR(20) , item VARCHAR(20) , amountperone INT , quantity INT, this_id INT )" )
	local q = exports.NGSQL:db_query ( "SELECT * FROM user_shop" );
	if ( q and type ( q ) == "table" ) then
		for i, v in pairs ( q ) do
			local d = { }
			for k, e in pairs ( v ) do
				d[k] = e
			end
			user_shop.items[ tonumber ( v.this_id ) ] = d
		end
	end
end )


function user_shop.functions:addItem ( seller, item, amount, quan )
	local id = 0
	while ( user_shop.items [ id ] ) do
		id = id + 1
	end

	exports.NGSQL:db_exec ( "INSERT INTO user_shop ( seller_account, item, amountperone, quantity, this_id ) VALUES ( ?, ?, ?, ?, ? )",
		tostring ( seller ), tostring ( item ), tostring ( amount ), tostring ( quan ), tostring ( id ) );
		
	local data = { 
		seller_account = seller,
		item = item,
		amountperone = amount,
		quantity = quan,
		this_id = id
	}
	
	user_shop.items[ id ] = data
	return true
end

addEvent ( "NGShops:Module->UserShp:getShopList", true )
addEventHandler ( "NGShops:Module->UserShp:getShopList", root, function ( )
	local items = user_shop.items
	
	for i, v in pairs ( items ) do
		if ( v.quantity == 0 ) then
			table.remove ( user_shop.items, i )
			exports.NGSQL:db_exec ( "DELETE FROM user_shop WHERE this_id=?", i )
		end
	end
	
	triggerClientEvent ( source, "NGShops:Module->UserShop:onClientReciveList", source, items )
end )

addEvent ( "NGShops:Module->UserShop:onClientAttemptBuyItem", true )
addEventHandler ( "NGShops:Module->UserShop:onClientAttemptBuyItem", root, function ( id, amnt )
	local d = user_shop.items [ id ]
	if ( d.quantity < amnt ) then
		return false
	end
	
	local totalPrice = d.amountperone * amnt
	if ( getPlayerMoney ( source ) < totalPrice ) then
		return exports.NGMessages:sendClientMessage ( "You need $"..totalPrice.." to buy "..amnt.." of this item. You cannot afford it.", source, 255, 255, 0 )
	end
	
	local itms = getElementData ( source, "NGUser:Items" )
	if ( not itms ) then
		itms = { }
	end
	
	if ( not itms[d.item] ) then
		itms[d.item] = 0
	end
	
	itms[d.item] = itms[d.item] + amnt
	setElementData ( source, "NGUser:Items", itms )
	user_shop.items [ id ].quantity = d.quantity - amnt
	local d = user_shop.items [ id ]
	takePlayerMoney ( source, totalPrice )
	exports.NGMessages:sendClientMessage ( "You bought "..amnt.." "..itemList[d.item:lower()].."s for $"..totalPrice.." from "..d.seller_account.."!", source, 0, 255, 0 )
	
	if ( d.quantity == 0 ) then
		exports.NGSQL:db_exec ( "DELETE FROM user_shop WHERE this_id=?", id );
		table.remove ( user_shop.items, id )
	else
		exports.NGSQL:db_exec ( "UPDATE user_shop SET quantity=? WHERE this_id=?", d.quantity, id );
		user_shop.items[id].quantity = d.quantity
	end
	
	if ( d.seller_account:lower ( ) ~= "console" ) then
		local givenMoney = false
		for i, v in pairs ( getElementsByType ( "player" ) ) do
			local a = getPlayerAccount ( v )
			if ( not isGuestAccount ( a ) and getAccountName ( a ) == d.seller_account ) then
				givePlayerMoney ( v, totalPrice )
				exports.NGMessages:sendClientMessage ( getPlayerName ( source ).." has bought "..amnt.." "..itemList[d.item:lower()].."s for $"..totalPrice, v, 0, 255, 0 )
				givenMoney = true
				break
			end
		end
		
		if ( not givenMoney ) then
			local q = exports.NGSQL:db_query ( "SELECT * FROM accountdata WHERE Username=?", d.seller_account );
			if( q and type ( q ) == "table" and table.len ( q ) > 0 ) then
				local money = tonumber ( q [ 1 ] ['Money'] ) + totalPrice
				exports.NGSQL:db_exec ( "UPDATE accountdata SET Money=? WHERE Username=?", tostring ( money ), d.seller_account )
			end
		end
	end
end )

function user_shop.functions:removeItem ( id )
	if ( not user_shop.items[ id ] ) then
		return false
	end
	table.remove ( user_shop.items, id )
	exports.NGSQL:db_exec ( "DELETE FROM user_shop WHERE this_id=?", id )
end

function user_shop.functions:getUserItems ( account )
	local q = exports.NGSQL:db_query ( "SELECT * FROM user_shop WHERE seller_account=?", account )
	if ( not q or type ( q ) ~= "table" ) then
		q = { }
	end
	return q
end


addEvent ( "NGShops:Module->UserShop:getProfileItems", true )
addEventHandler ( "NGShops:Module->UserShop:getProfileItems", root, function ( )
	local a = getAccountName ( getPlayerAccount ( source ) )
	local items = user_shop.functions:getUserItems ( a )
	triggerClientEvent ( source, "NGShops:Module->UserShop:sendClientItems", source, items )
end )

addEvent ( "NGShops:Module->UserShop:addItemToShop", true )
addEventHandler ( "NGShops:Module->UserShop:addItemToShop", root, function ( item, quantity, price )
	-- ( seller, item, amount, quan )
	local acc = getAccountName ( getPlayerAccount ( source ) )
	
	if ( isTimer ( user_shop.spamTimers [ acc ] ) ) then
		return exports.NGMessages:sendClientMessage ( "You can only add items to the shop every 5 minutes ("..calculateEngTime ( getTimerDetails ( user_shop.spamTimers [ acc ] ) ).." remaining)", source, 255, 0, 0 )
	end
	
	user_shop.functions:addItem ( acc, item, price, quantity )
	local data = getElementData ( source, "NGUser:Items" )
	data[item] = data[item] - quantity
	setElementData ( source, "NGUser:Items", data )
	user_shop.spamTimers[ acc ] = setTimer ( function() end, 300000, 1 )
	
	exports.NGMessages:sendClientMessage ( "You added "..quantity.." "..tostring(itemList[item:lower()]).." to the user shop, with it being $"..tostring(price).." per item", source, 0, 255, 0 )
end )


function calculateEngTime ( milSec )
	local sec = math.floor ( milSec / 1000 )
	local min = 0
	local hour = 0
	
	while ( sec > 60 ) do
		sec = sec - 60
		min = min + 1
	end
	
	while ( min > 60 ) do
		min = min - 60
		hour = hour + 1
	end
	
	if ( sec > 0 and min == 0 and hour == 0 ) then
		return sec.." seconds"
	elseif ( min > 0 and hour == 0 ) then
		return min.." minutes"
	elseif ( hour > 0 ) then
		return hour.." hours"
	end
end
