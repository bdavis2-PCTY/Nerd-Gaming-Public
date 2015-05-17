print_ = print
print = outputChatBox

exports.scoreboard:scoreboardAddColumn ( "VIP", root, 50, "VIP", 10 )
for i, v in pairs ( getElementsByType ( "player" ) ) do
	if ( not getElementData ( v, "VIP" ) ) then
		setElementData ( v, "VIP", "None" )
	end
end

addEventHandler ( "onPlayerJoin", root, function ( )
	setElementData ( source, "VIP", "None" )
end )

-- VIP Chat --
addCommandHandler ( "vipchat", function ( p, cmd, ... )
	if ( not isPlayerVIP ( p ) ) then
		return exports.NGMessages:sendClientMessage ( "This command is for VIP users only", p, 255, 0, 0 )
	end
	
	if ( isPlayerMuted ( p ) ) then
		return exports.NGMessages:sendClientMessage ( "This command is disabled when you're muted", p, 255, 255, 0 )
	end
	
	if ( not getElementData ( p, "userSettings" )['usersetting_display_vipchat'] ) then
		return exports.NGMessages:sendClientMessage ( "Please enable VIP chat in your phone settings to use this command.", 0, 255, 255 )
	end
	
	local msg = table.concat ( { ... }, " " )
	if ( msg:gsub ( " ", "" ) == "" ) then
		return exports.NGMessages:sendClientMessage ( "Syntax: /"..tostring(cmd).." [message]", p, 255, 255, 0 )
	end
	
	local tags = "(VIP)"..tostring(exports.NGChat:getPlayerTags ( p ))
	local msg = tags..getPlayerName ( p )..": #ffffff"..msg
	for i,v in pairs ( getElementsByType ( 'player' ) ) do
		if ( ( isPlayerVIP ( v ) or exports.NGAdministration:isPlayerStaff ( p ) ) and getElementData ( v, "userSettings" )['usersetting_display_vipchat'] ) then
			outputChatBox ( msg, v, 200, 200, 0, true )
		end
	end
end )





function checkPlayerVipTime ( p )
	local vip = getElementData ( p, "VIP" )
	if ( vip == "None" ) then return end
	local expDate = getElementData ( p, "NGVIP.expDate" )  or "0000-00-00"  -- Format: YYYY-MM-DD
	if ( isDatePassed ( expDate ) ) then
		setElementData ( p, "VIP", "None" )
		setElementData ( p, "NGVIP.expDate", "0000-00-00" )
		exports.NGMessages:sendClientMessage ( "Your VIP time has been expired.", p, 255, 0, 0 )
	end
end

function checkAllPlayerVIP ( )
	for i, v in pairs ( getElementsByType ( "player" ) ) do
		checkPlayerVipTime ( v )
	end
end

function isPlayerVIP ( p )
	checkPlayerVipTime ( p )
	return tostring ( getElementData ( p, "VIP" ) ):lower ( ) ~= "none"
end 

function getVipLevelFromName ( l )
	local levels = { ['none'] = 0, ['bronze'] = 1, ['silver'] = 2, ['gold'] = 3, ['diamond'] = 4 }
	return levels[l:lower()] or 0;
end










------------------------------------------
-- Give VIP players free cash			--
------------------------------------------
local payments = { [1] = 500, [2] = 700, [3] = 1000, [4] = 1500 }

VipPayoutTimer = setTimer ( function ( )
	exports.NGLogs:outputServerLog ( "Sending out VIP cash...." )
	print_ ( "Sending out VIP cash...." )
	outputDebugString ( "Sending VIP cash" )
	
	for i, v in ipairs ( getElementsByType ( "player" ) ) do
		if ( isPlayerVIP ( v ) ) then
			local l = getVipLevelFromName ( getElementData ( v, "VIP" ) )
			local money = payments [ l ]
			givePlayerMoney ( v, money )
			exports.NGMessages:sendClientMessage ( "Here is a free $"..money.." for being a VIP player!", v, 0, 255, 0 )
		end
	end
end, (60*60)*1000, 0 ) 


function getVipPayoutTimerDetails ( ) 
	return getTimerDetails ( VipPayoutTimer )
end

function isDatePassed ( date )
	-- date format: YYYY-MM-DD
	local this = { }
	local time = getRealTime ( );
	this.year = time.year + 1900
	this.month = time.month + 1
	this.day = time.monthday 
	local old = { }
	local data = split ( date, "-" )
	old.year = data[1];
	old.month = data[2];
	old.day = data[3];
	for i, v in pairs ( this ) do
		this [ i ] = tonumber ( v )
	end for i, v in pairs ( old ) do
		old [ i ] = tonumber ( v )
	end
	if ( this.year > old.year ) then
		return true
	elseif ( this.year == old.year and this.month > old.month ) then
		return true
	elseif ( this.year == old.year and this.month == old.month and this.day > old.day ) then
		return true
	end
	return false
end






addEventHandler( "onResourceStart", resourceRoot, function ( )
	checkAllPlayerVIP ( )
	setTimer ( checkAllPlayerVIP, 120000, 0 )
end )


--[[

Bronze: 
	- Laser
	- Able to warp vehicle to you
	- Additional 6 vehicles in spawners
	- $500/hour
	- 5% less jail time


	
Silver: 
	- Laser
	- Able to warp your vehicle to you
	- Additional 6 vehicles in spawners
	- $700/hour
	- 15% less jail time
	
	
Gold:
	- Laser
	- Able to warp your vehicle to you
	- Additional 6 vehicles in spawner
	- $1000/hour
	- %25 less jail time
	
	
Diamond:
	- Laser
	- Able to warp your vehicle to you
	- Additional 6 vehicles in spawners
	- $1500/hour
	- Half jail time


]]







