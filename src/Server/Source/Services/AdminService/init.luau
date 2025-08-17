-- // Packages
local Cmdr = require("@ServerPackages/cmdr") :: any

-- // Init
local AdminService = {}

function AdminService:Start()
	Cmdr:RegisterDefaultCommands()
	Cmdr:RegisterCommandsIn(script.Commands)
	Cmdr:RegisterHooksIn(script.Hooks)
end

return AdminService
