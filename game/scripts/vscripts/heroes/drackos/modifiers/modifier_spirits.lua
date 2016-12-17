modifier_spirits = class({})

LinkLuaModifier("modifier_spirits_tracker", "heroes/drackos/modifiers/modifier_spirits_tracker.lua", LUA_MODIFIER_MOTION_NONE)

function modifier_spirits:OnCreated()
	target = self:GetParent()
	caster = self:GetAbility():GetCaster()
	damage = self:GetAbility():GetSpecialValueFor("damage")
	multiplier = self:GetAbility():GetSpecialValueFor("multiplier")
	duration = self:GetAbility():GetSpecialValueFor("duration")
	
	stacks = 1
	target:AddNewModifier(caster, self, "modifier_spirits_tracker", nil)
	target:SetModifierStackCount("modifier_spirits_tracker", caster, 1)
	
	Timers:CreateTimer(duration, function()
		stacks = target:GetModifierStackCount("modifier_spirits_tracker", caster)
		if stacks == 1 then
			target:RemoveModifierByName("modifier_spirits_tracker")
		else
			target:SetModifierStackCount("modifier_spirits_tracker", caster, stacks-1)
		end
	end)	
	
	i = stacks-1
	
	local damageTable = {
		victim = target,
		attacker = caster,
		damage = damage * multiplier^i,
		damage_type = DAMAGE_TYPE_MAGICAL,
	}
	ApplyDamage(damageTable)
end

function modifier_spirits:OnRefresh()
	target = self:GetParent()
	caster = self:GetAbility():GetCaster()
	damage = self:GetAbility():GetSpecialValueFor("damage")
	multiplier = self:GetAbility():GetSpecialValueFor("multiplier")
	duration = self:GetAbility():GetSpecialValueFor("duration")
	
	stacks = target:GetModifierStackCount("modifier_spirits_tracker", caster)
	target:SetModifierStackCount("modifier_spirits_tracker", caster, stacks+1)

	Timers:CreateTimer(duration, function()
		stacks = target:GetModifierStackCount("modifier_spirits_tracker", caster)
		if stacks == 1 then
			target:RemoveModifierByName("modifier_spirits_tracker")
		else
			target:SetModifierStackCount("modifier_spirits_tracker", caster, stacks-1)
		end
	end)	
	
	i = stacks-1
	
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