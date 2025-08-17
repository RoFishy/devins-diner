--[[
Simple touch connection for models
usage:

	local zone = TouchZone(model)
	local connection = zone.playerTouched(function(player, character)

	end)
	connection:Disconnect()

	local connection = zone.memeTouched(function(meme)

	end)
	connection:Disconnect()

	zone:Destroy()
]]

local function TouchZone(model: Model | BasePart)
	local partTouched = {}
	local partExited = {}
	local nextTouch = {}
	local nextTouchEnd = {}
	local connections = {}

	local function Touched(hit: BasePart)
		local ancestor: Model? = hit:FindFirstAncestorOfClass("Model")
		local now = time()

		if ancestor and (not nextTouch[ancestor] or nextTouch[ancestor] < now) then
			nextTouch[ancestor] = now + 1
			for _, callback in pairs(partTouched) do
				task.defer(callback, ancestor)
			end
		end
	end

	local function TouchEnded(hit: BasePart)
		local ancestor: Model? = hit:FindFirstAncestorOfClass("Model")
		local now = time()

		if ancestor and (not nextTouchEnd[ancestor] or nextTouchEnd[ancestor] < now) then
			nextTouchEnd[ancestor] = now + 1
			for _, callback in pairs(partExited) do
				task.defer(callback, ancestor)
			end
		end
	end

	if model:IsA("BasePart") then
		table.insert(connections, model.Touched:Connect(Touched))
		table.insert(connections, model.TouchEnded:Connect(TouchEnded))
	end

	for _, v in pairs(model:GetDescendants()) do
		if v:IsA("BasePart") then
			table.insert(connections, v.Touched:Connect(Touched))
			table.insert(connections, v.TouchEnded:Connect(TouchEnded))
		end
	end

	return {
		partTouched = function(callback)
			table.insert(partTouched, callback)
			return {
				Disconnect = function()
					local i = table.find(partTouched, callback)
					if i then
						table.remove(partTouched, i)
					end
				end,
			}
		end,

		partExited = function(callback)
			table.insert(partExited, callback)
			return {
				Disconnect = function()
					local i = table.find(partExited, callback)
					if i then
						table.remove(partExited, i)
					end
				end,
			}
		end,

		Destroy = function()
			for _, connection in pairs(connections) do
				if connection.Connected then
					connection:Disconnect()
				end
			end

			connections = {}
		end,
	}
end

return TouchZone
