function changeBlipRange ( )
	for i, v in ipairs ( getElementsByType ( "blip" ) ) do
		if ( getBlipIcon ( v ) ~= 0 ) then
			setBlipVisibleDistance ( v, 300 )
		end
	end
end
changeBlipRange ( )
setTimer ( changeBlipRange, 60000, 0 )