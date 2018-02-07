--
-- Author: Your Name
-- Date: 2017-08-07 09:57:42
--
local spriteFrameCache = cc.SpriteFrameCache:getInstance()
local TableUtils = require("app.TableUtils")
local TagUtils = require("app.TagUtils")
local Emeny = class("Emeny", function()
	return cc.Sprite:create()
end)

function Emeny:ctor(emenyType, x, y, objs, tag, funt_lostblood)
	self.isBoom = false
	self.funt_lostblood = funt_lostblood
	TableUtils.insertEmeny(self)
	self:setSpriteFrame(string.format("enemyLeft%d_1.png", emenyType))
	self:setAnchorPoint(0.5, 0.5)
	self:setPosition(x, y)
	self.x = x
	self.y = y
	self.objs = objs
	self.pointLen = #objs -- 计算点
	self.emenyType = emenyType
	self.mAction = nil --左右方向
	self:setTag(tag)
	local loadingbar = ccui.LoadingBar:create("zs_xt.png")
	loadingbar:setPositionY(self:getContentSize().height)
	loadingbar:setPositionX(self:getContentSize().width/2)
	loadingbar:setTag(TagUtils.loadingBarTag)
	self:addChild(loadingbar)
	loadingbar:setPercent(100)
	-- self.allPoinLen
	local animation = cc.Animation:create()
	self:init(emenyType)
	for i=1,4 do
		local frame = spriteFrameCache:getSpriteFrame(string.format("enemyLeft%d_%d.png", emenyType, i))
		animation:addSpriteFrame(frame)
		animation:setDelayPerUnit(0.3)
	end
	local animate = cc.Animate:create(animation)
	self.mAction = self:runAction(cc.RepeatForever:create(animate))

	--move
	local dx, dy = objs[1].x, objs[1].y
	local distance = math.sqrt(math.pow(x - dx, 2) + math.pow(y - dy, 2))
	local time = distance/self.speed
	local ac1 = cc.MoveTo:create(time, cc.p(objs[1].x, objs[1].y))
	local ac2 = cc.CallFunc:create(handler(self, self.callFunc))
	self.walkAction = self:runAction(cc.Sequence:create(ac1, ac2))
end

-- 初始化怪物
function Emeny:init(emenyType)
	if emenyType == 1 then
		self.speed = 110
		self.blood = 40
		self.fullBlood = 40
	elseif emenyType == 2 then
		self.speed = 130
		self.blood = 60
		self.fullBlood = 60
	elseif emenyType == 3 then
		self.speed = 150
		self.blood = 80
		self.fullBlood = 80
	end
end

function Emeny:changeHP()
	local loadingBar = self:getChildByTag(TagUtils.loadingBarTag)
	loadingBar:setPercent(self.blood/self.fullBlood * 100)
end

-- 移动函数
function Emeny:callFunc()
	self.pointLen = self.pointLen - 1
	if self.pointLen >= 0 then
		local x,y = self:getPosition()
		local dx, dy = self.objs[table.getn(self.objs) - self.pointLen].x, self.objs[table.getn(self.objs) - self.pointLen].y
		local distance = math.sqrt(math.pow(x - dx, 2) + math.pow(y - dy, 2))
		self:changeDirection(x, dx)
		local time = distance/self.speed
		local ac1 = cc.MoveTo:create(time, cc.p(self.objs[table.getn(self.objs) - self.pointLen].x, self.objs[table.getn(self.objs) - self.pointLen].y))
		local ac2 = cc.CallFunc:create(handler(self, self.callFunc))
		self.walkAction = self:runAction(cc.Sequence:create(ac1, ac2))
	else 
		self.funt_lostblood()
		self:killMe()
	end
end

function Emeny:changeDirection(x, dx)
	if x ~= dx then
		local animation = cc.Animation:create()
		local name = nil
		if x - dx < 0 then
			name = "enemyRight%d_%d.png"		
		else
			name = "enemyLeft%d_%d.png"
		end
		for i=1,4 do
			local sname = string.format(name, self.emenyType, i)
			local frame = spriteFrameCache:getSpriteFrame(sname)
			animation:addSpriteFrame(frame)
			animation:setDelayPerUnit(0.3)
		end
		local animate = cc.Animate:create(animation)
		self:stopAction(self.mAction)
		self.mAction = self:runAction(cc.RepeatForever:create(animate))
	end
end

function Emeny:stopWalkAction()
	self:stopAction(self.walkAction)
end

function Emeny:killMe()
	TableUtils.removeEmeny(self)
	self:stopAllActions()
	self:removeFromParent(true)
	self = nil
end

function Emeny:boom()
	self.isBoom = true
	TableUtils.removeEmeny(self)
	self:stopAllActions()
	local name = "explode%d_%d.png"
	local animation = cc.Animation:create()
	for i=1,6 do
		local frame = spriteFrameCache:getSpriteFrame(string.format(name, self.emenyType, i))
		animation:addSpriteFrame(frame)
		animation:setDelayPerUnit(0.1)
	end
	local animate = cc.Animate:create(animation)
	local func = cc.CallFunc:create(handler(self, self.killMe))
	local sequence = cc.Sequence:create(animate, func)
	self:runAction(sequence) 
	self:addMoney()
end

function Emeny:addMoney()
	local moneyLabel = self:getParent():getParent():getChildByTag(TagUtils.toolBalTag):getChildByTag(TagUtils.moneyLabelTag)
	local money = moneyLabel:getString()
	money = tonumber(money)
	if self.emenyType == 1 then
		money = money + 100
		moneyLabel:setString(money)
	elseif self.emenyType == 2 then
		money = money + 200
		moneyLabel:setString(money)
	elseif self.emenyType == 3 then
		money = money + 300
		moneyLabel:setString(money)
	end
end

return Emeny
