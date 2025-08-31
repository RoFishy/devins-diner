-- // utils
local FSM = require("@Utility/FSM")
local RestaurantTypes = require("@Services/RestaurantService/Utils/Types")

local Open = {} :: FSM.State<RestaurantTypes.Config, RestaurantTypes.Events>

function Open.Enter(_, _) end

function Open.Tick(_, _, _) end

function Open.OnEvent(_, _, _) end

function Open.Exit(_, _) end

return Open
