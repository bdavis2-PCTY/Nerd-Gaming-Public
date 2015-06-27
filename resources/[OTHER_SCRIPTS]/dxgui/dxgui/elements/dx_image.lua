dxImage = class ( 'dxImage', dxGUI )

function dxImage:create(x, y, width, height, image, parent)
	if not (x and y and width and height and image) then return; end
	local self = setmetatable({}, {__index = self});
	self.type = "image";
	self.x = x;
	self.y = y;
	self.width = width;
	self.height = height;
	self.image = image;
	self.rotation = {0, 0, 0};
	self.color = {255, 255, 255, 255};
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
dxImage.new = dxImage.create;

function dxImage:setImage(image)
	if (not image) then return; end
	self.image = image;
end

function dxImage:setRotation(rotation, rotation_center_offset_x, rotation_center_offset_y)
	if (not rotation) then return; end
	self.rotation = {rotation, rotation_center_offset_x or 0, rotation_center_offset_y or 0};
end

function dxImage:draw()
	if (self.visible) then
		dxDrawImage(self.x, self.y, self.width, self.height, self.image, unpack(self.rotation), tocolor(unpack(self.color)));
	end
end