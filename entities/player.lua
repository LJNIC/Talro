local Base = require 'entities/base'
local Colors = require 'utility/colors'

local Player = Base:extend()

function Player:new(x, y)
	Player.super.new(self, x, y, Colors.BLUE, Colors.DARKEST, '\1')
	self.animating = false
	self.toggle = true
	self.health = 0
	self.maxHealth = 3
end

return Player
