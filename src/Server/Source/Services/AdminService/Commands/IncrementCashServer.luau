local PlayerService = require("@Services/PlayerService")

return function(_, Players: { Player }, Amount: number)
	for _, Player in Players do
		PlayerService.Store:updateAsync(Player, function(Data)
			Data.Cash += Amount
			return true
		end)
	end
	return "Success"
end
