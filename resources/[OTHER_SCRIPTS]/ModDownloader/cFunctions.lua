function table.len ( tb )
	local l = 0;
	for _ in pairs ( tb ) do 
		l = l + 1;
	end 
	return l;
end 

local __outputDebugString = _G['outputDebugString'];
function outputDebugString ( msg, r, g, b )
	if not r then r = 0 end 
	if not g then g = 255 end
	if not b then b = 0 end 
	__outputDebugString ( msg, 0, r, g, b );
end 