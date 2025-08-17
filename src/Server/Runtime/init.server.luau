-- // Services
local ServerStorage = game:GetService("ServerStorage")
local Services = ServerStorage.Services
local Components = ServerStorage.Components

-- // Modules
local Bootstrapper = require("@Shared/Bootstrapper")
local Log = require("@Utility/Log")

local Promise = require("@Packages/TypedPromise")

-- // Init
local StartTime = os.clock()
Log.Warn("Starting Server")
Bootstrapper.load(Services)

local ComponentPromises = {} :: { Promise.Promise }
for _, Module: ModuleScript in Components:GetChildren() do
	if Module:IsA("ModuleScript") then
		table.insert(
			ComponentPromises,
			Promise.new(function(resolve, reject)
				local success, response = pcall(function()
					(require)(Module)
				end)

				if success then
					Log.Info(`Initialized Component "{Module.Name}"`)
					resolve()
				else
					Log.Warn(`Failed to initialize Component "{Module.Name}" with response: {response}`)
					reject(response)
				end
			end)
		)
	end
end

Promise.all(ComponentPromises)

local EndTime = os.clock() - StartTime
Log.Warn(("Loading complete, took %.2f seconds"):format(EndTime))
