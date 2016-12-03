spurt = class({})

function spurt:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	 
	local info = 
	{
		Target = target,
		Source = caster,
		Ability = self,	
		EffectName = "particles/spurt_tracker.vpcf",
		iMoveSpeed = self:GetSpecialValueFor( "projectile_speed" ),
		vSourceLoc= caster:GetAbsOrigin(),                -- Optional (HOW)
		bDrawsOnMinimap = false,                          -- Optional
		bDodgeable = true,                                -- Optional
		bIsAttack = false,                                -- Optional
		bVisibleToEnemies = true,                         -- Optional
		bReplaceExisting = false,                         -- Optional
		flExpireTime = GameRules:GetGameTime() + 10,      -- Optional but recommended
		bProvidesVision = true,                           -- Optional
		iVisionRadius = 400,                              -- Optional
		iVisionTeamNumber = caster:GetTeamNumber()        -- Optional
	}
	projectile = ProjectileManager:CreateTrackingProjectile(info)
	EmitSoundOn( "Hero_Morphling.AdaptiveStrike.Cast", self:GetCaster() )
end

function spurt:OnProjectileHit( hTarget, vLocation )
	if hTarget ~= nil and ( not hTarget:IsInvulnerable() ) and ( not hTarget:TriggerSpellAbsorb( self ) ) then
		EmitSoundOn( "Hero_Morphling.AdaptiveStrike", hTarget )
		local spurt_damage = self:GetSpecialValueFor( "damage" )
		

		if hTarget:IsAlive() and ( not hTarget:IsMagicImmune() ) and ( not hTarget:IsInvulnerable() ) then

			local damagetable = {
				victim = hTarget,
				attacker = self:GetCaster(),
				damage = spurt_damage,
				damage_type = DAMAGE_TYPE_MAGICAL,
			}
			ApplyDamage( damagetable )
			hTarget:AddNewModifier( self:GetCaster(), self, "modifier_stunned", { duration = self:GetSpecialValueFor("stun_duration")} )
		
		end
	end

	return true
end
