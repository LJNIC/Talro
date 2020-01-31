local Base = require 'entities/base'
local Player = require 'entities/player'
local Colors = require 'utility/colors'
local Animations = require 'animations'
local Util = require 'utility/util'

local Scarab = Base:extend()

Scarab.defaultSpeed = 1.5
Scarab.defaultHealth = 3
Scarab.range = 8

function Scarab:new(x, y)
	Scarab.super.new(self, x, y, Colors.GREEN, Colors.DARKEST, '\171')
	self.health = Scarab.defaultHealth
	self.maxHealth = Scarab.defaultHealth
	self.speed = Scarab.defaultSpeed
	self.time = 0
end

function Scarab:ai()
	if self.map:isVisible(self.x, self.y) then
		local player = self.map:getPlayer()
		local directionToPlayer = self:isInOrthogonalRange(player.x, player.y, Scarab.range)

		if directionToPlayer then
			local length, entity = self:getEntityOrWall(directionToPlayer, self.range)

			if entity:is(Player) and length > 0 then
				self:shoot(directionToPlayer, length, entity)
				return
			end
		end
	end
end

function Scarab:shoot(direction, length, entity)
	Animations.addAnimation(self:getShootFrames(direction, length), self:afterShoot(entity))
end

function Scarab:getShootFrames(direction, length)
	local frames = {}

	for i = 1, length, 1 do
		local frame = {{
			x = self.x + direction.x * i,
			y = self.y + direction.y * i,
			fg = Colors.BROWN,
			bg = Colors.DARKEST,
			symbol = '\7'
		}}
		frames[i] = frame
	end

	return frames
end

function Scarab:afterShoot(entity)
	return function()
		if entity then
			Util.damageEntity(entity, 1)
		end
	end
end

return Scarab
