--
-- Author: Your Name
-- Date: 2017-08-17 19:59:24
--

local type = -1
local price = 0
local TableUtils = require("app.TableUtils")
local Bullet = require("app.model.Bullet")
local Tower = class("Tower", function ()
	return cc.Node:create()
end)

function Tower:ctor(x, y, type, price)
	self.x = x
	self.y = y
	self.type = type
	self.price = price
	self.range = 0
	self.base = nil
	self.sprite = nil
	self.base = cc.Sprite:createWithSpriteFrameName("baseplate.png")
	self.base:setAnchorPoint(0.5, 0.5)
	-- draw:drawSolidCircle(cc.p(x, y), 60, math.pi/2, 50, cc.c4f(1,1,0,1))
	self:addChild(self.base)
	self.width = self.base:getContentSize().width
	self.height = self.base:getContentSize().height
	local frameName = nil
	if type == 111 then
		frameName = "arrow.png"
		self.time = 0.1
		self.range = 180
	elseif type == 222 then
		frameName = "attackTower.png"
		self.range = 150
		self.time = 0.15
	elseif type == 333 then
		frameName = "multiDirTower.png"
		self.range = 220
		self.time = 0.05
	end
	self.sprite = cc.Sprite:createWithSpriteFrameName(frameName)
	self.sprite:setAnchorPoint(0.5, 0.5)
	self:addChild(self.sprite)
	self:setPosition(cc.p(x, y))
	self.entry = self:getScheduler():scheduleScriptFunc(handler(self, self.scheduleFunc), self.time, false)
end

function Tower:unSchedule()
	print("执行towerSchedule--------")
	if self.entry then
		self:getScheduler():unscheduleScriptEntry(self.entry)
		self.entry = nil
	end
end

function Tower:moveAndShot()

end

function Tower:fire(x, y, emeny, angle)
	local bullet = Bullet.new(self.x, self.y, emeny, self.type)
	bullet:runAction(cc.RotateTo:create(1/60,180 - angle))
	self:getParent():addChild(bullet, 2)
end

function Tower:scheduleFunc()
	local emenyTable = TableUtils.getEmenyTable()
	if not emenyTable then
		return
	end
	local x = self.x
	local y = self.y
	if not x or not y then
		return
	end
	if #emenyTable > 0 then
		local minDistance = math.sqrt(math.pow(x - emenyTable[1]:getPositionX(), 2) + math.pow(y - emenyTable[1]:getPositionY(), 2))
		local minIndex = 1
		for i=1,#emenyTable do
			local minDistance2 = math.sqrt(math.pow(x - emenyTable[i]:getPositionX(), 2) + math.pow(y - emenyTable[i]:getPositionY(), 2)) 
			if minDistance2 < minDistance then
				minIndex = i
				minDistance = minDistance2
			end
		end
		local angle = self:getAngle(emenyTable[minIndex]:getPositionX(), emenyTable[minIndex]:getPositionY(), x, y)
		if self.type == 111 then
			self.sprite:runAction(cc.RotateTo:create(1/60,180 - angle))
		end
		if minDistance < self.range + emenyTable[minIndex]:getContentSize().width/2 then
			self:fire(x, y, emenyTable[minIndex], angle)
		end
	end
end
function Tower:getAngle(px1, py1, px2, py2)
        --两点的x、y值
        local x = px2-px1;
        local y = py2-py1;
        local hypotenuse = math.sqrt(math.pow(x, 2)+math.pow(y, 2));
        --斜边长度
        local cos = x/hypotenuse;
        local radian = math.acos(cos);
        --求出弧度
        local angle = 180/(math.pi/radian);
        --用弧度算出角度        
        if y<0 then
            angle = -angle;
        elseif y == 0 and x < 0 then
            angle = 180;
        end
        return angle;
end
return Tower