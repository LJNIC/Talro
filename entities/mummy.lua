local Colors = require 'utility/colors'
local Base = require 'entities/base'
local AStar = require 'lib/astar'
local Animations = require 'animations'
local Util = require 'utility/util'

local Mummy = Base:extend()

Mummy.defaultSpeed = 2
Mummy.defaultHealth = 2
Mummy.grabCooldown = 2
Mummy.grabRange = 5

function Mummy:new(x, y)
	Mummy.super.new(self, x, y, Colors.WHITE, Colors.DARKEST, '\242')
	self.health = Mummy.defaultHealth
	self.maxHealth = Mummy.defaultHealth
	self.speed = Mummy.defaultSpeed
	self.range = Mummy.grabRange
	self.grabTimer = Mummy.grabCooldown
	self.time = 0
	self.pathcount = 0
	self.lastpath = nil
end

function Mummy:callback(player)
	return function(x, y)
		return self.map:isWalkable(x, y) or (x == player.x and y == player.y)
	end
end

function Mummy:ai()
	--Pathfinding: Target player when in player's FOV, if not move randomly
	if self.map:isVisible(self.x, self.y) then
		local player = self.map:getPlayer()
		--Check if player is within range to grab and grab them if they are
		local directionToPlayer = self:isInOrthogonalRange(player.x, player.y)

		if directionToPlayer and self.grabTimer == 0 then

			local length, entity = self:getEntityOrWall(directionToPlayer, self.range)

			if entity then
				self:grab(directionToPlayer, length, entity)
				self.grabTimer = Mummy.grabCooldown
				return
			end
		end

		self.pathcount = 0
		self.lastpath = Util.pathfind(self.map, self.map, self, player, self:callback(player))

		--Get the second tile in the path because the first is the mummy
		if self.lastpath then
			local to = self.lastpath[2]
			self.pathcount = self.pathcount + 1	

			self:moveTo(to.x, to.y)
		end
	else
		--If the player is out of view but the mummy hasn't reached their last location, continue on it
		if self.lastpath and self.pathcount + 2 < #self.lastpath then
			local to = self.lastpath[2 + self.pathcount]
			self.pathcount = self.pathcount + 1
			self:moveTo(to.x, to.y)
		--If the player is out of view and the mummy has reached the last location, wander randomly
		else
			local axis = (math.random() > 0.5) and 1 or -1	
			local direction = (math.random() > 0.5) and 1 or -1
			self:moveTo(axis == 1 and direction or 0, axis == -1 and direction or 0)
		end
	end

	if self.grabTimer > 0 then
		self.grabTimer = self.grabTimer - 1
	end
end

function Mummy:grab(direction, length, entity)
	Animations.addAnimation(self:getGrabFrames(direction, length), self:afterGrab(direction, entity))
end

function Mummy:afterGrab(direction, entity)
	return function()
		entity:moveTo(self.x + direction.x, self.y + direction.y)
	end
end

function Mummy:getGrabFrames(direction, length)
	local frame = {}

	for i = 1, length, 1 do
		frame[i] = {
			x = self.x + direction.x * i, 
			y = self.y + direction.y * i, 
			fg = Colors.SILVER , 
			bg = Colors.DARKEST, 
			symbol = direction.y == 0 and '\247' or '\140'
		}
	end

	return {frame, frame, frame}
end

return Mummy
