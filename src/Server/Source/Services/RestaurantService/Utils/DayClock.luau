-- // services
local Lighting = game:GetService("Lighting")

-- // pkg
local Janitor = require("@Packages/Janitor")

type DayConfig = {
	IncrementDelay: number,
}

local DayClock = {}

export type DayClock = typeof(DayClock) & {
	_rate: number,
	_day: number,

	_janitor: Janitor.Janitor,
}

function DayClock.New(cfg: DayConfig)
	local self = setmetatable({}, DayClock)
	self._rate = cfg.IncrementDelay
	self._day = 1

	Lighting.ClockTime = 0

	self._janitor = Janitor.new()

	self._janitor:Add(task.spawn(function()
		while task.wait(self._rate) do
			local PreviousClocktime = Lighting.ClockTime
			Lighting.ClockTime = (Lighting.ClockTime + (1 / 60)) % 24
			local NewTime = Lighting.ClockTime

			if NewTime < PreviousClocktime then
				self._day += 1
			end
		end
	end))
end

function DayClock.GetDay(self: DayClock)
	return self._day
end

function DayClock.Destroy(self: DayClock)
	self._janitor:Cleanup()
end

return DayClock
