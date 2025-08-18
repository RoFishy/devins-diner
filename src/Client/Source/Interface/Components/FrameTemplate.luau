-- // Packages
local Fusion = require("@Packages/Fusion")

-- // fusion
local Children = Fusion.Children

-- // Types
type UsedAs<T> = Fusion.UsedAs<T>
type Child = Fusion.Child
type Scope<T> = Fusion.Scope<T>

type FrameTemplateProps = {
	Name: UsedAs<string>,
	Size: UsedAs<UDim2>,
	Image: UsedAs<string>,
	Position: UsedAs<UDim2>?,
	Parent: UsedAs<Instance>,

	Children: {
		Inner: Child,
		Outer: Child,
	},
}

local function FrameTemplate(Scope: Scope<typeof(Fusion)>, Props: FrameTemplateProps)
	return Scope:New("Frame")({
		Name = Props.Name,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Size = UDim2.fromScale(1, 1),
		Position = Props.Position or UDim2.fromScale(0.5, 0.5),
		BackgroundTransparency = 1,
		Parent = Props.Parent,

		[Children] = {
			Props.Children.Outer,

			Scope:New("ImageLabel")({
				Name = "Frame",
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundTransparency = 1,
				Position = UDim2.fromScale(0.5, 0.5),
				Size = Props.Size,
				Image = Props.Image,

				[Children] = {
					Props.Children.Inner,
				},
			}),
		},
	})
end

return FrameTemplate
