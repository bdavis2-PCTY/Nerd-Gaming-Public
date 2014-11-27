-- LS
exports.ngwarpmanager:makeWarp ( { pos = { 915.22, -1003.64, 39 }, toPos = { 384.8, 173.8,1008.7 }, cInt = 0, cDim = 0, tInt = 3, tDim = 1 } )
exports.ngwarpmanager:makeWarp ( { pos = { 389.84, 173.79, 1009.38 }, toPos = { 915.22, -1001, 39 }, cInt = 3, cDim = 1, tInt = 0, tDim = 0 } )
--LV
exports.ngwarpmanager:makeWarp ( { pos = { 2474.67, 1024.08, 11.82 }, toPos = { 384.8, 173.8,1008.7 }, cInt = 0, cDim = 0, tInt = 3, tDim = 2 } )
exports.ngwarpmanager:makeWarp ( { pos = { 389.84, 173.79, 1009.38 }, toPos = { 2474.67, 1024.08, 10.82 }, cInt = 3, cDim = 2, tInt = 0, tDim = 0 } )
--sf
exports.ngwarpmanager:makeWarp ( { pos = { -1704.39, 785.8, 26.42 }, toPos = { 384.8, 173.8,1008.7 }, cInt = 0, cDim = 0, tInt = 3, tDim = 3 } )
exports.ngwarpmanager:makeWarp ( { pos = { 389.84, 173.79, 1009.38 }, toPos = { -1704.39, 785.8, 25.42 }, cInt = 3, cDim = 3, tInt = 0, tDim = 0 } )




--



local bank = {
    button = {},
    radio = {},
    label = {}
}
local sx, sy = guiGetScreenSize ( )
bank['window'] = guiCreateWindow( ( sx / 2 - 446 / 2 ), ( sy / 2 - 363 / 2 ), 446, 363, "Bank Account - N/A", false)
bank['amount'] = guiCreateEdit(9, 239, 214, 23, "", false, bank['window'])
bank['progress'] = guiCreateProgressBar(233, 236, 203, 26, false, bank['window'])
bank.label[1] = guiCreateLabel(0, 25, 446, 49, string.rep ( "_", 85 ).."\nUser Information\n"..string.rep ( "_", 85 ), false, bank['window'])
bank.label[2] = guiCreateLabel(10, 84, 213, 20, "Account Name: N/A", false, bank['window'])
bank.label[3] = guiCreateLabel(10, 114, 213, 20, "Account Balance: $0", false, bank['window'])
bank.label[4] = guiCreateLabel(0, 159, 446, 49, string.rep ( "_", 85 ).."\nUser Actions\n"..string.rep ( "_", 85 ), false, bank['window'])
bank.label[5] = guiCreateLabel(10, 218, 81, 19, "Amount:", false, bank['window'])
bank.label[6] = guiCreateLabel(0, 3, 203, 18, "Processing Request...", false, bank['progress'])
bank.radio['deposit'] = guiCreateRadioButton(9, 272, 101, 20, "Deposit", false, bank['window'])
bank.radio['withdraw'] = guiCreateRadioButton(110, 272, 113, 20, "Withdraw", false, bank['window'])
bank.button['go'] = guiCreateButton(233, 272, 203, 30, "Continue With Request", false, bank['window'])
bank.button['exit'] = guiCreateButton(233, 312, 203, 30, "Exit Bank", false, bank['window'])

guiSetVisible ( bank['window'], false )
guiSetVisible ( bank['progress'], false )
guiWindowSetMovable ( bank['window'], false )
guiWindowSetSizable(bank['window'], false)
guiLabelSetHorizontalAlign(bank.label[1], "center", false)
guiLabelSetHorizontalAlign(bank.label[4], "center", false)
guiLabelSetColor(bank.label[6], 255, 0, 0)
guiLabelSetHorizontalAlign(bank.label[6], "center", false)
guiRadioButtonSetSelected(bank.radio['deposit'], true)

for i, v in pairs ( bank.label ) do 
	guiSetFont ( v, 'default-bold-small' )
end

ClientMarker = nil
balance = nil
account = nil
addEvent ( "NGBank:onClientEnterBank", true )
addEventHandler ( "NGBank:onClientEnterBank", root, function ( money, account, marker )
	guiSetVisible ( bank['window'], true )
	guiSetText ( bank['window'], "Bank Account - ".. tostring ( account ) )
	guiSetText ( bank['amount'], "" )
	guiSetText ( bank.label[2], "Account Name: "..tostring ( account ) )
	guiSetText ( bank.label[3], "Account Balance: $"..convertNumber ( money ) )
	guiSetText ( bank.label[6], "Processing - 0%" )
	guiProgressBarSetProgress ( bank['progress'], 0 )
	
	ClientMarker = marker
	balance = money
	account = account
	showCursor ( true )
	addEventHandler ( "onClientMarkerLeave", ClientMarker, CloseWindow_Marker )
	addEventHandler ( "onClientGUIClick", root, bankClicking )
	addEventHandler ( "onClientGUIChanged", root, bankEditing )
end )

