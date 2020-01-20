local Colors = require 'utility/colors'
local Gamestate = require 'lib/state'

local Start = {}

function Start:init()
	self.title = {image = love.graphics.newImage('assets/talro.png')}
	self.title.x = 992/2 - self.title.image:getWidth()/2
	self.title.y = 736/2 - self.title.image:getHeight() - 50
	love.window.setMode(992, 736)
	love.graphics.setBackgroundColor(0, 0, 0)
end

function Start:draw()
	love.graphics.setColor(Colors.DARKEST)
	love.graphics.rectangle('fill', 0, 0, 992, 736)
	love.graphics.setColor(1, 1, 1)
	love.graphics.draw(self.title.image, self.title.x, self.title.y)
end

function Start:keypressed()
	Gamestate.switch(require 'states/play')
end

return Start
