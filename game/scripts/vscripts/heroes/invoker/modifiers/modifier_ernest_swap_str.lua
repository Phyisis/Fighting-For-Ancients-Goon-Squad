modifier_ernest_swap_str = class({})

function modifier_ernest_swap_str:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
		MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,		
    }
    return funcs
end

function modifier_ernest_swap_str:GetTexture()
	return "ernest_swap_str"
end

function modifier_ernest_swap_str:GetModifierBonusStats_Strength()
	bonus_str = self:GetAbility():GetSpecialValueFor("flat_bonus")
	bonus_to_primary = self:GetAbility():GetSpecialValueFor("primary_bonus")
	return bonus_str + bonus_to_primary
end

function modifier_ernest_swap_str:GetModifierBonusStats_Agility()
	bonus_agi = self:GetAbility():GetSpecialValueFor("flat_bonus")
	return bonus_agi
end

function modifier_ernest_swap_str:GetModifierBonusStats_Intellect()
	bonus_int = self:GetAbility():GetSpecialValueFor("flat_bonus")
	return bonus_int
end

function modifier_ernest_swap_str:IsPurgable()
	return false
end

function modifier_ernest_swap_str:GetModifierConstantHealthRegen()
	caster = self:GetParent()
	strmod = caster:GetStrength() - caster:GetBaseStrength()
	return strmod/5
end

function modifier_ernest_swap_str:GetModifierAttackRangeBonus()
	return -100
end