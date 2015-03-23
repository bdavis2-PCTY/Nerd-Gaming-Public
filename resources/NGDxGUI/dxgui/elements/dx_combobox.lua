dxCombobox = class ( 'dxCombobox', dxGUI )

function dxCombobox:create ( x, y, width, height, caption, parent )
    self.type = "combobox"
    self.x = x
    self.y = y
    self.width = width
    self.height = height
    self.text = text
    self.options = {}
    self.selected = 0
    self.active = false
    self.parent = parent
    return self
end

function dxCombobox:addItem ( text )
    table.insert ( self.options, text )
end

function dxCombobox:removeItem ( index )
    table.remove ( self.options, index )
end

function dxCombobox:clear ( )
    self.options = {}
end

function dxCombobox:getItemText ( index )
    return self.options[index]
end

function dxCombobox:setItemText ( index, text )
    self.options[index] = text
end

function dxCombobox:getSelected ( )
    return self.selected
end

function dxCombobox:setSelected ( index )
    self.selected = index
end