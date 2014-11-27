addEvent ( "NGInventory:onClientUseItem", true )
addEventHandler ( "NGInventory:onClientUseItem", root, function ( i )
	exports.NGLogs:outputActionLog ( getPlayerName ( source ).." ("..getAccountName(getPlayerAccount(source))..") used a(n) "..tostring(i) )
end )

local pickups = { }
addEvent( "NGInventory:onClientDropItem", true )
addEventHandler ( "NGInventory:onClientDropItem", root, function ( item, amount, name )
	local x, y, z = getElementPosition ( source )
	local rot = findRotation ( x, y, x+1, y+1 )
	local x, y = getPointFromDistanceRotation ( x, y, 1.5, rot )
	local p = createPickup ( x-1, y+1, z, 3, item, 5000 )
	pickups[p] = { itemID=item, amount=amount, itemName = name }
	addEventHandler ( "onPickupHit", p, OnPickupHit )

	pickups[p].interior = source.interior
	pickups[p].dimension = source.dimension
end )

function OnPickupHit ( p )
	if ( p and isElement ( p ) and getElementType ( p ) == "player" and not isPedInVehicle ( p ) ) then
		local d = getElementData ( p, "NGUser:Items" )
		local pI = pickups [ source ]
		if ( not d ) then
			d = { }
			setElementData ( p, "NGUser:Items", { } )
		end
		if ( not d [ pI.itemName ] ) then
			d[pI.itemName] = 0
			setElementData ( p, "NGUser:Items", d )
		end
		d[pI.itemName] = d[pI.itemName] + pI.amount
		setElementData ( p, "NGUser:Items", d )
		exports.NGMessages:sendClientMessage ( "You have picked up "..tostring(pI.amount).." of this item.", p, 0, 255, 0 )
		removeEventHandler ( "onPickupHit", p, OnPickupHit )
		destroyElement ( source )
	end
end




function getPointFromDistanceRotation(x, y, dist, angle)
    local a = math.rad(90 - angle);
    local dx = math.cos(a) * dist;
    local dy = math.sin(a) * dist;
    return x+dx, y+dy;
end

function findRotation(x1,y1,x2,y2)
  local t = -math.deg(math.atan2(x2-x1,y2-y1))
  if t < 0 then t = t + 360 end;
  return t;
end