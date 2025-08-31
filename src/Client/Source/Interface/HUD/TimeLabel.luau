-- // Packages
local Fusion = require("@Packages/Fusion")

-- // fujsion
local Children = Fusion.Children

-- // types
type TimeLabelProps = {
	Time: Fusion.Value<string>,
}

-- // init
local function TimeLabel(Scope: Fusion.Scope<typeof(Fusion)>, Props: TimeLabelProps)
	return Scope:New("ImageLabel")({
		Name = "TimeContainer",
		AnchorPoint = Vector2.new(0.5, 0),
		BackgroundTransparency = 1,
		Image = "rbxassetid://96383385686057",
		Position = UDim2.fromScale(0.5, 0.0160716),
		Size = UDim2.fromScale(0.486, 0.722),
		LayoutOrder = 2,

		[Children] = {
			Scope:New("UIAspectRatioConstraint")({
				Name = "UIAspectRatioConstraint",
				AspectRatio = 3.78095,
			}),

			Scope:New("ImageLabel")({
				Name = "Icon",
				AnchorPoint = Vector2.new(0.5, 0),
				BackgroundTransparency = 1,
				Image = "rbxassetid://139681687522187",
				Position = UDim2.fromScale(0.120588, 0.206699),
				Size = UDim2.fromScale(0.151134, 0.571429),

				[Children] = {
					Scope:New("UIAspectRatioConstraint")({
						Name = "UIAspectRatioConstraint",
					}),
				},
			}),

			Scope:New("TextLabel")({
				Name = "TimeLabel",
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundTransparency = 1,
				FontFace = Font.new("rbxasset://fonts/families/FredokaOne.json"),
				Position = UDim2.fromScale(0.5, 0.5),
				Size = UDim2.fromScale(0.529243, 0.505025),
				Text = Props.Time,
				TextColor3 = Color3.new(1, 1, 1),
				TextScaled = true,

				[Children] = {
					Scope:New("UIStroke")({
						Name = "UIStroke",
						Color = Color3.fromRGB(80, 53, 4),
						Thickness = 3.9519,
					}),
				},
			}),
		},
	})
end

return TimeLabel
