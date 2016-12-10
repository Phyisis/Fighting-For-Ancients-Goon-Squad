rainbow_wave = class({})

--------------------------------------------------------------------------------

function rainbow_wave:OnSpellStart()
	self.wave_speed = self:GetSpecialValueFor( "wave_speed" )
	self.wave_width_initial = self:GetSpecialValueFor( "wave_width_initial" )
	self.wave_width_end = self:GetSpecialValueFor( "wave_width_end" )
	self.wave_distance = self:GetSpecialValueFor( "wave_distance" )
	self.wave_damage = self:GetSpecialValueFor( "wave_damage" ) 

	EmitSoundOn( "Hero_Magnataur.ShockWave.Cast.Anvil", self:GetCaster() )
	local wave_particle = ParticleManager:CreateParticle("particles/rainbow_wave.vpcf", PATTACH_ABSORIGIN, self:GetCaster())
		ParticleManager:SetParticleControl( wave_particle, 0, self:GetCaster():GetAbsOrigin():__add(Vector(0,0,200)) )

	--[[ Point Target
	local vPos = nil
	if self:GetCursorTarget() then
		vPos = self:GetCursorTarget():GetOrigin()
	else
		vPos = self:GetCursorPosition()
	end

	local vDirection = vPos - self:GetCaster():GetOrigin()
	vDirection.z = 0.0
	vDirection = vDirection:Normalized()
	]]

	-- No Target
	vDirection = self:GetCaster():GetForwardVector()

	self.wave_speed = self.wave_speed * ( self.wave_distance / ( self.wave_distance - self.wave_width_initial ) )

	local info = {
		EffectName = "",
		Ability = self,
		vSpawnOrigin = self:GetCaster():GetOrigin(), 
		fStartRadius = self.wave_width_initial,
		fEndRadius = self.wave_width_end,
		vVelocity = vDirection * self.wave_speed,
		fDistance = self.wave_distance,
		Source = self:GetCaster(),
		iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP,
	}

	ProjectileManager:CreateLinearProjectile( info )
	EmitSoundOn( "Hero_Magnataur.ShockWave.Cast.Anvil", self:GetCaster() )
end

--------------------------------------------------------------------------------

function rainbow_wave:OnProjectileHit( hTarget, vLocation )
	if hTarget ~= nil and ( not hTarget:IsMagicImmune() ) and ( not hTarget:IsInvulnerable() ) then
		local damage = {
			victim = hTarget,
			attacker = self:GetCaster(),
			damage = self.wave_damage,
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = self
		}

		ApplyDamage( damage )

		local vDirection = vLocation - self:GetCaster():GetOrigin()
		vDirection.z = 0.0
		vDirection = vDirection:Normalized()
		
		--local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_lina/lina_spell_wave_impact.vpcf", PATTACH_ABSORIGIN_FOLLOW, hTarget )
		--ParticleManager:SetParticleControlForward( nFXIndex, 1, vDirection )
		--ParticleManager:ReleaseParticleIndex( nFXIndex )
	end

	return false
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------