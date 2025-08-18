-- // Packages
local Fusion = require("@Packages/Fusion")
local UILabs = require("@Packages/UI-Labs")

-- // HUD
local RewardFrame = require("@Interface/Frames/Rewards")
local Controls = {
	State = UILabs.Choose({ "Claimed", "Next", "Locked" }),
	Time = 600,
}

local Story = {
	fusion = Fusion,
	controls = Controls,
	story = function(props)
		local scope = props.scope
		RewardFrame(scope, {
			Parent = props.target,
			Position = UDim2.fromScale(0.5, 0.5),
			State = props.controls.State,
			Time = props.controls.Time,
		})
	end,
}

return Story
