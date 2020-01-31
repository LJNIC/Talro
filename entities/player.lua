local Base = require 'entities/base'
local Lever = require 'entities/lever'
local Colors = require 'utility/colors'
local Animations = require 'animations'
local Util = require 'utility/util'

local Player = Base:extend()

function Player:new(x, y)
	Player.super.new(self, x, y, Colors.BLUE, Colors.DARKEST, '\1')
	self.health = 3
	self.maxHealth = 3
	self.hooks = 5
	self.torches = 3
end

function Player:pull(direction)
	if length == 0 then return end
	local length, entity = self:getEntityOrWall(direction, 5)

	if self.hooks == 0 then
		return
	end
	self.hooks = self.hooks - 1
	self.acted = true

	Animations.addAnimation(self:getWhipFrames(direction, length, entity, true), self:afterPull(direction, length, entity))
end

function Player:afterPull(direction, length, entity)
	return function () 
		if entity and entity.pullable then
			entity:moveTo(self.x + direction.x, self.y + direction.y)

			if self.map:getTile(entity.x, entity.y).tileType == 'Pit' then
				self.map:removeEntity(entity)
			end
		else
			local x = self.x + direction.x * (length + 1)
			local y = self.y + direction.y * (length + 1)
			local tile = self.map:getTile(x, y)

			if tile and tile.hookable then
				self:moveTo(x - direction.x, y - direction.y)
				return
			end
		end
	end
end

function Player:attack(direction)
	local length, entity = self:getEntityOrWall(direction, 5)
	if length == 0 then return end

	self.acted = true
	Animations.addAnimation(self:getWhipFrames(direction, length, entity), self:afterAttack(direction, entity))
end

function Player:afterAttack(direction, entity)
	return function()
		if entity then
			if entity.health then
				Util.damageEntity(entity, 1)
			elseif entity:is(Lever) then
				entity:toggle()
			end
		end
	end
end

function Player:getWhipFrames(direction, length, entity, pull)
	local frame = {}

	for i = 1, length, 1 do
		frame[i] = {
			x = self.x + direction.x * i, 
			y = self.y + direction.y * i, 
			fg = pull and length == i and Colors.SILVER or Colors.BROWN, 
			bg = Colors.DARKEST, 
			symbol = direction.y == 0 and '~' or '\140'
		}
	end

	local frames = {frame, frame, frame}
	
	if not pull and entity and entity.health then
		local hitFrame = {{
			x = self.x + direction.x * (length + 1),
			y = self.y + direction.y * (length + 1),
			fg = Colors.SILVER,
			bg = Colors.DARKEST,
			symbol = '\42'
		}}
		frames[4] = hitFrame
		frames[5] = Animations.emptyFrame()
	end

	return frames
end

function Player:torch(direction)
	local length, entity = self:getEntityOrWall(direction, 8)
	if length == 0 then return end

	if self.torches == 0 then
		return
	end
	self.torches = self.torches - 1
	self.acted = true

	Animations.addAnimation(self:getTorchFrames(direction, length), self:afterTorch(entity))
end

function Player:afterTorch(entity)
	return function()
		if entity then
			Util.damageEntity(entity, 1)
		end
	end
end

function Player:getTorchFrames(direction, length)
	local frames = {}

	for i = 1, length, 1 do
		local frame = {{
			x = self.x + direction.x * i,
			y = self.y + direction.y * i,
			fg = Colors.ORANGE,
			bg = Colors.DARKEST,
			symbol = '\243'
		}}
		frames[i] = frame
	end

	return frames
end

return Player
