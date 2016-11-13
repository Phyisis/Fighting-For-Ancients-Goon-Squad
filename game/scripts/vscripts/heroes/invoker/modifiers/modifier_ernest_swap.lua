modifier_ernest_swap = class({})

function modifier_ernest_swap:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
    }
    return funcs
end

function modifier_ernest_swap:IsPurgable()
	return false
end

function modifier_ernest_swap:GetModifierBonusStats_Strength()
	bonus_str = self:GetAbility():GetSpecialValueFor("flat_bonus")
	bonus_to_primary = self:GetAbility():GetSpecialValueFor("primary_bonus")
	caster = self:GetParent()
	if caster:GetPrimaryAttribute() == DOTA_ATTRIBUTE_STRENGTH then
		return bonus_str + bonus_to_primary
	else
		return bonus_str
	end
end

function modifier_ernest_swap:IsHidden()
	return true
end

function modifier_ernest_swap:GetModifierBonusStats_Agility()
	bonus_agi = self:GetAbility():GetSpecialValueFor("flat_bonus")
	bonus_to_primary = self:GetAbility():GetSpecialValueFor("primary_bonus")
	caster = self:GetParent()

	if caster:GetPrimaryAttribute() == DOTA_ATTRIBUTE_AGILITY then
		return bonus_agi + bonus_to_primary
	else
		return bonus_agi
	end
end

function modifier_ernest_swap:GetModifierBonusStats_Intellect()
	bonus_int = self:GetAbility():GetSpecialValueFor("flat_bonus")
	bonus_to_primary = self:GetAbility():GetSpecialValueFor("primary_bonus")
	caster = self:GetParent()
	if caster:GetPrimaryAttribute() == DOTA_ATTRIBUTE_INTELLECT then
		return bonus_int + bonus_to_primary
	else
		return bonus_int
	end
end