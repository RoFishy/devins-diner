-- // Packages
local Component = require("@Packages/Component") :: any
local Janitor = require("@Packages/Janitor")
local ZonePlus = require("@Packages/ZonePlus")

-- // Modules
local Network = require("@Shared/Network")
local TouchZone = require("@Utility/TouchZone")

-- // types
type DoorModel = Model & {
	Door1: Model,
	Door: Model,
	OpenZone: Model & {
		Inside: Part,
		Outside: Part,
	},
}

-- // Constants
local TWEEN_INFO = {
	0.5,
	Enum.EasingStyle.Bounce,
	Enum.EasingDirection.Out,
} :: { Enum.EasingDirection | Enum.EasingStyle | number }

-- // Init
local Door = Component.new({
	Tag = "Door",
	Ancestors = { workspace },
})

function Door:Construct()
	self._janitor = Janitor.new()
end

function Door:Start()
	local Model = self.Instance :: DoorModel

	local OpenZone = TouchZone(Model.OpenZone)

	self._janitor:Add(OpenZone)

	local DoorOpened = false
	local DoorDefaultCFrame = Model.Door:GetPivot()
	local Door1DefaultCFrame = Model.Door1:GetPivot()

	local MainZone = ZonePlus.new(Model.OpenZone)

	local function OpenDoors(Direction: "Inside" | "Outside")
		DoorOpened = true

		local DoorOrientation: number
		if Direction == "Inside" then
			DoorOrientation = 125
		else
			DoorOrientation = -125
		end

		local DoorFinal = DoorDefaultCFrame * CFrame.Angles(0, math.rad(DoorOrientation), 0)
		local Door1Final = Door1DefaultCFrame * CFrame.Angles(0, math.rad(-DoorOrientation), 0)

		Network.Utility.TweenModel.Position:fireAll(Model.Door, DoorFinal, TWEEN_INFO)

		Network.Utility.TweenModel.Position:fireAll(Model.Door1, Door1Final, TWEEN_INFO)

		task.delay(0.6, function()
			Model.Door1:PivotTo(Door1Final)
			Model.Door:PivotTo(DoorFinal)
		end)
	end
	local function CloseDoors()
		DoorOpened = false

		Network.Utility.TweenModel.Position:fireAll(Model.Door, DoorDefaultCFrame, TWEEN_INFO)

		Network.Utility.TweenModel.Position:fireAll(Model.Door1, Door1DefaultCFrame, TWEEN_INFO)

		task.delay(0.6, function()
			Model.Door1:PivotTo(Door1DefaultCFrame)
			Model.Door:PivotTo(DoorDefaultCFrame)
		end)
	end

	OpenZone.partTouched(function(_Model: Model)
		if _Model:FindFirstChildOfClass("Humanoid") then
			MainZone:trackItem(_Model)
			if not DoorOpened then
				task.wait(0.2)
				local InsideParts = workspace:GetPartsInPart(Model.OpenZone.Inside)
				for _, Part in InsideParts do
					if Part.Parent and Part.Parent:FindFirstChildOfClass("Humanoid") then
						OpenDoors("Inside")
						return
					end
				end

				local OutsideParts = workspace:GetPartsInPart(Model.OpenZone.Outside)
				for _, Part in OutsideParts do
					if Part.Parent and Part.Parent:FindFirstChildOfClass("Humanoid") then
						OpenDoors("Outside")
						return
					end
				end
			end
		end
	end)

	MainZone.itemExited:Connect(function(item)
		MainZone:untrackItem(item)

		task.wait(0.2)
		local InsideParts = workspace:GetPartsInPart(Model.OpenZone.Inside)
		for _, Part in InsideParts do
			if Part.Parent and Part.Parent:FindFirstChildOfClass("Humanoid") then
				return
			end
		end

		local OutsideParts = workspace:GetPartsInPart(Model.OpenZone.Outside)
		for _, Part in OutsideParts do
			if Part.Parent and Part.Parent:FindFirstChildOfClass("Humanoid") then
				return
			end
		end

		CloseDoors()
	end)
end

function Door:Stop()
	self._janitor:Cleanup()
end

return Door
