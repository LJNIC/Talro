local Object = require 'lib/classic'

local Base = Object:extend()
Base.count = 0

function Base:new(x, y, fg, bg, symbol)
	self.x = x
	self.y = y
	self.fg = fg
	self.bg = bg
	self.symbol = symbol
	self.pullable = true
	self.id = Base.count
	Base.count = Base.count + 1
end

function Base:moveTo(x, y)
	if not self.map:isBlocked(x, y) then
		self.x = x
		self.y = y
	end
end

function Base:getEntityOrWall(dir, length)
	for i = 1, length do
		local x = dir.x * i + self.x 
		local y = dir.y * i + self.y

		if self.map:isBlocked(x, y) then
			local entity = self.map:getEntityAt(x, y)
			return i - 1, entity
		end
	end
	return length - 1
end

function Base:isInOrthogonalRange(targetX, targetY, range)
	local dx = targetX - self.x
	local dy = targetY - self.y

	if ((dx == 0 and math.abs(dy) - 1 < self.range) or
	    (dy == 0 and math.abs(dx) - 1 < self.range)) then

		local direction = {
			x = (dx ~= 0) and dx / math.abs(dx) or 0, 
			y = (dy ~= 0) and dy / math.abs(dy) or 0
		}
		return direction
	end

	return nil
end

function Base:getDistanceToPlayer(player)
	local player = player or self.map:getPlayer()
	return player.x - self.x, player.y - self.y
end

return Base
