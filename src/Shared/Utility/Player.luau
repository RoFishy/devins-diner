-- // Services
local Players = game:GetService("Players")

-- // package
local Promise = require("@Packages/TypedPromise")

-- // Player Utils
return {
	GetFriends = function(Player: Player)
		return Promise.new(function(resolve, reject)
			local Success, Result = pcall(Players.GetFriendsAsync, Players, Player.UserId)

			if not Success then
				reject(Result)
			end

			repeat
				local PlayerFriends = {}

				local info = Result:GetCurrentPage()
				for _, FriendInfo in info do
					table.insert(PlayerFriends, FriendInfo)
				end
				if not Result.IsFinished then
					Result:AdvanceToNextPageAsync()
				end

				resolve(PlayerFriends)
			until Result.IsFinished
		end)
	end,
	IsInGroup = function(Player: Player, GroupId: number)
		return Promise.new(function(resolve)
			resolve(Player:IsInGroup(GroupId))
		end)
	end,
}
