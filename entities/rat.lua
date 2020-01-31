local Base = require 'entities/base'
local Colors = require 'utility/colors'
local AStar = require 'lib/astar'

local Rat = Base:extend()

Rat.defaultSpeed = 0.75
Rat.defaultHealth = 1

function Rat:new(x, y)
	Rat.super.new(self, x, y, Colors.GREY, Colors.DARKEST, '\241')
	self.maxHealth = Rat.defaultHealth
	self.health = Rat.defaultHealth
	self.speed = Rat.defaultSpeed
	self.time = 0
end

function Rat:callback(player)
	return function(x, y)
		--return self.map:isPassable(x, y) 
		return self.map:isWalkable(x, y) or (x == player.x and y == player.y)
	end
end

function Rat:getPath(player, walk)
	return AStar:find(self.map.width, self.map.height, self, player, self:callback(player), false, false)
end

function Rat:ai()
	if self.map:isVisible(self.x, self.y) then
		local player = self.map:getPlayer()
		self.lastpath = self:getPath(player)

		if self.lastpath then
			local to = self.lastpath[2]
			self:moveTo(to.x, to.y)
		end
	end
end

return Rat
