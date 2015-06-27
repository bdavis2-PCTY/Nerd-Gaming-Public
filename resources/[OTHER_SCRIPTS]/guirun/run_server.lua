------------------------------------------
-- 		 	  	 GUIRuncode	 		 	--
------------------------------------------
-- Developer: Braydon Davis	(xXMADEXx)	--
-- File: run_server.lua					--
-- Copyright 2013 (C) RoS				--
-- All rights reserved.					--
------------------------------------------
sec = {{{{{{},{},{},{}}}}}}				--
------------------------------------------

local ACL = 'Level 5' -- Required ACL to open the panel
local command = 'runscript' -- Command to open panel

local allowedACLS = { "Level 5", "Level 4" }

function openClientRuncodePanel ( player )
	local allowed = false
	for _, ACL in ipairs ( allowedACLS ) do
		if ( isPlayerInACL ( player, ACL ) ) then
			allowed = true
			break
		end
	end
	if ( not allowed ) then return end
	triggerClientEvent ( player, "GUIRuncode:onClientOpenPanel", player )
end
addCommandHandler ( command, openClientRuncodePanel )

function isPlayerInACL ( player, acl )
	local account = getPlayerAccount( player )
	if ( isGuestAccount ( account ) ) then
		return false
	end
	if ( isObjectInACLGroup ( "user."..getAccountName ( account ), aclGetGroup ( acl ) ) ) then
		return true
	else
		return false
	end
end

addEvent ( "GUIRuncode:runServerCode", true )
addEventHandler ( "GUIRuncode:runServerCode", root, function ( code )
	runString ( code, source )
end )

function runString ( code, p )
	local player = getPlayerName ( p ) or 'Console'
	outputToLogs ( p, code, 'server' )
	local notReturned
	local commandFunction,errorMsg = loadstring("return "..code)
	if errorMsg then
		notReturned = true
		commandFunction, errorMsg = loadstring(code)
	end
	if errorMsg then
		triggerClientEvent ( p, 'GUIRuncode:setClientResultText', p, "Results: "..errorMsg )
		return
	end
	results = { pcall(commandFunction) }
	if not results[1] then
		triggerClientEvent ( p, 'GUIRuncode:setClientResultText', p, "Results: "..results[2] )
		return
	end
	if not notReturned then
		local resultsString = ""
		local first = true
		for i = 2, #results do
			if first then
				first = false
			else
				resultsString = resultsString..", "
			end
			local resultType = type(results[i])
			if isElement(results[i]) then
				resultType = "element:"..getElementType(results[i])
			end
			resultsString = resultsString..tostring(results[i]).." ["..resultType.."]"
		end
		triggerClientEvent ( p, 'GUIRuncode:setClientResultText', p, "Results: "..resultsString )
	elseif not errorMsg then
		triggerClientEvent ( p, 'GUIRuncode:setClientResultText', p, "Results: Command executed" )
	end
end

function outputToLogs ( p, execution, side )
	local txt = "GUI Runcode: "..tostring ( getPlayerName ( p ) or 'Console' ).." executed "..tostring ( execution ).." ("..tostring ( side ).."-side)"
	outputDebugString ( tostring ( txt ), 2 )
	outputServerLog ( tostring ( txt ) )
end
addEvent ( 'GUIRuncode:outputLogs', true )
addEventHandler ( 'GUIRuncode:outputLogs', root, outputToLogs )
