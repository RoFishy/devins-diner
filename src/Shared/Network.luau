-- // Packages
local Remo = require("@Packages/Remo")
local t = require("@Packages/t")

local Schemas = require("@Shared/Schemas")
local Types = require("@Shared/Types")

type Remotes = Remo.Remotes<{
	Utility: {
		TweenModel: {
			Position: Remo.ServerToClient<(Instance, CFrame, { any })>,
			Scale: Remo.ServerToClient<(Instance, number, number, { any })>,
		},
	},

	Data: {
		SyncData: Remo.ServerToClient<(Types.UserData, Types.UserData)>,
	},
}>

local Remotes: Remotes = Remo.createRemotes({
	Utility = Remo.namespace({
		TweenModel = Remo.namespace({
			Position = Remo.remote(t.Instance, t.CFrame, t.table),
			Scale = Remo.remote(t.Instance, t.numberPositive, t.numberPositive, t.table),
		}),
	}),

	Data = Remo.namespace({
		SyncData = Remo.remote(Schemas.UserData, Schemas.UserData),
	}),
})

return Remotes
