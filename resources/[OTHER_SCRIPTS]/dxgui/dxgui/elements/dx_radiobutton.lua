dxRadioButton = class ( 'dxRadioButton', dxGUI )
local _clicked = false;
--TODO: Add scaling maybe? (height)
--TODO: Does it have to be circular?

function dxRadioButton:create ( x, y, width, text, parent )
    if not (x and y and width) then return; end
	local self = setmetatable({}, {__index = self})
    self.type = "radiobutton"
    self.x = x
    self.y = y
    self.width = width
    self.height = 15;
    self.text = text or "";
    self.color = {255, 255, 255, 200};
    self.text_color = {255, 255, 255, 200};
    self.selected = selected
    self.enabled = true;
    self.visible = true
    self.render = true
    --self.active = false
	if parent then
        self.render = false
        self.parent = parent
        table.insert(parent.children, self)
    end
	
	table.insert(dxObjects, self)
    return self
end
dxRadioButton.new = dxRadioButton.create;

function dxRadioButton:getSelected ( )
    return self.selected
end

function dxRadioButton:setSelected ( selected )
    self.selected = selected
end

function dxRadioButton:draw ()
    if (self.visible) then
        local box_width, box_height = self.height, self.height;
        local r, g, b, a = unpack(self.color);
        local text_r, text_g, text_b, text_a = unpack(self.text_color);
        if self.enabled and isCursorShowing() and (not Cursor.active) and (self.parent and self.parent:isCursorOverRectangle(self.x, self.y, box_width + dxGetTextWidth(self.text) + 5, box_height) or isCursorOverRectangle(self.x, self.y, box_width + dxGetTextWidth(self.text) + 5, box_height)) then
            a = 255;
            text_a = 255;

            if (getKeyState("mouse1") and not _clicked) then
                _clicked = true;
                self.selected = not self.selected;

                if (self.parent) then
                	for index, element in pairs(self.parent.children or {}) do
                		if (element ~= self and element.type == "radiobutton") then element.selected = false; end
                	end
                end
            end
        end
        dxDrawBorder(self.x, self.y, box_width, box_height, tocolor(r, g, b, a));
        if (self.selected) then dxDrawRectangle(self.x + 4, self.y + 4, box_width - 7, box_height - 7, tocolor(r, g, b, a)); end
        local x = self.x + box_width + 5;
        local width = self.width - box_width - 5;
        dxDrawText(self.text, x, self.y, x + width, self.y + box_height + 2, tocolor(text_r, text_g, text_b, text_a), 1.0, "default", "left", "center");
    end

    if (not getKeyState("mouse1")) then _clicked = false; end
end