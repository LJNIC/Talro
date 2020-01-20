local Directions = require 'utility/directions'

local keys = {}
function keys.getKeys() 
	return 
	{
		up = Directions.up,
		down =  Directions.down, 
		right = Directions.right, 
		left = Directions.left
	}, 
	{
		w = Directions.up,
		s = Directions.down,
		d = Directions.right,
		a = Directions.left
	}
end
return keys
