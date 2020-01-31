local Gamestate = require 'lib/state'
local Colors = require 'utility/colors'
local ActionKeys = require 'utility/keys'.getKeys()
local Util = require 'utility/util'

local Whip = {}

function Whip:enter(from)
	self.from = from
	self.display = self.from.mapDisplay
end

function Whip:keypressed(key)
	if key == 'escape' then
		Gamestate.pop()
	end

	if ActionKeys[key] then
		self.from.player:pull(ActionKeys[key], true)
		Gamestate.pop()
	end
end

function Whip:draw()
	self.from:draw()
	Util.drawArrows(self.from.player, self.display, Colors.SILVER)
	self.from.mapDisplay:draw()
end

return Whip
