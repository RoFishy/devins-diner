-- // Packages
local Fusion = require("@Packages/Fusion")

-- // items
local RatingStar = require("@Interface/HUD/RatingStar")

-- // fusion
local Children = Fusion.Children

type RatingFrameProps = {
	Rating: Fusion.Value<number>,

	Position: Fusion.UsedAs<UDim2>,
}

-- init
local function RatingFrame(Scope: Fusion.Scope<typeof(Fusion)>, Props: RatingFrameProps)
	return Scope:New("Frame")({
		Name = "Rating",
		AnchorPoint = Vector2.new(0.5, 0),
		BackgroundTransparency = 1,
		Position = Props.Position,
		Size = UDim2.fromScale(0.267, 0.076),

		[Children] = {
			Scope:New("UIListLayout")({
				Name = "UIListLayout",
				FillDirection = Enum.FillDirection.Horizontal,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				SortOrder = Enum.SortOrder.LayoutOrder,
			}),
			Scope:ForValues({ 1, 2, 3, 4, 5 }, function(_, _, Value)
				return RatingStar(Scope, {
					Fill = Scope:Computed(function(Use)
						if Use(Props.Rating) > Value or Use(Props.Rating) == Value then
							return 0
						elseif Use(Props.Rating) < Value and Use(Props.Rating) <= Value - 1 then
							return 1
						else
							return 1 - (Use(Props.Rating) - (Value - 1))
						end
					end) :: any,
					LayoutOrder = typeof(Value) == "number" and Value or 0,
				})
			end) :: any,
		},
	})
end

return RatingFrame
