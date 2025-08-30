-- // Services
local Players = game:GetService("Players")

-- // Packages
local Lyra = require("@Packages/Lyra")

-- // mod
local Cache = require("@ServerModules/Cache")
local DataTemplate = require("@ServerModules/DataTemplate")

local Network = require("@Shared/Network")

local Schemas = require("@Shared/Schemas")
local Types = require("@Shared/Types")

local PlayerUtils = require("@Utility/Player")

-- // l funcs
local function UpdateLeaderstats(UserId: string, newData: Types.UserData, _: Types.UserData?)
	local Player = Players:GetPlayerByUserId(tonumber(UserId))
	if Player then
		local leaderstats = Player:WaitForChild("leaderstats", 5) :: Folder
		local Cash = leaderstats:WaitForChild("Cash", 5) :: IntValue

		Cash.Value = newData.Cash
	end
end

local function CachePlayerFriends(Player: Player)
	PlayerUtils.GetFriends(Player):andThen(function(Friends)
		Cache.PlayerFriends[Player] = Friends :: { { DisplayName: string, Id: number, Username: string } }
	end)
end

local function SyncData(Key: string, NewData: Types.UserData, OldData: Types.UserData?)
	local Player = Players:GetPlayerByUserId(tonumber(Key))
	if Player then
		local _OldData = OldData or DataTemplate
		Network.Data.SyncData:fire(Player, _OldData, NewData)
	end
end

-- // store
local PlayerStore = Lyra.createPlayerStore({
	name = "PlayerData",
	template = DataTemplate,
	schema = Schemas.UserData,
	changedCallbacks = {
		UpdateLeaderstats,
		SyncData,
	},
})

local PlayerService = {
	Store = PlayerStore,
}

function PlayerService:Start()
	Players.PlayerAdded:Connect(function(Player: Player)
		PlayerService.Store:loadAsync(Player)
		PlayerService:_SetupLeaderstats(Player)
		CachePlayerFriends(Player)
	end)

	Players.PlayerRemoving:Connect(function(Player: Player)
		PlayerService.Store:unloadAsync(Player)
	end)

	game:BindToClose(function()
		PlayerService.Store:closeAsync()
	end)
end

function PlayerService:_SetupLeaderstats(Player: Player)
	local leaderstats = Instance.new("Folder")
	leaderstats.Name = "leaderstats"
	leaderstats.Parent = Player

	local Cash = Instance.new("IntValue")
	Cash.Name = "Cash"
	Cash.Parent = leaderstats

	local PlayerData = PlayerService.Store:getAsync(Player)
	if PlayerData then
		Cash.Value = PlayerData.Cash
	end
end

return PlayerService
