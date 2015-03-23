dxFont = class ( 'dxFont' )

function dxFont:create ( filepath, size, bold )
    if not size then size = 9 end
    if not bold then bold = false end
	local self = enew(dxCreateFont(filepath, size, bold), dxFont) -- Magic: self => the font, but it is also an instance
    return self
end

function dxFont:destroy ( )
	destroyElement(self)
	self = nil
end