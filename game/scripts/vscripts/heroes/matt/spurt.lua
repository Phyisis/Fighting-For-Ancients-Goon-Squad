spurt = class({})

function spurt:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	 
	local info = 
	{
		Target = target,
		Source = caster,
		Ability = self,	
		EffectName = "spurt_trail.vpcf",
		iMoveSpeed = 1150,
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
end

function spurt:OnProjectileHit() 
	local damageTable = {
		victim = target,
		attacker = caster,
		damage = self:GetSpecialValueFor("damage"),
		damage_type = DAMAGE_TYPE_MAGICAL,
	}
	ApplyDamage(damageTable)
end