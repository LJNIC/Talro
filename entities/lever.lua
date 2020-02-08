local Base = require 'entities/base'
local Colors = require 'utility/colors'
local List = require 'lib/list'

local Lever = Base:extend()

function Lever:new(x, y, toggled, toggles)
	Lever.super.new(self, x, y, Colors.YELLOW, Colors.DARKEST, toggled and '\172' or '\173')
	self.toggled = toggled
	self.toggles = toggles or {}
end

function Lever:toggle()
	self.toggled = not self.toggled
	self.symbol = self.toggled and '\172' or '\173'
	for _,item in pairs(self.toggles) do
		self.map:setTile(item.x, item.y, self.toggled and item.on or item.off)
	end
end

return Lever
