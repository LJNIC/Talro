local Display = require 'lib/display'
local Gamestate = require 'lib/state'
local Directions = require 'utility/directions'
local TileTypes = require 'utility/tile-types'
local Colors = require 'utility/colors'
local ActionKeys, MoveKeys = (require 'utility/keys').getKeys()
local Map = require 'map'
local Player = require 'entities/player'
local Mummy = require 'entities/mummy'
local Rat = require 'entities/rat'
local Scarab = require 'entities/scarab'
local Lever = require 'entities/lever'
local Animations = require 'animations'
local Util = require 'utility/util'

local Play = {}

function Play:init()
	love.keyboard.setKeyRepeat(true)

	self.display = Display:new({h = 23, w = 31}, nil, 2, {0, 0, 0}, Colors.DARKEST, {vsync = true}, nil, false)
	self.mapDisplay = Display:new({h = 19, w = 29}, {x = 32, y = 32}, 2, {0, 0, 0}, Colors.DARKEST, nil, nil, false)
	self.player = Player(5, 5)
	self.map = Map(29, 19, self.mapDisplay, true)
	self.border = Util.parseCSV('assets/Mockup.csv')

	Animations.init(self.mapDisplay)

	local map = self.map
	local display = self.display

	map:addEntity(self.player)
	map:addEntity(Scarab(15, 10))
	map:addEntity(Rat(16, 4))
	map:addEntity(Rat(15, 4))
	map:addEntity(Rat(17, 4))
	map:addEntity(Rat(16, 5))
	map:addEntity(Rat(16, 6))

	self:writeUI()
end

function Play:writeUI()
	local display = self.display

	display:clear()

	for _,tile in pairs(self.border) do
		display:write(tile.symbol, tile.x, tile.y, tile.fg, tile.bg)
	end

	display:write(tostring(self.player.health), 2, 22, Colors.RED)
	display:write('\3', 3, 22, Colors.RED)

	display:write('Floor 1', 13, 22, Colors.GREEN)

	display:write(tostring(self.player.hooks), 26, 22, Colors.SILVER)
	display:write('\140', 27, 22, Colors.SILVER)

	display:write(tostring(self.player.torches), 29, 22, Colors.ORANGE)
	display:write('\235', 30, 22, Colors.ORANGE)
end

function Play:keypressed(key, scancode, isrepeat)

	local player = self.player


	if key == 'escape' and not isrepeat then
		Animations.endAll()
		Gamestate.switch(require 'states/start')
	end

	if not Animations.isEmpty() then return end

	if key == 'e' then
		Gamestate.push(require 'states/whip')
	end

	if key == 'q' then
		Gamestate.push(require 'states/torch')
	end

	if ActionKeys[key] then
		player:attack(ActionKeys[key])
	elseif MoveKeys[key] then
		local x = player.x + MoveKeys[key].x
		local y = player.y + MoveKeys[key].y

		if self.map:isWalkable(x, y) then
			player:moveTo(x, y)
			player.acted = true
		end
	end
end

function Play:update(dt)
	if self.player.acted and Animations.isEmpty() then
		self.map:computeAI()	
		self.player.acted = false
	end
	Animations.update(dt)
end
   
function Play:draw()
	self.map:write()
	Animations.write()
	self:writeUI()
	self.display:draw()
	self.map:draw()
end

return Play
