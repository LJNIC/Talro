local Object = require 'lib/classic'
local List = require 'lib/list'

local AnimationManager = Object:extend()
AnimationManager.FPS = 0.08

function AnimationManager:new(display)
	self.animations = List.new()
	self.display = display
end

--[[
Frame definition:
	{{x, y, fg, bg, symbol}, {x, y, fg, bg, symbol}}
--]]
function AnimationManager:addAnimation(frames, onComplete)
	self.animations:add({frames = frames, time = 0, index = 1, onComplete = onComplete})
end

function AnimationManager:update(dt)
	for i = self.animations.size, 1, -1 do
		local animation = self.animations:get(i)
		animation.time = animation.time + dt

		if animation.time >= AnimationManager.FPS then
			animation.index = animation.index + 1

			if not (animation.index > #animation.frames) then
				animation.time = 0
			else
				if animation.onComplete then animation.onComplete() end
				self.animations:remove(animation, i)
			end
		end
	end
end

function AnimationManager:write()
	for i = 1, self.animations.size do
		local animation = self.animations:get(i)
		for _,tile in ipairs(animation.frames[animation.index]) do
			self.display:write(tile.symbol, tile.x, tile.y, tile.fg, tile.bg)
		end
	end
end

return AnimationManager
