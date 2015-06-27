dxProgressBar = class ( 'dxProgressBar', dxGUI )

function dxProgressBar:create(x, y, width, height, parent)
	if not (x and y and width and height) then return; end
	local self = setmetatable({}, {__index = self});
	self.type = "progressbar";
	self.x = x;
	self.y = y;
	self.width = width;
	self.height = height;
	self.text = "";
	self.progress = 0;
	self.color = {255, 255, 255, 100};
	self.progress_color = {255, 255, 255, 200};
	self.text_color = {0, 0, 0, 255};
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
dxProgressBar.new = dxProgressBar.create;

function dxProgressBar:getProgress()
	return self.progress;
end

function dxProgressBar:setProgress(progress)
	if (not progress) then return; end
	self.progress = progress;
end

function dxProgressBar:setText(text)
	if (not text) then return end;
	self.text = text;
end

function dxProgressBar:setProgressColor(r, g, b, a)
	if not (r and g and b) then return; end
	self.progress_color = {r, g, b, a or 255};
end

function dxProgressBar:setTextColor(r, g, b, a)
	if not (r and g and b) then return; end
	self.text_color = {r, g, b, a or 255};
end

function dxProgressBar:draw()
	if (self.visible) then
		dxDrawRectangle(self.x, self.y, self.width, self.height, tocolor(unpack(self.color)));
		dxDrawRectangle(self.x + 5, self.y + 5, (self.progress / 100) * (self.width - 10), self.height - 10, tocolor(unpack(self.progress_color)));
		dxDrawText(self.text:format(self.progress), self.x, self.y, self.x + self.width, self.y + self.height, tocolor(unpack(self.text_color)), 1.0, "default", "center", "center");
	end
end