modifier_water_fiend_initiator = class({})

LinkLuaModifier("modifier_water_fiend", "heroes/matt/modifiers/modifier_water_fiend.lua", LUA_MODIFIER_MOTION_NONE)

function modifier_water_fiend_initiator:OnCreated()
	if IsServer() then
		caster = self:GetCaster()
		self:StartIntervalThink(0.035)
		print("created water fiend initiator")
	end
end

function modifier_water_fiend_initiator:OnIntervalThink()
	
	ability = self:GetAbility()
	mod_table = {
	damage = ability:GetSpecialValueFor("damage"),
	evasion = ability:GetSpecialValueFor("evasion"),
	hp_regen = ability:GetSpecialValueFor("hp_regen"),
	mana_regen = ability:GetSpecialValueFor("mana_regen"),
	speed = ability:GetSpecialValueFor("speed"),
	}
	height = GetGroundHeight(caster:GetAbsOrigin(), caster)
	if height <= 150 and not caster:HasModifier("modifier_water_fiend") then
		caster:AddNewModifier(caster, self, "modifier_water_fiend", mod_table)
		caster:CalculateStatBonus()
	end
	if height > 150 and caster:HasModifier("modifier_water_fiend") then
		caster:RemoveModifierByName("modifier_water_fiend")
	end
end

function modifier_water_fiend_initiator:AllowIllusionDuplicate()
	return true
end

function modifier_water_fiend_initiator:IsHidden()
	return true
end
