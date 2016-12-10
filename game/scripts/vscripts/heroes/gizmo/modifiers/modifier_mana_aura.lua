modifier_mana_aura = class({})

function modifier_mana_aura:DeclareFunctions()
	local funcs = {
	MODIFIER_PROPERTY_MANA_REGEN_TOTAL_PERCENTAGE,
	}
	return funcs
end

function modifier_mana_aura:GetModifierTotalPercentageManaRegen()
	regen = 0
	if self:GetParent():GetManaPercent() ~= 100 then
		regen = self:GetAbility():GetSpecialValueFor("mana")
	end
	return regen
end

function modifier_mana_aura:GetEffectName()
	return "particles/mana_regen.vpcf"
end