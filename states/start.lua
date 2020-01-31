local Charm = require 'lib/charm'
local Gamestate = require 'lib/state'
local Colors = require 'utility/colors'
local Settings = require 'settings'

local Start = {}

function Start:init()
	self.title = {image = love.graphics.newImage('assets/talro.png')}
	love.window.setMode(992, 736)
	love.graphics.setBackgroundColor(0, 0, 0)
	self.layout = Charm.new()
end

function Start:draw()
	local layout = self.layout
	love.graphics.setColor(Colors.DARKEST)
	love.graphics.rectangle('fill', 0, 0, 992, 736)
	--[[
	love.graphics.setColor(1, 1, 1)
	love.graphics.draw(self.title.image, self.title.x, self.title.y)
	--]]
	layout
		:new('rectangle', Settings.WIDTH/8, Settings.HEIGHT/8)
			:width(Settings.WIDTH - Settings.WIDTH/4)
			:height(Settings.HEIGHT - Settings.HEIGHT/4)
			:beginChildren()
				:new('image', self.title.image)
					:left(layout:get('@current', 'width') / 2)
					:color(1, 1, 1, 1)
			:endChildren()
		:draw()
end

function Start:keypressed(key, scancode, isrepeat)
	if key == 'escape' then 
		if not isrepeat then love.event.quit(0) end
	else
		Gamestate.switch(require 'states/play')
	end

end

return Start
