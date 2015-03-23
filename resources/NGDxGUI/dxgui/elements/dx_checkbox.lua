dxCheckbox = class ( 'dxCheckbox', dxGUI )

function dxCheckbox:create ( x, y, width, height, selected, parent )
	local self = setmetatable({}, {__index = self})
    self.type = "checkbox"
    self.x = x
    self.y = y
    self.width = width
    self.height = height
    self.selected = selected
    self.visible = true
    self.render = true
    --self.active = false
	if parent then
        self.render = false
        self.parent = parent
        table.insert(parent.childs, self)
    end
	
	table.insert(dxObjects, self)
    return self
end

function dxCheckbox:getSelected ( )
    return self.selected
end

function dxCheckbox:setSelected ( selected )
    self.selected = selected
end

function dxCheckbox:render ()

end