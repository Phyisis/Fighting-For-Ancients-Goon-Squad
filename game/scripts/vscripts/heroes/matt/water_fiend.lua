water_fiend = class({})

LinkLuaModifier("modifier_water_fiend_initiator", "heroes/matt/modifiers/modifier_water_fiend_initiator.lua", LUA_MODIFIER_MOTION_NONE)

function water_fiend:GetIntrinsicModifierName()
	return "modifier_water_fiend_initiator"
end
