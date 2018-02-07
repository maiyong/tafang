
local MainScene = class("MainScene", cc.load("mvc").ViewBase)
local Emeny = require("app.model.Emeny")
local TableUtils = require("app.TableUtils")
local Tower = require("app.model.Tower")
local Logic = require("app.Logic")
local TagUtils = require("app.TagUtils")
local GameOverScene = require("app.views.GameOverScene")

local dispatcher = cc.Director:getInstance():getEventDispatcher()

local emenyLen = 20
local emenyLen2 = 30
local emenyLen3 = 40
local curEmenyLen = emenyLen

local callEntry = nil
local towers = {}
local towerLayer = nil
local sfyz = nil
local tileSize = nil
local layer = nil
local blood = 10

function MainScene:onCreate()
	local bg = display.newSprite("playbg.png")
	bg:setPosition(cc.p(display.cx, display.cy))
	self:addChild(bg)
	print("helloworld")
	local toolBar = cc.Sprite:createWithSpriteFrameName("toolbg.png")
	toolBar:setScaleX(0.7)
	toolBar:setScaleY(0.8)
	toolBar:setTag(TagUtils.toolBalTag)
	toolBar:setPosition(1136/2, display.height - toolBar:getContentSize().height * 0.4)
	
	local moneyLabel = cc.Label:createWithBMFont("fonts/bitmapFontChinese.fnt", " ")
	moneyLabel:setString("500")	
	moneyLabel:setPosition(cc.p(toolBar:getContentSize().width/8, toolBar:getContentSize().height/2))
	moneyLabel:setTag(TagUtils.moneyLabelTag)
	moneyLabel:setAnchorPoint(0, 0.5)
	toolBar:addChild(moneyLabel)

	local totalBoLabel = cc.Label:createWithBMFont("fonts/bitmapFontChinese.fnt", " ")
	totalBoLabel:setString("3")
	totalBoLabel:setPosition(cc.p(toolBar:getContentSize().width/2, toolBar:getContentSize().height/1.8))
	totalBoLabel:setAnchorPoint(0, 0.5)
	totalBoLabel:setTag(TagUtils.totalBoLabelTag)
	toolBar:addChild(totalBoLabel)

	local nowBoLabel = cc.Label:createWithBMFont("fonts/bitmapFontChinese.fnt", " ")
	nowBoLabel:setString("1")
	nowBoLabel:setPosition(cc.p(toolBar:getContentSize().width/2.69, toolBar:getContentSize().height/1.8))
	nowBoLabel:setAnchorPoint(0, 0.5)
	nowBoLabel:setTag(TagUtils.nowBoLabelTag)
	toolBar:addChild(nowBoLabel)

	self:addChild(toolBar, 40)

	layer = self:createLayer()
    self:addChild(layer)
	self:addChild(towerLayer)
end

function MainScene:lostBlood()
	blood = blood - 1
	print(string.format("掉血，剩余%d滴血", blood))
	if blood <= 0 then
		self:gameOver()
	end
end

function MainScene:stopEmenyAllAction()
	for i, emeny in ipairs(TableUtils.getEmenyTable()) do
		emeny:stopWalkAction()
	end
end

function MainScene:stopTowerAllSchedule()
	for i, v in ipairs(TableUtils.getTowerTable()) do
		local towerTable = v
		for j=1,#towerTable do
			print(j)
		 	if towerTable[j] then
				towerTable[j]:unSchedule()
			end
		end
	end
end

function MainScene:unSchedule()
	if callEntry ~= nil then
		cc.Director:getInstance():getScheduler():unscheduleScriptEntry(callEntry)
		callEntry = nil
	end
end

