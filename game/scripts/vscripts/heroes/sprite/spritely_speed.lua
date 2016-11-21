spritely_speed = class({})

LinkLuaModifier("modifier_spritely_speed", "heroes/sprite/modifiers/modifier_spritely_speed.lua", LUA_MODIFIER_MOTION_NONE )

function spritely_speed:GetIntrinsicModifierName()
	return "modifier_spritely_speed"
end

