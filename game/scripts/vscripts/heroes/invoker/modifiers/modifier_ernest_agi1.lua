modifier_ernest_agi1 = class({})

function modifier_ernest_agi1:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_EVASION_CONSTANT, 
	}
	return funcs
end

function modifier_ernest_agi1:OnCreated()
	if IsServer() then
		evasion_blur = ParticleManager:CreateParticle( "particles/evasion_blur.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
			ParticleManager:SetParticleControl( evasion_blur, 0, self:GetParent():GetAbsOrigin() )
	end
end

function modifier_ernest_agi1:GetModifierEvasion_Constant()
	evasion = self:GetAbility():GetSpecialValueFor("evasion")
	return evasion
end

function modifier_ernest_agi1:IsPurgable()
	return true
end

function modifier_ernest_agi1:GetTexture()
	return "ernest_agi1"
end

function modifier_ernest_agi1:IsDebuff()
	return false
end

function modifier_ernest_agi1:OnDestroy()
	ParticleManager:DestroyParticle(evasion_blur, false)
end