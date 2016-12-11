lantern = class({})

LinkLuaModifier("modifier_lantern", "heroes/matt/modifiers/modifier_lantern.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("generic_thinker", "shared_modifiers/generic_thinker.lua", LUA_MODIFIER_MOTION_NONE)

function lantern:GetIntrinsicModifierName()
	return "modifier_lantern"
end