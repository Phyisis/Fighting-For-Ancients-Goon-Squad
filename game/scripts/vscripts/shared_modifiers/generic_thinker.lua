generic_thinker = class({})

function generic_thinker:OnIntervalThink()
	if IsServer() then		
		--[[
			local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_lina/lina_spell_light_strike_array.vpcf", PATTACH_WORLDORIGIN, nil )
			ParticleManager:SetParticleControl( nFXIndex, 0, self:GetParent():GetOrigin() )
			ParticleManager:SetParticleControl( nFXIndex, 1, Vector( self.light_strike_array_aoe, 1, 1 ) )
			ParticleManager:ReleaseParticleIndex( nFXIndex )
	 
			EmitSoundOnLocationWithCaster( self:GetParent():GetOrigin(), "Ability.LightStrikeArray", self:GetCaster() )
	 
			
		
		]]--
		Timer:CreateTimer(duration, function()
			UTIL_Remove( self:GetParent() )
		end)
	end
end