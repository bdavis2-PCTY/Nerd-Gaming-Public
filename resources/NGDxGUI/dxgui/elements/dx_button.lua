dxButton = class ( 'dxButton', dxGUI )

function dxButton:create ( x, y, width, height, text, parent )
    local self = setmetatable({}, {__index = self})
    self.type = "button"
    self.text = text
    self.x = x
    self.y = y
    self.width = width
    self.height = height
    self.font = "default"
    self.textcolor = {255, 255, 255, 200}
    self.color = {0, 0, 0, 255}
    self.visible = true
    self.render = true
    self.func = function (state) if state == "down" then error("[WARNING] This Button has no function!") end end
	
    if parent then -- if we have an parent we have to draw it on the rendertarget of the parent, so it must be rendered in the renderevent of the Parent!
        self.render = false -- avoid the normal drawing
        self.parent = parent
        table.insert(parent.childs, self)
    end
	
    table.insert(dxObjects, self)
    return self
end

function dxButton:destroy ( )
    local parent = self.parent
    if parent then
        local idx = table.find(parent.childs, self)
        if idx then
            table.remove(parent.childs, idx)
        end
    end
	
    local idx = table.find(dxObjects, self)
    if idx then
        table.remove(dxObjects, idx)
    end
end

function dxButton:initiateClick (_, state)
    if state == "down" then
        self.textcolor[4] = 255
		self.func(state)
    elseif state == "up" then
        self.textcolor[4] = 200
    end
end

function dxButton:draw ( )
    if self.visible then
        local parent = self.parent
        local x, y, w, h = self.x, self.y, self.x + self.width, self.y + self.height
        if parent then
            --x, y, w, h = self.x, self.y, self.x + self.width, self.y + self.height
            if isCursorShowing() and (not Cursor.active) and parent:isCursorOverRectangle(self.x, self.y, self.width, self.height) then
                dxDrawRectangle(x, y, self.width, self.height, tocolor(self.color[1] + 25, self.color[2] + 25, self.color[3] + 25, self.color[4]), false)
            else
                dxDrawRectangle(x, y, self.width, self.height, tocolor(unpack(self.color)), false)
            end
        else
            --x, y, w, h = self.x, self.y, self.x + self.width, self.y + self.height
            if isCursorShowing() and (not Cursor.active) and isCursorOverRectangle(self.x, self.y, self.width, self.height) then
                dxDrawRectangle(x, y, self.width, self.height, tocolor(self.color[1] + 25, self.color[2] + 25, self.color[3] + 25, self.color[4]), false)
            else
                dxDrawRectangle(x, y, self.width, self.height, tocolor(unpack(self.color)), false)
            end
        end
		
        dxDrawText (self.text, x, y, w, h, tocolor(unpack(self.textcolor)), 1, self.font, "center", "center", true, false, false)
    end
end
