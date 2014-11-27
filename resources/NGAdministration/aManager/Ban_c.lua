function openBanWindow ( acc )
	Ban = { }
	BanDetails = { 
		account = acc
	}
	
	Ban.window = guiCreateWindow((sx/2-250/2), (sy/2-270/2), 250, 270, "Ban Account", false)
	guiWindowSetSizable(Ban.window, false )
	Ban.account = guiCreateLabel(20, 37, 315, 23, "Ban Account: "..tostring(acc), false, Ban.window)
	Ban.misc_1 = guiCreateLabel(19, 102, 75, 22, "Unban Day:", false, Ban.window)
    Ban.misc_2 = guiCreateLabel(19, 134, 82, 22, "Unban Month:", false, Ban.window)
	Ban.misc_3 = guiCreateLabel(19, 166, 82, 22, "Unban Year:", false, Ban.window)
	Ban.misc_4 = guiCreateLabel(19, 198, 82, 22, "Reason:", false, Ban.window)
	Ban.cancel = guiCreateButton(19, 230, 82, 33, "Cancel", false, Ban.window)
	Ban.ban = guiCreateButton(106, 230, 82, 33, "Ban", false, Ban.window) 
	Ban.reason = guiCreateEdit(111, 201, 120, 25, "", false, Ban.window)
	
	local d = getRealTime ( )
	Ban.unbanMonth = guiCreateEdit(111, 131, 120, 25, d.month + 1, false, Ban.window)
	Ban.unbanYear = guiCreateEdit(111, 166, 120, 25, d.year + 1900, false, Ban.window)
	Ban.unbanDay = guiCreateEdit(111, 99, 120, 25, d.monthday+1, false, Ban.window)
	
	local data = { 
		day = guiGetText(Ban.unbanDay),
		month = guiGetText(Ban.unbanMonth),
		year = guiGetText(Ban.unbanYear)
	}
	Ban.unbanLabel = guiCreateLabel(19, 61, 316, 22, "Unban Date: "..table.concat({guiGetText(Ban.unbanDay),guiGetText(Ban.unbanMonth),guiGetText(Ban.unbanYear)},"/").." ("..getDaysToDate(data)..")", false, Ban.window)
	
	addEventHandler ( "onClientGUIClick", Ban.ban, onClientBanButtonClick )
	addEventHandler ( "onClientGUIClick", Ban.cancel, onClientBanButtonClick )
	addEventHandler ( "onClientGUIChanged", Ban.unbanMonth, onClientBanEditEdit )
	addEventHandler ( "onClientGUIChanged", Ban.unbanYear, onClientBanEditEdit )
	addEventHandler ( "onClientGUIChanged", Ban.unbanDay, onClientBanEditEdit )
	
	showCursor ( true )
end

function destroyBanWindow ( )
	removeEventHandler ( "onClientGUIClick", Ban.ban, onClientBanButtonClick )
	removeEventHandler ( "onClientGUIClick", Ban.cancel, onClientBanButtonClick )
	removeEventHandler ( "onClientGUIChanged", Ban.unbanMonth, onClientBanEditEdit )
	removeEventHandler ( "onClientGUIChanged", Ban.unbanYear, onClientBanEditEdit )
	removeEventHandler ( "onClientGUIChanged", Ban.unbanDay, onClientBanEditEdit )
	for i, v in pairs ( Ban ) do
		if ( v and isElement ( v ) ) then
			local t = getElementType ( v )
			if ( t:sub ( 0, 4 ) == "gui-" ) then
				destroyElement ( v )
			end
		end
	end
	Ban = nil
	showCursor ( false )
end

function onClientBanButtonClick ( )
	if ( source == Ban.cancel ) then
		destroyBanWindow ( )
	elseif ( source == Ban.ban ) then
		
		local account = BanDetails.account;
		local data = { 
			day = guiGetText(Ban.unbanDay),
			month = guiGetText(Ban.unbanMonth),
			year = guiGetText(Ban.unbanYear)
		}
		
		local days = getDaysToDate ( data )
		if ( days:sub ( 0, 1 ) == "-" ) then -- check if date is passed
			return outputChatBox ( "Invalid date; This date is already passed" )
		end

		triggerServerEvent ( "NGAdmin:Modules->Banner:onAdminBanClient", localPlayer, account, tonumber(data.day), tonumber(data.month), tonumber(data.year), guiGetText ( Ban.reason ), days )
		destroyBanWindow ( )
	end
end

function onClientBanEditEdit ( )
	local t = guiGetText ( source )
	if ( t == "" ) then return end
	local t = t:gsub ( "%a", "" )
	local t = t:gsub ( "%s", "" )
	local t = t:gsub ( "%p", "" )
	local f = getRealTime ( )
	local t = tonumber ( t )
	if ( t < 1 ) then
		t = 1
	end if ( source == Ban.unbanMonth and t > 12 ) then
		t = 12
	elseif ( source == Ban.unbanDay and t > 30 ) then
		t = 30
	end
	guiSetText ( source, tostring ( t ) )
	local data = { 
		day = guiGetText(Ban.unbanDay),
		month = guiGetText(Ban.unbanMonth),
		year = guiGetText(Ban.unbanYear)
	}
	local fDate = table.concat({guiGetText(Ban.unbanDay),guiGetText(Ban.unbanMonth),guiGetText(Ban.unbanYear)},"/")
	guiSetText ( Ban.unbanLabel, "Unban Date: "..fDate.." ("..getDaysToDate(data)..")" )
end


function getDaysToDate ( d )
	local day = tonumber ( d.day )
	local month = tonumber ( d.month ) * 30
	local year = tonumber ( d.year ) * 365
	local t = getRealTime ( )
	local tDay = t.monthday
	local tMonth = ( t.month + 1 ) * 30
	local tYear = ( t.year + 1900 ) * 365
	local tSum = tDay + tMonth + tYear
	local dSum = day + month + year
	local days = dSum - tSum
	if ( days == 1 ) then
		return "1 Day"
	else
		return days.." Days" 
	end
end