export type Config = {
	IncrementDelay: number,
	Hours: {
		Open: {
			StartHour: number,
			StartMinute: number?,
		},
		Close: {
			StartHour: number,
			StartMinute: number?,
		},
	},
}

export type Events = { kind: "FORCE_OPEN" } | { kind: "FORCE_CLOSE" } | { kind: "PLAYER_LEFT", userId: number }

return {}
