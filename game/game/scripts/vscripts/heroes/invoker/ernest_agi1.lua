ernest_agi1 = class({})

LinkLuaModifier("modifier_ernest_agi1", "heroes/invoker/modifiers/modifier_ernest_agi1.lua", LUA_MODIFIER_MOTION_NONE)

function ernest_agi1:OnSpellStart()
	caster = self:GetCaster()
	target = self:GetCursorTarget()
	duration = self:GetSpecialValueFor("duration")
	
	if target:GetTeamNumber() ~= caster:GetTeamNumber() then
		local damageTable = {
			victim = target,
			attacker = caster,
			damage = self:GetSpecialValueFor("damage"),
			damage_type = DAMAGE_TYPE_MAGICAL,
		}
		ApplyDamage(damageTable)
	end
	
	target:AddNewModifier(caster, self, "modifier_ernest_agi1", {duration = duration})
	
end