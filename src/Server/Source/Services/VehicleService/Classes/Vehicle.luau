-- // Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- // util
local Log = require("@Utility/Log")

local Network = require("@Shared/Network")

-- // obj
local Assets = ReplicatedStorage.Assets :: Folder & {
	Cars: Folder,
}
local Cars = Assets.Cars :: Folder & { Model }

local VehicleComponents =
	workspace.Components.Vehicle :: Folder & { Waypoints: Folder & { Spawns: Folder, Entry: Folder } }
local SpawnPoints = VehicleComponents.Waypoints.Spawns :: Folder
local EntryPoints = VehicleComponents.Waypoints.Entry :: Folder & {
	Far: Folder,
	Close: Folder,
}

-- // config
local HEIGHT_OFFSET = CFrame.new(0, 3.25, 0)

-- // init
local Vehicle = {}
Vehicle.__index = Vehicle

export type Vehicle = typeof(setmetatable(
	{} :: {
		Model: Model,
		EnterDiner: boolean,
	},
	Vehicle
))

function Vehicle.new(Name: string, EnterDiner: boolean): Vehicle?
	local self = setmetatable({}, Vehicle)

	local Model = Cars:FindFirstChild(Name) :: Model
	if not Model then
		Log.Warn(`Could not find vehicle "{Name}"`)
		return
	else
		self.Model = Model:Clone()
	end

	self.EnterDiner = EnterDiner

	self:Spawn()

	return self
end

function Vehicle.Spawn(self: Vehicle)
	self.Model.Parent = workspace

	local Spawns = SpawnPoints:GetChildren()
	local RandomSpawn = Spawns[math.random(#Spawns)] :: Model & {
		Start: Part,
		End: Part,
	}

	self.Model:PivotTo(
		CFrame.lookAt(RandomSpawn.Start.Position + RandomSpawn.Start.CFrame.LookVector * 2, RandomSpawn.End.Position)
			* HEIGHT_OFFSET
	)

	--local Path = PathfindingService:CreatePath()

	if not self.EnterDiner then
		Network.Utility.TweenModel.Position:fireAll(
			self.Model,
			RandomSpawn.End.CFrame * HEIGHT_OFFSET,
			{ Time = 10, EasingStyle = Enum.EasingStyle.Linear }
		)
		task.wait(10)
		self:Destroy()
	else
		local Type = RandomSpawn.Name

		local PointFolder = EntryPoints:FindFirstChild(Type) :: Folder
		local RandomPoint = PointFolder:GetChildren()[math.random(#PointFolder:GetChildren())] :: Part & {
			Value: ObjectValue,
		}

		local Time = if RandomPoint.Name == "2" then 7 else 3
		Network.Utility.TweenModel.Position:fireAll(
			self.Model,
			RandomPoint.CFrame * HEIGHT_OFFSET,
			{ Time = Time, EasingStyle = Enum.EasingStyle.Linear }
		)
		task.wait(Time)

		self.Model:PivotTo(RandomPoint.CFrame * HEIGHT_OFFSET)

		local NextPoint = RandomPoint.Value.Value :: Part & {
			Paths: Folder & {
				["1"]: Folder & {
					Point: ObjectValue,
					Zone: IntValue,
				},
				["2"]: Folder & {
					Point: ObjectValue,
					Zone: IntValue,
				},
			},
		}

		Network.Utility.TweenModel.Position:fireAll(
			self.Model,
			CFrame.lookAt(self.Model:GetPivot().Position, NextPoint.Position + NextPoint.CFrame.LookVector * 3),
			{
				Time = 0.75,
			}
		)

		task.wait(0.75)

		Network.Utility.TweenModel.Position:fireAll(self.Model, NextPoint.CFrame * HEIGHT_OFFSET, {
			Time = 2,
			EasingStyle = Enum.EasingStyle.Linear,
		})
		task.wait(2)

		self.Model:PivotTo(NextPoint.CFrame * HEIGHT_OFFSET)
	end
end

function Vehicle.Destroy(self: Vehicle)
	self.Model:Destroy()
end

return Vehicle
