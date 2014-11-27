local peak = tonumber ( getAccountData ( getAccount ( "Console" ), "ServerPeak" ) ) or #getElementsByType ( "player" )
function getServerPeak ( )
	return peak
end



if not peak then
	peak = #getElementsByType ( "player" )
	setAccountData ( getAccount ( "Console" ), "ServerPeak", tostring ( peak ) )
else
	if ( #getElementsByType ( "player" ) > peak ) then
		peak = #getElementsByType ( "player" )
		exports.ngmessages:sendClientMessage ( "The new server peak is "..tostring(peak).."! Here is a free $8,000 for everyone!", root, 0, 255, 0 )
		setAccountData ( getAccount ( "Console" ), "ServerPeak", tostring ( peak ) )
		for i,v in pairs ( getElementsByType ( "player" ) ) do
			givePlayerMoney ( v, 8000 )
		end
	end
end

addEventHandler ( "onPlayerJoin", root, function ( )
	if ( #getElementsByType ( "player" ) > peak ) then
		peak = #getElementsByType ( "player" )
		exports.ngmessages:sendClientMessage ( "The new server peak is "..tostring(peak).."! Here is a free $8,000 for everyone!", root, 0, 255, 0 )
		setAccountData ( getAccount ( "Console" ), "ServerPeak", tostring ( peak ) )
		for i,v in pairs ( getElementsByType ( "player" ) ) do
			givePlayerMoney ( v, 8000 )
		end
	end
end )

addCommandHandler ( "peak", function ( p )
	exports.ngmessages:sendClientMessage ( "The server peak is "..tostring(getServerPeak()), p, 0, 255, 0 )
end )