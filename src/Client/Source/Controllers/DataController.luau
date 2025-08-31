-- // pkg
local Replica = require("@Packages/Replica") :: any

-- // util
local Network = require("@Shared/Network")
local Types = require("@Shared/Types")

local Signals = require("@ClientUtility/Signals")

local Values = require("@Controllers/InterfaceController/Values")

-- // init
local DataCache = {
	ServerData = {},
	PlayerData = {} :: Types.UserData,
	TempData = {},
}

-- // init
local DataController = {}

function DataController.Start(_: DataController)
	Network.Data.SyncData:connect(function(OldData, NewData)
		if NewData == nil or NewData == DataCache.PlayerData then
			return
		end
		DataCache.PlayerData = NewData
		Signals.PlayerDataChanged:Fire(OldData, NewData)
	end)

	Replica.OnNew("RestaurantData", function(_replica)
		_replica:OnSet({ "Open" }, function(new_value)
			Values.Open:set(new_value)
		end)
		_replica:OnSet({ "GameTime" }, function(new_value)
			Values.Time:set(new_value)
		end)
		_replica:OnSet({ "Rating" }, function(new_value)
			Values.Rating:set(new_value)
		end)
	end)
	Replica.RequestData()
end

type DataController = typeof(DataController)

return DataController :: DataController
