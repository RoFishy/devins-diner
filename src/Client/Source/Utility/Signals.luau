-- // Packages
local Signal = require("@Packages/Signal")

local Types = require("@Shared/Types")

return {
	OpenFrame = Signal.new() :: Signal.Signal<string>,
	CloseAllFrames = Signal.new(),

	-- // Data
	PlayerDataChanged = Signal.new() :: Signal.Signal<Types.UserData>,
}
