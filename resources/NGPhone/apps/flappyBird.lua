flappy		= false;
function appFunctions.flappy:onPageOpen ( )
	if(flappy) then
		flappyBirdGame:Destructor();
	else
		flappyBirdGame	= FlappyBirdGame:New();
	end
	flappy = not(flappy)
end


local cFunc = {};
local cSetting = {};

Flappy = {};
Flappy.__index = Flappy;

function Flappy:New(...)
	local obj = setmetatable({}, {__index = self});
	if obj.Constructor then
		obj:Constructor(...);
	end
	return obj;
end

function Flappy:Calculate()
	if(self.ready == true) then
		if(getTickCount()-self.startTick >= 1000) then
			self.startTick = getTickCount()
			self.FPS = self.tempFPS;
			self.tempFPS = 0;
		else
			self.tempFPS = self.tempFPS+1;
		end
	
		self.sy		= self.sy-self.velocityY

		self.velocityY	= self.velocityY-0.5/self.FPS*60
		
		if(self.velocityY < 1) then
			local rotAdd = (5/self.velocityY);

			if(rotAdd <= 0 or rotAdd > 1) then
				rotAdd = 2;
			end

			self.rotation = self.rotation+rotAdd;
		end

		if(self.rotation > 90) then
			self.rotation = 90;
		end

		if(self.sy >= (self.iSY-93)-self.sizeY) then
			self.sy = (self.iSY-93)-self.sizeY;

			self:Die("yes");
		end

		if(self.sy < -self.sizeY) then
			self.sy = -self.sizeY;
		end
	end
end

function Flappy:Die(uWat)
	if(self.dead == false) then

		self.dead = true;
		flappyBirdGame.moving = false;
		flappyBirdGame.flappyUI.deadmenuEnabled = true;

		Sound:New("audio/flappy_bird/sfx_hit.ogg");
		if not(uWat) then
			setTimer(function() Sound:New("audio/flappy_bird/sfx_die.ogg") end, 350, 1)
		end
	end
end

function Flappy:Reset()
	self.sx			= (self.iSX/2)-self.sizeX/2;
	self.sy			= (self.iSY/2)-self.sizeY/2;

	self.rotation	= 0;

	self.velocityY	= 0;

	self.dead		= false;
	self.ready 		= false;
end

function Flappy:IsBetweenX(gX)
	if((self.sx+self.sizeX) > gX) and (gX+self.sizeX > self.sx+self.sizeX-52) then
		return true
	end
	return false;
end

function Flappy:AddCoin()
	Sound:New("audio/flappy_bird/sfx_point.ogg")
	
	flappyBirdGame.flappyUI.score = flappyBirdGame.flappyUI.score+1;
	
	if(flappyBirdGame.flappyUI.score > bestScore) then
		bestScore = flappyBirdGame.flappyUI.score;
	end
end

function Flappy:CheckCoinAdd()
	if(getTickCount()-self.coinTick > 1000 and self.dead ~= true) then
		self.coinTick = getTickCount();
		self:AddCoin();
	end
end

function Flappy:IsInRoehre(gX, iY1, iY2, checkPoint)
	if(checkPoint) then
		if(self:IsBetweenX(gX)) then
			self:CheckCoinAdd()
		end
	else
		if(self:IsBetweenX(gX)) and ((iY1-self.sizeY < self.sy) or ((iY2+320) > self.sy))then
			return true;
		end
	end
	return false;
end

function Flappy:ClickFlappy( x, y)
	if(self.dead ~= true) then
		self.velocityY	= 7
		self.rotation 	= -30;

		if(self.ready == false) then
			self.ready = not(self.ready)
			flappyBirdGame.flappyUI.startmenuAEnabled = false;
		end

		Sound:New("audio/flappy_bird/sfx_wing.ogg");
	else
		flappyBirdGame:Reset();
	end
end

function Flappy:Constructor(iSX, iSY)
	self.iSX		= iSX;
	self.iSY		= iSY;
	self.sizeX		= 34;
	self.sizeY		= 34;
	self.sx			= (iSX/2)-self.sizeX/2;
	self.sy			= (iSY/2)-self.sizeY/2;
	self.doCoinStart = false;
	self.lastY		= 0;
	self.rotation	= 0;
	self.velocityY	= 0;
	self.FPS		= 60;
	self.startTick = getTickCount();
	self.tempFPS	= 60;
	self.ready		= false;
	self.dead		= false;
	self.coinTick	= getTickCount();
	self.readyAlpha	= 255;
	self.clickFlappyFunc	= function(...) self:ClickFlappy(...) end;
	bindKey("mouse1", "down", self.clickFlappyFunc)
end

FlappyBirdGame = {};
FlappyBirdGame.__index = FlappyBirdGame;

function FlappyBirdGame:New(...)
	local obj = setmetatable({}, {__index = self});
	if obj.Constructor then
		obj:Constructor(...);
	end
	return obj;
end


