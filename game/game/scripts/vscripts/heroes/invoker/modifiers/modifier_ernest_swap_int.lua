modifier_ernest_swap_int = class({})

function modifier_ernest_swap_int:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
		MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
		MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,		
    }
    return funcs
end

function modifier_ernest_swap_int:GetTexture()
	return "ernest_swap_int"
end

function modifier_ernest_swap_int:GetModifierBonusStats_Strength()
	bonus_str = self:GetAbility():GetSpecialValueFor("flat_bonus")
	return bonus_str
end

function modifier_ernest_swap_int:GetModifierBonusStats_Agility()
	bonus_agi = self:GetAbility():GetSpecialValueFor("flat_bonus")
	return bonus_agi
end

function modifier_ernest_swap_int:GetModifierBonusStats_Intellect()
	bonus_int = self:GetAbility():GetSpecialValueFor("flat_bonus")
	bonus_to_primary = self:GetAbility():GetSpecialValueFor("primary_bonus")
	return bonus_int + bonus_to_primary
end

function modifier_ernest_swap_int:IsPurgable()
	return false
end

function modifier_ernest_swap_int:RemoveOnDeath()
	return false
end

function modifier_ernest_swap_int:GetModifierConstantManaRegen()
	caster = self:GetParent()
	intmod = caster:GetIntellect() - caster:GetBaseIntellect()
	return intmod/5
end

function modifier_ernest_swap_int:GetModifierAttackRangeBonus()
	return 100
end