arresties = { }
tased = { }

addEventHandler ( "onPlayerDamage", root, function ( cop, weapon, _, loss ) 
	-- arrest system
	if ( isElement ( cop ) and weapon and cop ~= source  ) then
		
		if ( getElementData ( cop, "NGEvents:IsPlayerInEvent" ) or getElementData ( source, "NGEvents:IsPlayerInEvent" ) ) then
			return 
		end
	
		if ( cop == source ) then return end
		if ( getElementType ( cop ) == 'vehicle' ) then
			cop = getVehicleOccupant ( cop )
		end
		if ( not isElement ( cop ) or getElementType ( cop ) ~= 'player' ) then return end
		if ( not getPlayerTeam ( cop ) ) then
			return
		end

		if ( exports['NGPlayerFunctions']:isTeamLaw ( getTeamName ( getPlayerTeam ( cop ) ) ) ) then
			if ( getElementData ( source, "isSpawnProtectionEnabled" ) == true ) then 
				return exports['NGMessages']:sendClientMessage ( "This player has spawn-protection enabled.", cop, 255, 0, 0 ) 
			end
			
			if ( getPlayerTeam ( source ) and getTeamName ( getPlayerTeam ( source ) ) == "Staff" ) then 
				return exports['NGMessages']:sendClientMessage ( "You cannot arrest/tase on-duty staff.", cop, 255, 0, 0 ) 
			end
			
			if ( arresties[source] ) then 
				return exports['NGMessages']:sendClientMessage ( "This player is already arrested.", cop, 255, 0, 0 ) 
			end
			if ( getPlayerWantedLevel ( source ) >= 1 ) then
				if ( weapon == 3 ) then
					-- Arrest
					arrestPlayer ( source, cop )
					exports['NGMessages']:sendClientMessage ( "You have arrested "..getPlayerName ( source )..", take him to a police station.", cop, 0, 255, 0 )
					exports['NGMessages']:sendClientMessage ( getPlayerName ( cop ).." arrested you!", source, 255, 255, 0 )
					setElementHealth ( source, getElementHealth ( source ) + loss )
					setElementData ( source, "NGJobs:ArrestingOfficer", cop )
					
					addEventHandler ( "onPlayerQuit", source, onPlayerAttmemptArrestAvoid );
				elseif ( weapon == 23 ) then
					-- Taze Player
					if ( tased [ source ] ) then
						return exports.NGMessages:sendClientMessage ( "This player is already tased", cop, 255, 255, 255 )
					end
					
					local a = cop
					local t = getPlayerTeam ( a )
					if ( not t ) then return end
					if ( getPlayerWantedLevel ( source ) == 0 ) then return end
					if ( exports.NGPlayerFunctions:isTeamLaw ( getTeamName ( t ) ) and not getElementData ( source, "NGJobs:ArrestingOfficer" ) ) then
						-- now we know:
						-- source 	-> wanted, not arrested
						-- w 		-> teaser
						toggleAllControls ( source, false )
						if ( isPedInVehicle ( source ) ) then
							removePedFromVehicle ( source )
						end
						setPedAnimation(source, "CRACK", "crckdeth2", 4000, false, true, false)
						
						exports.NGMessages:sendClientMessage ( "You have tased ".. getPlayerName ( source ), a, 0, 255, 0 )
						exports.NGMessages:sendClientMessage ( "You have been tased by "..getPlayerName ( a ), source, 255, 0, 0 )
						tased [ source ] = true
						setTimer ( function ( p, c )
							if ( isElement ( p ) ) then
								setPedAnimation ( p )
								toggleAllControls ( p, true )
								exports.NGMessages:sendClientMessage ( "You are no longer tased", p, 0, 255, 0 )
								if ( isElement ( c ) ) then
									exports.NGMessages:sendClientMessage ( getPlayerName ( p ).." is now un-tased!", c, 255, 255, 0 )
								end
							end
							tased [ p ] = false
						end, 4000, 1, source, a )
					end
				else
					if ( isPedInVehicle ( cop ) ) then return end 
					exports['NGMessages']:sendClientMessage ( "Use a nightstick to arrest and a silenced pistol to tase", cop, 255, 255, 255 )
				end
			else
				local f = math.floor ( loss * 1.2)
				setElementHealth ( cop, getElementHealth ( cop ) - f )
				exports['NGMessages']:sendClientMessage ( "You've lost "..tostring ( f ).."% health for hurting an innocent player.", cop, 255, 255, 0 )
			end
		end	
	end
end )

