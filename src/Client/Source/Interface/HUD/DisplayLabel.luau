-- // Packages
local Fusion = require("@Packages/Fusion")

-- // util
local FormatNumber = require("@Utility/FormatNumber")

-- // fusion
local Children = Fusion.Children

-- // types
type UsedAs<T> = Fusion.UsedAs<T>
type Child = Fusion.Child
type DisplayLabelProps = {
	BackgroundImage: UsedAs<string>,
	Name: UsedAs<string>,
	Text: UsedAs<string>,
	LayoutOrder: UsedAs<number>,

	IconImage: UsedAs<string>,
	Amount: Fusion.Value<number>,

	StrokeColor: UsedAs<Color3>,

	Children: Child?,
}

-- // init
local function DisplayLabel(Scope: Fusion.Scope<typeof(Fusion)>, Props: DisplayLabelProps)
	return Scope:New("ImageLabel")({
		Name = Props.Name,
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundTransparency = 1,
		LayoutOrder = Props.LayoutOrder,
		Image = Props.BackgroundImage,
		Position = UDim2.fromScale(0.424581, 0.203808),
		Size = UDim2.fromScale(0.723254, 0.277508),

		[Children] = {
			Scope:New("UIAspectRatioConstraint")({
				Name = "UIAspectRatioConstraint",
				AspectRatio = 3.78947,
			}),

			Scope:New("ImageLabel")({
				Name = "IconImage",
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundTransparency = 1,
				Image = Props.IconImage,
				Position = UDim2.fromScale(0.130332, 0.5),
				Size = UDim2.fromScale(0.173611, 0.657895),
			}),

			Scope:New("TextLabel")({
				Name = "AmountLabel",
				BackgroundTransparency = 1,
				FontFace = Font.new("rbxasset://fonts/families/FredokaOne.json"),
				Position = UDim2.fromScale(0.240487, 0.170881),
				Size = UDim2.fromScale(0.479416, 0.658238),
				Text = Scope:Computed(function(Use)
					return `${FormatNumber.Comma(Use(Props.Amount))}`
				end),
				TextColor3 = Color3.new(1, 1, 1),
				TextScaled = true,

				[Children] = {
					Scope:New("UIStroke")({
						Name = "UIStroke",
						Color = Props.StrokeColor,
						Thickness = 3.0308,
					}),
				},
			}),

			Scope:New("TextLabel")({
				Name = "Label",
				BackgroundTransparency = 1,
				FontFace = Font.new("rbxasset://fonts/families/FredokaOne.json"),
				Position = UDim2.fromScale(0.0386728, -0.188341),
				Size = UDim2.fromScale(0.368852, 0.368477),
				Text = Props.Text,
				TextColor3 = Color3.new(1, 1, 1),
				TextScaled = true,

				[Children] = {
					Scope:New("UIStroke")({
						Name = "UIStroke",
						Color = Props.StrokeColor,
						Thickness = 3.0308,
					}),
				},
			}),

			Props[Children],
		},
	})
end

return DisplayLabel
