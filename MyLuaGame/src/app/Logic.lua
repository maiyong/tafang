--
-- Author: Your Name
-- Date: 2017-09-11 19:57:34
--
local Logic = {}

-- 世界坐标转换为地图坐标
function Logic.convertToMapPosition(x, y, sfyz, tileSize)
	local x = math.floor(x * sfyz / tileSize.width) + 1
	local y = math.floor(y * sfyz / tileSize.width) + 1
	return x, y
end

function Logic.convertToWorldPosition(x, y, sfyz, tileSize)
	local x = math.floor(x * sfyz / tileSize.width) + 1
	local y = math.floor(y * sfyz / tileSize.height) + 1
	return x, y
end

return Logic