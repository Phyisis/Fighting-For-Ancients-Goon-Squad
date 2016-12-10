ernest_agi3 = class({})

LinkLuaModifier("modifier_ernest_agi3", "heroes/invoker/modifiers/modifier_ernest_agi3.lua", LUA_MODIFIER_MOTION_NONE )

function ernest_agi3:OnSpellStart()
	caster = self:GetCaster()
	duration = self:GetSpecialValueFor("duration")
	caster:AddNewModifier(caster, self, "modifier_ernest_agi3", {duration=duration})
end