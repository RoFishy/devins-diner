-- // services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- // obj
local Cars = ReplicatedStorage.Assets.Cars :: Folder

-- // Classes
local Vehicle = require("@Services/VehicleService/Classes/Vehicle")

local function GetRandomCar()
	return Cars:GetChildren()[math.random(#Cars:GetChildren())].Name
end

local VehicleService = {}

function VehicleService.Start(_: VehicleService)
	while task.wait(2) do
		task.spawn(function()
			Vehicle.new(GetRandomCar(), true)
		end)
	end
end

type VehicleService = typeof(VehicleService)

return VehicleService :: VehicleService
