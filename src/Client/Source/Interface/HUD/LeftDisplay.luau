-- // Packages
local Fusion = require("@Packages/Fusion")

-- // fusion
local Children = Fusion.Children

-- // stuff
local ButtonTemplate = require("@Interface/Components/ButtonTemplate")
local DisplayLabel = require("@Interface/HUD/DisplayLabel")

-- // types
type LeftDisplayProps = {
	Wallet: Fusion.Value<number>,
	Bank: Fusion.Value<number>,
	Bills: Fusion.Value<number>,

	Position: Fusion.UsedAs<UDim2>,
}

-- // init
local function LeftDisplay(Scope: Fusion.Scope<typeof(Fusion)>, Props: LeftDisplayProps)
	return Scope:New("Frame")({
		Name = "Displays",
		AnchorPoint = Vector2.new(0, 0.5),
		BackgroundTransparency = 1,
		Position = Props.Position,
		Size = UDim2.fromScale(0.249678, 0.285346),

		[Children] = {
			Scope:New("UIListLayout")({
				Name = "UIListLayout",
				Padding = UDim.new(0.05, 0),
				SortOrder = Enum.SortOrder.LayoutOrder,
				VerticalAlignment = Enum.VerticalAlignment.Center,
			}),

			Scope:New("UIPadding")({
				Name = "UIPadding",
				PaddingLeft = UDim.new(0.02, 0),
			}),

			DisplayLabel(Scope, {
				Name = "Cash",
				Text = "My Wallet",
				Amount = Props.Wallet,
				IconImage = "rbxassetid://101981048510476",
				BackgroundImage = "rbxassetid://85980078849006",
				StrokeColor = Color3.fromRGB(4, 80, 13),
				LayoutOrder = 1,

				[Fusion.Children] = {
					ButtonTemplate.ImageButton(Scope, {
						Name = "Add",
						Image = "rbxassetid://132295849234813",
						Position = UDim2.fromScale(0.876, 0.51),
						Size = UDim2.fromScale(0.170139, 0.684211),
						AnchorPoint = Vector2.new(0.5, 0.5),
						ZIndex = 2,

						[Children] = {
							Scope:New("UIAspectRatioConstraint")({
								Name = "UIAspectRatioConstraint",
								AspectRatio = 0.942308,
							}),
						},
					}),
				},
			}),
			DisplayLabel(Scope, {
				Name = "Bank",
				Text = "Server Bank",
				Amount = Props.Bank,
				IconImage = "rbxassetid://106512422808391",
				BackgroundImage = "rbxassetid://85980078849006",
				StrokeColor = Color3.fromRGB(4, 80, 13),
				LayoutOrder = 2,
			}),
			DisplayLabel(Scope, {
				Name = "Bills",
				Text = "Bills",
				Amount = Props.Bills,
				IconImage = "rbxassetid://113863967973860",
				BackgroundImage = "rbxassetid://130918231795339",
				StrokeColor = Color3.fromRGB(80, 4, 5),
				LayoutOrder = 3,
			}),
		},
	})
end

return LeftDisplay
