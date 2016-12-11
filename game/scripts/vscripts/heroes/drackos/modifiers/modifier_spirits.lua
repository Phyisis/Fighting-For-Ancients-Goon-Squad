modifier_spirits = class({})

LinkLuaModifier("modifier_spirits_tracker", "heroes/drackos/modifiers/modifier_spirits_tracker.lua", LUA_MODIFIER_MOTION_NONE)

function modifier_spirits:OnCreated()
	target = self:GetParent()
	caster = self:GetAbility():GetCaster()
	damage = self:GetAbility():GetSpecialValueFor("damage")
	multiplier = self:GetAbility():GetSpecialValueFor("multiplier")
	i = 0
	
	if target:HasModifier("modifier_spirits2") then
		i = i+1
	end

	if target:HasModifier("modifier_spirits3") then
		i = i+1
	end

	if target:HasModifier("modifier_spirits_tracker") then
		stacks = target:GetModifierStackCount("modifier_spirits_tracker", caster)
		target:SetModifierStackCount("modifier_spirits_tracker", caster, stacks+1)
	else
		target:AddNewModifier(caster, self, "modifier_spirits_tracker", nil)
		target:SetModifierStackCount("modifier_spirits_tracker", caster, 1)
	end	

	local damageTable = {
		victim = target,
		attacker = caster,
		damage = damage * multiplier^i,
		damage_type = DAMAGE_TYPE_MAGICAL,
	}
	ApplyDamage(damageTable)
end

function modifier_spirits:OnDestroy()
	stacks = target:GetModifierStackCount("modifier_spirits_tracker", caster)
	if stacks == 1 then
		target:RemoveModifierByName("modifier_spirits_tracker")
	else
		target:SetModifierStackCount("modifier_spirits_tracker", caster, stacks-1)
	end
end

function modifier_spirits:IsHidden()
	return true
end