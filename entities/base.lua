local Object = require 'lib/classic'

local Base = Object:extend()
Base.count = 0

function Base:new(x, y, fg, bg, symbol)
	self.x = x
	self.y = y
	self.fg = fg
	self.bg = bg
	self.symbol = symbol
	self.id = Base.count
	Base.count = Base.count + 1
end

function Base:moveTo(x, y)
	self.x = x
	self.y = y
end

return Base
