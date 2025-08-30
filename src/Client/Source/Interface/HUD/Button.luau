-- // Packages
local Fusion = require("@Packages/Fusion")

-- // components
local ButtonTemplate = require("@Interface/Components/ButtonTemplate")

-- // util
local Signals = require("@ClientUtility/Signals")

-- // fusion
local Children = Fusion.Children

-- // Types
type UsedAs<T> = Fusion.UsedAs<T>
type Scope<T> = Fusion.Scope<T>
type Child = Fusion.Child

type SquareButtonProps = {
	Text: UsedAs<string>,
	TextStrokeColor3: UsedAs<Color3>?,
	Icon: UsedAs<string>,
	Name: UsedAs<string>,
	Position: UsedAs<UDim2>,
	Size: UsedAs<UDim2>,

	LayoutOrder: UsedAs<number>?,

	BackgroundImage: UsedAs<string>?,

	Children: Child?,
	Frame: string?,
	Callback: () -> ()?,
}

-- // const
local DEFAULT_IMAGE = "rbxassetid://80615104488459"
local DEFAULT_TEXT_STROKE = Color3.fromRGB(4, 45, 80)

-- // button
local function SquareButton(Scope: Scope<typeof(Fusion)>, Props: SquareButtonProps)
	return ButtonTemplate.ImageButton(Scope, {
		Name = Props.Name,
		Image = Props.BackgroundImage or DEFAULT_IMAGE,
		Size = Props.Size,
		Position = Props.Position,
		LayoutOrder = Props.LayoutOrder or 0,
		AnchorPoint = Vector2.new(0.5, 1),

		OnClick = function()
			if Props.Frame then
				Signals.OpenFrame:Fire(Props.Frame)
			end
			if Props.Callback then
				Props.Callback()
			end
		end,

		[Children] = {
			Scope:New("UIAspectRatioConstraint")({
				AspectRatio = 0.991,
			}),

			Scope:New("ImageLabel")({
				BackgroundTransparency = 1,
				Image = Props.Icon,
				Size = UDim2.fromScale(0.641, 0.635),
				Position = UDim2.fromScale(0.5, 0.5),
				AnchorPoint = Vector2.new(0.5, 0.5),
			}),

			Scope:New("TextLabel")({
				AnchorPoint = Vector2.new(0.5, 1),
				Position = UDim2.fromScale(0.5, 1.05394),
				Size = UDim2.fromScale(1.21116, 0.261006),

				BackgroundTransparency = 1,
				FontFace = Font.new("rbxasset://fonts/families/FredokaOne.json"),
				Text = Props.Text,
				TextColor3 = Color3.new(1, 1, 1),
				TextScaled = true,

				[Children] = {
					Scope:New("UIStroke")({
						Color = Props.TextStrokeColor3 or DEFAULT_TEXT_STROKE,
						Thickness = 2.8,
					}),
				},
			}),
		},
	})
end

return {
	SquareButton = SquareButton,
}
