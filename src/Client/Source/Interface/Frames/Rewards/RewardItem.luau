-- // Packages
local Fusion = require("@Packages/Fusion")

-- // Const
local REGULAR_BACKGROUND = "rbxassetid://88831126214608"
local CLAIMED_BACKGROUND = "rbxassetid://112041574690047"

local CLAIMED_TEXT_GRADIENT = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(192, 237, 26)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(83, 239, 9)),
})
local REGULAR_TEXT_GRADIENT = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(250, 251, 255)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(201, 213, 253)),
})

-- // util
local TimeUtils = require("@Utility/Time")

-- // fusion
local Children = Fusion.Children

-- // types
type UsedAs<T> = Fusion.UsedAs<T>
type Value<T> = Fusion.Value<T>
type Scope<T> = Fusion.Scope<T>
type RewardItemProps = {
	LayoutOrder: UsedAs<number>,
	Time: Value<number>,
	FrameState: Value<string>,
	Icon: UsedAs<string>,
	RewardName: UsedAs<string>,
}

local function RewardItem(Scope: Scope<typeof(Fusion)>, Props: RewardItemProps)
	return Scope:New("ImageLabel")({
		Name = "RewardItem",
		BackgroundTransparency = 1,
		Image = Scope:Computed(function(Use)
			if Use(Props.FrameState) == "Claimed" then
				return CLAIMED_BACKGROUND
			else
				return REGULAR_BACKGROUND
			end
		end),
		Size = UDim2.fromScale(0.18711, 0.975),
		LayoutOrder = Props.LayoutOrder,

		[Children] = {
			Scope:New("TextLabel")({
				Name = "TextLabel",
				AnchorPoint = Vector2.new(0.5, 1),
				BackgroundTransparency = 1,
				FontFace = Font.new("rbxasset://fonts/families/FredokaOne.json"),
				Position = UDim2.fromScale(0.5, 0.995492),
				Size = UDim2.fromScale(0.802808, 0.274529),
				Text = Props.RewardName,
				TextColor3 = Color3.fromRGB(4, 44, 80),
				TextScaled = true,
				ZIndex = 3,
				TextTransparency = Scope:Computed(function(Use)
					if Use(Props.FrameState) == "Locked" then
						return 0.5
					else
						return 0
					end
				end),

				[Children] = {
					Scope:New("UIPadding")({
						Name = "UIPadding",
						PaddingBottom = UDim.new(0.149123, 0),
						PaddingTop = UDim.new(0.149123, 0),
					}),
				},
			}),

			Scope:New("TextLabel")({
				Name = "TextLabel",
				AnchorPoint = Vector2.new(0.5, 0),
				BackgroundTransparency = 1,
				FontFace = Font.new("rbxasset://fonts/families/FredokaOne.json"),
				Position = UDim2.fromScale(0.497, 0.0253589),
				Size = UDim2.fromScale(0.724, 0.216094),
				Text = Scope:Computed(function(Use)
					if Use(Props.FrameState) == "Claimed" then
						return "CLAIMED"
					elseif Use(Props.FrameState) == "Next" and Use(Props.Time) <= 0 then
						return "CLAIM"
					else
						return `{TimeUtils.FormatHMS(Use(Props.Time))}`
					end
				end),
				TextColor3 = Color3.new(1, 1, 1),
				TextScaled = true,
				ZIndex = 3,

				[Children] = {
					Scope:New("UIGradient")({
						Name = "UIGradient",
						Color = Scope:Computed(function(Use)
							if Use(Props.FrameState) == "Claimed" then
								return CLAIMED_TEXT_GRADIENT
							else
								return REGULAR_TEXT_GRADIENT
							end
						end),
						Rotation = 90,
					}),

					Scope:New("UIPadding")({
						Name = "UIPadding",
						PaddingBottom = UDim.new(0.06, 0),
						PaddingTop = UDim.new(0.06, 0),
					}),

					Scope:New("UIStroke")({
						Name = "UIStroke",
						Color = Color3.fromRGB(29, 75, 20),
						Thickness = 3,
						Transparency = Scope:Computed(function(Use)
							if Use(Props.FrameState) == "Locked" then
								return 0.5
							else
								return 0
							end
						end),
					}),
				},
			}),

			Scope:New("ImageLabel")({
				Name = "p Burger Outline 256.png",
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundTransparency = 1,
				Image = Props.Icon,
				ImageTransparency = Scope:Computed(function(Use)
					if Use(Props.FrameState) == "Locked" then
						return 0.5
					else
						return 0
					end
				end),
				Position = UDim2.fromScale(0.5, 0.5),
				Size = UDim2.fromScale(0.661111, 0.508547),

				[Children] = {
					Scope:New("UIAspectRatioConstraint")({
						Name = "UIAspectRatioConstraint",
					}),

					Scope:New("ImageLabel")({
						Name = "Lock",
						AnchorPoint = Vector2.new(0.5, 0.5),
						BackgroundTransparency = 1,
						Image = "rbxassetid://81887867063213",
						Position = UDim2.fromScale(0.5, 0.5),
						Size = UDim2.fromScale(0.882353, 0.882353),
						Visible = Scope:Computed(function(Use)
							return Use(Props.FrameState) == "Locked"
						end),

						[Children] = {
							Scope:New("UIAspectRatioConstraint")({
								Name = "UIAspectRatioConstraint",
							}),
						},
					}),

					Scope:New("ImageLabel")({
						Name = "Check",
						AnchorPoint = Vector2.new(0.5, 0.5),
						BackgroundTransparency = 1,
						Image = "rbxassetid://114644689485791",
						Position = UDim2.fromScale(0.5, 0.5),
						Size = UDim2.fromScale(0.781513, 0.781513),
						Visible = Scope:Computed(function(Use)
							return Use(Props.FrameState) == "Claimed"
						end),

						[Children] = {
							Scope:New("UIAspectRatioConstraint")({
								Name = "UIAspectRatioConstraint",
							}),
						},
					}),
				},
			}),

			Scope:New("UIAspectRatioConstraint")({
				Name = "UIAspectRatioConstraint",
				AspectRatio = 0.769231,
			}),
		},
	})
end

return RewardItem
