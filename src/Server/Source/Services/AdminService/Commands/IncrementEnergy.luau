return {
	Name = "incrementEnergy",
	Aliases = {},
	Description = "Increment a player's energy",
	Args = {
		{
			Type = "players",
			Name = "player",
			Description = "The player to increment energy of",
		},
		{
			Type = "number",
			Name = "energy",
			Description = "The amount of energy to increment",
		},
	},
}