function onPlayerAttmemptArrestAvoid ( )
	--outputChatBox ( getPlayerName ( source )..  " attempted to arrest avoid" )
	triggerEvent ( "ngpolice:onJailCopCrimals", getElementData ( source, "NGJobs:ArrestingOfficer" ) )
end

addCommandHandler ( "release", function ( p, _, p2 )
	if ( getPlayerTeam ( p ) and exports['NGPlayerFunctions']:isTeamLaw ( getTeamName ( getPlayerTeam ( p ) ) ) ) then
		if ( p2 ) then
			local c = getPlayerFromName ( p2 ) or exports['NGPlayerFunctions']:getPlayerFromNamePart ( p2 )
			if c then
				if ( arresties[c] ) then
					if ( getElementData ( c, "NGJobs:ArrestingOfficer") == p ) then
						exports['NGMessages']:sendClientMessage ( "You have released "..getPlayerName ( c ), p, 0, 255, 0)
						exports['NGMessages']:sendClientMessage ( getPlayerName ( p ).." released you.", c, 0, 255, 0 )
						releasePlayer ( c )
						local arresties2 = { }
						for i, v in pairs ( arresties ) do
							if ( getElementData ( v, "NGJobs:ArrestingOfficer" ) == p ) then
								table.insert ( arresties2, v )
							end
						end
						triggerClientEvent ( root, "onPlayerEscapeCop", root, c, p, arresties2 )
					else exports['NGMessages']:sendClientMessage ( "You're not "..getPlayerName ( c ).."'s arresting officer, you cannot release him.", p, 255, 255, 0 ) end
				else exports['NGMessages']:sendClientMessage ( getPlayerName ( c ).." isn't being arrested", p, 255, 255, 0 ) end
			else exports['NGMessages']:sendClientMessage ( p2.." doesn't exist. ", p, 255, 255, 0 ) end
		else exports['NGMessages']:sendClientMessage ( "Syntax error. /release [player]", p, 255, 255, 0 ) end
	else exports['NGMessages']:sendClientMessage ( "You're not a law officer.", p, 255, 255, 0 ) end
end )

function arrestPlayer ( crim, cop )
	showCursor ( crim, true )
	arresties[crim] = true
	toggleControl ( crim, 'right', false )
	toggleControl ( crim, 'left', false )
	toggleControl ( crim, 'forwards', false )
	toggleControl ( crim, 'backwards', false )
	toggleControl ( crim, 'jump', false )
	toggleControl ( crim, 'sprint', false )
	toggleControl ( crim, 'walk', false )
	toggleControl ( crim, 'fire', false )
	onTimer ( crim, cop )
	triggerClientEvent ( root, "onPlayerStartArrested", root, crim, cop )
end

function onTimer ( crim, cop )
	if ( isElement ( crim ) and isElement ( cop ) ) then
		if ( not getPlayerTeam ( cop ) or not exports['NGPlayerFunctions']:isTeamLaw ( getTeamName ( getPlayerTeam ( cop ) ) ) ) then return releasePlayer ( crim ) end
		if ( not arresties[crim] ) then return  end
		local cx, cy, cz = getElementPosition ( crim )
		local px, py, pz = getElementPosition ( cop )
		local rot = findRotation ( cx, cy, px, py )
		setPedRotation ( crim, rot )
		setCameraTarget ( crim, crim )
		local dist = getDistanceBetweenPoints3D ( cx, cy, cz, px, py, pz )
		if ( isPedInVehicle ( cop ) ) then
			if ( not isPedInVehicle ( crim ) ) then
				warpPedIntoVehicle ( crim, getPedOccupiedVehicle ( cop ), 1 )
			end
		else
			if ( isPedInVehicle ( crim ) ) then
				removePedFromVehicle ( crim )
			end
		end
		if ( not isPedInVehicle ( crim ) ) then
			if ( dist >= 20 ) then
				setElementPosition ( crim, px +1, py+1, pz )
			elseif ( dist >= 15 ) then
				setControlState ( crim, 'walk', false )
				setControlState ( crim, 'jump', true )
				setControlState ( crim, 'sprint', true )
				setControlState ( crim, "forwards", true )
			elseif ( dist >= 10 ) then
				setControlState ( crim, 'walk', false )
				setControlState ( crim, 'jump', false )
				setControlState ( crim, 'sprint', true )
				setControlState ( crim, "forwards", true )
			elseif ( dist >= 7 ) then
				setControlState ( crim, 'walk', false )
				setControlState ( crim, 'jump', true )
				setControlState ( crim, 'sprint', false )
				setControlState ( crim, "forwards", true )
			elseif ( dist >= 2 ) then
				setControlState ( crim, 'walk', true )
				setControlState ( crim, 'jump', false )
				setControlState ( crim, 'sprint', false )
				setControlState ( crim, "forwards", true )
			else
				setControlState ( crim, 'walk', false )
				setControlState ( crim, 'jump', false )
				setControlState ( crim, 'sprint', false )
				setControlState ( crim, "forwards", false )
			end
		end
		
		crim.interior = cop.interior;
		crim.dimension = cop.dimension
		
		setTimer ( onTimer, 500, 1, crim, cop )
	else
		arresties[crim] = false
		if ( not isElement ( cop ) and isElement ( crim ) ) then
			releasePlayer ( crim )
			exports['NGMessages']:sendClientMessage ( "Your arresting officer has quit, therefore, you've been released.", crim, 0, 255, 0 )
		end
	end
