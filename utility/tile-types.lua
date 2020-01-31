local Colors = require 'utility/colors'

local tileTypes = {}

function tileTypes:newTile(tileType, seenfg, visiblefg, symbol, passable, blocks, hookable)
	t = {}
	t.tileType = tileType
	t.seenfg = seenfg
	t.visiblefg = visiblefg
	t.symbol = symbol
	t.passable = passable or false
	t.blocks = blocks or false
	t.hookable = hookable or false
	self[tileType] = t
end

tileTypes:newTile('Floor', Colors.GREY, Colors.WHITE, '\250', true, false)
tileTypes:newTile('Wall', Colors.GREY, Colors.YELLOW, '\35', false, true)
tileTypes:newTile('Hero', Colors.WHITE, Colors.WHITE , '\34', false, true)
tileTypes:newTile('Pit', Colors.PIT, Colors.PIT, ' ', false, false)
tileTypes:newTile('Hook', Colors.YELLOW, Colors.YELLOW, '\9', false, true, true)

return tileTypes
