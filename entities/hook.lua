local Base = require 'entities/base'
local Colors = require 'utility/colors'

local Hook = Base:extend()

function Hook:new(x, y)
	Hook.super.new(self, x, y, Colors.YELLOW, Colors.DARKEST, '\9')	
end

return Hook
