-- // Services
local SoundService = game:GetService("SoundService")

-- // Packages
local Fusion = require("@Packages/Fusion")

-- // Sounds
local Press = SoundService:WaitForChild("Press") :: Sound
local Hover = SoundService:WaitForChild("Hover") :: Sound

-- // fusion
local Children = Fusion.Children
local OnEvent = Fusion.OnEvent

-- // component
local Shimmer = require("@Interface/Components/Shimmer")

-- // types
type UsedAs<T> = Fusion.UsedAs<T>
type Scope<T> = Fusion.Scope<T>
type Child = Fusion.Child

type ButtonProps = {
	Name: UsedAs<string>,
	Position: UsedAs<UDim2>,
	AnchorPoint: UsedAs<Vector2>?,
	Size: UsedAs<UDim2>,

	BackgroundTransparency: UsedAs<number>?,
	ZIndex: UsedAs<number>?,
	LayoutOrder: UsedAs<number>?,
	BackgroundColor3: UsedAs<Color3>?,

	ImageColor3: UsedAs<Color3>?,
	Image: UsedAs<string>,

	Children: Child?,
	OnClick: () -> ()?,
}

local function ImageButton(Scope: Scope<typeof(Fusion)>, Props: ButtonProps)
	local Hovering = Scope:Value(false)
	local MouseDown = Scope:Value(false)

	return Scope:New("ImageButton")({
		Name = Props.Name,
		Size = Props.Size,
		Position = Props.Position,
		AnchorPoint = Props.AnchorPoint or Vector2.new(0.5, 0.5),

		BackgroundTransparency = Props.BackgroundTransparency or 1,
		BackgroundColor3 = Props.BackgroundColor3 or Color3.new(1, 1, 1),
		LayoutOrder = Props.LayoutOrder or 0,
		ZIndex = Props.ZIndex or 0,

		Image = Props.Image,
		ImageColor3 = Props.ImageColor3 or Color3.new(1, 1, 1),

		[Children] = {
			Scope:New("UIScale")({
				Scale = Scope:Tween(
					Scope:Computed(function(Use)
						if Use(Hovering) == false then
							return 1
						elseif Use(MouseDown) == false then
							return 1.15
						else
							return 0.75
						end
					end),
					TweenInfo.new(0.1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
				),
			}),
			Shimmer(Scope, {
				Enabled = Hovering,
				Corner = UDim.new(0.2, 0),
			}),
			Props[Children],
		},

		[OnEvent("MouseButton1Click")] = function()
			SoundService:PlayLocalSound(Press)
			if Props.OnClick then
				Props.OnClick()
			end
		end,

		[OnEvent("MouseEnter")] = function()
			SoundService:PlayLocalSound(Hover)
			Hovering:set(true)
		end,
		[OnEvent("MouseLeave")] = function()
			Hovering:set(false)
		end,
		[OnEvent("MouseButton1Down")] = function()
			MouseDown:set(true)
		end,
		[OnEvent("MouseButton1Up")] = function()
			MouseDown:set(false)
		end,
	})
end

return {
	ImageButton = ImageButton,
}
