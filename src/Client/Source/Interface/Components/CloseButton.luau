-- // Packages
local Fusion = require("@Packages/Fusion")

-- // Components
local ButtonTemplate = require("@Interface/Components/ButtonTemplate")

-- // mod
local Signals = require("@ClientUtility/Signals")

-- // types
type UsedAs<T> = Fusion.UsedAs<T>
type Scope<T> = Fusion.Scope<T>
type CloseButtonProps = {
	Position: UsedAs<UDim2>,
	Frame: string,
	Size: UsedAs<UDim2>,
	AspectRatio: UsedAs<number>?,
}

local function CloseButton(Scope: Scope<typeof(Fusion)>, Props: CloseButtonProps)
	return ButtonTemplate.ImageButton(Scope, {
		Name = "Close",
		Image = "rbxassetid://135109674433249",
		Position = Props.Position,
		Size = Props.Size,
		ZIndex = 9,

		OnClick = function()
			Signals.OpenFrame:Fire(Props.Frame)
		end,

		Children = {
			Scope:New("UIAspectRatioConstraint")({
				AspectRatio = Props.AspectRatio or 1,
			}),
		},
	})
end

return CloseButton
