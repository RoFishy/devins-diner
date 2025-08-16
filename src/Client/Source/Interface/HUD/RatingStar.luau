-- // Packages
local Fusion = require("@Packages/Fusion")

-- // fusion
local Children = Fusion.Children

-- // types
type UsedAs<T> = Fusion.UsedAs<T>
type StarProps = {
	LayoutOrder: UsedAs<number>,
	Fill: number,
}

local function RatingStar(Scope: Fusion.Scope<typeof(Fusion)>, Props: StarProps)
	return Scope:New("ImageLabel")({
		BackgroundTransparency = 1,
		LayoutOrder = Props.LayoutOrder,
		Image = "rbxassetid://88261898019153",
		ScaleType = Enum.ScaleType.Fit,
		Size = UDim2.fromScale(0.163621, 1),

		[Children] = {
			Scope:New("UIGradient")({
				Name = "UIGradient",
				Color = Scope:Computed(function(Use)
					local FillAmount = Use(Props.Fill) or 0

					return ColorSequence.new({
						ColorSequenceKeypoint.new(0, Color3.fromRGB(23, 23, 23)), -- Dark (empty)
						ColorSequenceKeypoint.new(FillAmount, Color3.fromRGB(23, 23, 23)), -- Dark until fill point
						ColorSequenceKeypoint.new(math.min(FillAmount + 0.001, 1), Color3.new(1, 1, 1)), -- Transition to white
						ColorSequenceKeypoint.new(1, Color3.new(1, 1, 1)), -- White (filled)
					})
				end),
				Rotation = 180,
			}),
		},
	})
end

return RatingStar
