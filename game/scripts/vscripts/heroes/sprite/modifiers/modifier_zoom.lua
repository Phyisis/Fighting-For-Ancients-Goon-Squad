modifier_zoom = class({})

function modifier_zoom:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_MOVESPEED_MAX,
        MODIFIER_PROPERTY_MOVESPEED_LIMIT,
    }
    return funcs
end

function modifier_zoom:IsPurgable()
	return false
end

function modifier_zoom:GetModifierMoveSpeedBonus_Percentage()
	bonus = self:GetAbility():GetSpecialValueFor("zoom_movespeed")
	return bonus
end

function modifier_zoom:GetModifierMoveSpeed_Max()
    return 1000
end

function modifier_zoom:GetModifierMoveSpeed_Limit()
    return 1000
end




