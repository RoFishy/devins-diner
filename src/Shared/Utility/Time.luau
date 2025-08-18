local function Format(Int)
	return string.format("%02i", Int)
end

return {
	FormatHMS = function(s: number): string
		local Minutes = (s - s % 60) / 60
		s = s - Minutes * 60
		local Hours = (Minutes - Minutes % 60) / 60
		Minutes = Minutes - Hours * 60
		return Format(Hours) .. ":" .. Format(Minutes) .. ":" .. Format(s)
	end,

	FormatMS = function(s: number): string
		return string.format("%.f:%02d", s / 60, s % 60)
	end,
}
