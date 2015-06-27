Cursor = {}

function Cursor:constructor ()
	showCursor(true)

	self.currX   = -500;
	self.currY   = -500; 
	self.newX    = -500;
	self.newY    = -500; 
	self.offX    = 0;
	self.offX    = 0; 
	self.bound   = self.bound or false;
	self.pressed = false;
	self.currElement = nil;
	self.active  = true;
	
	self.renderFunc      = self.renderFunc or bind(self.render, self);
	self.onCursoMoveFunc = self.onCursoMoveFunc or bind(self.onCursoMove, self);
	addEventHandler("onClientRender", root, self.renderFunc)
	
	self.keyFunction = function (_, state)
	if isCursorShowing() then
		if state == "down" then
				self.pressed           = true;
				self.currX, self.currY = getCursorPosition();
				self.currX, self.currY = self.currX * screenW, self.currY * screenH;
				self.newX, self.newY   = self.currX, self.currY;
		
				for i, v in ipairs(dxMovable.elements or {}) do
					if isCursorOverRectangle(v.posX, v.posY, v.w, v.h) then
						if v.movable then
							v.cursorOffX, v.cursorOffY = v.posX - self.currX, v.posY - self.currY
							self.currElement = v
							break;
						end
					end
				end
					
				addEventHandler("onClientCursorMove", root, self.onCursoMoveFunc)
			else
				self.pressed = false;
				self.currElement = nil;
				
				if getCursorAlpha() == 0 then
					setCursorAlpha(255)
				end
					
				removeEventHandler("onClientCursorMove", root, self.onCursoMoveFunc)
			end
		end
	end
	
	if not self.bound then
		self.bound = true
		bindKey("mouse1", "both", self.keyFunction)
	end
end

function Cursor:onCursoMove (cX, cY)
	Cursor.newX, Cursor.newY = cX * screenW, cY * screenH
end

function Cursor:render ()
	if isCursorShowing() then
		self.offX, self.offY = self.newX - self.currX, self.newY - self.currY
		
		if DEBUG then
			dxDrawLine(self.currX, self.currY, self.currX + self.offX, self.newY - self.offY, tocolor(125, 0, 0, 255), 3) -- offX
			dxDrawText(("%s"):format(self.offX), self.currX, self.currY, self.currX + self.offX, self.newY - self.offY, tocolor(125, 0, 0, 255), 1.00, "default-bold", "center", "bottom")
			dxDrawLine(self.newX, self.newY, self.newX, self.newY - self.offY, tocolor(0, 0, 125, 255), 3) -- offY
			dxDrawText(("%s"):format(self.offY), self.newX + 60, self.currY, self.newX + 60, self.newY, tocolor(0, 0, 125, 255), 1.00, "default-bold", "center", "center")
			dxDrawLine(self.currX, self.currY, self.newX, self.newY, tocolor(0, 125, 0, 255), 3) -- Mouse movement
			dxDrawText(("%s"):format(math.sqrt(self.offX^2 + self.offY^2)), self.currX + 70, self.currY, self.newX + 70, self.newY , tocolor(0, 125, 0, 255), 1.00, "default-bold", "center", "center")
				
			if self.offY < 0 then
				dxDrawText(("(%s, %s)"):format(self.currX, self.currY), self.currX, self.currY + 20, self.currX, self.currY + 20, tocolor(255, 254, 254, 138), 1.00, "default-bold", "center", "bottom")
				dxDrawText(("(%s, %s)"):format(self.newX, self.newY), self.newX, self.newY - 5, self.newX, self.newY - 5, tocolor(255, 254, 254, 138), 1.00, "default-bold", "center", "bottom")
			else
				dxDrawText(("(%s, %s)"):format(self.currX, self.currY), self.currX, self.currY - 5, self.currX, self.currY - 5, tocolor(255, 254, 254, 138), 1.00, "default-bold", "center", "bottom")
				dxDrawText(("(%s, %s)"):format(self.newX, self.newY), self.newX, self.newY + 20, self.newX, self.newY + 20, tocolor(255, 254, 254, 138), 1.00, "default-bold", "center", "bottom")
			end
		end

		dxDrawText(("offX: %s, offY: %s"):format(self.offX, self.offY), screenW/2, 881, screenW/2, 900, tocolor(255, 254, 254, 138), 1.00, "default", "center", "bottom", false, false, false, false, false)
	end
end

function Cursor:destructor ()
	for i, v in ipairs(dxMovable.elements) do
		if not ((v.posX >= 0) and (v.posX <= (screenW - v.w)) and (v.posY >= 0) and (v.posY <= (screenH - v.h))) then
			error("[dxMovable] Some Elements collide with the Screenborder!")
		end
	end

		showCursor(false)

		removeEventHandler("onClientRender", root, self.renderFunc)
		removeEventHandler("onClientCursorMove", root, self.onCursoMoveFunc)
		
		self.active  = false;
end

bindKey("F2", "down", function ()
	if isCursorShowing() and Cursor.active then
		Cursor:destructor()
	else
		Cursor:constructor()
	end
end)