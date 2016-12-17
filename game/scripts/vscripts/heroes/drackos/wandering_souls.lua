wandering_souls = class({})

LinkLuaModifier("modifier_souls_tracker", "heroes/drackos/modifiers/modifier_souls_tracker.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("wanderer_thinker", "heroes/drackos/modifiers/wanderer_thinker.lua", LUA_MODIFIER_MOTION_NONE)

function wandering_souls:GetIntrinsicModifierName()
	return "modifier_souls_tracker"
end