function MainScene:createLayer()
	towerLayer = cc.Layer:create()
	sfyz = 864/640
	local layer = cc.Layer:create()
	-- 创建地图
	local tileMap = cc.TMXTiledMap:create("map/tilemap0.tmx")
	tileSize = tileMap:getTileSize()
	local bg = tileMap:getLayer("bg")
	layer:addChild(tileMap)
	-- 设置点击事件
	local listener = cc.EventListenerTouchOneByOne:create()
	listener:registerScriptHandler(function (touch, event)
		local towerTable = TableUtils.getTowerTable()
		-- local node = self:getChildTag(110)
		-- if not node then
			self:removeChildByTag(110, true)
		-- end
		-- dump(towerTable)
		local x, y = Logic.convertToMapPosition(touch:getLocation().x, touch:getLocation().y, sfyz, tileSize)
		if towerTable[x][y] ~= nil then
			local draw = cc.DrawNode:create()
			draw:drawCircle(cc.p(towerTable[x][y]:getPositionX(), towerTable[x][y]:getPositionY()), towerTable[x][y].range, math.pi/2, 150, false, cc.c4f(1, 1, 1, 1))
			draw:setTag(110)
			self:addChild(draw)
			towerLayer:removeAllChildren()
			return false
		end
		return true
	end, cc.Handler.EVENT_TOUCH_BEGAN)
	listener:registerScriptHandler(function (touch, event)
	end, cc.Handler.EVENT_TOUCH_MOVED)
	listener:registerScriptHandler(function (touch, event)
		local x = touch:getLocation().x
		local y = touch:getLocation().y
		print("x=" .. x .. " y= " .. y)
		-- self:gameOver()
				-- cc.Director:getInstance():pushScene(GameOverScene.new())
		-- local gid = bg:getTileGIDAt(cc.p(Logic.convertToMapPosition(x, y, sfyz, tileSize))) - 1
		-- local properties = tileMap:getPropertiesForGID(gid)
		-- print(properties)
		-- dump(properties:asValueMap())
		self:createTower(Logic.convertToWorldPosition(x, y, sfyz, tileSize))
	end, cc.Handler.EVENT_TOUCH_ENDED)
	dispatcher:addEventListenerWithSceneGraphPriority(listener, layer)
	-- 获取移动点
	local objGroup = tileMap:getObjectGroup("obj") 
	local lobjs =objGroup:getObjects()

	local schedule = cc.Director:getInstance():getScheduler()
	callEntry = schedule:scheduleScriptFunc(functor(self.createEmeny, self, lobjs, schedule), 1, false)
	return layer
end

-- 创建敌人
function MainScene:createEmeny(lobjs, schedule)
	local flag = math.floor((math.random() * 1000) % 3 + 1)
	if flag == 2 then
		return
	end
	local num = math.floor((math.random() * 1000) % 3 + 1)
	local emeny = Emeny.new(num, lobjs[1].x, lobjs[1].y, lobjs, emenyLen, handler(self, self.lostBlood))
	layer:addChild(emeny, 2)
	curEmenyLen = curEmenyLen - 1
	if curEmenyLen <= 0 then
		self:unSchedule()
		local toolbar = self:getChildByTag(TagUtils.toolBalTag)
		local nowBoLabel = toolbar:getChildByTag(TagUtils.nowBoLabelTag)
		local nowBo = nowBoLabel:getString()
		local totalBoLabel = toolbar:getChildByTag(TagUtils.totalBoLabelTag)
		local totalBo = totalBoLabel:getString()
		local n_totalBo = tonumber(totalBo)
		local n_nowBo = tonumber(nowBo)
		n_nowBo = n_nowBo + 1
		if n_nowBo <= n_totalBo then
			print("加一波")
			if n_nowBo == 2 then
				curEmenyLen = emenyLen2
			else
				curEmenyLen = emenyLen3
			end
			nowBoLabel:setString(n_nowBo)
			local schedule = cc.Director:getInstance():getScheduler()
			callEntry = schedule:scheduleScriptFunc(functor(self.createEmeny, self, lobjs, schedule), 1, false)
		else
			print("波數結束")
		end
	end
end

