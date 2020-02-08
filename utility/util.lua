local hex = require 'lib/hexmaniac'
local AStar = require 'lib/astar'
local TileTypes = require 'utility/tile-types'
local Util = {}

--Rounds a 0-1 number to 1 or 0
function Util.round(num)
	return (num > 0.5) and 1 or 0
end

--returns a table with each entry a table
--of values
function Util.parseCSV(csvfile)
	local values = {}
	local k = 1
	for line in love.filesystem.lines(csvfile) do
		local tempTile = {}
		local i = 1
		for word in string.gmatch(line, '([^,]+)') do
    		tempTile[i] = word
			i = i + 1
		end
		
		local x = tonumber(tempTile[1])
		local y = tonumber(tempTile[2])
		local symbol = string.char(tempTile[3])
		local fg = hex.rgb(tempTile[4]:sub(2))
		local bg  = hex.rgb(tempTile[5]:sub(2))
		values[k] = {x = x + 1, y = y + 1, symbol = symbol, fg = fg, bg = bg} 
		k = k + 1
	end
	return values
end

function Util.getTileFromSymbol(symbol)
	for _,tile in pairs(TileTypes) do
		if tile.symbol == symbol then
			return tile
		end
	end
end

function Util.damageEntity(entity, damage)
	if not entity.health then return end

	entity.health = entity.health - damage
end

function Util.pathfind(map, start, target, filter)
	return AStar:find(map.width, map.height, start, target, filter, false, false)
end

local directionsToSymbols = {
	up = '\24',
	down = '\25',
	right = '\26',
	left = '\27'
}

function Util.drawArrows(player, display, color)
	for name, direction in pairs(require 'utility/directions') do
		local x = player.x + direction.x
		local y = player.y + direction.y

		if not player.map:isBlocked(x, y) then
			display:write(directionsToSymbols[name], x,  y, color)
		end
	end	
end

--add two vectors
function Util.addVector(x1, y1, x2, y2)
	return x1 + x2, y1 + y2
end

--multiply two vectors
function Util.multVector(x1, y1, x2, y2)
	return x1 * x2, y1 * y2
end

return Util