function CloseBankWindow ( )
	guiSetText ( bank['window'], "Bank Account - ".. tostring ( account ) )
	guiSetVisible ( bank['window'], false )
	guiSetVisible ( bank['progress'], false )
	guiSetText ( bank['amount'], "" )
	guiSetText ( bank.label[2], "Account Name: N/A" )
	guiSetText ( bank.label[3], "Account Balance: $0" )
	guiSetText ( bank.label[6], "Processing - 0%" )
	guiProgressBarSetProgress ( bank['progress'], 0 )
	removeEventHandler ( "onClientMarkerLeave", ClientMarker, CloseWindow_Marker )
	ClientMarker = nil
	balance = nil
	account = nil
	showCursor ( false )
	removeEventHandler ( "onClientGUIClick", root, bankClicking )
	removeEventHandler ( "onClientGUIChanged", root, bankEditing )
end

function bankClicking ( )
	if ( isPedDead ( localPlayer ) ) then
		CloseBankWindow ( )
	end
	if ( source == bank.button['exit'] ) then
		CloseBankWindow ( )
	elseif ( source == bank.button['go'] ) then
		if ( guiGetText ( bank['amount'] ) ~= "" ) then
			setAllEnabled ( false )
			guiSetVisible ( bank['progress'], true )
			guiProgressBarSetProgress ( bank['progress'], 0 )
			progressTimer = setTimer ( function ( )
				guiProgressBarSetProgress ( bank['progress'], guiProgressBarGetProgress ( bank['progress'] ) + 2 )
				guiSetText ( bank.label[6], "Processing - "..tostring ( guiProgressBarGetProgress ( bank['progress'] ) ).."%" )
				if ( guiProgressBarGetProgress ( bank['progress'] ) >= 100 and guiGetVisible ( bank['window'] ) ) then
					if ( isTimer ( progressTimer ) ) then
						killTimer ( progressTimer )
					end
					setAllEnabled ( true )
					guiSetText ( bank.label[6], "Process Complete" )
					
					local mode = nil
					if ( guiRadioButtonGetSelected ( bank.radio['deposit'] ) ) then
						mode = 'deposit'
					else
						mode = 'withdraw'
					end
					triggerServerEvent ( "NGBank:ModifyAccount", localPlayer, tostring ( mode ), tonumber ( guiGetText ( bank['amount'] ) ) )
					
					setTimer ( function ( )
						if ( not isTimer ( progressTimer ) ) then
							guiProgressBarSetProgress ( bank['progress'], 0 )
							guiSetVisible ( bank['progress'], false )
							guiSetText ( bank.label[6], "Processing - 0%" )
						end
					end, 2500, 1 )
				end
			end, 60+math.random ( -10, 80 ), 100 )
		else
			exports['NGMessages']:sendClientMessage ( "Please enter an amount", 200, 200, 200 )
		end
	end
end

function bankEditing ( )
	if ( source == bank['amount'] ) then
		guiSetText ( source, guiGetText(source):gsub ( "%p", "" ) )
		guiSetText ( source, guiGetText(source):gsub ( "%s", "" ) )
		guiSetText ( source, guiGetText(source):gsub ( "%a", "" ) )
	end
end

function CloseWindow_Marker ( p )
	if ( p == localPlayer ) then
		CloseBankWindow ( )
	end
end

function setAllEnabled ( s )
	guiSetEnabled ( bank.button['go'], s )
	guiSetEnabled ( bank.button['exit'], s )
	guiSetEnabled ( bank.radio['deposit'], s )
	guiSetEnabled ( bank.radio['withdraw'], s )
	guiSetEnabled ( bank['amount'], s )
end

addEvent ( "NGBanks:resfreshBankData", true )
addEventHandler ( "NGBanks:resfreshBankData", root, function ( amount ) 
	guiSetText ( bank.label[3], "Account Balance: $"..convertNumber ( amount ) )
end )

function convertNumber ( number )  
	local formatted = number  
	while true do      
		formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')    
		if ( k==0 ) then      
			break   
		end  
	end  
	return formatted
end
