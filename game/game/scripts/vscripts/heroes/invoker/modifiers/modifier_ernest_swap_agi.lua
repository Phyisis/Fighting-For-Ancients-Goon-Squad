modifier_ernest_swap_agi = class({})

function modifier_ernest_swap_agi:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
		MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
    }
    return funcs
end

function modifier_ernest_swap_agi:GetTexture()
	return "ernest_swap_agi"
end

function modifier_ernest_swap_agi:GetModifierBonusStats_Strength()
	bonus_str = self:GetAbility():GetSpecialValueFor("flat_bonus")
	return bonus_str
end

function modifier_ernest_swap_agi:GetModifierBonusStats_Agility()
	bonus_agi = self:GetAbility():GetSpecialValueFor("flat_bonus")
	bonus_to_primary = self:GetAbility():GetSpecialValueFor("primary_bonus")
	return bonus_agi + bonus_to_primary
end

function modifier_ernest_swap_agi:GetModifierBonusStats_Intellect()
	bonus_int = self:GetAbility():GetSpecialValueFor("flat_bonus")
	return bonus_int
end

function modifier_ernest_swap_agi:IsPurgable()
	return false
end

function modifier_ernest_swap_agi:RemoveOnDeath()
	return false
end

function modifier_ernest_swap_agi:GetModifierMoveSpeedBonus_Constant()
	caster = self:GetParent()
	agimod = caster:GetAgility() - caster:GetBaseAgility()
	return agimod/2
end