local Gamestate = require 'lib/state'

local showDebug = false

function love.load(arg)
	love.window.setTitle('Talro')
	showDebug = arg[1] == 'debug'
	Gamestate.switch(require 'states/start')
end

function love.keypressed(key, scancode, isrepeat)
	Gamestate.keypressed(key)
end

function love.update(dt)	
	Gamestate.update(dt)
end

function love.draw() 
	Gamestate.draw()
	if showDebug then
		love.graphics.print("Current FPS: " .. tostring(love.timer.getFPS( )), 10, 10)
		love.graphics.print("Current garbage: " .. collectgarbage('count') .. ' KB', 10, 30)
	end
end
