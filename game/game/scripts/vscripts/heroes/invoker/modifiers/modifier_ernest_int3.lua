modifier_ernest_int3 = class({})

function modifier_ernest_int3:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE, 
	}
	return funcs
end

function modifier_ernest_int3:DeclareVariables()
	local vars = {
		slow,
	}
	return vars
end

function modifier_ernest_int3:OnCreated()
	slow = self:GetAbility():GetSpecialValueFor("slow")
end

function modifier_ernest_int3:GetTexture()
	return "ernest_int3"
end

function modifier_ernest_int3:GetModifierMoveSpeedBonus_Percentage()
	return -slow
end