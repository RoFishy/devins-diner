-- // Services
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")

-- // pkg
local Replica = require("@Packages/Replica")

-- // Utils
local FSM = require("@Utility/FSM")

local DayClock = require("@Services/RestaurantService/Utils/DayClock")
local RestaurantTypes = require("@Services/RestaurantService/Utils/Types")

-- // States
local OpenState = require("@Services/RestaurantService/States/Open")

-- // const
local GameDataToken = Replica.Token("RestaurantData") :: any

local GameDataReplica =
	Replica.New({ Token = GameDataToken, Data = { Rating = 1, Open = false, GameTime = "00:00 AM" } })

-- // vars
local Config: RestaurantTypes.Config = {
	IncrementDelay = 0.75,
	Hours = {
		Open = {
			StartHour = 6,
			StartMinute = 0,
		},
		Close = {
			StartHour = 22,
			StartMinute = 0,
		},
	},
}

local RestaurantService = {}

function RestaurantService.Init(_: RestaurantService)
	DayClock.New({
		IncrementDelay = Config.IncrementDelay,
	})
	GameDataReplica:Replicate()
end

function RestaurantService.Start(_: RestaurantService)
	local Machine = FSM.new(OpenState, Config)

	RunService.Heartbeat:Connect(function(DeltaTime)
		Machine:Tick(DeltaTime)
	end)

	Lighting:GetPropertyChangedSignal("ClockTime"):Connect(function()
		local Time = Lighting.TimeOfDay
		local Split = Time:split(":")

		local Hour = tonumber(Split[1])
		local Minute = Split[2]

		local Suffix = "AM"

		local Open = true

		if Hour < Config.Hours.Open.StartHour or Hour >= Config.Hours.Close.StartHour then
			Open = false
		end

		if Hour and Hour > 12 then
			Hour = Hour - 12
			Suffix = "PM"
		elseif Hour and Hour == 12 then
			Suffix = "PM"
		end

		GameDataReplica:Set({ "GameTime" }, `{Hour}:{Minute}  {Suffix}`)
		GameDataReplica:Set({ "Open" }, Open)
	end)
end

type RestaurantService = typeof(RestaurantService)

return RestaurantService :: RestaurantService
