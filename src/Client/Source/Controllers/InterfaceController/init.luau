-- // Services
local Lighting = game:GetService("Lighting")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

-- // plr
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local Camera = workspace.CurrentCamera
local Blur = Lighting:WaitForChild("Blur")

-- // utils
local Signals = require("@ClientUtility/Signals")

local TweenNumber = require("@Utility/TweenNumber")

-- // package
local Fusion = require("@Packages/Fusion")

-- // stuff
local HUD = require("@Interface/HUD")

local Interface = ReplicatedStorage:WaitForChild("Client"):WaitForChild("Interface")
local FrameModules = Interface:WaitForChild("Frames")

-- // scopes
local Scopes = require("@Controllers/InterfaceController/Scopes")

-- // Variables
local Values = require("@Controllers/InterfaceController/Values")

-- // const
local DEFAULT_FOV = 70
local ZOOMED_IN_FOV = 50
local DEFAULT_BLUR = 0
local BLURRED_AMOUNT = 25

local FrameOpen = Scopes.FrameScope:Value(false)

-- // Obj
local ScreenGui: ScreenGui

local InterfaceController = {
	CurrentFrame = nil :: string?,
	CurrentScope = nil :: Fusion.Scope<typeof(Fusion)>?,
}

function InterfaceController.Init(_: InterfaceController)
	ScreenGui = Instance.new("ScreenGui")
	ScreenGui.Name = "Interface"
	ScreenGui.ResetOnSpawn = false
	ScreenGui.IgnoreGuiInset = true
	ScreenGui.Parent = PlayerGui
end

function InterfaceController.Start(self: InterfaceController)
	Signals.PlayerDataChanged:Connect(function(OldData, NewData)
		TweenNumber(OldData.Cash, NewData.Cash, function(i)
			Values.Wallet:set(i)
		end)
		Values.Energy:set(NewData.Energy)
	end)

	task.delay(1, function()
		HUD(Scopes.HUDScope, {
			Parent = ScreenGui,
			Enabled = Values.HUDEnabled,
			Time = Values.Time,
			Rating = Values.Rating,

			Wallet = Values.Wallet,
			Bank = Values.Bank,
			Bills = Values.Bills,

			Energy = Values.Energy,

			Open = Values.Open,
		})
	end)

	Signals.CloseAllFrames:Connect(function()
		self:CloseAllFrames()
	end)

	Signals.OpenFrame:Connect(function(Name: string)
		if self.CurrentFrame and self.CurrentFrame == Name then
			self:CloseAllFrames()
			return
		end

		self:OpenFrame(Name)
	end)
end

function InterfaceController.CloseAllFrames(self: InterfaceController, KeepEffects: boolean?)
	if not KeepEffects then
		TweenService:Create(
			Camera,
			TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
			{ FieldOfView = DEFAULT_FOV }
		):Play()
		TweenService:Create(Blur, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
			Size = DEFAULT_BLUR,
		}):Play()
		Values.HUDEnabled:set(true)
	end

	self.CurrentFrame = nil
	FrameOpen:set(false)

	task.delay(0.2, function()
		if self.CurrentScope then
			local CurrentScope = self.CurrentScope :: Fusion.Scope<typeof(Fusion)>
			CurrentScope:doCleanup()
			self.CurrentScope = nil :: any
		end
	end)
end

function InterfaceController.OpenFrame(self: InterfaceController, Name: string)
	Values.HUDEnabled:set(false)

	if self.CurrentFrame then
		self:CloseAllFrames(true)
	end

	TweenService:Create(
		Camera,
		TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
		{ FieldOfView = ZOOMED_IN_FOV }
	):Play()
	TweenService:Create(Blur, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
		Size = BLURRED_AMOUNT,
	}):Play()

	self.CurrentFrame = Name
	self.CurrentScope = Scopes.FrameScope:innerScope()

	local FrameModule = (require)(FrameModules[Name])

	local CurrentScope = self.CurrentScope :: Fusion.Scope<typeof(Fusion)>
	FrameModule(CurrentScope, {
		Position = CurrentScope:Spring(
			CurrentScope:Computed(function(Use, _)
				if Use(FrameOpen) == false then
					return UDim2.fromScale(0.5, 0.9)
				else
					return UDim2.fromScale(0.5, 0.5)
				end
			end),
			25,
			0.5
		),
		Parent = CurrentScope:New("ScreenGui")({
			IgnoreGuiInset = true,
			Name = "Frames",
			Parent = game.Players.LocalPlayer.PlayerGui,
		}),
	})

	FrameOpen:set(true)
end

type InterfaceController = typeof(InterfaceController) & {
	CurrentFrame: string?,
	CurrentScope: Fusion.Scope<typeof(Fusion)>?,
}

return InterfaceController :: InterfaceController
