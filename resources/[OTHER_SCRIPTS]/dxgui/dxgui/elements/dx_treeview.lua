dxTreeView = class ( 'dxTreeView', dxGUI )
local _clicked = false;

function dxTreeView:create(x, y, width, height, text, parent)
	if not (x and y and width and height) then return; end
	local self = setmetatable({}, {__index = self});
	self.x = x;
	self.y = y;
	self.width = width;
	self.height = height;
	self.text = text or "";
	self.items = {};
	self.folded = {};
	self.color = {255, 255, 255, 125};
	self.enabled = true;
	self.render = true;
	self.visible = true;

	if (parent) then
		self.parent = parent;
		self.render = false;
		table.insert(parent.children, self);
	end

	table.insert(dxObjects, self);
	return self;
end
dxTreeView.new = dxTreeView.create;

function dxTreeView:destroy(do_not_remove)
	for index, item in pairs(self.items) do
		item:destroy(do_not_remove);
	end
	dxGUI.destroy(self, do_not_remove);
end

function dxTreeView:addItem(text)
	if (not text) then return; end
	return dxTreeViewItem(text, self);
end

function dxTreeView:draw()
	if (self.visible) then
		local current_y = self.y + 5;
		dxDrawRectangle(self.x, self.y, self.width, self.height, tocolor(unpack(self.color)));
		for index, item in pairs(self.items) do
			current_y = _drawItem(item, self, current_y, 0, self.width);
		end
	end
	if (not getKeyState("mouse1")) then _clicked = false; end
end

function _drawItem(item, parent, current_y, current_level)
	local text = item.text;
	local r, g, b, a = unpack(item.color);
	local x = parent.x + 5 + (current_level * 20);
    if self.enabled and item.enabled and isCursorShowing() and (not Cursor.active) and (parent.parent and parent.parent:isCursorOverRectangle(x, current_y, parent.width - 15, dxGetFontHeight() + 5) or isCursorOverRectangle(x, current_y, parent.width - 15, dxGetFontHeight() + 5)) then
		a = 255

        if (getKeyState("mouse1") and not _clicked) then
            _clicked = true;
            if (#item.items > 0) then item.folded = not item.folded; end
        end
	end
	if (#item.items > 0) then
		if (item.folded) then symbol = "→"; else symbol = "↓"; end
		dxDrawText(symbol, x, current_y, nil, nil, tocolor(r, g, b, a));
	end
	dxDrawText(text, x + 15, current_y, x + 15 + parent.width - (x + 20 - parent.x), current_y + dxGetFontHeight() + 5, tocolor(r, g, b, a), 1.0, "default", "left", "center", true);
	current_y = current_y + dxGetFontHeight() + 5
	if (not item.folded and #item.items > 0) then
		for index, _item in pairs(item.items) do
			current_y = _drawItem(_item, parent, current_y, current_level + 1);
		end
	end
	return current_y;
end