function openVipEditWindow ( acc )
	Vip = { }
	VipDetails = { 
		account = acc
	}
	
	Vip.window = guiCreateWindow((sx/2-250/2), (sy/2-270/2), 250, 270, "VIP Manager", false)
	guiWindowSetSizable(Vip.window, false )
	Vip.account = guiCreateLabel(20, 37, 315, 23, "Account: "..tostring(acc), false, Vip.window)
	Vip.misc_1 = guiCreateLabel(19, 102, 75, 22, "Exp. Day:", false, Vip.window)
    Vip.misc_2 = guiCreateLabel(19, 134, 82, 22, "Exp. Month:", false, Vip.window)
	Vip.misc_3 = guiCreateLabel(19, 166, 82, 22, "Exp. Year:", false, Vip.window)
	Vip.misc_4 = guiCreateLabel(19, 198, 82, 22, "Level:", false, Vip.window)
	Vip.cancel = guiCreateButton(19, 230, 82, 33, "Cancel", false, Vip.window)
	Vip.update = guiCreateButton(106, 230, 82, 33, "Update VIP", false, Vip.window) 
	Vip.level = guiCreateButton(111, 201, 120, 25, "Bronze", false, Vip.window)
	
	local d = getRealTime ( )
	Vip.expMonth = guiCreateEdit(111, 131, 120, 25, d.month + 1, false, Vip.window)
	Vip.expYear = guiCreateEdit(111, 166, 120, 25, d.year + 1900, false, Vip.window)
	Vip.expDay = guiCreateEdit(111, 99, 120, 25, d.monthday+1, false, Vip.window)
	
	local data = { 
		day = guiGetText(Vip.expDay),
		month = guiGetText(Vip.expMonth),
		year = guiGetText(Vip.expYear)
	}
	Vip.expLabel = guiCreateLabel(19, 61, 316, 22, "Expiration Date: "..table.concat({guiGetText(Vip.expDay),guiGetText(Vip.expMonth),guiGetText(Vip.expYear)},"/").." ("..getDaysToDate(data)..")", false, Vip.window)
	
	addEventHandler ( "onClientGUIClick", Vip.update, onClientVipButtonClick )
	addEventHandler ( "onClientGUIClick", Vip.cancel, onClientVipButtonClick )
	addEventHandler ( "onClientGUIClick", Vip.level, onClientVipButtonClick)
	addEventHandler ( "onClientGUIChanged", Vip.expMonth, onClientVipEditChanged )
	addEventHandler ( "onClientGUIChanged", Vip.expYear, onClientVipEditChanged )
	addEventHandler ( "onClientGUIChanged", Vip.expDay, onClientVipEditChanged )
	
	showCursor ( true )
end

function destroyVipWindow ( )
	removeEventHandler ( "onClientGUIClick", Vip.update, onClientVipButtonClick )
	removeEventHandler ( "onClientGUIClick", Vip.cancel, onClientVipButtonClick )
	removeEventHandler ( "onClientGUIClick", Vip.level, onClientVipButtonClick)
	removeEventHandler ( "onClientGUIChanged", Vip.expMonth, onClientVipEditChanged )
	removeEventHandler ( "onClientGUIChanged", Vip.expYear, onClientVipEditChanged )
	removeEventHandler ( "onClientGUIChanged", Vip.expDay, onClientVipEditChanged )
	destroyElement ( Vip.window )
	Vip = nil
	VipDetails = nil
	showCursor ( false )
end 

function onClientVipButtonClick ( )
	if ( source == Vip.level ) then
		local t = tostring ( source.text ):lower ( )
		if ( t == "bronze" ) then
			source.text = "Silver"
		elseif ( t == 'silver' ) then
			source.text = 'Gold'
		elseif ( t == 'gold' ) then
			source.text = 'Diamond'
		elseif ( t == 'diamond' ) then
			source.text = 'Bronze'
		end
	elseif ( source == Vip.cancel ) then
		destroyVipWindow ( )
	elseif ( source == Vip.update) then
		local day = tonumber ( Vip.expDay.text )
		local month = tonumber ( Vip.expMonth.text)
		local year = tonumber ( Vip.expYear.text )
		if ( not day or not month or not year ) then
			return exports.ngmessages:sendClientMessage ( "Invalid date provided.", 255, 0, 0 )
		end

		triggerServerEvent ( "NGAdmin->Modules->aManager->VIPManager->UpdateAccountVIP", localPlayer, VipDetails.account, Vip.level.text, day, month, year )
	end 
end 


function onClientVipEditChanged ( )
	local t = guiGetText ( source )
	if ( t == "" ) then return end
	local t = t:gsub ( "%a", "" )
	local t = t:gsub ( "%s", "" )
	local t = t:gsub ( "%p", "" )
	local f = getRealTime ( )
	local t = tonumber ( t )
	if ( t < 1 ) then
		t = 1
	end if ( source == Vip.expMonth and t > 12 ) then
		t = 12
	elseif ( source == Vip.expDay and t > 30 ) then
		t = 30
	end
	guiSetText ( source, tostring ( t ) )
	local data = { 
		day = guiGetText(Vip.expDay),
		month = guiGetText(Vip.expMonth),
		year = guiGetText(Vip.expYear)
	}
	local fDate = table.concat({guiGetText(Vip.expDay),guiGetText(Vip.expMonth),guiGetText(Vip.expYear)},"/")
	guiSetText ( Vip.expLabel, "Expiration Date: "..fDate.." ("..getDaysToDate(data)..")" )
end