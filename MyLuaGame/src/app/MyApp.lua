
local MyApp = class("MyApp", cc.load("mvc").AppBase)

function MyApp:onCreate()
    math.randomseed(os.time())
    	-- display.loadSpriteFrames()
    -- cc.SpriteFrameCache:getInstance():addSpriteFramesWithFile("Plsy.plist")
end

return MyApp
