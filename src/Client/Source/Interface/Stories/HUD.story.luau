-- // Packages
local Fusion = require("@Packages/Fusion")
local UILabs = require("@Packages/UI-Labs")

-- // HUD
local HUD = require("@Interface/HUD")

local Controls = {
	Enabled = true,
	Time = "00:00 AM",
	Rating = UILabs.Slider(1, 0, 5, 0.25),

	Wallet = 0,
	Bank = 0,
	Bills = 0,

	Energy = 0,

	Open = true,
}

local Story = {
	fusion = Fusion,
	controls = Controls,
	story = function(props)
		local scope = props.scope
		HUD(scope, {
			Parent = props.target,
			Enabled = props.controls.Enabled,
			Time = props.controls.Time,
			Rating = props.controls.Rating,

			Wallet = props.controls.Wallet,
			Bank = props.controls.Bank,
			Bills = props.controls.Bills,

			Energy = props.controls.Energy,

			Open = props.controls.Open,
		})
	end,
}

return Story
