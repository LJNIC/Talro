local Base = require 'entities/base'
local Colors = require 'utility/colors'

local Lever = Base:extend()

function Lever:new(x, y, toggled)
	Lever.super.new(self, x, y, Colors.YELLOW, Colors.DARKEST, '\172')
	self.toggled = toggled
end

function Lever:toggle()
	self.toggled = not self.toggled
	self.symbol = self.toggled and '\172' or '\173'
end

return Lever
