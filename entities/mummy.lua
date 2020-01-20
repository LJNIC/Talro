local Colors = require 'utility/colors'
local Base = require 'entities/base'

local Mummy = Base:extend()

function Mummy:new(x, y)
	Mummy.super.new(self, x, y, Colors.WHITE, Colors.DARKEST, '\242')
	self.health = 2
	self.maxHealth = 2
end

return Mummy