function FlappyBirdGame:CreateNewTube()
	for i = 1, 2, 1 do
		local gX				= self.sx+self.gX;
		local randTubeLength	= math.random(100, 250)
		local obenTube 			= Tube:New(true, gX, randTubeLength*1.25)
		local untenTube 		= Tube:New(false, gX, randTubeLength)
		self.tubes[gX] = {obenTube, untenTube};
		setTimer(function()
			table.remove(self.tubes, gX)
		end, 3000, 1)
	end
end

function FlappyBirdGame:Render()
	dxSetRenderTarget(self.renderTarget, true);
	local iTimeDone	= getTickCount()-self.startTick
	if(self.background == 1) then
		dxDrawImageSection(0, 0, self.sx, self.sy, 0, 0, self.sx, self.sy, self.imageTexture)
	else
		dxDrawImageSection(0, 0, self.sx, self.sy, 292, 0, self.sx, self.sy, self.imageTexture)
	end
	for gX, tubePaar in pairs(self.tubes) do
		local untenTube, obenTube	= tubePaar[1], tubePaar[2];
		self.lastX	= gX-self.gX;
		local iY1, iY2 = self.sy-untenTube.iLength, 0-obenTube.iLength;
		dxDrawImageSection(gX-self.gX, self.sy-untenTube.iLength, untenTube.sizeX, untenTube.sizeY, untenTube.u, untenTube.v, untenTube.w, untenTube.h, self.imageTexture)
		dxDrawImageSection(gX-self.gX, 0-obenTube.iLength, obenTube.sizeX, obenTube.sizeY, obenTube.u, obenTube.v, obenTube.w, obenTube.h, self.imageTexture)
		if(self.flappy:IsInRoehre(gX-self.gX, iY1, iY2)) then
			self.flappy:Die()
		end
		self.flappy:IsInRoehre(self.lastX, nil, nil, true)
	end
	for i = 0, 1, 1 do
		dxDrawImageSection(((self.sx*i)-iTimeDone/10)-i, self.sy-93, 336, 93, 584, 0, 336, 93, self.imageTexture)
	end

	if(self.moving == true) then
		self.gX	= ((getTickCount()-self.defaultStartTick)/10)
	end
	if(self.flappyUI.startmenuAEnabled ~= true) then
		-- draw bird
		dxDrawImageSection(self.flappy.sx, self.flappy.sy, self.flappy.sizeX, self.flappy.sizeY, 230, 757, self.flappy.sizeX, self.flappy.sizeY, self.imageTexture, self.flappy.rotation)
	end
	if(iTimeDone >= 2880 or self.moving == false) then
		self.startTick = getTickCount();
	end
	self.flappyUI:RenderStartMenu();
	if(self.flappy.dead == true) then
		self.flappyUI:RenderDeadMenu();
	else
		self.flappyUI:RenderScore();
	end
	dxSetRenderTarget(nil);
	
	local x, y = guiGetPosition ( base, false )
	--dxDrawImage((self.aesx/2)-(self.sx/2), (self.aesy/2)-(self.sy/2), self.sx, self.sy, self.renderTarget);
	dxDrawImage(x+43, y+92, 262, 422, self.renderTarget, 0, 0, 0, tocolor ( 255, 255, 255, 255 ), true );
	self.flappy:Calculate();
	if(getTickCount()-self.tubeTick > 2000) then
		if(self.moving == true and self.flappy.ready == true) then
			self:CreateNewTube();
		end
		self.tubeTick = getTickCount();
	end
end

function FlappyBirdGame:Reset()
	self.flappy:Reset();
	self.flappyUI:Reset()
	self.startTick		= getTickCount();
	self.tubeTick		= getTickCount();
	self.defaultStartTick = getTickCount();
	self.tubes			= {}
	self.gX				= 0;
	self.moving 		= true;
end

function FlappyBirdGame:Constructor(...)
	self.sx, self.sy	= 288, 512;
	self.aesx, self.aesy = guiGetScreenSize();
	self.gX				= 0;
	self.renderTarget	= dxCreateRenderTarget(self.sx, self.sy, false)
	self.imageTexture	= dxCreateTexture("images/flappyBird.png", "argb", true, "clamp" );
	self.flappy			= Flappy:New(self.sx, self.sy);
	self.flappyUI		= FlappyUI:New(self.sx, self.sy, self.imageTexture);
	self.startTick		= getTickCount();
	self.tubeTick		= getTickCount();
	self.background		= math.random(1, 2);
	self.defaultStartTick = getTickCount();
	self.tubes			= {}
	self.moving			= true;
	self.renderFunc		= function(...) self:Render(...) end;
	addEventHandler("onClientRender", getRootElement(), self.renderFunc)
end

function FlappyBirdGame:Destructor()
	removeEventHandler("onClientRender", getRootElement(), self.renderFunc)
	destroyElement(self.renderTarget)
	destroyElement(self.imageTexture);
	unbindKey("mouse1", "down", self.flappy.clickFlappyFunc)
	self = nil;
end


FlappyUI = {};
FlappyUI.__index = FlappyUI;
bestScore			= 0;

