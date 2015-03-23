--[[
    ToDo:
    do stuff
]]

dxObjects = {}

dxGUI = class ( 'dxGUI' )

function dxGUI:bringToFront ( )
    if self.parent then self.parent:bringToFront() return end

    local idx = table.find(dxObjects, self)
        if idx then
            for i, v in ipairs(self.childs) do
                local idx = table.find(dxObjects, v)
                if idx then
                    table.remove(dxObjects, idx)
                    table.insert(dxObjects, v)
                end
            end
		
            table.remove(dxObjects, idx)
            table.insert(dxObjects, self)
        end
    idx = table.find(dxMovable.elements, self.m)
        if idx then
            table.remove(dxMovable.elements, idx)
            table.insert(dxMovable.elements, 1, self.m)
        end
    idx = nil
end

function dxGUI:sendToBack ( )
    if self.parent then self.parent:sendToBack() return end

    local idx
    idx = table.find(dxObjects, self)
        if idx then
            table.remove(dxObjects, idx)
            table.insert(dxObjects, 1, self)
			
            for i, v in ipairs(self.childs) do
                local idx = table.find(dxObjects, v)
                if idx then
                    table.remove(dxObjects, idx)
                    table.insert(dxObjects, 1, v)
                end
            end
        end
    idx = table.find(dxMovable.elements, self.m)
        if idx then
            table.remove(dxMovable.elements, idx)
            table.insert(dxMovable.elements, self.m)
        end
    idx = nil
end

function dxGUI:activate ( )
    if self.parent then self.parent:activate() return end
    --Set as active window
end

function dxGUI:getAlpha ( )
    return self.color[4]
end

function dxGUI:setAlpha ( alpha )
    self.color[4] = alpha
end

function dxGUI:setColor ( oldR, oldG, oldB )
    local r, g, b = oldR, oldG, oldB
    if string.find(tostring(r), "#") then -- look for HEX Codes
        local rgb = hexToRGB(r)
        r, g, b = rgb[1], rgb[2], rgb[3]
    end

    self.color = {r, g, b, self.color[4]}
end

function dxGUI:getColor ( )
    return self.color
end

function dxGUI:getEnabled ( )
    return self.enabled
end

function dxGUI:setEnabled ( enabled )
    self.enabled = enabled
end

function dxGUI:getFont ( )
    return self.font
end

function dxGUI:setFont ( font )
    self.font = font
end

function dxGUI:getParent ( )
    return self.parent
end

function dxGUI:setParent ( parent )
    self.parent = parent
end

function dxGUI:getPosition ( )
    if self.m then
        return self.m.posX, self.m.posY
    else
        return self.x, self.y
    end
end

function dxGUI:setPosition ( x, y )
    if self.m then -- if we have an rendertarget we must change the rendertarget position
        self.m.posX, self.m.posY = x, y
    else
        self.x, self.y = x, y
    end
end

function dxGUI:getSize ( )
    if self.m then
        return self.m.w, self.m.h
    else
        return self.width, self.height
    end
end

function dxGUI:setSize ( width, height )
    if self.m then
        self.m.w, self.m.h = width, height
    else
        self.width, self.height = width, height
    end
end

function dxGUI:getText ( )
    return self.text
end

function dxGUI:setText ( text )
    self.text = text
end

function dxGUI:getVisible ( )
    return self.visible
end

function dxGUI:setVisible ( visible )
    self.visible = visible
	
    if self.m then -- if we have an rendertarget we also mut change the rendertarget visibility
        self.m.movable = self.visible
    end
end

--Drawing functions
function clientRender()
	dxMovable:render()

    for k,v in ipairs(dxObjects) do
        if v.visible and v.render then
            v:draw()
        end
    end
end
addEventHandler("onClientRender", root, clientRender)

function onClick(...)
    local testfunc = function (a, b) if table.find(dxObjects, b) < table.find(dxObjects, a) then return true end end

    for k, v in spairs(dxObjects, testfunc) do
        if v.type == "button" and v.visible then
            if not Cursor.active then
                local parent = v.parent
                if parent then
                    if parent:isCursorOverRectangle(v.x, v.y, v.width, v.height) then
                        v:initiateClick(...)
                        break
                    end
                else
                    if isCursorOverRectangle(v.x, v.y, v.width, v.height) then
                        v:initiateClick(...)
                        break
                    end
                end
            end
        end
    end
end
addEventHandler("onClientClick", root, onClick)

--dxMovable

--Generic functions
screenW, screenH = guiGetScreenSize()

function hexToRGB ( hex )
    hex = hex:gsub( "#", "" )
    return { tonumber ( "0x"..hex:sub( 1, 2 ) ), tonumber ( "0x"..hex:sub( 3, 4 ) ), tonumber ( "0x"..hex:sub( 5, 6 ) ) }
end

-- Test
local longString = 
[[
Hello %s,
how are you?
I'm testing the DirectX-GUI-Libary
and if you can see this it works fine.

Here you can see an example Window!
You can move it around, just press F2!
]]

--[[
addEventHandler("onClientResourceStart", resourceRoot, function ()
    local win = dxWindow:create(10, 10, 250, 245, "Information", true)
    local win2 = dxWindow:create(500, 10, 250, 245, "window2", true)
    local but = dxButton:create(5, 190, 240, 50, "Press me. (Alt-Gr)", win)
    local but2 = dxButton:create(5, 190, 240, 50, "Press me. (Alt-Gr)", win2)
    local text = dxText:create (5, 25, 240, 160, longString:format(getPlayerName(localPlayer)), win)
    text:setAlginX("center")
    text:setAlginY("center")
	
    but:setColor(125, 0, 0)
    but2:setColor(125, 0, 0)
	
    --but.func = function (state) if state == "down" then error("1") end end
    but2.func = function (state) if state == "down" then error("2") end end
end)

bindKey("ralt", "down", function () showCursor(not isCursorShowing()) end)]]