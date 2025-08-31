-- // mod
local Scopes = require("@Controllers/InterfaceController/Scopes")

local UIScope = Scopes.UIScope

return {
	Time = UIScope:Value("10:00 AM"),
	HUDEnabled = UIScope:Value(true),
	Rating = UIScope:Value(0),

	Wallet = UIScope:Value(0),
	Bank = UIScope:Value(0),
	Bills = UIScope:Value(0),

	Energy = UIScope:Value(0),

	Open = UIScope:Value(true),
}
