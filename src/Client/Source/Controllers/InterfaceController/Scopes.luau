-- // packages
local Fusion = require("@Packages/Fusion")

local UIScope = Fusion.scoped(Fusion)
local HUDScope = UIScope:innerScope()
local FrameScope = UIScope:innerScope()

return {
	HUDScope = HUDScope,
	FrameScope = FrameScope,
	UIScope = UIScope,
}
