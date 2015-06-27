dxText = class ( 'dxText', dxGUI )

function dxText:create ( x, y, width, height, text, parent )
	if not (x and y and width and height) then return; end
	local self = setmetatable({}, {__index = self})
	self.type = "text"
    self.text = text or "";
    self.x = x
    self.y = y
    self.width = width
    self.height = height
    self.font = "default"
	self.scale = 1
	self.alignX = "left"
	self.alignY = "top"
	self.clip = false
	self.wordbreak = false
    self.color = {255, 255, 255, 255}
    self.visible = true
    self.render = true
	
	if parent then
		self.render = false
		self.parent = parent
		table.insert(parent.children, self)
	end
	
	table.insert(dxObjects, self)
	return self
end
dxText.new = dxText.create;

function dxText:setAlignX ( alignX )
	if (not alignX) then return; end
	self.alignX = alignX
end

function dxText:getAlignX ( )
	return self.alignX
end

function dxText:setAlignY ( alignY )
	if (not alignY) then return; end
	self.alignY = alignY
end

function dxText:getAlignY ( )
	return self.alignY
end

function dxText:setClip ( clip )
	self.clip = clip
end

function dxText:getClip ( )
	return self.clip
end

function dxText:setWordbreak ( wordbreak )
	self.wordbreak = wordbreak
end

function dxText:getWordbreak ( )
	return self.wordbreak
end

function dxText:draw ( )
	--dxDrawRectangle(self.x, self.y, self.width, self.height, tocolor(0, 0, 0, 150))
	dxDrawText(self.text, self.x, self.y, self.x + self.width, self.y + self.height, tocolor(unpack(self.color)), self.scale, self.font, self.alignX, self.alignY, self.clip, self.wordbreak, false)
end