modifier_spritely_speed = class({})

function modifier_spritely_speed:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_MOVESPEED_MAX,
        MODIFIER_PROPERTY_MOVESPEED_LIMIT,
    }
    return funcs
end

function modifier_spritely_speed:IsPurgable()
	return false
end

function modifier_spritely_speed:GetModifierMoveSpeedBonus_Percentage()
	bonus = self:GetAbility():GetSpecialValueFor("movespeed_bonus")
	return bonus
end

function modifier_spritely_speed:GetModifierMoveSpeed_Max()
    return 1000
end

function modifier_spritely_speed:GetModifierMoveSpeed_Limit()
    return 1000
end




