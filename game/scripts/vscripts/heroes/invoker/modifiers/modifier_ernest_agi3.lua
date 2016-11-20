modifier_ernest_agi3 = class({})

function modifier_ernest_agi3:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_PROPERTY_INVISIBILITY_LEVEL,
		MODIFIER_EVENT_ON_ABILITY_EXECUTED 
	}
	return funcs
end

function modifier_ernest_agi3:OnCreated(params)
	if IsServer() then
		EmitSoundOnLocationWithCaster( self:GetCaster():GetOrigin(), "Hero_BountyHunter.WindWalk", self:GetCaster() )
		local hAbility = self:GetAbility()
		local hTarget = self:GetParent()
		local nFXIndex = ParticleManager:CreateParticle( "particles/green_fire.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
			ParticleManager:SetParticleControl( nFXIndex, 0, hTarget:GetAbsOrigin() )
			ParticleManager:SetParticleControl( nFXIndex, 15, Vector( 133, 0, 162 ) )
	end
end

function modifier_ernest_agi3:CheckState()
	local invis = false
	if self:GetElapsedTime() > 2 then 
		invis = true 
	end
	
	local state = {
		[MODIFIER_STATE_INVISIBLE] = invis
	}
	return state
end

function modifier_ernest_agi3:GetModifierInvisibilityLevel()
	if self:GetElapsedTime() < 2 then
		return self:GetElapsedTime()/2
	else
		return 1
	end
end

function modifier_ernest_agi3:OnAttackLanded( params )
	if IsServer() then
		if params.attacker == self:GetParent() then
			self:Destroy()
		end
	end
end

function modifier_ernest_agi3:OnAbilityExecuted( params )
	if IsServer() then
		if params.ability:GetAbilityName() ~= "ernest_swap" then	
			if params.unit == self:GetParent() then
				self:Destroy()
			end
		end
	end
end

function modifier_ernest_agi3:GetTexture()
	return "ernest_agi3"
end

function modifier_ernest_agi3:GetAttributes()
	return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE 
end

function modifier_ernest_agi3:AllowIllusionDuplicate() 
	return false
end