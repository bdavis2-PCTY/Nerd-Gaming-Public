dxText = class ( 'dxText', dxGUI )

function dxText:create ( x, y, width, height, text, parent )
	local self = setmetatable({}, {__index = self})
	self.type = "textlable"
    self.text = text
    self.x = x
    self.y = y
    self.width = width
    self.height = height
    self.font = "default"
	self.scale = 1
	self.alginX = "left"
	self.alginY = "top"
	self.clip = false
	self.wordbreak = false
    self.color = {255, 255, 255, 255}
    self.visible = true
    self.render = true
	
	if parent then
		self.render = false
		self.parent = parent
		table.insert(parent.childs, self)
	end
	
	table.insert(dxObjects, self)
	return self
end

function dxText:setAlginX ( alginX )
	self.alginX = alginX
end

function dxText:getAlginX ( )
	return self.alginX
end

function dxText:setAlginY ( alginY )
	self.alginY = alginY
end

function dxText:getAlginY ( )
	return self.alginY
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
	dxDrawText(self.text, self.x, self.y, self.x + self.width, self.y + self.height, tocolor(unpack(self.color)), self.scale, self.font, self.alginX, self.alginY, self.clip, self.wordbreak, false)
end