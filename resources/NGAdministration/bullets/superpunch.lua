plrsWithSuperPunch = { }

addEventHandler ( "onPlayerDamage", root, function ( atr, weap, _, loss )
	
	if ( atr and isElement ( atr ) and weap and weap == 0 ) then
		if ( getElementModel ( atr ) and getElementModel ( atr ) == 217 ) then
			if ( getPlayerStaffLevel ( atr, "int" ) or 0 >= 4 and plrsWithSuperPunch [ atr ] ) then
				local h = loss+60
				setElementHealth ( source, getElementHealth ( source ) - h )
				setElementVelocity ( source, 0, 0, 5 )
			end
		end
	end

end )

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