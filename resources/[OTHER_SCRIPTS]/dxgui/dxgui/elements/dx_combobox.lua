dxComboBox = class ( 'dxComboBox', dxGUI )
local _clicked = false;

--TODO: Improve colors to suit the default background of a dxWindow

function dxComboBox:create ( x, y, width, caption, parent, caption_color )
    if not (x and y and width) then return; end
    local self = setmetatable({}, {__index = self});
    self.type = "combobox"
    self.x = x
    self.y = y
    self.width = width
    self.height = dxGetFontHeight() + 10;
    self.items = {};
    self.color = {0, 0, 0, 153};
    self.caption_color = caption_color or {255, 255, 255, 255};
    self.selected = 1
    self.active = false
    self.enabled = true;
    self.visible = true;
    self.render = true;

    if (parent) then
        self.parent = parent;
        self.render = false;
        table.insert(parent.children, self);
    end

    if (caption and type(caption == "string") and caption ~= "")  then
        self.selected = 0;
        self.caption = caption;
    end

    table.insert(dxObjects, self);
    return self
end
dxComboBox.new = dxComboBox.create;

function dxComboBox:addItem ( text, color )
    if (not text or text == "") then return; end
    table.insert ( self.items, {text, color or {255, 255, 255, 2550}} )
end

function dxComboBox:removeItem ( index )
    if (not tonumber(index)) then return; end
    table.remove ( self.items, index )
end

function dxComboBox:clear ( )
    self.items = {}
end

function dxComboBox:getItemText ( index )
    if (not index) then return; end
    if (index == 0) then return self.caption or nil;
    elseif (not self.items[index]) then return; end
    return self.items[index][1]
end

function dxComboBox:setItemText ( index, text )
    if (not index or not self.items[index]) then return; end
    self.items[index][1] = text
end

function dxComboBox:getSelected ( )
    return self.selected
end

function dxComboBox:setSelected ( index )
    if (not index or not self.items[index]) then return; end
    self.selected = index
end

function dxComboBox:initiateClick(button, state)
    if (button ~= "left" or state ~= "up") then return end
    self.active = not self.active
end

function dxComboBox:itemClick(index)
    self.selected = index;
    self.active = false;
end

function dxComboBox:draw()
    local r, g, b, a = unpack(self.color);
    if self.enabled and not self.active and isCursorShowing() and (not Cursor.active) and (self.parent and self.parent:isCursorOverRectangle(self.x, self.y, self.width, self.height) or isCursorOverRectangle(self.x, self.y, self.width, self.height)) then
        a = 255
    end
    dxDrawRectangle(self.x, self.y, self.width, self.height, tocolor(r, g, b, a));

    local text, text_color
    if (self.caption and self.selected == 0) then
        text, text_color = self.caption, self.caption_color;
    else
        text, text_color = unpack(self.items[self.selected]);
    end
    dxDrawText(text, self.x + 1, self.y + 4, self.x + self.width - 1, self.y + self.height - 4, tocolor(unpack(text_color)), 1.0, "left", "center");

    if (self.active) then
        for index, item in pairs(self.items) do
            local text, text_color = unpack(self.items[index]);
            local r, g, b, a = unpack(self.color);
            a = 200;
            local y = self.y + (self.height * index);
            if self.enabled and isCursorShowing() and (not Cursor.active) and (self.parent and self.parent:isCursorOverRectangle(self.x, y, self.width, self.height) or isCursorOverRectangle(self.x, y, self.width, self.height)) then
                a = 255
                if (getKeyState("mouse1") and not _clicked) then
                    _clicked = true;
                    self:itemClick(index);
                end
            end
            if (self.selected == index) then a = 255; end
            dxDrawRectangle(self.x, y, self.width, self.height, tocolor(r, g, b, a));
            dxDrawText(text, self.x + 1, y + 4, self.x + self.width - 1, y + self.height - 4, tocolor(unpack(text_color)), 1.0, "left", "center");
        end
    end
    if (not getKeyState("mouse1")) then _clicked = false; end
end