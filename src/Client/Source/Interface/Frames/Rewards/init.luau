-- // Packages
local Fusion = require("@Packages/Fusion")

-- // fusion
local Children = Fusion.Children

-- // Types
type UsedAs<T> = Fusion.UsedAs<T>
type Scope<T> = Fusion.Scope<T>
type Value<T> = Fusion.Value<T>
type RewardProps = {
	Parent: UsedAs<Instance>,
	Position: UsedAs<UDim2>,
	State: Value<string>?,
	Time: Value<number>?,
}

-- // Components
local ButtonTemplate = require("@Interface/Components/ButtonTemplate")
local CloseButton = require("@Interface/Components/CloseButton")
local FrameTemplate = require("@Interface/Components/FrameTemplate")

local RewardItem = require("@Interface/Frames/Rewards/RewardItem")

-- // modules
local RewardsModule = require("@Shared/Config/Rewards")

-- // init
local function Rewards(Scope: Scope<typeof(Fusion)>, Props: RewardProps)
	return FrameTemplate(Scope, {
		Name = "Rewards",
		Size = UDim2.fromScale(0.538, 0.442),
		Image = "rbxassetid://111607019856423",
		Position = Props.Position,
		Parent = Props.Parent,

		Children = {
			Inner = {
				CloseButton(Scope, {
					Position = UDim2.fromScale(0.924658, 0.162474),
					Size = UDim2.fromScale(0.0958904, 0.213836),
					Frame = "Rewards",
					AspectRatio = 0.960784,
				}),
				Scope:New("UIAspectRatioConstraint")({
					Name = "UIAspectRatioConstraint",
					AspectRatio = 2.14256,
				}),

				Scope:New("Frame")({
					Name = "Frame",
					BackgroundTransparency = 1,
					Position = UDim2.fromScale(0.0313112, 0.366876),
					Size = UDim2.fromScale(0.942165, 0.503611),

					[Children] = {
						Scope:New("UIGridLayout")({
							Name = "UIGridLayout",
							CellPadding = UDim2.fromScale(0.0135135, 0.0541667),
							CellSize = UDim2.fromScale(0.18711, 0.975),

							[Children] = {
								Scope:New("UIAspectRatioConstraint")({
									Name = "UIAspectRatioConstraint",
									AspectRatio = 0.769231,
								}),
							},
						}),

						Scope:ForPairs(RewardsModule, function(_, _, Reward, Data)
							return Reward,
								RewardItem(Scope, {
									FrameState = Props.State or Scope:Value("Claimed"),
									LayoutOrder = Reward,
									Icon = Data.Image,
									Time = Props.Time or Scope:Value(600),
									RewardName = Data.RewardName,
								})
						end) :: any,
					},
				}),

				ButtonTemplate.ImageButton(Scope, {
					Name = "Claim",
					Image = "rbxassetid://110980130953993",
					Position = UDim2.fromScale(0.5, 0.98847),
					Size = UDim2.fromScale(0.262231, 0.209644),
					AnchorPoint = Vector2.new(0.5, 0.5),

					[Children] = {
						Scope:New("UIAspectRatioConstraint")({
							Name = "UIAspectRatioConstraint",
							AspectRatio = 2.68,
						}),
					},
				}),
			},
			Outer = {},
		},
	})
end

return Rewards