end

function findRotation(x1,y1,x2,y2)
	local t = -math.deg(math.atan2(x2-x1,y2-y1))
	if t < 0 then t = t + 360 end;
	return t;
end

function releasePlayer ( p )
	toggleAllControls ( p, true )
	setControlState ( p, 'walk', false )
	setControlState ( p, 'jump', false )
	setControlState ( p, 'sprint', false )
	setControlState ( p, "forwards", true )
	setElementData ( p, "NGJobs:ArrestingOfficer", nil )
	arresties[p] = nil
	showCursor ( p, false )
	removeEventHandler ( "onPlayerQuit", p, onPlayerAttmemptArrestAvoid );
end


function onJailCopCriminals( )
	for v, _ in pairs ( arresties ) do 
		if ( getElementData ( v, "NGJobs:ArrestingOfficer" ) == source ) then
			
			releasePlayer ( v )
			local time = math.floor ( ( getElementData ( v, "WantedPoints" ) * 2 ) or 50 )
			local orgTime = time
			local vip = getElementData ( v, "VIP" )
			if ( exports.NGVIP:getVipLevelFromName ( vip ) == 4 ) then
				time = time - ( time * 0.5 )
				exports.NGMessages:sendClientMessage ( "You're serving 50% less jail time due to diamond VIP! (Original time: "..orgTime.." seconds)", v, 0, 255, 0 )
			elseif ( exports.NGVIP:getVipLevelFromName ( vip ) == 3  ) then
				time = time - ( time * 0.25 )
				exports.NGMessages:sendClientMessage ( "You're serving 25% less jail time due to gold VIP! (Original time: "..orgTime.." seconds)", v, 0, 255, 0 )
			elseif ( exports.NGVIP:getVipLevelFromName ( vip ) == 2 ) then
				time = time - ( time * 0.15 )
				exports.NGMessages:sendClientMessage ( "You're serving 15% less jail time due to silver VIP! (Original time: "..orgTime.." seconds)", v, 0, 255, 0 )
			elseif ( exports.NGVIP:getVipLevelFromName ( vip ) == 1 ) then
				time = time - ( time * 0.05 )
				exports.NGMessages:sendClientMessage ( "You're serving 5% less jail time due to bronze VIP! (Original time: "..orgTime.." seconds)", v, 0, 255, 0 )
			end
			
			local time = math.floor ( time )
			
			givePlayerMoney ( source, math.floor ( orgTime*2 ) )
			exports['NGMessages']:sendClientMessage ( "You were paid $"..math.floor ( orgTime*2 ).." for arresting "..getPlayerName ( v ).."!", source, 0, 255, 0 )
			exports['NGPolice']:jailPlayer ( v, time, false, source, "Police Arrest" )
			updateJobColumn ( getAccountName ( getPlayerAccount ( source ) ), "Arrests", "AddOne" )
		end
	end
end

addEvent ( "ngpolice:onJailCopCrimals", true )
addEventHandler ( "ngpolice:onJailCopCrimals", root, onJailCopCriminals )

-- Prevent arrest avoid by disconnect
addEventHandler ( "onPlayerLeave", root, function ( ) 
    if ( arresties [ source ] ) then 

            
    end  
end );