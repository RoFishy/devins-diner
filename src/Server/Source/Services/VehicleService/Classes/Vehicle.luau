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
	workspace.Components.Vehicle :: Folder & { Waypoints: Folder & { Spawns: Folder, Entry: Folder }, ParkingSpots: Folder }
local SpawnPoints = VehicleComponents.Waypoints.Spawns :: Folder
local EntryPoints = VehicleComponents.Waypoints.Entry :: Folder & {
	Far: Folder,
	Close: Folder,
}
local ParkingSpots = VehicleComponents.ParkingSpots

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

	task.spawn(self.Spawn, self)

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
		self.Model:PivotTo(
			CFrame.lookAt(self.Model:GetPivot().Position, NextPoint.Position + NextPoint.CFrame.LookVector * 3)
		)

		Network.Utility.TweenModel.Position:fireAll(self.Model, NextPoint.CFrame * HEIGHT_OFFSET, {
			Time = 2,
			EasingStyle = Enum.EasingStyle.Linear,
		})
		task.wait(2)

		self.Model:PivotTo(NextPoint.CFrame * HEIGHT_OFFSET)

		self:Park(NextPoint)
	end
end

function Vehicle.Park(
	self: Vehicle,
	CurrentPoint: Part & {
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
	},
	RandomPath: number?
)
	local Random = RandomPath or math.random(1, 2)

	local ChosenPath = CurrentPoint.Paths:FindFirstChild(tostring(Random)) :: Folder & {
		Point: ObjectValue,
		Zone: IntValue,
	}
	local ChosenPoint = ChosenPath.Point.Value :: Part

	local Spot = self:SelectRandomSpot(ChosenPath.Zone.Value) :: Part
	if Spot then
		Spot:SetAttribute("Vehicle", true)
		--if ChosenPoint.CFrame.LookVector:Dot(self.Model:GetPivot().LookVector) == 1 then
		if ChosenPath.Zone.Value == 1 then
			Network.Utility.TweenModel.Position:fireAll(
				self.Model,
				CFrame.lookAt(self.Model:GetPivot().Position, ChosenPoint.Position + ChosenPoint.CFrame.LookVector),
				{
					Time = 0.75,
				}
			)
			task.wait(0.75)
			self.Model:PivotTo(
				CFrame.lookAt(self.Model:GetPivot().Position, ChosenPoint.Position + ChosenPoint.CFrame.LookVector)
			)
		end
		--end

		local TimeToSpot: number
		local Distance = (Spot.Position - self.Model:GetPivot().Position).Magnitude
		if Distance > 150 then
			TimeToSpot = 5
		elseif Distance > 130 then
			TimeToSpot = 4
		elseif Distance > 70 then
			TimeToSpot = 3
		elseif Distance > 40 then
			TimeToSpot = 2
		else
			TimeToSpot = 1
		end

		local ModelPosition = self.Model:GetPivot().Position
		local Position = Spot.CFrame.LookVector * 25
		local AdjustedPosition =
			Vector3.new(Spot.Position.X + Position.X, ModelPosition.Y, Spot.Position.Z + Position.Z)
		Network.Utility.TweenModel.Position:fireAll(
			self.Model,
			CFrame.lookAlong(AdjustedPosition, self.Model:GetPivot().LookVector),
			{ Time = TimeToSpot, EasingStyle = Enum.EasingStyle.Linear }
		)

		task.wait(TimeToSpot)
		self.Model:PivotTo(CFrame.lookAlong(AdjustedPosition, self.Model:GetPivot().LookVector))

		Network.Utility.TweenModel.Position:fireAll(
			self.Model,
			CFrame.lookAt(self.Model:GetPivot().Position, Spot.Position),
			{
				Time = 0.75,
				EasingStyle = Enum.EasingStyle.Linear,
			}
		)
		task.wait(0.75)
		self.Model:PivotTo(CFrame.lookAt(self.Model:GetPivot().Position, Spot.Position))

		Network.Utility.TweenModel.Position:fireAll(
			self.Model,
			Spot.CFrame * CFrame.new(0, -1.25, 0) * CFrame.Angles(0, math.rad(180), 0),
			{
				Time = 1,
				EasingStyle = Enum.EasingStyle.Linear,
			}
		)

		task.wait(1)
		self.Model:PivotTo(Spot.CFrame * CFrame.new(0, -1.25, 0) * CFrame.Angles(0, math.rad(180), 0))
	elseif RandomPath then
		self:Destroy()
	else
		return self:Park(CurrentPoint, if Random == 1 then 2 else 1)
	end
end

function Vehicle.SelectRandomSpot(self: Vehicle, Zone: number, AttemptNumber: number?): any
	local ZoneFolder = ParkingSpots:FindFirstChild(`Zone{Zone}`) :: Folder

	if AttemptNumber and AttemptNumber >= #ZoneFolder:GetChildren() then
		return false
	end

	local RandomSpot = ZoneFolder:GetChildren()[math.random(#ZoneFolder:GetChildren())]
	if RandomSpot:GetAttribute("Vehicle") then
		AttemptNumber = AttemptNumber and AttemptNumber + 1 or 1
		return self:SelectRandomSpot(Zone, AttemptNumber)
	else
		return RandomSpot
	end
end

function Vehicle.Destroy(self: Vehicle)
	self.Model:Destroy()
end

return Vehicle
