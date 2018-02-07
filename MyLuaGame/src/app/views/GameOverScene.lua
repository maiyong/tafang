--
-- Author: Your Name
-- Date: 2017-09-20 21:31:12
--
local GameOverScene = class("GameOverScene", cc.load("mvc").ViewBase)
local TagUtils = require("app.TagUtils")

function GameOverScene:onCreate()
	local layer = self:createLayer()
	layer:setTag(TagUtils.gameOverLayerTag)
	self:addChild(layer)
	local bg0 = cc.Sprite:create("playbg1.jpg")
	bg0:setPosition(display.cx, display.cy)
	layer:addChild(bg0)
	local bg = cc.Sprite:createWithSpriteFrameName("failedPanel.png")
	bg:setPosition(display.cx, display.cy)
	bg:setScale(640/864)
	bg:setTag(TagUtils.gameMenuBGTag)
	layer:addChild(bg)
	self:createMenu()
end

function GameOverScene:createMenu()
	-- local label = cc.LabelAtlas:create("HelloWrold", "fonts/tuffy_bold_italic-charmap.png", "48", "66", string.byte(' '))
	-- label:setPosition(display.cx, display.cy)
	-- self:addChild(label)
	local menuBG = self:getChildByTag(TagUtils.gameOverLayerTag):getChildByTag(TagUtils.gameMenuBGTag)

	local reStart = ccui.Button:create()
	reStart:setTitleText("重新开始")
	reStart:setTitleFontSize(60)
	reStart:setTitleFontName("Marker Felt.ttf")
	reStart:setPosition(menuBG:getContentSize().width/2, 50)
	reStart:addTouchEventListener(function (target, selected)
		-- print("=======" .. selected)
		if selected == ccui.TouchEventType.ended then 
			local scene = display.newScene("app.views.MainScene")
    		scene:addChild(require("app.views.MainScene").new())
			cc.Director:getInstance():replaceScene(scene)
		end
	end)
	-- local restart = cc.MenuItemLabel:create(reStart)
	-- restart:setPosition(display.cx, display.cy)
	-- local mn = cc.Menu:create(restart)
	-- reStart:setPosition(menuBG:getContentSize().width/2, menuBG:getContentSize().height/2)
	menuBG:addChild(reStart)

	local button = ccui.Button:create()
	button:setTitleText("退出游戏")
	button:setTitleFontSize(60)
	button:setPosition(menuBG:getContentSize().width/2, 120)
	button:setTitleFontName("Marker Felt.ttf")
	button:addTouchEventListener(function(target, selected)
		-- body
		cc.Director:getInstance():endToLua()  
	end)
	menuBG:addChild(button)
	-- self:addChild(mn)
end

function GameOverScene:createLayer()
	local layer = cc.Layer:create()
	return layer
end

return GameOverScene