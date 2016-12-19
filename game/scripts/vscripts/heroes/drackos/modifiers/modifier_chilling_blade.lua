modifier_chilling_blade = class({})

function modifier_chilling_blade:DeclareFunctions()
	local funcs = {
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}
	return funcs
end

function modifier_chilling_blade:GetModifierMoveSpeedBonus_Percentage()
	slow = self:GetAbility():GetSpecialValueFor("Slow")
	return -slow
end