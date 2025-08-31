return {
	PlayerFriends = setmetatable(
		{} :: { [Player]: { { DisplayName: string, Id: number, Username: string } } },
		{ __mode = "k" }
	),
}
