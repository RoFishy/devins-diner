local Promise = require("@Packages/TypedPromise")

return {
	ComputePathAsync = function(Path: Path, StartPosition: Vector3, EndPosition: Vector3)
		return Promise.new(function(resolve, reject)
			local Success, Error = pcall(function()
				Path:ComputeAsync(StartPosition, EndPosition)
			end)

			if Success and Path.Status == Enum.PathStatus.Success then
				resolve(Path:GetWaypoints())
			else
				reject(Error)
			end
		end)
	end,
}
