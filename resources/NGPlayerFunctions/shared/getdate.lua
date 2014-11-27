function getToday ( )
	local t = getRealTime ( )
	local year = t.year + 1900
	local month = t.month + 1
	local day  =t.monthday
	if ( month < 10 ) then month = 0 .. month end
	if ( day < 10 ) then day = 0 .. day end
	local date = table.concat ( { year, month, day }, "-" )
	return date
end