-- // Modules
local Network = require("@Shared/Network")

local TweenModel = require("@Shared/Utility/TweenModel")

-- // init
local TweenController = {}

function TweenController:Start()
	Network.Utility.TweenModel.Position:connect(function(Model, TargetCFrame, Info: any)
		local Unpacked = TweenInfo.new(table.unpack(Info))
		if Model:IsA("Model") then
			TweenModel.Position(Model, TargetCFrame, Unpacked)
		end
	end)
end

return TweenController