function FlappyUI:New(...)
	local obj = setmetatable({}, {__index = self});
	if obj.Constructor then
		obj:Constructor(...);
	end
	return obj;
end

function FlappyUI:RenderStartMenu()
	if(self.startmenuEnabled ~= false) then
		local u, v, w, h = 587, 115, 191, 55;
		dxDrawImageSection((self.iSX/2)-w/2, ((self.iSY/2)+h/2)-170, w, h, u, v, w, h, self.imageTexture, 0, 0, 0, tocolor(255, 255, 255, self.startmenuAlpha))
		u, v, w, h = 583, 179, 114, 104;
		dxDrawImageSection((self.iSX/2)-w/2, ((self.iSY/2)+h/2)-120, w, h, u, v, w, h, self.imageTexture, 0, 0, 0, tocolor(255, 255, 255, self.startmenuAlpha))
		if(self.startmenuAEnabled == false) then
			if(self.startmenuAlpha > 10) then
				self.startmenuAlpha = self.startmenuAlpha-10
			else
				self.startmenuEnabled = false;
			end
		end
	end
end

function FlappyUI:RenderDeadMenu()
	if(self.deadmenuEnabled == true) then
		local u, v, w, h = 788, 116, 196, 53
		dxDrawImageSection((self.iSX/2)-w/2, ((self.iSY/2)+h/2)-180, w, h, u, v, w, h, self.imageTexture, 0, 0, 0, tocolor(255, 255, 255, self.deadmenuAlpha))
		u, v, w, h = 6, 518, 226, 114
		dxDrawImageSection((self.iSX/2)-w/2, ((self.iSY/2)+h/2)-130, w, h, u, v, w, h, self.imageTexture, 0, 0, 0, tocolor(255, 255, 255, self.deadmenuAlpha))
		dxDrawText(self.score, (self.iSX/2)+135, ((self.iSY/2)+50/2)+115, 150, 50, tocolor(0, 0, 0, self.renderScoreAlpha), 1, "pricedown", "center", "center")
		dxDrawText(bestScore, (self.iSX/2)+135, ((self.iSY/2)+50/2)+210, 150, 50, tocolor(0, 0, 0, self.renderScoreAlpha), 1, "pricedown", "center", "center")
		if(self.deadmenuAlpha < 240) then
			self.deadmenuAlpha = self.deadmenuAlpha+10;
		end
	end
end

function FlappyUI:RenderScore()
	if(self.renderScore == true) then
		local u, v, w, h = 788, 116, 196, 53
		dxDrawText(self.score, (self.iSX/2)+5, ((self.iSY/2)+50/2)-175, 150, 50, tocolor(0, 0, 0, self.renderScoreAlpha), 2, "pricedown", "center", "center")
		dxDrawText(self.score, (self.iSX/2), ((self.iSY/2)+50/2)-180, 150, 50, tocolor(255, 255, 255, self.renderScoreAlpha), 2, "pricedown", "center", "center")
		if(self.renderScoreAlpha < 240) then
			self.renderScoreAlpha = self.renderScoreAlpha+10;
		end
	end
end

function FlappyUI:Reset()
	self.startmenuEnabled	= true;
	self.startmenuAEnabled	= true;
	self.startmenuAlpha		= 255;
	self.deadmenuEnabled 	= false;
	self.deadmenuAlpha		= 0;
	self.renderScore		= true;
	self.renderScoreAlpha	= 0;
	self.score				= 0;
end


function FlappyUI:Constructor(iSX, iSY, imageTexture)
	self.iSX		= iSX;
	self.iSY		= iSY;
	self.imageTexture		= imageTexture;
	self.startmenuAlpha		= 255;
	self.startmenuEnabled	= true;
	self.startmenuAEnabled	= true;
	self.deadmenuEnabled	= false;
	self.deadmenuAlpha		= 0;
	self.renderScore		= true;
	self.renderScoreAlpha	= 0;
	self.score				= 0;
end

Sound = {};
Sound.__index = Sound;
function Sound:New(...)
	local obj = setmetatable({}, {__index = self});
	if obj.Constructor then
		obj:Constructor(...);
	end
	return obj;
end

function Sound:Constructor(sFilepath)
	self.sound	= playSound(sFilepath, false)
end

Tube = {};
Tube.__index = Tube;
function Tube:New(...)
	local obj = setmetatable({}, {__index = self});
	if obj.Constructor then
		obj:Constructor(...);
	end
	return obj;
end

function Tube:Constructor(bDirection, iSX, iLength)
	self.direction		= bDirection;
	self.iSX			= iSX;
	self.iLength		= iLength;
	self.u				= 0;
	self.v				= 0;
	self.w				= 0;
	self.h				= 0;
	self.sizeX			= 52;
	self.sizeY			= 320;
	if(bDirection == true) then
		self.u				= 168; -- 112
		self.v				= 646;
		self.w				= 52;
		self.h				= 320;
	else
		self.u				= 112;
		self.v				= 646;
		self.w				= 52;
		self.h				= 320;
	end
end
