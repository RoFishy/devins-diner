-- // Classes
local Vehicle = require("@Services/VehicleService/Classes/Vehicle")

local VehicleService = {}

function VehicleService.Start(_: VehicleService)
	while task.wait(3) do
		task.spawn(function()
			Vehicle.new("Blue Sedan", false)
		end)
	end
end

type VehicleService = typeof(VehicleService)

return VehicleService :: VehicleService
