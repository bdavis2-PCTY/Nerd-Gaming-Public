--[[
    ToDo:
    do stuff
]]

dxObjects = {}

dxGUI = class ( 'dxGUI' )

function dxGUI:destroy ( do_not_remove )
    local parent = self.parent
    if (not do_not_remove) then
        if parent then
            local idx = table.find(parent.children, self)
            if idx then
                table.remove(parent.children, idx)
            end
        end
    end
    
    local idx = table.find(dxObjects, self)
    if idx then
        table.remove(dxObjects, idx)
    end
end

function dxGUI:bringToFront ( )
    if self.parent then self.parent:bringToFront() return end

    local idx = table.find(dxObjects, self)
        if idx then
            for i, v in ipairs(self.children) do
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
			
            for i, v in ipairs(self.children) do
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
    if (not alpha) then return; end
    self.color[4] = alpha
end

function dxGUI:setColor ( r, g, b )
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
    if (not font) then return; end
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
    if not (x and y) then return; end
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
    if not (width and height) then return; end
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
    self.text = text or "";
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

function dxPrompt(message, ycallback, ncallback, include_edit)
    if not (message and type(ycallback) == "function") then return; end
    local screen_width, screen_height = GuiElement.getScreenSize();
    local width, height = 300, 200;
    local button_y = 160;
    local x, y = (screen_width - width) / 2, (screen_height - height) / 2;
    local window = dxWindow(x, y, width, height, "Confirmation");
    local label = dxText(10, 20, 280, 115, message, window);
        label:setAlignX("center");
        label:setAlignY("center");
        label:setWordbreak(true);
    local edit;
    if (include_edit) then edit = dxEditField(10, 120, 280, 30, "", window); end
    local y = dxButton(5, button_y, 137.5, 30, "Yes", window);
    local n = dxButton(152.5, button_y, 140, 30, "No", window);
        y:setColor(125, 0, 0);
        n:setColor(125, 0, 0);
    y.func = function(state)
        if (state ~= "up") then return; end
        ycallback(include_edit and edit.text or nil);
        window:destroy();
    end
    n.func = function(state)
        if (state ~= "up") then return; end
        if (ncallback) then ncallback(); end
        window:destroy();
    end
    return window;
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
        if (v.enabled) then
            local visible = v.visible;
            if (v.parent) then
                if (v.parent.type == "window") then visible = v.parent.visible and v.visible;
                elseif (v.parent.type == "tab") then visible = v.parent.panel.selected == v.parent.id and v.parent.panel.parent.visible and v.visible; end
            end
            if (visible) then
                if v.type == "button" then
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
                elseif (v.type == "combobox") then
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

function dxDrawBorder(x, y, width, height, color)
    color = color or tocolor(255, 255, 255, 255);
    dxDrawLine(x, y, x, y + height, color);
    dxDrawLine(x, y + height, x + width, y + height, color);
    dxDrawLine(x + width, y + height, x + width, y, color);
    dxDrawLine(x + width, y, x, y, color);
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

addEventHandler("onClientResourceStart", resourceRoot, function ()
     local win = dxWindow(10, 10, 250, 245, "Information", true, true)
     local win2 = dxWindow(500, 100, 500, 400, "window2", true)
     local but = dxButton(5, 190, 240, 50, "Press me. (Alt-Gr)", win)
     local but2 = dxButton(5, 190, 240, 50, "Press me. (Alt-Gr)", win2)
     local text = dxText (5, 25, 240, 160, longString:format(getPlayerName(localPlayer)), win)
     text:setAlignX("center")
     text:setAlignY("center")

     but:setColor(125, 0, 0)
     but2:setColor(125, 0, 0)
    
    but.func = function (state) if state == "down" then error("1") end end
     but2.func = function (state) if state == "down" then error("2") end end

    -- Combo Box Test
     c = dxComboBox:create(5, 60, 240, "Caption", win2);
     c:addItem("Test #1");
     c:addItem("Test #2", {255, 0, 0, 255});
     c:addItem("Test #3", {255, 255, 0, 255});

    -- Tabs test
     t = dxTabPanel:create(30, 40, 400, 300, win2);
     t:addTab("Title");
     tab2 = t:addTab("Title #2");
     debug(tostring(tab2), tostring(t));
     t:addTab("Title #3");
     local but2 = dxButton:create(30, 190, 240, 50, "My Name", tab2)
     but2:setColor(125, 0, 0)
     local t = dxTabPanel:create(10, 40, 250, 245,win2)
     ts = t:addTab("Test");
     ts2 = t:addTab("Test 2");
     ts2.color = {153, 153, 0, 255}
     local but = dxButton:create(5, 150, 240, 50, "Press me", ts)
     but:setColor(125, 0, 0)
     local but = dxButton:create(5, 100, 240, 50, "Press me", ts2)
     but:setColor(0, 0, 125)

end)

bindKey("ralt", "down", function () showCursor(not isCursorShowing()) end)