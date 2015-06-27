dxEditField = class ( 'dxEditField', dxGUI )
local mt = getmetatable(dxEditField);
mt.__index = function(self, key)
    if (key == "text") then
        return rawget(self, "edit").text;
    elseif (key == "readOnly") then
        return rawget(self, "edit").readOnly;
    else
        return rawget(dxEditField, key);
    end
end;
mt.__newindex = function(self, key, value)
    if (key == "text") then
        self.edit:setText(value);
    elseif (key == "readOnly") then
        self.edit.readOnly = value;
    else
        rawset(self, key, value);
    end
end;

--TODO: masked

function dxEditField:create ( x, y, width, height, text, parent )
    if not (x and y and width and height) then return; end
    local self = setmetatable({}, mt);
    self.type = "editfield"
    self.x = x
    self.y = y
    self.width = width
    self.height = height
    self._old_text = text or "";
    self.textcolor = {0, 0, 0, 255};
    self.color = {255, 255, 255, 200};
    -- self.masked = false
    -- self.maxLength = false
    -- self.caret = 0
    self.visible = true;
    self.render = true;

    self.edit = GuiEdit(x, y, width, height, text or "", false);
    self.edit:setAlpha(0);
    self.edit:setProperty("AlwaysOnTop", "true");

    --TODO: This needs a rewrite, stop using GuiEdit and actually code a dx one from scratch
    if (parent) then
        self.render = false;
        self.parent = parent;
        table.insert(parent.children, self);
        self.edit:setPosition(parent.x + x, parent.y + y, false);
        if (parent.type == "tab") then self.edit.visible = parent.panel.parent.visible;
        else self.edit.visible = parent.visible; end
    end

    addEventHandler("onClientGUIChanged", self.edit, function() _checkForWidth(self); end, false);

    table.insert(dxObjects, self);
    return self
end
dxEditField.new = dxEditField.create;

function dxEditField:destroy(do_not_remove)
    self.edit:destroy();
    dxGUI.destroy(self, do_not_remove);
end

-- function dxEditField:getMax ( )
--     return self.maxLength
-- end

-- function dxEditField:setMax ( maxLength )
--     self.maxLength = maxLength
-- end

function dxEditField:getReadOnly ( )
    return self.readOnly;
end

function dxEditField:setReadOnly ( readOnly )
    self.readOnly = readOnly;
end

function dxEditField:setCaretIndex ( index )
    if (not index) then return; end
    self.edit.caret = index
end

function dxEditField:getCaretIndex ( )
    return self.edit.caret
end

function dxEditField:getText()
    return self.edit:getText();
end

function dxEditField:setText(text)
    return self.edit:setText(text or "");
end

function _checkForWidth(self)
    if (dxGetTextWidth(self.edit:getText()) > (self.width - 25)) then
        self.edit:setText(self._old_text);
    else
        self._old_text = self.edit:getText();
    end
end

function dxEditField:draw()
    if (self.visible) then
        dxDrawRectangle(self.x, self.y, self.width, self.height, tocolor(unpack(self.color)));
        dxDrawText(self.edit.text, self.x + 8.5, self.y, self.x + self.width - 8.5, self.y + self.height, tocolor(unpack(self.textcolor)), 1.0, "default", "left", "center", true, false, false);
        
        -- Selection highlight
        local selection_start, selection_length = tonumber(self.edit:getProperty("SelectionStart")), tonumber(self.edit:getProperty("SelectionLength"));
        if (selection_length > 0) then
            local selection_x, selection_width;
            local text = self.edit:getText();
            if (selection_start == 0) then
                local selection_text = text:sub(1, selection_length);
                selection_x = self.x + 8.5
                selection_width = dxGetTextWidth(selection_text);
            else
                local pre_text = text:sub(1, selection_start);
                local selection_text = text:sub(selection_start + 1, selection_length + selection_start);
                selection_x = self.x + 8.5 + dxGetTextWidth(pre_text);
                selection_width = dxGetTextWidth(selection_text);
            end
            dxDrawRectangle(selection_x, self.y + 1, selection_width, self.height - 2, tocolor(56, 70, 239, 153));
        end
    end
end