--!strict
-- BubbleOrb: a floating glass orb that bobs and glows
local TweenService = game:GetService("TweenService")

local BubbleOrb = {}
BubbleOrb.__index = BubbleOrb

export type BubbleOrb = typeof(setmetatable({} :: {
	part: BasePart,
	bobHeight: number,
}, BubbleOrb))

local GLOW_COLOR = Color3.fromRGB(124, 232, 255)

function BubbleOrb.new(part: BasePart, bobHeight: number?): BubbleOrb
	local self = setmetatable({
		part = part,
		bobHeight = bobHeight or 2,
	}, BubbleOrb)

	part.Material = Enum.Material.Glass
	part.Color = GLOW_COLOR
	part.Transparency = 0.35
	return self
end

function BubbleOrb.bob(self: BubbleOrb)
	local info = TweenInfo.new(1.8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true)
	local goal = { Position = self.part.Position + Vector3.new(0, self.bobHeight, 0) }
	TweenService:Create(self.part, info, goal):Play()
end

return BubbleOrb
