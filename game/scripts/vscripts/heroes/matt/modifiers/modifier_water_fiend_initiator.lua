modifier_water_fiend_initiator = class({})

LinkLuaModifier("modifier_water_fiend", "heroes/matt/modifiers/modifier_water_fiend.lua", LUA_MODIFIER_MOTION_NONE)

function modifier_water_fiend_initiator:OnCreated()
	caster = self:GetParent()
	self:StartIntervalThink(0.035)
	print("created water fiend initiator")
end

function modifier_water_fiend_initiator:OnIntervalThink()
	if IsServer() then
		caster = self:GetParent()
		ability = self:GetAbility()
		height = GetGroundHeight(caster:GetAbsOrigin(), nil)
		if height <= 150 and not caster:HasModifier("modifier_water_fiend") then
			caster:AddNewModifier(caster, self:GetAbility(), "modifier_water_fiend", nil)
		end
		if height > 150 and caster:HasModifier("modifier_water_fiend") then
			caster:RemoveModifierByName("modifier_water_fiend")
		end
	end
end

function modifier_water_fiend_initiator:AllowIllusionDuplicate()
	return false
end

function modifier_water_fiend_initiator:IsHidden()
	return true
end
