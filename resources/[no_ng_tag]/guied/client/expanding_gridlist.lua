--[[--------------------------------------------------
	GUI Editor
	client
	expanding_gridlist.lua
	
	a gridlist that has collapsible/expandable header items
--]]--------------------------------------------------


ExpandingGridList = {
	parentExpandedPrefix = "- ",
	parentCollapsedPrefix = "+ ",
	childPrefix = "      "
}

ExpandingGridList.__index = ExpandingGridList


function ExpandingGridList:create(x, y, w, h, relative, parent)
	local gridlist = guiCreateGridList(x, y, w, h, relative, parent)
	guiGridListSetSortingEnabled(gridlist, false)

	local new = setmetatable(
		{
			x = x,
			y = y,
			w = w,
			h = h,
			parent = parent,
			gridlist = gridlist,
		},
		ExpandingGridList
	)
	
	addEventHandler("onClientGUIDoubleClick", gridlist,
		function(button, state)
			if button == "left" and state == "up" then
				local row, col = guiGridListGetSelectedItem(source)
				
				if row and col and row ~= -1 and col ~= -1 then
					ExpandingGridList.doubleClickRowHandler(new, row, col)
				end
			end
		end
	, false)
	
	addEventHandler("onClientGUIClick", gridlist,
		function(button, state)
			if button == "left" and state == "up" then
				local row, col = guiGridListGetSelectedItem(source)
				
				if row and col and row ~= -1 and col ~= -1 then
					ExpandingGridList.clickRowHandler(new, row, col)
				end
			end
		end
	, false)
	
	doOnChildren(gridlist, setElementData, "guieditor.internal:noLoad", true)
	
	return new
end


function ExpandingGridList:addColumn(colName)
	guiGridListAddColumn(self.gridlist, colName, 2)
end


function ExpandingGridList:open()
	guiSetVisible(self.gridlist, true)
end


function ExpandingGridList:close()
	if self.expanded then
		self:collapseRow(self.expanded.row, self.expanded.col)
	end
	
	guiSetVisible(self.gridlist, false)
end


