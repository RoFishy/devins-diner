-- // util
local Network = require("@Shared/Network")
local Types = require("@Shared/Types")

local Signals = require("@ClientUtility/Signals")

-- // init
local DataCache = {
	ServerData = {},
	PlayerData = {} :: Types.UserData,
	TempData = {},
}

-- // init
local DataController = {}

function DataController:Start()
	Network.Data.SyncData:connect(function(Data)
		if Data == nil or Data == DataCache.PlayerData then
			return
		end
		DataCache.PlayerData = Data
		Signals.PlayerDataChanged:Fire(Data)
	end)
end

return DataController
