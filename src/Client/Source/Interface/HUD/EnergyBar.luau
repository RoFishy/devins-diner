-- // Packages
local Fusion = require("@Packages/Fusion")

-- // fusion
local Children = Fusion.Children

-- // types
type EnergyBarProps = {
	Energy: Fusion.Value<number>,
	Position: Fusion.UsedAs<UDim2>,
}

-- // init
local function EnergyBar(Scope: Fusion.Scope<typeof(Fusion)>, Props: EnergyBarProps)
	return Scope:New("ImageLabel")({
		Name = "Energy",
		AnchorPoint = Vector2.new(0, 0.5),
		BackgroundTransparency = 1,
		Image = "rbxassetid://118647641664328",
		ImageColor3 = Color3.fromRGB(127, 119, 0),
		Position = Props.Position,
		Size = UDim2.fromScale(0.189375, 0.0920319),

		[Children] = {
			Scope:New("ImageLabel")({
				Name = "IconImage",
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundTransparency = 1,
				Image = "rbxassetid://85810033169765",
				Position = UDim2.fromScale(0.128483, 0.5),
				ScaleType = Enum.ScaleType.Fit,
				Size = UDim2.fromScale(0.173611, 0.657895),
				ZIndex = 2,

				[Children] = {
					Scope:New("UIAspectRatioConstraint")({
						Name = "UIAspectRatioConstraint",
					}),
				},
			}),

			Scope:New("TextLabel")({
				Name = "Label",
				BackgroundTransparency = 1,
				FontFace = Font.new("rbxasset://fonts/families/FredokaOne.json"),
				Position = UDim2.fromScale(0.0386729, -0.188341),
				Size = UDim2.fromScale(0.232863, 0.368477),
				Text = "Energy",
				TextColor3 = Color3.new(1, 1, 1),
				TextScaled = true,
				ZIndex = 2,

				[Children] = {
					Scope:New("UIStroke")({
						Name = "UIStroke",
						Color = Color3.fromRGB(80, 39, 4),
						Thickness = 3.0308,
					}),
				},
			}),

			Scope:New("UIAspectRatioConstraint")({
				Name = "UIAspectRatioConstraint",
				AspectRatio = 3.78947,
			}),

			Scope:New("CanvasGroup")({
				Name = "CanvasGroup",
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundTransparency = 1,
				Position = UDim2.fromScale(0.5, 0.5),
				Size = UDim2.fromScale(0.98, 0.98),
				ZIndex = -1,

				[Children] = {
					Scope:New("UICorner")({
						Name = "UICorner",
						CornerRadius = UDim.new(0.3, 0),
					}),

					Scope:New("ImageLabel")({
						Name = "Bar",
						AnchorPoint = Vector2.new(0, 0.5),
						BackgroundTransparency = 1,
						ClipsDescendants = true,
						Image = "rbxassetid://118647641664328",
						Position = UDim2.fromScale(0, 0.506367),
						ScaleType = Enum.ScaleType.Crop,
						Size = Scope:Tween(
							Scope:Computed(function(Use)
								return UDim2.fromScale(1 * (Use(Props.Energy) / 100), 1)
							end),
							TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
						),
						ZIndex = 1,

						[Children] = {
							Scope:New("UICorner")({
								Name = "UICorner",
								CornerRadius = UDim.new(0.3, 0),
							}),

							Scope:New("UIStroke")({
								Name = "UIStroke",
								Color = Color3.fromRGB(80, 39, 4),
								Thickness = 3.5,
							}),
						},
					}),
				},
			}),
		},
	})
end

return EnergyBar
