local Object = require 'lib/classic'
local List = require 'lib/list'

local AnimationManager = {}
local FPS = 0.08
local animations = List.new()
local display

function AnimationManager.init(d)
	display = d
end

--[[
Frame definition:
	{{x, y, fg, bg, symbol}, {x, y, fg, bg, symbol}}
--]]
function AnimationManager.addAnimation(frames, onComplete)
	animations:add({frames = frames, time = 0, index = 1, onComplete = onComplete})
end

function AnimationManager.update(dt)
	for i = animations.size, 1, -1 do
		local animation = animations:get(i)
		animation.time = animation.time + dt

		if animation.time >= FPS then
			animation.index = animation.index + 1

			if not (animation.index > #animation.frames) then
				animation.time = 0
			else
				if animation.onComplete then animation.onComplete() end
				animations:remove(animation, i)
			end
		end
	end
end

function AnimationManager.write()
	for i = 1, animations.size do
		local animation = animations:get(i)
		for _,tile in ipairs(animation.frames[animation.index]) do
			display:write(tile.symbol, tile.x, tile.y, tile.fg, tile.bg)
		end
	end
end

return AnimationManager
