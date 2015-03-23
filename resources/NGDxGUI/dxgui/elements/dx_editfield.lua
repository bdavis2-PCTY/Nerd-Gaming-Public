dxEditfield = class ( 'dxEditfield', dxGUI )

function dxEditfield:create ( x, y, width, height, text, parent )
    self.type = "editfield"
    self.x = x
    self.y = y
    self.width = width
    self.height = height
    self.text = text
    self.masked = false
    self.maxLength = false
    self.readOnly = false
    self.caret = 0
    self.active = false
    self.parent = parent
    return self
end

function dxEditfield.getMax ( )
    return self.maxLength
end

function dxEditfield.setMax ( maxLength )
    self.maxLength = maxLength
end

function dxEditfield.getReadOnly ( )
    return self.readOnly
end

function dxEditfield.setReadOnly ( readOnly )
    self.readOnly = readOnly
end

function dxEditfield.setCaretIndex ( index )
    editfield.caret = index
end

function dxEditfield.getCaretIndex ( )
    return editfield.caret
end