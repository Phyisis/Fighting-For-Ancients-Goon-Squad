modifier_moonwalk = class({})

function modifier_moonwalk:DeclareFunctions()
    local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BASE_OVERRIDE,
		MODIFIER_PROPERTY_TURN_RATE_PERCENTAGE,
		MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE_MIN,
    }
    return funcs
end

function modifier_moonwalk:GetModifierTurnRate_Percentage()
	return self:GetAbility():GetSpecialValueFor("turn_rate")
end

function modifier_moonwalk:GetModifierMoveSpeed_AbsoluteMin()
	return 1
end

function modifier_moonwalk:GetModifierMoveSpeedOverride()
	return 1
end