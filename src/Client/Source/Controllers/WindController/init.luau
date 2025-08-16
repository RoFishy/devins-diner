-- // Modules
local WindLines = require(script.WindLines)

-- // Const
local WIND_DIRECTION = Vector3.new(1, 0, 0.3)
local WIND_SPEED = 50

-- // init
local WindController = {}

function WindController:Start()
	WindLines:Init({
		Direction = WIND_DIRECTION,
		Speed = WIND_SPEED,
		Lifetime = 1.5,
		SpawnRate = 7,
	})
end

return WindController
