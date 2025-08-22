-- // Packages
local Fusion = require("@Packages/Fusion")

-- // type
type ShimmerProps = {
	Enabled: Fusion.Value<boolean>,
	Corner: Fusion.UsedAs<UDim>,
}

-- // init
local function Shimmer(Scope: Fusion.Scope<typeof(Fusion)>, Props: ShimmerProps)
	return Scope:New("Frame")({
		Name = "UIShimmer",
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BackgroundTransparency = 0,
		ClipsDescendants = true,
		Size = UDim2.new(1, 0, 1, 0),
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(0.5, 0, 0.5, 0),
		BorderSizePixel = 0,
		LayoutOrder = 9,

		[Fusion.Children] = {
			Scope:New("UICorner")({
				CornerRadius = Props.Corner,
			}),

			Scope:New("UIGradient")({
				Rotation = 15,
				Color = ColorSequence.new(Color3.new(1, 1, 1)),
				Transparency = NumberSequence.new({
					NumberSequenceKeypoint.new(0, 1),
					NumberSequenceKeypoint.new(0.15, 1),
					NumberSequenceKeypoint.new(0.5, 0.55),
					NumberSequenceKeypoint.new(0.85, 1),
					NumberSequenceKeypoint.new(1, 1),
				}),
				Offset = Scope:Tween(
					Scope:Computed(function(Use)
						if Use(Props.Enabled) == true then
							return Vector2.new(1, 0)
						else
							return Vector2.new(-1, 0)
						end
					end),
					TweenInfo.new(0.2, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut)
				),
			}),
		},
	})
end

return Shimmer
