exports['Scoreboard']:addScoreboardColumn('Playtime')

local data = { }
setTimer ( function ( )
	for i, v in ipairs ( getElementsByType ( 'player' ) ) do
		if ( data[v] ) then
			local min = tonumber ( data[v]['min'] )
			local hour = tonumber ( data[v]['hour'] )
			if min then
				if hour then
					data[v]['min'] = min + 1
					
					if ( data[v]['min'] >= 60 ) then
						data[v]['min'] = 0
						data[v]['hour'] = data[v]['hour'] + 1
					end
					
					if ( tonumber ( data[v]['hour'] ) < 1 ) then
						if ( tonumber ( data[v]['min'] ) == 1 ) then
							setElementData ( v, "Playtime", "1 Minute" )
						else
							setElementData ( v, "Playtime", data[v]['min'].." Minutes" )
						end
					else
						if ( data[v]['hour'] == 1 ) then
							setElementData ( v, "Playtime", "1 Hour" )
						else
							setElementData ( v, "Playtime", data[v]['hour'].." Hours" )
						end
					end
					
				else
					data[v]['hour'] = 0
				end
			else
				data[v]['min'] = 0
			end
		else
			data[v] = { 
				['hour'] = 0,
				['min']=0
			}
		end
		setElementData ( v, "Playtime_hour", tonumber ( data[v]['hour'] ) )
		setElementData ( v, "Playtime_min", tonumber ( data[v]['min'] ) )
		
	end
end, 60000, 0 )

addEventHandler ( 'onPlayerJoin', root, function ( )
	if ( data[source] ) then
		data[source] = nil
	end
	data[source] = { }
	data[source]['min'] = 0
	data[source]['hour'] = 0
end )

addEventHandler ( "onResourceStart", resourceRoot, function ( )
	for i, source in ipairs ( getElementsByType ( 'player' ) ) do
		local to_min = 0
		local to_hour = 0
		if ( not getElementData ( source, "Playtime" ) or not getElementData ( source, "Playtime_hour" ) or not getElementData ( source, "Playtime_min" ) ) then
			setElementData ( source, "Playtime", "0 Minutes" )
			setElementData ( source, "Playtime_hour", 0 )
			setElementData ( source, "Playtime_min", 0 )
		else
			if ( not isGuestAccount ( getPlayerAccount ( source ) ) ) then
				local data = exports['NGSQL']:account_exist ( getAccountName ( getPlayerAccount ( source ) ) )
				if data then
					to_min = tonumber ( data[1]['Playtime_mins'] )
					to_hour = tonumber ( data[1]['Playtime_hours'] )
				end
			else
				setElementData ( source, "Playtime", "Loading Data" )
				to_hour = tonumber ( getElementData ( source, "Playtime_hour" ) ) or 0
				to_min = tonumber ( getElementData ( source, "Playtime_min" ) ) or 0
			end
		end

		data[source] = { }
		data[source]['min'] = to_min
		data[source]['hour'] = to_hour
		
		local data_set = ""
		if ( to_hour > 0 ) then
			if ( to_hour ~= 1 ) then
				data_set = tostring ( to_hour ).." Hours"
			else
				data_set = "1 Hour"
			end
		else
			if ( to_min ~= 1 ) then
				data_set = tostring ( to_min ).." Minutes"
			else
				data_set = "1 Minute"
			end
		end
		setElementData ( source, "Playtime", data_set )
		
	end
end )

addEventHandler ( "onPlayerLogin", root, function ( )
	setTimer ( function ( p )
		if ( getElementData ( p, "Playtime_min" ) and getElementData ( p, "Playtime_hour" ) ) then
			data[p] = { }
			data[p]['min'] = tonumber ( getElementData ( p, "Playtime_min" ) ) or 0
			data[p]['hour'] = tonumber ( getElementData ( p, "Playtime_hour" ) ) or 0
		end
	end, 500, 1, source )
end )


function getPlayerPlaytime ( p )
	if ( p and getElementType ( p ) == 'player' ) then
		if ( data[p] and data[p]['min'] and data[p]['hour'] ) then
			local h = tonumber ( data[p]['hour'] )
			local m = tonumber ( data[p]['min'] )
			return h, m
		end
	end
	return 0, 0
end

function setPlayerPlaytime ( p, hour, min )
	if ( p and getElementType ( p ) == 'player' and hour and min ) then
		local min = tonumber ( min )
		local hour = tonumber ( hour )
		if min and hour then
			if ( data[p] ) then
				data[p] = nil
			end
			data[p] = { }
			data[p]['min'] = min;
			data[p]['hour'] = hour;
			setElementData ( p, 'Playtime_min', min )
			setElementData ( p, 'Playtime_hour', hour )
			
			local pt = ""
			
			if ( hour > 0 ) then
				if ( hour ~= 1 ) then
					pt = tostring ( hour ).." Hours"
				else
					pt = tostring ( hour ).." Hour"
				end
			else
				if ( min ~= 1 ) then
					pt = tostring ( min ).." Minutes"
				else
					pt = tostring ( min ).." Minute"
				end
			end
			setElementData ( p, "Playtime", tostring ( pt ) )
			return true
		end
	end
	return false
end

function deletePlayerPlaytime ( p )
	if  ( p and getElementType ( p ) == 'player' and data[p] ) then
		data[p] = nil
		return true
	end
	return false
end

addCommandHandler ( 'playtime', function ( p )
	if ( not data[p] ) then
		data[p]['min']=0;
		data[p]['hour']=0;
		return exports.NGMessages:sendClientMessage("(ERROR) Updating table status.... 0 Minutes and 0 Hours.", p, 255, 0, 0 )
	end
	exports['NGMessages']:sendClientMessage( "Your play time is "..tostring(data[p]['hour']).." hours and "..tostring(data[p]['min']).." minutes.", p, 0, 255, 0 )
end )

