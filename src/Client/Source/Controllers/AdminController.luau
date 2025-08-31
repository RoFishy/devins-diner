-- // Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Cmdr = (require)(ReplicatedStorage:WaitForChild("CmdrClient"))

local AdminController = {}

function AdminController.Start(_: AdminController)
	Cmdr:SetActivationKeys({ Enum.KeyCode.F2 })
end

type AdminController = typeof(AdminController)

return AdminController :: AdminController
