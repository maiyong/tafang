--
-- Author: Your Name
-- Date: 2nil17-nil8-18 22:31:21
--
local TableUtils = {}

local emenyTable = {}

local bulletTable = {}

local towerTable = {
		{nil, nil, nil, nil, nil, nil, nil, nil, nil},{nil, nil, nil, nil, nil, nil, nil, nil, nil},
		{nil, nil, nil, nil, nil, nil, nil, nil, nil},{nil, nil, nil, nil, nil, nil, nil, nil, nil},
		{nil, nil, nil, nil, nil, nil, nil, nil, nil},{nil, nil, nil, nil, nil, nil, nil, nil, nil},
		{nil, nil, nil, nil, nil, nil, nil, nil, nil},{nil, nil, nil, nil, nil, nil, nil, nil, nil},
		{nil, nil, nil, nil, nil, nil, nil, nil, nil},{nil, nil, nil, nil, nil, nil, nil, nil, nil},
		{nil, nil, nil, nil, nil, nil, nil, nil, nil},{nil, nil, nil, nil, nil, nil, nil, nil, nil},
		{nil, nil, nil, nil, nil, nil, nil, nil, nil},{nil, nil, nil, nil, nil, nil, nil, nil, nil},
		{nil, nil, nil, nil, nil, nil, nil, nil, nil},{nil, nil, nil, nil, nil, nil, nil, nil, nil}}

function TableUtils.clearAllTable()
	emenyTable = {}
	bulletTable = {}
	towerTable = {
		{nil, nil, nil, nil, nil, nil, nil, nil, nil},{nil, nil, nil, nil, nil, nil, nil, nil, nil},
		{nil, nil, nil, nil, nil, nil, nil, nil, nil},{nil, nil, nil, nil, nil, nil, nil, nil, nil},
		{nil, nil, nil, nil, nil, nil, nil, nil, nil},{nil, nil, nil, nil, nil, nil, nil, nil, nil},
		{nil, nil, nil, nil, nil, nil, nil, nil, nil},{nil, nil, nil, nil, nil, nil, nil, nil, nil},
		{nil, nil, nil, nil, nil, nil, nil, nil, nil},{nil, nil, nil, nil, nil, nil, nil, nil, nil},
		{nil, nil, nil, nil, nil, nil, nil, nil, nil},{nil, nil, nil, nil, nil, nil, nil, nil, nil},
		{nil, nil, nil, nil, nil, nil, nil, nil, nil},{nil, nil, nil, nil, nil, nil, nil, nil, nil},
		{nil, nil, nil, nil, nil, nil, nil, nil, nil},{nil, nil, nil, nil, nil, nil, nil, nil, nil}}
end

function TableUtils.insertTower(x, y, tower)
	towerTable[x][y] = tower
end

function TableUtils.removeTower(x, y)
	towerTable[x][y] = nil
end

function TableUtils.getTowerTable()
	return towerTable
end

function TableUtils.isExist(tower)
	for i=1,#towerTable do
		if tower == towerTable[i] then
			return true
		end
	end
	return false
end

function TableUtils.insertBullet(bullet)
	if bullet == nil then
		return
	end
	if not bulletTable then 
		bulletTable = {}
	end
	bulletTable[#bulletTable + 1] = bullet
end

function TableUtils.removeBullet(bullet)
	if not bulletTable then
		print("error")
	end
	for i=1,#bulletTable do
		if bullet == bulletTable[i] and bullet ~= nil then
			print("type = " .. type(bulletTable[i]))
			bulletTable[i]:removeFromParent(true)
			bulletTable[i] = nil
			table.remove(bulletTable, i)
			bullet = nil
		end
	end	
end

function TableUtils.insertEmeny(emeny)
	if not emenyTable then
		emenyTable = {}
	end
	emenyTable[#emenyTable + 1] = emeny
end

function TableUtils.removeEmeny(emeny)
	if not emenyTable then
		print("error")
		return
	end
	for i=1,#emenyTable do
		if emeny == emenyTable[i] then
			table.remove(emenyTable, i)
			emeny = nil
			break
		end
	end
end

function TableUtils.getEmenyTable()
	return emenyTable
end


return TableUtils