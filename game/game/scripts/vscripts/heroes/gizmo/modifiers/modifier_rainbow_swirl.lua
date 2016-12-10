modifier_rainbow_swirl = class({})

function modifier_rainbow_swirl:DeclareFunctions()
    local funcs = {
		MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE,
    }
    return funcs
end

function modifier_rainbow_swirl:GetModifierPercentageCooldown()
	return self:GetAbility():GetSpecialValueFor("cooldown_reduction")
end
