modifier_water_fiend = class({})

function modifier_water_fiend:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_PROPERTY_EVASION_CONSTANT,
		MODIFIER_EVENT_ON_UNIT_MOVED,
	}
	return funcs
end

function modifier_water_fiend:DeclareVariables()
	local vars = {
		damage,
		speed,
		hp_regen,
		mana_regen,
		evasion,
	}
	return vars
end

function modifier_water_fiend:OnCreated(keys)
	damage = keys.damage
	speed = keys.speed
	hp_regen = keys.hp_regen
	mana_regen = keys.mana_regen
	evasion = keys.evasion
	
	if IsServer() then
		water_particle = ParticleManager:CreateParticle( "particles/water_buff5.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
			ParticleManager:SetParticleControl( water_particle, 0, self:GetParent():GetAbsOrigin())
	end
end

function modifier_water_fiend:GetModifierDamageOutgoing_Percentage()
	if IsServer() then
		return damage
	end
end

function modifier_water_fiend:GetModifierMoveSpeedBonus_Percentage()
	if IsServer() then
		--speed = ability:GetSpecialValueFor("speed")
		return speed
	end
end

function modifier_water_fiend:GetModifierConstantHealthRegen()
	if IsServer() then
		--hp_regen = ability:GetSpecialValueFor("hp_regen")
		return hp_regen
	end
end

function modifier_water_fiend:GetModifierConstantManaRegen()
	if IsServer() then
		--mana_regen = ability:GetSpecialValueFor("mana_regen")
		return mana_regen
	end
end

function modifier_water_fiend:GetModifierEvasion_Constant()
	if IsServer() then
		--evasion = ability:GetSpecialValueFor("evasion")
		return evasion
	end
end

function modifier_water_fiend:GetModifierUnitStatsNeedsRefresh()
	return true
end

function modifier_water_fiend:IsPurgable()
	return false
end

function modifier_water_fiend:GetTexture()
	return "water_fiend"
end

function modifier_water_fiend:IsDebuff()
	return false
end

function modifier_water_fiend:OnDestroy()
	if IsServer() then
		ParticleManager:DestroyParticle(water_particle, false)
	end
end





