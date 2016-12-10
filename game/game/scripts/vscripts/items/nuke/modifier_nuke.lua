modifier_nuke = class({})

function modifier_nuke:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
    }
    return funcs
end

function modifier_nuke:IsHidden()
	return true
end

function modifier_nuke:GetModifierBonusStats_Strength()
	return 50
end

function modifier_nuke:GetModifierBonusStats_Agility()
	return 50
end

function modifier_nuke:GetModifierBonusStats_Intellect()
	return 50
end

function modifier_nuke:	GetModifierPreAttack_BonusDamage()
	return 60
end

function modifier_nuke:IsPurgable()
	return false
end