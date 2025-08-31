-- // Packages
local Fusion = require("@Packages/Fusion")

-- // Const
local OPEN_IMAGE = "rbxassetid://85980078849006"
local CLOSED_IMAGE = "rbxassetid://130918231795339"

local OPEN_STROKE_COLOR = Color3.fromRGB(4, 80, 13)
local CLOSED_STROKE_COLOR = Color3.fromRGB(80, 4, 5)

-- // type
type StatusLabelProps = {
	Open: Fusion.Value<boolean>,
	Position: Fusion.UsedAs<UDim2>,
}

-- // init
local function StatusLabel(Scope: Fusion.Scope<typeof(Fusion)>, Props: StatusLabelProps)
	return Scope:New("ImageLabel")({
		Name = "Status",
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundTransparency = 1,
		Image = Scope:Computed(function(Use)
			if Use(Props.Open) == true then
				return OPEN_IMAGE
			else
				return CLOSED_IMAGE
			end
		end),
		Position = Props.Position,
		Size = UDim2.fromScale(0.128594, 0.0684375),

		[Fusion.Children] = {
			Scope:New("UIAspectRatioConstraint")({
				Name = "UIAspectRatioConstraint",
				AspectRatio = 3.78947,
			}),

			Scope:New("TextLabel")({
				Name = "Label",
				BackgroundTransparency = 1,
				FontFace = Font.new("rbxasset://fonts/families/FredokaOne.json"),
				Position = UDim2.fromScale(0.216075, 0.0985763),
				Size = UDim2.fromScale(0.571399, 0.78453),
				Text = Scope:Computed(function(Use)
					if Use(Props.Open) == true then
						return "OPEN"
					else
						return "CLOSED"
					end
				end),
				TextColor3 = Color3.new(1, 1, 1),
				TextScaled = true,

				[Fusion.Children] = {
					Scope:New("UIStroke")({
						Name = "UIStroke",
						Color = Scope:Computed(function(Use)
							if Use(Props.Open) == true then
								return OPEN_STROKE_COLOR
							else
								return CLOSED_STROKE_COLOR
							end
						end),
						Thickness = 3.0308,
					}),
				},
			}),
		},
	})
end

return StatusLabel
