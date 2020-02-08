local Colors = require 'utility/colors'

local tileTypes = {}

local function newTile(tileType, seenfg, visiblefg, symbol, passable, blocks, hookable)
	t = {}
	t.tileType = tileType
	t.seenfg = seenfg
	t.visiblefg = visiblefg
	t.symbol = symbol
	t.passable = passable or false
	t.blocks = blocks or false
	t.hookable = hookable or false
	tileTypes[tileType] = t
end

newTile('Floor', Colors.GREY, Colors.WHITE, '\250', true, false)
newTile('Wall', Colors.GREY, Colors.YELLOW, '\35', false, true)
newTile('Hero', Colors.WHITE, Colors.WHITE , '\34', false, true)
newTile('Pit', Colors.PIT, Colors.PIT, '\219', false, false)
newTile('Hook', Colors.YELLOW, Colors.YELLOW, '\9', false, true, true)
newTile('Door', Colors.YELLOW, Colors.YELLOW, '\174', false, true)
newTile('OpenDoor', Colors.YELLOW, Colors.YELLOW, '\175', true, false)

return tileTypes
