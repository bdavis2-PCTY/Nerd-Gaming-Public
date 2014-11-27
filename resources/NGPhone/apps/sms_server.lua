addEvent ( 'NGPhone:App.SMS:SendPlayerMessage', true )
addEventHandler ( 'NGPhone:App.SMS:SendPlayerMessage', root, function ( who, message )
	if ( who and isElement ( who ) ) then
		triggerClientEvent ( who, 'NGPhone:App.SMS:OnPlayerReciveMessage', who, source, message )
		exports['NGLogs']:outputChatLog ( "Phone:SMS", "From "..getPlayerName(source).." | To: "..getPlayerName(who).." | Message: "..message )
	end
end )