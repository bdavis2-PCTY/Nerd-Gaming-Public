dxWindow = class("dxWindow", dxGUI);
local mt = getmetatable(dxWindow);
mt.__index = function(self, key)
    if (key == "visible") then
        return rawget(self, "_visible");
    else
        return rawget(dxWindow, key);
    end
end    
mt.__newindex = function(self, key, value)
    if (key == "visible") then
        self:setVisible(value);
    else
        rawset(self, key, value);
    end
end

function dxWindow:create ( x, y, width, height, text, movable, post_gui )
    if not (x and y and width and height) then return; end
    local self = setmetatable({}, mt)
    self.type = "window"
    self.text = text or "";
    self.x = x
    self.y = y
    self.width = width
    self.height = height
    self.font = "default"
    self.post_gui = post_gui;
    self.render = true
    self.sizable = true
    self._visible = true
    self.color = {31, 31, 31, 220}
    self.titlecolor = {81, 156, 14, 200}
	
    self.movable = movable == true
    self.m = dxMovable:createMovable(width, height, true)
    self.m.posX, self.m.posY = x, y
    self.m.movable = movable == true
	
    self.children = {}
	
    table.insert(dxObjects, self)
    return self
end
dxWindow.new = dxWindow.create;

function dxWindow:destroy ( )
	local idx = table.find(dxObjects, self)
	if idx then
		table.remove(dxObjects, idx)
	end
	if isElement(self.m) then
		self.m:destroyElement()
	end
	if table.getn(self.children) > 0 then
		for i, v in pairs(self.children) do
            v:destroy(true);
		end
	end
	
    self = nil
end

function dxWindow:setMovable ( movable )
    self.movable = movable
    self.m:setMovable(self.movable)
end

function dxWindow:getMovable ( )
    return self.movable
end

function dxWindow:setSizable ( sizable )
    self.sizable = sizable
end

function dxWindow:getSizable ( )
    return self.sizable
end

function dxWindow:setTitleColor ( r, g, b )
    if string.find(tostring(r), "#") then -- look for HEX Codes
        local rgb = hexToRGB(r)
        r, g, b = rgb[1], rgb[2], rgb[3]
    end

    self.titlecolor = {r, g, b, self.titlecolor[4]}
end

function dxWindow:getTitleColor ( )
	return self.titlecolor
end

function dxWindow:isCursorOverRectangle ( x, y, w, h )
	local x, y, w, h = self.m.posX + x, self.m.posY + y, w, h
	local cX, cY = getCursorPosition()
	if isCursorShowing() and (not Cursor.active) then
		return ((cX*screenW > x) and (cX*screenW < x + w)) and ((cY*screenH > y) and (cY*screenH < y + h));
	else
		return false;
	end
end

--TODO: Nasty workaround, perhaps a different way to do this?
function dxWindow:setVisible(visible)
    for index, element in pairs(self.children) do
        if (element.type == "editfield") then
            element.edit.visible = visible;
        elseif (element.type == "tabpanel") then
            for index, tab in pairs(element.tabs) do
                for index, element in pairs(tab.children) do
                    if (element.type == "editfield") then
                        element.edit.visible = visible;
                    end
                end
            end
        end
    end
    self._visible = visible;
    if (self.m) then self.m.movable = visible; end
end

function dxWindow:draw ( )
    dxSetRenderTarget(self.m.renderTarget, true)
        dxSetBlendMode("modulate_add")
            dxDrawRectangle (0, 0, self.width, self.height, tocolor(unpack(self.color)), false)
            dxDrawRectangle (0, 0, self.width, 20, tocolor(unpack(self.titlecolor)), false)
            dxDrawText (self.text, 0, 0, 0 + self.width, 20, self.textcolor, 1, self.font, "center", "center", true, false, false)
			
            --TODO: Add priority to each element
            local comboboxes = {};
            for i, v in ipairs(self.children or {}) do -- draw all children on the rendertarget
                if v.visible then
                    if v.type ~= "combobox" then v:draw()
                    else table.insert(comboboxes, v); end
                elseif (type == "editfield" and v.edit.visible) then v.edit.visible = false;
                end
            end
            for i, v in ipairs(comboboxes) do
                v:draw();
            end
        dxSetBlendMode("blend")
        dxSetRenderTarget()
    dxDrawImage(self.m.posX, self.m.posY, self.m.w, self.m.h, self.m.renderTarget, 0, 0, 0, tocolor(255, 255, 255, 255), self.post_gui)
end