-- 创建塔
function MainScene:createTower(x, y)
	-- 顶部的时候塔在下方显示
	local isTop = false
	if y == 9 then
		isTop = true
	end
	x = x * tileSize.height / sfyz
	y = y * tileSize.height / sfyz
	local newY = 0
	if isTop then
		newY = y - ((sfyz * tileSize.height)/2 + 10)
	else
		newY = y + ((sfyz * tileSize.height)/2 + 10)
	end
	towerLayer:removeAllChildren()
	local towerPos = cc.Sprite:createWithSpriteFrameName("towerPos.png")
	towerPos:setAnchorPoint(1, 1)
	towerPos:setPosition(cc.p(x, y))
	towerLayer:addChild(towerPos)
	local arrowTower = cc.Sprite:createWithSpriteFrameName("ArrowTower1.png")
	arrowTower:setAnchorPoint(1, 1)
	arrowTower:setPosition(cc.p(x - (sfyz * tileSize.height)/2, newY))
	towerLayer:addChild(arrowTower, 10, 111)
	local attackTower = cc.Sprite:createWithSpriteFrameName("AttackTower1.png")
	attackTower:setAnchorPoint(1, 1)
	attackTower:setPosition(cc.p(x, newY))
	towerLayer:addChild(attackTower, 20, 222)
	local multilDirTower = cc.Sprite:createWithSpriteFrameName("MultiDirTower1.png")
	multilDirTower:setAnchorPoint(1, 1)
	multilDirTower:setPosition(cc.p(x + (sfyz * tileSize.height)/2, newY))
	towerLayer:addChild(multilDirTower, 30, 333)

	local listener = cc.EventListenerTouchOneByOne:create()
	listener:setSwallowTouches(true)
	listener:registerScriptHandler(function (touch, event)
		-- 吞并事件
		local node = event:getCurrentTarget()
		local locationInNode = node:convertToNodeSpace(touch:getLocation())
		local s = node:getContentSize()
		local rect = cc.rect(0, 0, s.width, s.height)
		if cc.rectContainsPoint(rect, locationInNode) then
			node:scaleTo({scale=1.1, time = 0.1})
			return true
		else 
			return false
		end
	end, cc.Handler.EVENT_TOUCH_BEGAN)
	listener:registerScriptHandler(function (touch, event)
	end, cc.Handler.EVENT_TOUCH_MOVED)
	listener:registerScriptHandler(function (touch, event)
		local node = event:getCurrentTarget()
		-- 建塔
		event:getCurrentTarget():scaleTo({scale=1, time=0.1})
		local moneyLabel = self:getChildByTag(TagUtils.toolBalTag):getChildByTag(TagUtils.moneyLabelTag)
		local money = moneyLabel:getString()
		money = tonumber(money)
		if node:getTag() == 111 then
			if money < 200 then
				return
			else
				money = money - 200
				moneyLabel:setString(money)
			end
		elseif node:getTag() == 222 then
			if money < 150 then
				return
			else
				money = money - 150
				moneyLabel:setString(money)
			end
		elseif node:getTag() == 333 then
			if money < 500 then
				return
			else
				money = money - 500
				moneyLabel:setString(money)
			end
		end
		local tower = Tower.new(towerPos:getPositionX() - (sfyz * 96)/4, 
			towerPos:getPositionY() - (sfyz * 96)/4, node:getTag(), 1)
		local x, y = Logic.convertToMapPosition(towerPos:getPositionX() - (sfyz * 96)/4, 
			towerPos:getPositionY() - (sfyz * 96)/4, sfyz, tileSize)
		TableUtils.insertTower(x, y, tower)
		towerLayer:removeAllChildren()
		layer:addChild(tower, 1)
		
	end, cc.Handler.EVENT_TOUCH_ENDED)
	dispatcher:addEventListenerWithSceneGraphPriority(listener, arrowTower)
	local listener2 = listener:clone()
	dispatcher:addEventListenerWithSceneGraphPriority(listener2, attackTower)	
	local listener3 = listener:clone()
	dispatcher:addEventListenerWithSceneGraphPriority(listener3, multilDirTower)	
end

function MainScene:gameOver()
	self:unSchedule()
	blood = 10
	self:stopTowerAllSchedule()
	self:stopEmenyAllAction()
	TableUtils.clearAllTable()
	print("gameOver")
	local scene = display.newScene("app.views.GameOverScene")
	scene:addChild(GameOverScene.new())
	cc.Director:getInstance():replaceScene(scene)
end

return MainScene