function ExpandingGridList:setData(data, sortedData, autoExpand)
	self.data = data
	
	self:populate(data, sortedData)
	
	if autoExpand then
		for i = 1, guiGridListGetRowCount(self.gridlist) do
			local text = guiGridListGetItemText(self.gridlist, i, 1)
			text = tostring(text):sub(#ExpandingGridList.parentCollapsedPrefix + 1)
			
			if text == autoExpand then
				self:expandRow(i, 1)
				break
			end
		end
	end
end


function ExpandingGridList:populate(data, sortedData)
	guiGridListClear(self.gridlist)
	
	self.expanded = nil
	
	if sortedData then
		for _,text in ipairs(sortedData) do
			local row = guiGridListAddRow(self.gridlist)

			guiGridListSetItemText(self.gridlist, row, 1, ExpandingGridList.parentCollapsedPrefix .. text, false, false)
		end
	else
		for text,_ in pairs(data) do
			local row = guiGridListAddRow(self.gridlist)
			
			guiGridListSetItemText(self.gridlist, row, 1, ExpandingGridList.parentCollapsedPrefix .. (text.text or text), false, false)
		end	
	end
end


function ExpandingGridList:doubleClickRowHandler(row, col)
	local text = guiGridListGetItemText(self.gridlist, row, col)
	text = tostring(text):sub(#ExpandingGridList.parentExpandedPrefix + 1)
	
	if self.data then
		if self.data[text] then
			self:expandRow(row, col)
		else
			self:doubleClickRow(row, col)
		end
	end
end


function ExpandingGridList:clickRowHandler(row, col)
	local text = guiGridListGetItemText(self.gridlist, row, col)
	text = tostring(text):sub(#ExpandingGridList.parentExpandedPrefix + 1)
	
	if self.data then
		if self.data[text] then
			self:clickHeader(row, col)
		else
			self:clickRow(row, col)
		end
	end
end


function ExpandingGridList:expandRow(row, col)
	if self.expanded then
		local same = self.expanded.row == row
		
		if (self.expanded.row < row) then
			local text = guiGridListGetItemText(self.gridlist, self.expanded.row, self.expanded.col)
			text = tostring(text):sub(3)

			row = row - #self.data[text]
		end		
		
		self:collapseRow(self.expanded.row, self.expanded.col)
		
		if same then
			return
		end
	end
	
	local text = guiGridListGetItemText(self.gridlist, row, col)
	text = tostring(text):sub(#ExpandingGridList.parentExpandedPrefix + 1)
	
	guiGridListSetItemText(self.gridlist, row, col, ExpandingGridList.parentExpandedPrefix .. text, false, false)
	
	self.expanded = {row = row, col = col}
	
	if not self.data then
		return
	end	
	
	for i,data in ipairs(self.data[text]) do
		guiGridListInsertRowAfter(self.gridlist, row + (i - 1))
		
		guiGridListSetItemText(self.gridlist, row + i, col, ExpandingGridList.childPrefix .. (type(data) == "string" and data or tostring(data.text)), false, false)
		guiGridListSetItemData(self.gridlist, row + i, col, data)
	end
	
	if self.onRowExpand then
		self.onRowExpand(row, col, text, self.onRowExpandArgs and unpack(self.onRowExpandArgs) or {})
	end
end


function ExpandingGridList:collapseRow(row, col)
	if not self.expanded then
		return
	end
	
	local text = guiGridListGetItemText(self.gridlist, row, col)
	text = tostring(text):sub(#ExpandingGridList.parentCollapsedPrefix + 1)
	
	guiGridListSetItemText(self.gridlist, row, col, ExpandingGridList.parentCollapsedPrefix .. text, false, false)
	
	self.expanded = nil
	
	if not self.data then
		return
	end		
	
	for i = #self.data[text], 1, -1 do
		guiGridListRemoveRow(self.gridlist, row + i)
	end		
	
	if self.onRowCollapse then
		self.onRowCollapse(row, col, text, self.onRowCollapseArgs and unpack(self.onRowCollapseArgs) or {})
	end
end


function ExpandingGridList:doubleClickRow(row, col)
	local text = guiGridListGetItemText(self.gridlist, row, col)
	text = tostring(text):sub(#ExpandingGridList.childPrefix + 1)
	
	local resource
	
	if self.expanded then
		resource = guiGridListGetItemText(self.gridlist, self.expanded.row, self.expanded.col)
		resource = tostring(resource):sub(#ExpandingGridList.parentExpandedPrefix + 1)	
	end

	local data = guiGridListGetItemData(self.gridlist, row, col)
	
	if self.onRowDoubleClick then
		self.onRowDoubleClick(row, col, text, resource, data, self.onRowDoubleClickArgs and unpack(self.onRowDoubleClickArgs) or {})
	end
end


function ExpandingGridList:clickRow(row, col)
	local text = guiGridListGetItemText(self.gridlist, row, col)
	text = tostring(text):sub(#ExpandingGridList.childPrefix + 1)
	
	local resource
	
	if self.expanded then
		resource = guiGridListGetItemText(self.gridlist, self.expanded.row, self.expanded.col)
		resource = tostring(resource):sub(#ExpandingGridList.parentExpandedPrefix + 1)	
	end
	
	local data = guiGridListGetItemData(self.gridlist, row, col)

	if self.onRowClick then
		self.onRowClick(row, col, text, resource, data, self.onRowClickArgs and unpack(self.onRowClickArgs) or {})
	end
end


function ExpandingGridList:clickHeader(row, col)
	local text = guiGridListGetItemText(self.gridlist, row, col)
	text = tostring(text):sub(#ExpandingGridList.parentCollapsedPrefix + 1)
	
	if self.onHeaderClick then
		self.onHeaderClick(row, col, text, self.onHeaderClickArgs and unpack(self.onHeaderClickArgs) or {})
	end
end