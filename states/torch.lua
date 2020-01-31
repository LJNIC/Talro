local Gamestate = require 'lib/state'
local Colors = require 'utility/colors'
local ActionKeys = require 'utility/keys'.getKeys()
local Util = require 'utility/util'

local Torch = {}

function Torch:enter(from)
	self.from = from
	self.display = self.from.mapDisplay
end

function Torch:keypressed(key)
	if key == 'escape' then
		Gamestate.pop()
	end

	if ActionKeys[key] then
		self.from.player:torch(ActionKeys[key])
		Gamestate.pop()
	end
end

function Torch:draw()
	self.from:draw()
	Util.drawArrows(self.from.player, self.display, Colors.ORANGE)
	self.from.mapDisplay:draw()
end

return Torch
