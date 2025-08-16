-- // Packages
local Fusion = require("@Packages/Fusion")

-- // HUD
local HUD = require("@Interface/HUD")

local Controls = {
	Enabled = true,
	Time = "00:00 AM",
	Rating = 0,

	Wallet = 0,
	Bank = 0,
	Bills = 0,
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
		})
	end,
}

return Story
