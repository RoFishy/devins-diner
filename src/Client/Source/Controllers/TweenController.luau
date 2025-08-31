-- // Modules
local Network = require("@Shared/Network")

local TweenModel = require("@Shared/Utility/TweenModel")

-- // init
local TweenController = {}

function TweenController.Start(_: TweenController)
	Network.Utility.TweenModel.Position:connect(function(Model, TargetCFrame, Info: any)
		local Unpacked = TweenInfo.new(
			Info.Time or 1,
			Info.EasingStyle or Enum.EasingStyle.Sine,
			Info.EasingDirection or Enum.EasingDirection.Out,
			Info.RepeatCount or 0,
			Info.Reverses or false
		)
		if Model:IsA("Model") then
			TweenModel.Position(Model, TargetCFrame, Unpacked)
		end
	end)
end

type TweenController = typeof(TweenController)

return TweenController :: TweenController
