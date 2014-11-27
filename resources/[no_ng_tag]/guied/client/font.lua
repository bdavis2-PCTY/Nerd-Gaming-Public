--[[--------------------------------------------------
	GUI Editor
	client
	font.lua
	
	creates the font picker gui
--]]--------------------------------------------------


fontHeights = {
	["default-normal"] = 15,
	["default-small"] = 15,
	["default-bold-small"] = 15,
	["clear-normal"] = 15,
	["sa-header"] = 60,
	["sa-gothic"] = 75,
	
	["default"] = 15,
	["default-bold"] = 15,
	["clear"] = 15,
	["arial"] = 15,
	["sans"] = 15,
	["pricedown"] = 20,
	["bankgothic"] = 20,
	["diploma"] = 25,
	["beckett"] = 25,
}


FontPicker = {	
	width = 440,
	height = 280,
	
	refreshAll = 
		function()
			for _,picker in ipairs(FontPicker.instances) do
				picker:loadFonts()
			end
		end
}

FontPicker.__index = FontPicker
FontPicker.instances = {}


addEvent("guieditor:client_getFonts", true)
addEventHandler("guieditor:client_getFonts", root,
	function(files)
		if files then
			local sortable = {}
			
			for name,_ in pairs(files) do
				sortable[#sortable + 1] = name
			end
								
			table.sort(sortable)
					
			FontPicker.browserData = {files = files, sorted = sortable}
			
			for i,picker in ipairs(FontPicker.instances) do
				if guiGetVisible(picker.window) and picker.custom then
					if picker.custom.browser then
						picker.custom.browserGrid:setData(files, sortable)
					end
				end
			end
			
			if FontPicker.reloading then
				for _,picker in ipairs(FontPicker.instances) do
					if picker.custom then
						guiSetProperty(picker.custom.browser, "AlwaysOnTop", "False")
					end
				end				
			
				local m
				if #sortable > 0 then
					m = MessageBox_Info:create("Font Picker Refresh", "Font list successfully updated from the server.")
				else
					m = MessageBox_Info:create("Font Picker Refresh", "Could not get font list from the server.\n\nPlease check ACL permissions")				
				end
				
				guiSetProperty(m.window, "AlwaysOnTop", "True")
				
				m.onClose = 
					function()
						for _,picker in ipairs(FontPicker.instances) do
							if picker.custom then
								guiSetProperty(picker.custom.browser, "AlwaysOnTop", "True")
							end
						end						
					end
			else
				if #sortable == 0 then
					for _,picker in ipairs(FontPicker.instances) do
						if picker.custom then
							guiSetProperty(picker.custom.browser, "AlwaysOnTop", "False")
						end
					end						
				
					local m = MessageBox_Info:create("Font Picker Refresh", "Could not get font list from the server.\n\nPlease check ACL permissions")
					guiSetProperty(m.window, "AlwaysOnTop", "True")		

					m.onClose = 
						function()
							for _,picker in ipairs(FontPicker.instances) do
								if picker.custom then
									guiSetProperty(picker.custom.browser, "AlwaysOnTop", "True")
								end
							end						
						end					
				end
			end
		else
			if FontPicker.reloading then
				for _,picker in ipairs(FontPicker.instances) do
					if picker.custom then
						guiSetProperty(picker.custom.browser, "AlwaysOnTop", "False")
					end
				end	
				
				local m = MessageBox_Info:create("Font Picker Refresh", "Font list could not be updated from the server.\n\nTry again later.")
				guiSetProperty(m.window, "AlwaysOnTop", "True")
	
				m.onClose = 
					function()
						for _,picker in ipairs(FontPicker.instances) do
							if picker.custom then
								guiSetProperty(picker.custom.browser, "AlwaysOnTop", "True")
							end
						end						
					end
			end
		end
		
		FontPicker.reloading = nil
	end
)	



function FontPicker:open(element, dx)
	local wndMain = guiCreateWindow((gScreen.x - FontPicker.width) / 2, (gScreen.y - FontPicker.height) / 2, FontPicker.width, FontPicker.height, "Font Picker", false)
	guiWindowSetSizable(wndMain, false)
	guiSetProperty(wndMain, "AlwaysOnTop", "True")
	
	if not dx then
		if getElementData(element, "guieditor.internal:dxElement") then
			dx = true
		end
	end	
	
	local new = setmetatable(
		{
			window = wndMain,
			element = element,
			dx = dx,
		},
		FontPicker
	)
	
	FontPicker.instances[#FontPicker.instances + 1] = new
	
	guiWindowTitlebarButtonAdd(wndMain, "Close", "right", function() new:close() end)	
	guiWindowTitlebarButtonAdd(wndMain, "Custom Fonts", "left", function() new:showCustom() end)	
		
	local height = 10	
	
	if dx then
		for i,font in ipairs(gDXFonts) do
			height = height + 10
			
			local lbl = guiCreateLabel(10, height, FontPicker.width - 10, fontHeights[font], "", false, wndMain)	
			setElementData(lbl, "guieditor.internal:dxFontName", font)

			height = height + fontHeights[font]
			
			if i < #gDXFonts then
				divider(wndMain, 60, height + 5, FontPicker.width - 120, "444444")
			end
			
			addEventHandler("onClientGUIClick", lbl, 
				function(button, state)
					if button == "left" and state == "up" then
						new:close(getElementData(source, "guieditor.internal:dxFontName"))
					end
				end
			, false)			
		end	
	else
		for i,font in ipairs(gFonts) do
			height = height + 10
			
			local lbl = guiCreateLabel(10, height, FontPicker.width - 20, fontHeights[font], "Example text", false, wndMain)
			guiLabelSetHorizontalAlign(lbl, "center")
			guiLabelSetVerticalAlign(lbl, "center")
			guiSetFont(lbl, font)
			setRolloverColour(lbl, gColours.primary, gColours.defaultLabel)

			height = height + fontHeights[font]
			
			if i < #gFonts then
				divider(wndMain, 60, height + 5, FontPicker.width - 120, "444444")
			end
			
			addEventHandler("onClientGUIClick", lbl, 
				function(button, state)
					if button == "left" and state == "up" then
						new:close(guiGetFont(source))
					end
				end
			, false)
		end
	end
	
	doOnChildren(wndMain, setElementData, "guieditor.internal:noLoad", true)
	
	return new
end


function FontPicker:showCustom()
	if self.custom then
		self:hideCustom()
		return
	end

	self.custom = {}
	
	guiSetSize(self.window, FontPicker.width, FontPicker.height + 100, false)
	
	self.custom.dividerLeft, self.custom.dividerRight = divider(self.window, 20, FontPicker.height - 10, FontPicker.width - 40)
	
	self.baseWidth = FontPicker.width - 20
	self.custom.base = guiCreateLabel(10, FontPicker.height - 5, self.baseWidth, 100, "", false, self.window)
	
	self.custom.title = guiCreateLabel(0, 0, FontPicker.width - 20, 15, "Custom Fonts", false, self.custom.base)
	guiLabelSetHorizontalAlign(self.custom.title, "center")
	guiLabelSetVerticalAlign(self.custom.title, "top")
	guiSetFont(self.custom.title, "default-bold-small")
		
	self.custom.lblFilepath = guiCreateLabel(0, 20, 50, 20, "Filepath:", false, self.custom.base)	
	
	self.custom.edtInput = guiCreateEdit(50, 19, self.baseWidth - 50 - 100, 20, gFilepathPrefix .. "fonts/PetitFormalScript.ttf", false, self.custom.base)
	setElementData(self.custom.edtInput, "guieditor:filter", gFilters.noSpace)
	
	self.custom.lblResult = guiCreateLabel(50, 40, self.baseWidth - 50, 20, "", false, self.custom.base)
	guiSetColour(self.custom.lblResult, unpack(gColours.secondary))
	
	self.custom.btnLoad = guiCreateButton(self.baseWidth - 10 - 90, 19, 70, 20, "Load", false, self.custom.base)
	
	self.custom.imgOpenBrowser = guiCreateStaticImage(self.baseWidth - 20, 21, 16, 16, "images/plus.png", false, self.custom.base)
	guiSetColour(self.custom.imgOpenBrowser, 200, 200, 200, 200)
	setRolloverColour(self.custom.imgOpenBrowser, {255, 255, 255, 255}, {200, 200, 200, 200})
	
	self.custom.browser = guiCreateWindow((gScreen.x - 250) / 2, (gScreen.y - 300) / 2, 250, 300, "Fonts", false)
	guiWindowSetMovable(self.custom.browser, false)
	guiWindowSetSizable(self.custom.browser, false)
	guiWindowTitlebarButtonAdd(self.custom.browser, "Close", "right", 
		function() 
			guiSetVisible(self.custom.browser, false) 
			guiSetProperty(self.window, "AlwaysOnTop", "True")
		end
	)	
	
	guiWindowTitlebarButtonAdd(self.custom.browser, "Select", "left", 
		function() 
			if self.current then
				if self.current.row then
					self.custom.browserGrid.onRowDoubleClick(self.current.row, self.current.col, self.current.text, self.current.resource)
				else
					self.custom.browserGrid.onRowDoubleClick(nil, nil, nil, self.current.resource)
				end
			end
		end
	)	
	
	guiWindowTitlebarButtonAdd(self.custom.browser, "Reload", "left", 
		function() 
			if not FontPicker.reloading then
				FontPicker.reloading = true
				
				triggerServerEvent("guieditor:server_getFonts", localPlayer)
			end
		end
	)		
	
	self.custom.browserGrid = ExpandingGridList:create(5, 20, 240, 220, false, self.custom.browser)
	self.custom.browserGrid:addColumn("Resource fonts")
	guiGridListAddRow(self.custom.browserGrid.gridlist)
	guiGridListSetItemText(self.custom.browserGrid.gridlist, 0, 1, "Loading...", true, false)
	
	self.custom.browserGrid.onRowClick = 
		function(row, col, text, resource)
			self.current = nil
			
			if fileExists(":" .. resource .. "/" .. text) then
				self.current = {
					row = row,
					col = col,
					text = text,
					resource = resource
				}
			else
				self.current = {
					resource = resource
				}
			end
		end	
		
	self.custom.browserGrid.onHeaderClick = 
		function()
			self.current = nil
		end
	
	self.custom.browserGrid.onRowDoubleClick = 
		function(row, col, text, resource)
			if row and col and resource and text and fileExists(":" .. resource .. "/" .. text) then
				guiSetVisible(self.custom.browser, false) 
				guiSetProperty(self.window, "AlwaysOnTop", "True")		

				guiSetText(self.custom.edtInput, ":" .. resource .. "/" .. text)
			else
				guiSetText(self.custom.browserWarning, "Please start the resource\n'"..resource.."'\nto use this font")
			end
		end
	
	self.custom.browserWarning = guiCreateLabel(5, 240, 240, 60, "", false, self.custom.browser)
	guiLabelSetHorizontalAlign(self.custom.browserWarning, "center")
	guiLabelSetVerticalAlign(self.custom.browserWarning, "center")
	guiSetFont(self.custom.browserWarning, "default-bold-small")
	guiSetColour(self.custom.browserWarning, unpack(gColours.primary))

	guiSetVisible(self.custom.browser, false)
	
	addEventHandler("onClientGUIClick", self.custom.imgOpenBrowser, 
		function(button, state)
			if button == "left" and state == "up" then
				guiSetProperty(self.window, "AlwaysOnTop", "False")
				
				guiSetVisible(self.custom.browser, true)
				guiBringToFront(self.custom.browser)
				guiSetProperty(self.custom.browser, "AlwaysOnTop", "True")
					
				guiSetText(self.custom.browserWarning, "")	
					
				if not FontPicker.browserData then
					triggerServerEvent("guieditor:server_getFonts", localPlayer)
				else
					self.custom.browserGrid:setData(FontPicker.browserData.files, FontPicker.browserData.sorted)
				end
			end
		end
	, false)	
	
	addEventHandler("onClientGUIClick", self.custom.btnLoad, 
		function(button, state)
			if button == "left" and state == "up" then
				local fontName = string.reverse(guiGetText(self.custom.edtInput))
				
				local s = fontName:find("\\", 0, true) or fontName:find("/", 0, true)
				
				if s then
					fontName = fontName:sub(0, s - 1)
				end
				
				fontName = string.reverse(fontName)
				
				local f = guiCreateFont(guiGetText(self.custom.edtInput), 10)
				
				if f then
					guiSetText(self.custom.lblResult, "Successfully loaded font '" .. fontName .. "'")
					
					local found = false
					
					for _,data in pairs(gCustomFonts) do
						if data.name == fontName then
							found = true
							break
						end
					end
					
					if not found then
						gCustomFonts[f] = {name = fontName, path = guiGetText(self.custom.edtInput)}
						FontPicker.refreshAll()
					end
				else
					guiSetText(self.custom.lblResult, "Failed to load font '" .. fontName .. "' - invalid file path.")
				end
			end
		end
	, false)
	
	self.custom.scroller = guiCreateScrollPane(0, 60, self.baseWidth, 40, false, self.custom.base)
	guiSetProperty(self.custom.scroller, "ClippedByParent", "False")
	
	self.custom.fonts = {}
	
	self:loadFonts()
end


function FontPicker:hideCustom()
	if not self.custom then
		return
	end	
	
	if self.custom.fonts then
		for _,item in ipairs(self.custom.fonts) do
			if item.lblInfo then
				destroyElement(item.lblInfo)
				destroyElement(item.lblExample)
			end
		end	
	end	
	
	self.custom.fonts = nil

	destroyElement(self.custom.base)
	destroyElement(self.custom.browser)
	
	guiSetSize(self.window, FontPicker.width, FontPicker.height, false)
	
	FontPicker.reloading = nil
	
	self.custom = nil
end


function FontPicker:loadFonts()
	if not self.custom then
		return
	end
	
	local y = 0
	local count = 0
	
	for _,item in ipairs(self.custom.fonts) do
		if item.lblInfo then
			destroyElement(item.lblInfo)
			destroyElement(item.lblExample)
		end
	end
	
	self.custom.fonts = {}
	
	for font, data in pairs(gCustomFonts) do
		self.custom.fonts[#self.custom.fonts + 1] = {}
		
		self.custom.fonts[#self.custom.fonts].lblInfo = guiCreateLabel(10, y, self.baseWidth - 10, 15, "Loaded custom font: " .. data.name, false, self.custom.scroller)
		guiLabelSetHorizontalAlign(self.custom.fonts[#self.custom.fonts].lblInfo, "left")
		guiLabelSetVerticalAlign(self.custom.fonts[#self.custom.fonts].lblInfo, "top")
		setRolloverColour(self.custom.fonts[#self.custom.fonts].lblInfo, gColours.primary, gColours.defaultLabel)
		
		self.custom.fonts[#self.custom.fonts].lblExample = guiCreateLabel(10, y + 15, self.baseWidth - 10, 25, "Example text", false, self.custom.scroller)
		guiSetFont(self.custom.fonts[#self.custom.fonts].lblExample, font)
		
		addEventHandler("onClientGUIClick", self.custom.fonts[#self.custom.fonts].lblInfo,
			function(button, state)
				if button == "left" and state == "up" then
					self:close(font, data.path)
				end
			end
		, false)
		
		y = y + 40
		count = count + 1
		
		local w = guiGetSize(self.custom.scroller, false)
		
		if count == 2 then
			guiSetSize(self.window, FontPicker.width, FontPicker.height + 100 + 40, false)
			guiSetSize(self.custom.scroller, w, 80, false)
		elseif count == 3 then
			guiSetSize(self.window, FontPicker.width, FontPicker.height + 100 + 80, false)
			guiSetSize(self.custom.scroller, w, 120, false)
		--elseif count == 4 then
		--	guiSetSize(self.window, FontPicker.width, FontPicker.height + 100 + 105, false)
		--	guiSetSize(self.custom.scroller, w, 140, false)
		end
	end
end


function FontPicker:close(picked, path)
	if self.onClose then
		self.onClose(picked)
	end
	
	if self.element and picked then
		local action = {}
		action[#action + 1] = {}
		
		if self.dx then
			if getElementData(self.element, "guieditor.internal:dxElement") then
				local dx = DX_Element.ids[getElementData(self.element, "guieditor.internal:dxElement")]
				
				if dx.dxType then
					action[#action + 1] = {}
					action[#action].ufunc = DX_Text.font
					action[#action].uvalues = {dx, dx.font_}
					action[#action].rfunc = DX_Text.font
					action[#action].rvalues = {dx, picked}		
					
					action.description = "Set ".. DX_Element.getTypeFriendly(dx.dxType) .." font"

					if path then
						local f = dxCreateFont(path)
						
						if f then
							dx:font(f, path)
							action[#action].rvalues = {dx, f}		
						end
					else
						dx:font(picked)
					end
					
					UndoRedo.add(action)	
				end		
			end
		else
			action[#action].ufunc = guiSetFont
			action[#action].uvalues = {self.element, guiGetFont(self.element)}
			action[#action].rfunc = guiSetFont
			action[#action].rvalues = {self.element, picked}
			
			action.description = "Set "..stripGUIPrefix(getElementType(self.element)).." font"
			UndoRedo.add(action)
			
			guiSetFont(self.element, picked)
			
			setElementData(self.element, "guieditor:font", path)
		end
	end
	
	if self.custom then
		destroyElement(self.custom.base)
		destroyElement(self.custom.browser)
	end	
	
	destroyElement(self.window)
	
	for i,picker in ipairs(FontPicker.instances) do
		if self == picker then
			table.remove(FontPicker.instances, i)
			break
		end
	end
	
	self = nil
end



addEventHandler("onClientRender", root,
	function()
		if not gEnabled then
			return
		end
	
		local mX,mY = getCursorPosition(true)
		
		for _,picker in ipairs(FontPicker.instances) do
			if picker.dx then
				local x, y = guiGetPosition(picker.window, false)
				local w, h = guiGetSize(picker.window, false)
				local height = 10
				
				local inside = (mX > x and mX < (x + w) and mY > y and mY < (y + h))
				
				for i,font in ipairs(gDXFonts) do
					height = height + 10
					
					local insideSection = inside and (mY > (y + height) and mY < (y + height + fontHeights[font]))
					
					dxDrawText("Example text "..tostring(font), x + 10, y + height, (x + w) - 10, y + height + fontHeights[font],insideSection and tocolor(unpack(gColours.primary)) or tocolor(255, 255, 255, 255), 1, font, "center", "center", true, false, true)

					height = height + fontHeights[font]
				end				
			end
		end	
	end
)