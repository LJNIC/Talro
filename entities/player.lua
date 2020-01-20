local Base = require 'entities/base'
local Colors = require 'utility/colors'
local Animations = require 'animations'

local Player = Base:extend()

function Player:new(x, y)
	Player.super.new(self, x, y, Colors.BLUE, Colors.DARKEST, '\1')
	self.animating = false
	self.toggle = true
	self.health = 0
	self.maxHealth = 3
end

function Player:whip(direction)
	local length, entity = self:pullItem(direction)
	if length == 0 then return end
	self.animating = true
	Animations.addAnimation(self:getWhipFrames(direction, length), self:afterWhip(direction, length, entity))
end

function Player:getWhipFrames(direction, length)
	local frame = {}

	for i = 1, length , 1 do
		frame[i] = {
			x = self.x + direction.x * i, 
			y = self.y + direction.y * i, 
			fg = Colors.BROWN, 
			bg = Colors.DARKEST, 
			symbol = direction.y == 0 and '~' or '\140'
		}
	end

	return {frame, frame, frame}
end

function Player:afterWhip(direction, length, entity)
	return function () 
		self.animating = false
		if entity then
			if entity:is(Hook) then
				self:moveTo(self.x + direction.x * length, self.y + direction.y * length)
			end

			entity:moveTo(self.x + direction.x, self.y + direction.y)

			if self.map:getTile(entity.x, entity.y).tileType == 'Pit' then
				self.map:removeEntity(entity)
			end
		end
	end
end

function Player:pullItem(dir)
	for i = 1, 5 do
		local x = dir.x * i + self.x 
		local y = dir.y * i + self.y

		if self.map:isBlocked(x, y) then
			local entity = self.map:getEntityAt(x, y)
			return i - 1, entity
		end
	end
	return 4
end

return Player
