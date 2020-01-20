local Display = require 'lib/display'
local Gamestate = require 'lib/state'
local Directions = require 'utility/directions'
local TileTypes = require 'utility/tile-types'
local Colors = require 'utility/colors'
local WhipKeys, MoveKeys = (require 'utility/keys').getKeys()
local Map = require 'map'
local Player = require 'entities/player'
local Hook = require 'entities/hook'
local Mummy = require 'entities/mummy'
local AnimationManager = require 'animations'
local Util = require 'utility/util'

local Play = {}

function Play:init()
	love.keyboard.setKeyRepeat(true)

	self.display = Display:new({h = 23, w = 31}, nil, 2, {0, 0, 0}, Colors.DARKEST, {vsync = true}, nil, false)
	self.mapDisplay = Display:new({h = 19, w = 29}, {x = 32, y = 32}, 2, {0, 0, 0}, Colors.DARKEST, nil, nil, false)
	self.player = Player(5, 5)
	self.map = Map:new(29, 19, self.mapDisplay, true)
	self.animations = AnimationManager(self.mapDisplay)

	local map = self.map
	local display = self.display

	map:addEntity(self.player)
	map:addEntity(Mummy(10, 5))
	map:addEntity(Hook(20, 15))
	map:addEntity(Hook(24, 11))
	map:addEntity(Hook(19, 10))
	map:setTile(18, 15, TileTypes.Pit)
	map:setTile(17, 15, TileTypes.Pit)
	map:setTile(16, 15, TileTypes.Pit)

	local tiles = Util.parseCSV('assets/Mockup.csv')
	for _,tile in pairs(tiles) do
		display:write(tile.symbol, tile.x, tile.y, tile.fg, tile.bg)
	end
	display:write('Floor 1', 13, 22, Colors.GREEN)
	display:write('\3\3\3', 2, 22, Colors.BROWN)
	display:write('\235\235\235', 28, 22, Colors.ORANGE)
	display:write('\235', 28, 22, Colors.GREY)
	self:writeToggle()
	self:writeHealth()
end

function Play:writeToggle()
	self.display:write(self.player.toggle and 'P' or 'A', 24, 22, self.player.toggle and Colors.GREEN or Colors.YELLOW)
end

function Play:writeHealth()
	local display = self.display
	local player = self.player

	local red = ''
	for i = 1, player.health, 1 do
		red = red .. '\3'
	end
	display:write(red, 2, 22, Colors.BROWN)

	local grey = ''
	for i = 1, player.maxHealth - player.health, 1 do
		grey = grey .. '\3'
	end
	display:write(grey, player.health + 2, 22, Colors.GREY)
end

function Play:keypressed(key, scancode, isrepeat)
	if self.player.animating then return end

	local player = self.player

	if key == 'p' then
		Gamestate.switch(require 'states/start')
	end

	if key == 'e' then
		player.toggle = not player.toggle
		self:writeToggle()
	end

	if WhipKeys[key] then
		self:startAnimation(WhipKeys[key])
	elseif MoveKeys[key] then
		local x = player.x + MoveKeys[key].x
		local y = player.y + MoveKeys[key].y

		if self.map:isPassable(x, y) then
			player:moveTo(x, y)
		end
	end
end

function Play:startAnimation(direction)
	local length, entity = self:pullItem(direction)
	if length == 0 then return end

	local player = self.player

	player.animating = true
	local frame = {}

	for i = 1, length , 1 do
		frame[i] = {
			x = player.x + direction.x * i, 
			y = player.y + direction.y * i, 
			fg = Colors.BROWN, 
			bg = Colors.DARKEST, 
			symbol = direction.y == 0 and '~' or '\140'
		}
	end

	local onComplete = function () 
		player.animating = false
		if entity then
			if entity:is(Hook) then
				player:moveTo(player.x + direction.x * length, player.y + direction.y * length)
			end

			entity:moveTo(player.x + direction.x, player.y + direction.y)

			if self.map:getTile(entity.x, entity.y).tileType == 'Pit' then
				self.map:removeEntity(entity)
			end
		end
	end

	self.animations:addAnimation({frame, frame, frame}, onComplete)
end

function Play:pullItem(dir)
	for i = 1, 5 do
		local x = dir.x * i + self.player.x 
		local y = dir.y * i + self.player.y

		if self.map:isBlocked(x, y) then
			local entity = self.map:getEntityAt(x, y)
			return i - 1, entity
		end
	end
	return 4
end

function Play:update(dt)
	self.animations:update(dt)
end
   
function Play:draw()
	self.map:write()
	self.animations:write()
	self.display:draw()
	self.map:draw()
end

return Play
