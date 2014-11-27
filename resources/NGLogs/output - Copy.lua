--[[function outputActionLog ( log )
	local sourceResource = sourceResource or getThisResource()
	local resourceName = getResourceName(sourceResource)
	exports['NGSQL']:db_exec ( "INSERT INTO log_actions ( Resource, currentTime, Log ) VALUES ( ?, ?, ? )", tostring ( resourceName or "NONE" ), tostring ( getToday ( ) ), tostring ( log ) )
end

function outputPunishLog ( log )
	local sourceResource = sourceResource or getThisResource()
	local resourceName = getResourceName(sourceResource)
	exports['NGSQL']:db_exec ( "INSERT INTO log_punish ( Resource, currentTime, Log ) VALUES ( ?, ?, ? )", tostring ( resourceName or "NONE" ), tostring ( getToday ( ) ), tostring ( log ) )
end

function outputChatLog ( chat, log )
	local sourceResource = sourceResource or getThisResource()
	local resourceName = getResourceName(sourceResource)
	local log = log:gsub ( "#%x%x%x%x%x%x", "" )
	exports['NGSQL']:db_exec ( "INSERT INTO log_chat ( Resource, Chat, currentTime, Log ) VALUES ( ?, ?, ?, ? )", tostring ( resourceName or "NONE" ), tostring ( chat ), tostring ( getToday ( ) ), tostring ( log ) )
end

function getToday ( ) 
	local time = getRealTime ( )
	local year = time.year+1900
	local month = time.month+1
	local day = time.monthday
	local hour = time.hour
	local min = time.minute
	local sec = time.second
	if ( month < 10 ) then month = 0 .. month end
	if ( day < 10 ) then day = 0 .. day end
	if ( hour < 10 ) then hour = 0 .. hour end
	if ( min < 10 ) then min = 0 .. min end
	if ( sec < 10 ) then sec = 0 .. sec end
	return "["..table.concat({year,month,day},":").."-"..table.concat({hour,min,sec},":").."]"
end]]

function outputActionLog ( ) end
function outputPunishLog ( ) end
function outputChatLog ( ) end