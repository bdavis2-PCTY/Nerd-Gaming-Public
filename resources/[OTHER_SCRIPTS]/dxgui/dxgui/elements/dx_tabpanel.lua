dxTabPanel = class ( 'dxTabPanel', dxGUI )
local _clicked = false;

function dxTabPanel:create(x, y, width, height, parent)
	if not (x and y and width and height) then return; end
	local self = setmetatable({}, {__index = self});
	self.type = "tabpanel";
	self.x = x;
	self.y = y;
	self.width = width;
	self.height = height;
	self.color = {0, 0, 0, 190};
	self.selected = 1;
	self.tabs = {};
	self.render = true;
	self.visible = true;

	if (parent) then
		self.parent = parent;
		self.render = false;
		table.insert(parent.children, self);
	end

	self.render_target = dxCreateRenderTarget(self.width, self.height - dxGetFontHeight() - 12, true);

	table.insert(dxObjects, self);
	return self;
end
dxTabPanel.new = dxTabPanel.create;

function dxTabPanel:destroy(do_not_remove)
	for index, tab in pairs(self.tabs) do self.tab:destroy() end
	dxGUI.destroy(self, do_not_remove);
end

function dxTabPanel:addTab(title)
	if (not title) then return; end
	return dxTab(title, self);
end

function dxTabPanel:removeTab(index)
	if (not index or not self.tabs[index]) then return; end
	self.tabs[index]:destroy();
end

function dxTabPanel:getSelected()
	return self.selected;
end

function dxTabPanel:setSelected(index)
	if (not index or not self.tabs[index]) then return; end
	self.selected = index;
end

function dxTabPanel:draw()
	if (self.visible) then
		local tab_width, tab_height = 50, dxGetFontHeight() + 12;
		dxDrawRectangle(self.x, self.y + tab_height, self.width, self.height - tab_height, tocolor(unpack(self.color)));
		dxDrawBorder(self.x, self.y + tab_height, self.width, self.height - tab_height);

		for index, tab in pairs(self.tabs) do
			if (dxGetTextWidth(tab.title) > tab_width) then tab_width = dxGetTextWidth(tab.title) + 20; end
			local r, g, b, a = unpack(self.color);
		    local x = self.x + (tab_width * (index - 1));
		    if (tab.enabled and isCursorShowing() and (not Cursor.active) and (self.parent and self.parent:isCursorOverRectangle(x, self.y, tab_width, tab_height) or isCursorOverRectangle(x, self.y, tab_width, tab_height))) then
		        a = 255;

		        if (getKeyState("mouse1") and not _clicked) then
		            _clicked = true;
		            self.selected = index;
		        end
		    elseif self.selected == index then
		    	a = 255;
		    else
		    	a = 120;
		    end
		    dxDrawRectangle(x, self.y, tab_width, tab_height, tocolor(r, g, b, a));
		    dxDrawBorder(x, self.y, tab_width, tab_height);
		    dxDrawText(tab.title, x, self.y, x + tab_width, self.y + tab_height, tocolor(unpack(tab.color)), 1.0, "default", "center", "center");
		
		    if (self.selected == index) then
				dxSetRenderTarget(self.render_target, true);
				dxSetBlendMode("modulate_add");
				for i, v in ipairs(tab.children or {}) do -- draw all children on the rendertarget
				    if v.visible then
				        v:draw();
				    end
				end
				dxSetBlendMode("blend");
				if (self.parent.m.renderTarget) then dxSetRenderTarget(self.parent.m.renderTarget);
				else dxSetRenderTarget(); end
				dxDrawImage(self.x, self.y + tab_height, self.width, self.height - tab_height, self.render_target);
			end
		end
	end
	if (not getKeyState("mouse1")) then _clicked = false; end
end