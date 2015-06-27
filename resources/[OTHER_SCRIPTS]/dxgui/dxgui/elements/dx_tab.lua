dxTab = class ( 'dxTab', dxGUI )

--TODO: Do tabs really need a visible field?

function dxTab:create(title, panel)
	if not (title and panel) then return; end
	local self = setmetatable({}, {__index = self});
	self.type = "tab";
	self.id = #panel.tabs + 1;
	self.title = title;
	self.panel = panel;
	self.x = panel.x;
	self.y = panel.y
	self.enabled = true;
	self.visible = true;
	self.color = {255, 255, 255, 255};
	-- self.visible = true;

	self.children = {};
	
	table.insert(panel.tabs, self);
	table.insert(dxObjects, self);
	return self;
end
dxTab.new = dxTab.create;

function dxTab:destroy()
	table.remove(self.panel.tabs, self.id);
	table.remove(dxObjects, self);
end

function dxTab:isCursorOverRectangle ( x, y, w, h )
	if (self.panel.parent) then
		x, y, w, h = self.panel.parent.x + self.panel.x + x, self.panel.parent.y + self.panel.y + y + dxGetFontHeight()+  12, w, h
	else
		x, y, w, h = self.panel.x + x, self.panel.y + y + dxGetFontHeight() + 12, w, h
	end
	local cX, cY = getCursorPosition()
	if isCursorShowing() and (not Cursor.active) then
		return ((cX*screenW > x) and (cX*screenW < x + w)) and ((cY*screenH > y) and (cY*screenH < y + h));
	else
		return false;
	end
end