modifier_water_fiend = class({})

function modifier_water_fiend:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_PROPERTY_EVASION_CONSTANT,
		MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
	}
	return funcs
end

function modifier_water_fiend:DeclareVariables()
	local vars = {
		damage,
		speed,
		hp_regen,
		mana_regen,
		evasion,
		bonus_range,
	}
	return vars
end

function modifier_water_fiend:OnCreated(keys)
	if IsServer() then
		water_particle = ParticleManager:CreateParticle( "particles/water_buff5.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
			ParticleManager:SetParticleControl( water_particle, 0, self:GetParent():GetAbsOrigin())
	end
end

function modifier_water_fiend:GetModifierDamageOutgoing_Percentage()
	damage = self:GetAbility():GetSpecialValueFor("damage")
	return math.floor(damage)
end

function modifier_water_fiend:GetModifierMoveSpeedBonus_Percentage()
	speed = self:GetAbility():GetSpecialValueFor("speed")
	return math.floor(speed)
end

function modifier_water_fiend:GetModifierConstantHealthRegen()
	hp_regen = self:GetAbility():GetSpecialValueFor("hp_regen")
	return hp_regen
end

function modifier_water_fiend:GetModifierConstantManaRegen()
	mana_regen = self:GetAbility():GetSpecialValueFor("mana_regen")
	return mana_regen
end

function modifier_water_fiend:GetModifierEvasion_Constant(args)
	evasion = self:GetAbility():GetSpecialValueFor("evasion")
	return evasion
end

function modifier_water_fiend:GetModifierAttackRangeBonus(args)
	bonus_range = self:GetAbility():GetSpecialValueFor("bonus_range")
	return math.floor(bonus_range)
end

function modifier_water_fiend:CheckState()
	local state = {
		[MODIFIER_STATE_CANNOT_MISS] = true
	}
	return state
end

function modifier_water_fiend:GetModifierUnitStatsNeedsRefresh()
	return true
end

function modifier_water_fiend:IsPurgable()
	return false
end

function modifier_water_fiend:GetTexture()
	return "water_fiend"
end

function modifier_water_fiend:IsDebuff()
	return false
end

function modifier_water_fiend:AllowIllusionDuplicate()
	return false
end

function modifier_water_fiend:RemoveOnDeath()
	return true
end

function modifier_water_fiend:OnDestroy()
	if IsServer() then
		ParticleManager:DestroyParticle(water_particle, false)
	end
end





