local lottery = nil
local winningNum = nil

addEvent ( "NGLottery->onClientAttemptToBuyLotteryTicket", true )
addEventHandler ( "NGLottery->onClientAttemptToBuyLotteryTicket", root, function ( number ) 
	local a = getPlayerAccount ( source )
	if ( isGuestAccount ( a ) ) then
		return exports.NGMessages:sendClientMessage ( "Please login to use the lottery", source, 255, 0, 0 )
	end

	if ( lottery [ getAccountName ( a ) ] ) then
		return exports.NGMessages:sendClientMessage ( "You already bought the lottery ticket \""..tostring(lottery[getAccountName(a)]).."\"", source, 255, 255, 0 )
	end

	for i, v in pairs ( lottery ) do
		if ( v == number ) then
			return exports.NGMessages:sendClientMessage ( "This number has already been bought.", source, 255, 255, 0 )
		end
	end

	if ( getPlayerMoney ( source ) < 100 ) then
		return exports.NGMessages:sendClientMessage ( "You don't have enough money to buy a lottery ticket", 255, 0, 0 )
	end

	takePlayerMoney ( source, 100 )
	exports.NGMessages:sendClientMessage ( "You have bought lottery ticket #"..tostring ( number ).."!", source, 0, 255, 0)
	lottery[getAccountName(a)] = number
end )

function winLottery ( )
	local winAccount = nil
	local winner = nil
	local num = getLotteryWinningNumber ( )
	for i, v in pairs ( lottery ) do
		if ( v == num ) then
			winAccount = i
		end
	end
	if ( winAccount ) then
		for i, v in pairs ( getElementsByType ( "player" ) ) do 
			local a = getPlayerAccount ( v )
			if ( not isGuestAccount ( a ) and getAccountName ( a ) == winAccount ) then
				winner = v
			end
		end
	end
	if ( winAccount and not winner ) then
		winner = winaccount.." #ff0000(offline)"
	elseif ( not winAccount ) then
		winner = nil
	end
	outputChatBox ( "====== Lottery =====", root, 255, 120, 0 )
	outputChatBox ( "Winner: "..tostring(winer or "Nobody"), root, 255, 255, 255, true)
	outputChatBox ( "Winning Number: #ffff00"..tostring ( num ), root, 255, 255, 255, true)
	outputChatBox ( "Prize: #00ff00$"..tostring ( prize ), root, 255, 255, 255, true )
	outputChatBox ( "==================", root, 255, 120, 0 )

	if ( winner ~= nil and getElementType ( winner ) == "player" ) then
		exports.NGMessages:sendClientMessage("You won $"..tostring(prize).." from the lottery!", winner, 0, 255, 0)
		givePlayerMoney ( winner, prize )
	end

	generateNextLottery ( )
end 

function generateNextLottery ( )
	lottery = { }
	winningNum = math.random ( 1, 80 )
	prize = math.random ( 7000, 10000 )
	if ( isTimer ( lotTImer ) ) then
		killTimer ( lotTImer )
		lotTImer = nil
	end
	lotTImer = setTimer ( winLottery, 1800000, 1)
end 

function getLotteryWinningNumber ( )
	return winningNum
end

function getLotteryTimer ( )
	return lotTImer 
end

generateNextLottery ( )




addEvent ( "NGLotter->onClientRequestTimerDetails", true )
addEventHandler ( "NGLotter->onClientRequestTimerDetails", root, function ( ) 
	triggerClientEvent ( source, "NGLottery->onServerSendClientTimerDetails", source, convertMilSecsToTimer ( getTimerDetails ( getLotteryTimer ( ) ) ))
end )


function convertMilSecsToTimer ( mil )
	local h = 0
	local m = 0
	local s = 0

	while ( mil > 1000 ) do
		s = s + 1
		mil = mil - 1000
	end

	while ( s > 60 ) do
		s = s - 60
		m = m + 1
	end 

	while ( m > 60 ) do
		m = m - 60
		h = h + 1
	end

	return tostring ( h ).."h "..tostring(m).."m "..tostring (s).."s"
end 