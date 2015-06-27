function table.find(tab, value)
	for k, v in pairs(tab) do
		if v == value then
			return k
		end
	end
	return nil
end

function isCursorOverRectangle (x, y, w, h)
	local cX, cY = getCursorPosition()
	if isCursorShowing() then
		return ((cX*screenW > x) and (cX*screenW < x + w)) and ( (cY*screenH > y) and (cY*screenH < y + h));
	else
		return false;
	end
end

function table.copy(tab, recursive)
    local ret = {}
    for key, value in pairs(tab) do
        if (type(value) == "table") and recursive then
        	ret[key] = table.copy(value)
        	local mt = getmetatable(value);
        	if (mt) then setmetatable(ret[key], mt); end
        else ret[key] = value end
    end
    return ret
end

function spairs (t, f)
	assert(type(t) == "table")
	assert(type(f) == "function")
	
	local t = table.copy(t)
	table.sort(t, f)
	
	local index = 0
	return ( 
		function ()
			while index <= table.getn(t) do
				index = index + 1
				
				if index and t[index] then
					return index, t[index];
				end
			end
		end
	)
end

function debug(...)
	for i, v in ipairs(arg) do arg[i] = tostring(v); end
    outputDebugString(table.concat(arg, "  "));
end