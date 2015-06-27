dxMovable = class ( 'dxWindow', nil )
dxMovable.elements = {}

function dxMovable:createMovable (w, h, b)
	if not (w and h) then return; end
	local self = setmetatable({
		renderTarget = dxCreateRenderTarget(w, h, b),
		posX = 0,
		posY = 0,
		w = w,
		h = h,
		cursorOffX = 0,
		cursorOffY = 0,
		alpha = 100,
		movable = true
	}, {
		__index = self
	})
	
	table.insert(dxMovable.elements, 1, self)
	
	return self;
end

function dxMovable:setMovable (bool)
	self.movable = bool
end

function dxMovable:destroy ()
	if isElement(self.renderTarget) then
		dxSetRenderTarget(self.renderTarget, true)
			-- Clear it.
		dxSetRenderTarget()
		
		destroyElement(self.renderTarget)
	end

	if table.find(dxMovable.elements, self) then 
		table.remove(dxMovable.elements, table.find(dxMovable.elements, self))
	end
end

function dxMovable:render ()
	if Cursor.active then
		local currElement = nil
		for i, v in ipairs(self.elements or {}) do
			if isCursorOverRectangle(v.posX, v.posY, v.w , v.h) then
				--error("YEAH")
				if v.movable then
					currElement = v
					break;
				end
			end
		end
		

		currElement = Cursor.currElement or currElement
		
		if currElement then
			if Cursor.currElement == currElement then
				currElement.alpha = 150
				currElement.posX, currElement.posY = Cursor.newX + currElement.cursorOffX, Cursor.newY + currElement.cursorOffY
			else
				if currElement.alpha == 150 then
					currElement.alpha = 100
				end
			end
			
			if not ((currElement.posX >= 0) and (currElement.posX <= (screenW - currElement.w)) and (currElement.posY >= 0) and (currElement.posY <= (screenH - currElement.h))) then
				dxDrawRectangle(currElement.posX - 10, currElement.posY - 10, currElement.w + 20, currElement.h + 20, tocolor(125, 0, 0, currElement.alpha))
			elseif not ((currElement.posX - 10 >= 0) and (currElement.posX + 10 <= (screenW - currElement.w)) and (currElement.posY - 10 >= 0) and (currElement.posY + 10 <= (screenH - currElement.h))) then
				dxDrawRectangle(currElement.posX - 10, currElement.posY - 10, currElement.w + 20, currElement.h + 20, tocolor(254, 138, 0, currElement.alpha))
			else
				dxDrawRectangle(currElement.posX - 10, currElement.posY - 10, currElement.w + 20, currElement.h + 20, tocolor(255, 255, 255, currElement.alpha))
			end
		end
	end
end