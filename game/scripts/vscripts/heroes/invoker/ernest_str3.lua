ernest_str3 = class({})

LinkLuaModifier("modifier_ernest_str3", "heroes/invoker/modifiers/modifier_ernest_str3.lua", LUA_MODIFIER_MOTION_NONE)

function ernest_str3:OnSpellStart()
	caster = self:GetCaster()
	target = self:GetCursorTarget()
	duration = self:GetSpecialValueFor("duration")	
	target:AddNewModifier(caster, self, "modifier_ernest_str3", {["duration"] = duration})
end
	
