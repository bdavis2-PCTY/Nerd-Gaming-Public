function dxDrawCircle3D( x, y, z, radius, segments, color, width )
    segments = segments or 16; -- circle is divided into segments -> higher number = smoother circle = more calculations
	local px, py, pz = getElementPosition ( localPlayer )
    color = color or tocolor( 255, 255, 0 );
    width = width or 1;
    local segAngle = 360 / segments;
    local fX, fY, tX, tY; -- drawing line: from - to
    for i = 1, segments do
		fX = x + math.cos( math.rad( segAngle * i ) ) * radius;
		fY = y + math.sin( math.rad( segAngle * i ) ) * radius;
		tX = x + math.cos( math.rad( segAngle * (i+1) ) ) * radius;
		tY = y + math.sin( math.rad( segAngle * (i+1) ) ) * radius;
		local c = isLineOfSightClear ( px, py, pz, fX, fY, z, true, true, true, true, true, false, false, nil )
		if ( c ) then
			dxDrawLine3D( fX, fY, z, tX, tY, z, color, width );
		end
    end
end
 
addEventHandler("onClientRender", root,
    function()
        dxDrawCircle3D( 2280.62, -1566.58, 6.65, 1, 50)
    end
)