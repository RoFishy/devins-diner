-- // Services
local TweenService = game:GetService("TweenService")

local function TweenNumber(OldValue: number, NewValue: number, Handler: (number) -> ())
	local i = 0
	while i < 1 do
		i = math.clamp(i + 0.1, 0, 1)
		local a = TweenService:GetValue(i, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
		local tweenInt = math.round(OldValue * (1 - a) + NewValue * a)

		Handler(tweenInt)
		task.wait(0.05)
	end
end

return TweenNumber
