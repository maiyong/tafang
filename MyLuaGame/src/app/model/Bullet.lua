--
-- Author: Your Name
-- Date: 2017-08-21 22:28:39
--
local Bullet = class("Bullet", function()
	return cc.Sprite:create()
end)

local TableUtils = require("app.TableUtils")

function Bullet:ctor(x, y, emeny, towerType)
	self:setPosition(cc.p(x, y))
	self.speed = 5
	self.towerType = towerType
	self.angle = nil
	self:initAngle(x, y, emeny)
	self:init()
	self.x = x
	self.y = y
	-- self:setSpriteFrame("bullet1.png")
	-- TableUtils.insertBullet(self)
	-- self:runAction(cc.MoveTo:create(1, cc.p(emeny:getPositionX(), emeny:getPositionY())))
	self.entry = self:getScheduler():scheduleScriptFunc(functor(self.scheduleFunc, self, emeny), self.time, false)
end

function Bullet:unSchedule()
	if self.entry ~= nil then
		self:getScheduler():unscheduleScriptEntry(self.entry)
		self.entry = nil
	end
end

function Bullet:init()
	if self.towerType == 111 then
		self:setSpriteFrame("arrowBullet.png")
		self.time = 1/60
	elseif self.towerType == 222 then
		self:setSpriteFrame("bullet1.png")
		self.time = 1/300
	elseif self.towerType == 333 then
		self:setSpriteFrame("bullet.png")
		self.time = 1/600
	end
end

function Bullet:initAngle(x, y, emeny)
	local dx = emeny:getPositionX()
	local dy = emeny:getPositionY()
	local tx = dx - x
	local ty = dy - y
	local angle = 0
	if tx >= 0 and ty >= 0 then
		angle = math.atan(math.abs(ty/tx))
	elseif ty >= 0 and tx <= 0 then
		angle = math.pi - math.atan(math.abs(ty/tx))
	elseif tx <= 0 and ty <= 0 then
		angle = math.pi + math.atan(math.abs(ty/tx))
	else
		angle = 2*math.pi - math.atan(math.abs(ty/tx))
	end
	self.angle = angle 
end

function Bullet:scheduleFunc(emeny)
	local x = self.x
	local y = self.y
	if not x or not y then
		return
	end
	if (emeny.isBoom and self.angle ~= nil) or tolua.isnull(emeny) or emeny == nil then
		if (x > display.width or y > display.height) then
			self:unSchedule()
			-- TableUtils.removeBullet(self)
			self:removeFromParent(true)
			self = nil
		else
			local fx = x + self.speed * math.cos(self.angle)
			local fy = y + self.speed * math.sin(self.angle)
			self.x = fx
			self.y = fy
			self:setPosition(cc.p(fx, fy))
		end
		return
	end
	local dx = emeny:getPositionX()
	local dy = emeny:getPositionY()
	local tx = dx - x
	local ty = dy - y

	if (math.abs(tx) < 10 and math.abs(ty) < 10) or emeny == nil then
		self:unSchedule()
		self:removeFromParent(true)
		self = nil
		-- TableUtils.removeBullet(self)
		emeny.blood = emeny.blood - 1
		emeny:changeHP()
		if emeny.blood <= 0 then
			emeny:boom()
		end
		return
	end
	local p = nil
	local angle = 0
	if tx >= 0 and ty >= 0 then
		angle = math.atan(math.abs(ty/tx))
	elseif ty >= 0 and tx <= 0 then
		angle = math.pi - math.atan(math.abs(ty/tx))
	elseif tx <= 0 and ty <= 0 then
		angle = math.pi + math.atan(math.abs(ty/tx))
	else
		angle = 2*math.pi - math.atan(math.abs(ty/tx))
	end
	local fx = x + self.speed * math.cos(angle)
	local fy = y + self.speed * math.sin(angle)
	self.angle = angle 
	self.x = fx
	self.y = fy
	self:setPosition(fx, fy)
end

return Bullet