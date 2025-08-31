-- // Packages
local Cmdr = require("@ServerPackages/cmdr") :: any

-- // Init
local AdminService = {}

function AdminService.Start(_: AdminService)
	Cmdr:RegisterDefaultCommands()
	Cmdr:RegisterCommandsIn(script.Commands)
	Cmdr:RegisterHooksIn(script.Hooks)
end

type AdminService = typeof(AdminService)

return AdminService :: AdminService
