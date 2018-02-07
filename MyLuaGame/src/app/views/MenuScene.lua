--
-- Author: Your Name
-- Date: 2017-09-21 21:23:49
--
local MenuScene = class("MenuScene", cc.load("mvc").ViewBase)

function MenuScene:onCreate()
	local spriteFrameCache = cc.SpriteFrameCache:getInstance()
	spriteFrameCache:addSpriteFrames("Play.plist", "Play.png")

	local bg = cc.Sprite:create("playbg1.jpg")
	bg:setPosition(display.cx, display.cy)
	self:addChild(bg)
	local widget = ccs.GUIReader:getInstance():widgetFromJsonFile("NewUi_1/NewUi_1.json")
	-- widget:setPosition(display.cx, display.cy)
	local button = widget:getChildByTag(7)
	button:addTouchEventListener(function (target, selected)
		if selected == ccui.TouchEventType.began then
			button:runAction(cc.ScaleTo:create(0.2, 0.9))
			return true
		elseif selected == ccui.TouchEventType.ended then
			button:runAction(cc.ScaleTo:create(0.2, 1))
			local scene = display.newScene("MainScene")
			scene:addChild(require("app.views.MainScene").new())
			cc.Director:getInstance():replaceScene(cc.TransitionFadeDown:create(1.0, scene))
			-- display.wrapScene(scene, display.SCENE_TRANSITIONS.FADETR, 0.5)
		end

	end)

	local emeny = widget:getChildByTag(6)
	local animation = cc.Animation:create()
	for i=1, 6 do 
		local spriteFrame = spriteFrameCache:getSpriteFrame(string.format("explode1_%d.png", i))
		animation:addSpriteFrame(spriteFrame)
		animation:setDelayPerUnit(0.1)
	end
	local animate = cc.Animate:create(animation)
	-- emeny:runAction(animate)
	-- emeny:setSpriteFrame(spriteFrameCache:getSpriteFrame("exploded1_3.png"))
	emeny:runAction(cc.RepeatForever:create(cc.Sequence:create(cc.ScaleTo:create(0.5, 0.8), cc.ScaleTo:create(0.5, 1))))
	self:addChild(widget)
end

return MenuScene
