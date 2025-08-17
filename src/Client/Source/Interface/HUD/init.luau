-- // Packages
local Fusion = require("@Packages/Fusion")

-- // stuff
local Button = require("@Interface/HUD/Button")
local EnergyBar = require("@Interface/HUD/EnergyBar")
local LeftDisplay = require("@Interface/HUD/LeftDisplay")
local RatingFrame = require("@Interface/HUD/RatingFrame")
local TimeLabel = require("@Interface/HUD/TimeLabel")

-- // fusion
local Children = Fusion.Children

-- // types
type Scope<T> = Fusion.Scope<T>
type HUDProps = {
	Parent: Instance,
	Enabled: Fusion.Value<boolean>,
	Time: Fusion.Value<string>,
	Rating: Fusion.Value<number>,

	Wallet: Fusion.Value<number>,
	Bank: Fusion.Value<number>,
	Bills: Fusion.Value<number>,

	Energy: Fusion.Value<number>,
}

-- // const
local TWEEN_INFO = TweenInfo.new(0.1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)

-- // init
local function HUD(Scope: Scope<typeof(Fusion)>, Props: HUDProps)
	return Scope:New("Frame")({
		Name = "HUD",
		Parent = Props.Parent,
		Size = UDim2.fromScale(1, 1),
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		BackgroundTransparency = 1,

		[Children] = {
			-- // Right Button Container
			Scope:New("Frame")({
				Name = "RightButtonContainer",
				AnchorPoint = Vector2.new(1, 0.5),
				BackgroundTransparency = 1,
				Position = Scope:Tween(
					Scope:Computed(function(Use)
						if Use(Props.Enabled) == true then
							return UDim2.fromScale(1, 0.5)
						else
							return UDim2.fromScale(1.1, 0.5)
						end
					end),
					TWEEN_INFO
				),
				Size = UDim2.fromScale(0.0847091, 0.794283),

				[Children] = {
					Scope:New("UIListLayout")({
						Padding = UDim.new(0.03, 0),
						FillDirection = "Vertical",
						SortOrder = "LayoutOrder",
						HorizontalAlignment = "Center",
						VerticalAlignment = "Center",
					}),

					Button.SquareButton(Scope, {
						Name = "Shop",
						LayoutOrder = 1,
						Position = UDim2.fromScale(0.202988, 1.90626),
						Size = UDim2.fromScale(0.756547, 0.153074),
						Icon = "rbxassetid://126107490822819",
						Text = "Shop",

						BackgroundImage = "rbxassetid://109569193211150",
						TextStrokeColor3 = Color3.fromRGB(80, 67, 4),
					}),

					Button.SquareButton(Scope, {
						Name = "Stats",
						LayoutOrder = 2,
						Position = UDim2.fromScale(0.202988, 1.90626),
						Size = UDim2.fromScale(0.756547, 0.153074),
						Icon = "rbxassetid://82066648762448",
						Text = "Stats",
					}),

					Button.SquareButton(Scope, {
						Name = "Quests",
						LayoutOrder = 3,
						Position = UDim2.fromScale(0.202988, 1.90626),
						Size = UDim2.fromScale(0.756547, 0.153074),
						Icon = "rbxassetid://85518157423469",
						Text = "Quests",
					}),

					Button.SquareButton(Scope, {
						Name = "Settings",
						LayoutOrder = 4,
						Position = UDim2.fromScale(0.202988, 1.90626),
						Size = UDim2.fromScale(0.756547, 0.153074),
						Icon = "rbxassetid://120764672303325",
						Text = "Settings",
					}),
				},
			}),

			-- // Top Stuff Holder
			Scope:New("Frame")({
				Name = "TopHolder",
				AnchorPoint = Vector2.new(0.5, 0),
				BackgroundTransparency = 1,
				Position = Scope:Tween(
					Scope:Computed(function(Use)
						if Use(Props.Enabled) == true then
							return UDim2.fromScale(0.5, 0)
						else
							return UDim2.fromScale(0.5, -0.13)
						end
					end),
					TWEEN_INFO
				),
				Size = UDim2.fromScale(0.465757, 0.153727),

				[Children] = {
					Scope:New("UIListLayout")({
						Name = "UIListLayout",
						FillDirection = Enum.FillDirection.Horizontal,
						HorizontalAlignment = Enum.HorizontalAlignment.Center,
						Padding = UDim.new(0.03, 0),
						SortOrder = Enum.SortOrder.LayoutOrder,
					}),

					Button.SquareButton(Scope, {
						Name = "Wheel",
						LayoutOrder = 1,
						Position = UDim2.fromScale(0.0618032, 2.12204),
						Size = UDim2.fromScale(0.123606, 0.694667),
						Icon = "rbxassetid://92540402780352",
						Text = "Lucky Spin",
					}),
					TimeLabel(Scope, { Time = Props.Time }),

					Button.SquareButton(Scope, {
						Name = "Rewards",
						LayoutOrder = 3,
						Position = UDim2.fromScale(0.0618032, 2.12204),
						Size = UDim2.fromScale(0.123606, 0.694667),
						Icon = "rbxassetid://84057639414523",
						Text = "Rewards",
					}),
				},
			}),

			-- // Rating area
			RatingFrame(Scope, {
				Rating = Props.Rating,
				Position = Scope:Tween(
					Scope:Computed(function(Use)
						if Use(Props.Enabled) == true then
							return UDim2.fromScale(0.5, 0.118171)
						else
							return UDim2.fromScale(0.5, -0.1)
						end
					end),
					TWEEN_INFO
				),
			}),

			-- // left holder
			LeftDisplay(Scope, {
				Wallet = Props.Wallet,
				Bank = Props.Bank,
				Bills = Props.Bills,

				Position = Scope:Tween(
					Scope:Computed(function(Use)
						if Use(Props.Enabled) == true then
							return UDim2.fromScale(0, 0.5)
						else
							return UDim2.fromScale(-0.5, 0.5)
						end
					end),
					TWEEN_INFO
				),
			}),

			-- // Energy Bar
			EnergyBar(Scope, {
				Energy = Props.Energy,
				Position = Scope:Tween(
					Scope:Computed(function(Use)
						if Use(Props.Enabled) == true then
							return UDim2.fromScale(0, 0.915793)
						else
							return UDim2.fromScale(-0.5, 0.915793)
						end
					end),
					TWEEN_INFO
				),
			}),
		},
	})
end

return HUD
