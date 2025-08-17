-- // Services
local Players = game:GetService("Players")

-- // plr
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- // Packages
local Fusion = require("@Packages/Fusion")

-- // utils
local Signals = require("@ClientUtility/Signals")

local Network = require("@Shared/Network")

-- // stuff
local HUD = require("@Interface/HUD")

-- // scopes
local UIScope = Fusion.scoped(Fusion)
local HUDScope = UIScope:innerScope()

-- // Variables
local Time = UIScope:Value("10:00 AM")
local HUDEnabled = UIScope:Value(true)
local Rating = UIScope:Value(0)

local Wallet = UIScope:Value(0)
local Bank = UIScope:Value(0)
local Bills = UIScope:Value(0)

local Energy = UIScope:Value(0)

-- // Obj
local ScreenGui: ScreenGui

local InterfaceController = {}

function InterfaceController:Init()
	ScreenGui = Instance.new("ScreenGui")
	ScreenGui.Name = "Interface"
	ScreenGui.ResetOnSpawn = false
	ScreenGui.IgnoreGuiInset = true
	ScreenGui.Parent = PlayerGui
end

function InterfaceController:Start()
	Network.Data.SyncData:connect(function(Data)
		Wallet:set(Data.Cash)
		Energy:set(Data.Energy)
	end)

	HUD(HUDScope, {
		Parent = ScreenGui,
		Enabled = HUDEnabled,
		Time = Time,
		Rating = Rating,

		Wallet = Wallet,
		Bank = Bank,
		Bills = Bills,

		Energy = Energy,
	})

	Signals.CloseAllFrames:Connect(function() end)

	Signals.OpenFrame:Connect(function() end)
end

return InterfaceController
