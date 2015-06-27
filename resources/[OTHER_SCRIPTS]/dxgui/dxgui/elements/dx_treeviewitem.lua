dxTreeViewItem = class("dxTreeViewItem", dxGUI);

function dxTreeViewItem:create(text, parent)
	if not (text and parent) then return; end
	local self = setmetatable({}, {__index = self});
	self.type = "textviewitem";
	self.text = text;
	self.parent = parent;
	self.folded = true;
	self.color = {0, 0, 0, 200};
	self.enabled = true;

	self.items = {};
	table.insert(parent.items, self);
	table.insert(dxObjects, self);
	return self;
end
dxTreeViewItem.new = dxTreeViewItem.create;

function dxTreeViewItem:destroy(do_not_remove)
	for index, item in pairs(self.items) do
		item:destroy(do_not_remove);
	end
	dxGUI.destroy(self, do_not_remove);
end

function dxTreeViewItem:addItem(text)
	if (not text) then return; end
	return dxTreeViewItem(text, self);
end