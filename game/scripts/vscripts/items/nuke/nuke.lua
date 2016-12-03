if item_nuke == nil then
    item_nuke = class({})
end

LinkLuaModifier("modifier_nuke", "items/nuke/modifier_nuke.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_fallout", "items/nuke/modifier_fallout.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("generic_thinker", "heroes/invoker/modifiers/generic_thinker.lua", LUA_MODIFIER_MOTION_NONE)

function item_nuke:GetIntrinsicModifierName()
	return "modifier_nuke"
end

function item_nuke:GetBehavior() 
    local behaviour = DOTA_ABILITY_BEHAVIOR_POINT
    return behaviour
end

function item_nuke:GetManaCost()
    return 1000
end

function item_nuke:GetCooldown( nLevel )
    return 10
end

function item_nuke:OnSpellStart()
    local hCaster = self:GetCaster() --We will always have Caster.
    local hTarget = false --We might not have target so we make fail-safe so we do not get an error when calling - self:GetCursorTarget()
    if not self:GetCursorTargetingNothing() then
        hTarget = self:GetCursorTarget()
    end
    local vPoint = self:GetCursorPosition() --We will always have Vector for the point.
    local vOrigin = hCaster:GetAbsOrigin() --Our caster's location
	duration = self:GetSpecialValueFor("fallout_duration")
	num1 = 0
	
	local launch_particle = ParticleManager:CreateParticle("particles/nuke/nuke_launch.vpcf", PATTACH_WORLDORIGIN, nil)	
		ParticleManager:SetParticleControl(launch_particle, 0, vOrigin)
	
	hCaster:EmitSound("Hero_Tinker.Heat-Seeking_Missile")
		
	thinker = CreateModifierThinker(hCaster, self, "generic_thinker", {["duration"] = 120}, vPoint, hCaster:GetTeamNumber(), false)
	hCaster:AddNoDraw()
		
	--rocket------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	
	local info = 
	{
		Target = thinker,
		Source = hCaster,
		Ability = self,	
		EffectName = "particles/nuke/nuke.vpcf",
		iMoveSpeed = self:GetSpecialValueFor( "projectile_speed" ),
		vSourceLoc= hCaster:GetAbsOrigin(),                -- Optional (HOW)
		bDrawsOnMinimap = true,                          -- Optional
		bDodgeable = true,                                -- Optional
		bIsAttack = false,                                -- Optional
		bVisibleToEnemies = true,                         -- Optional
		bReplaceExisting = false,                         -- Optional
		flExpireTime = GameRules:GetGameTime() + 30,      -- Optional but recommended
		bProvidesVision = true,                           -- Optional
		iVisionRadius = 2000,                              -- Optional
		iVisionTeamNumber = hCaster:GetTeamNumber()        -- Optional
	}
	projectile = ProjectileManager:CreateTrackingProjectile(info)
	
	--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	
	ProjectileManager:ProjectileDodge(hCaster)  --We disjoint disjointable incoming projectiles.
	
	--blink------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    --[[
	ParticleManager:CreateParticle("particles/items_fx/blink_dagger_start.vpcf", PATTACH_ABSORIGIN, hCaster) --Create particle effect at our caster.
    hCaster:EmitSound("DOTA_Item.BlinkDagger.Activate") --Emit sound for the blink
    hCaster:SetAbsOrigin(vPoint) --We move the caster instantly to the location
    FindClearSpaceForUnit(hCaster, vPoint, false) --This makes sure our caster does not get stuck
    ParticleManager:CreateParticle("particles/items_fx/blink_dagger_end.vpcf", PATTACH_ABSORIGIN, hCaster) --Create particle effect at our caster.
	]]
	--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	
	
end

function item_nuke:OnProjectileThink( vLocation )
	local hCaster = self:GetCaster()
	hCaster:SetAbsOrigin( vLocation:__add(Vector(0,0,200)) )
end

function item_nuke:OnProjectileHit( hTarget, vLocation )
	local hCaster = self:GetCaster() --We will always have Caster.
    local vPoint = thinker:GetAbsOrigin()
    local vOrigin = hCaster:GetAbsOrigin() --Our caster's location
	duration = self:GetSpecialValueFor("fallout_duration")
	num1 = 0
	
	hCaster:SetAbsOrigin( vLocation )
	hCaster:RemoveNoDraw()
	
	local nuke_particle = ParticleManager:CreateParticle("particles/nuke/mini_nuke.vpcf", PATTACH_ABSORIGIN, thinker)	
		ParticleManager:SetParticleControl(nuke_particle, 0, vPoint)
	hCaster:EmitSound("Hero_Techies.Suicide")
	
	GridNav:DestroyTreesAroundPoint(vPoint, self:GetSpecialValueFor("radius"), true)
	
	near_targets = FindUnitsInRadius(hCaster:GetTeamNumber(), vPoint, nil, self:GetSpecialValueFor("radius")/2, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP, 0, 0, false)
	
	for _,v in pairs(near_targets) do
		local damageTable = {
			victim = v,
			attacker = hCaster,
			damage = self:GetSpecialValueFor("damage"),
			damage_type = DAMAGE_TYPE_PURE,
		}
		ApplyDamage(damageTable)
	end

	Timers:CreateTimer(0.1, function()
		far_targets = FindUnitsInRadius(hCaster:GetTeamNumber(), vPoint, nil, self:GetSpecialValueFor("radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP, 0, 0, false)
		
		for _,v in pairs(far_targets) do
			local damageTable = {
				victim = v,
				attacker = hCaster,
				damage = self:GetSpecialValueFor("damage"),
				damage_type = DAMAGE_TYPE_PURE,
			}
			ApplyDamage(damageTable)
		end	
	end)
	
	
	Timers:CreateTimer(0.2, function()
			
		local targets = FindUnitsInRadius(hCaster:GetTeamNumber(), vPoint, nil, self:GetSpecialValueFor("radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP, 0, 0, false)
		
			
		for _,v in pairs(targets) do
			local damageTable = {
				victim = v,
				attacker = hCaster,
				damage = v:GetMaxHealth() * self:GetSpecialValueFor("fallout_dps")/1000,
				damage_type = DAMAGE_TYPE_PURE,
			}
			ApplyDamage(damageTable)
			
			v:AddNewModifier(hCaster, self, "modifier_fallout", nil)
		end
		
		local all_heroes = HeroList:GetAllHeroes()
		
		for _,v in pairs(all_heroes) do
			outside_radius = true
			
			for _,w in pairs(targets) do
				if v == w then
					outside_radius = false
				end
			end
			
			if outside_radius == true then
				v:RemoveModifierByName("modifier_fallout")
			end
		end
		
		num1 = num1 + 0.1
		
		if num1 < duration then
			return 0.1
		end
	end)
		
	Timers:CreateTimer(duration + 0.2, function()
		local all_heroes = HeroList:GetAllHeroes()
		
		for _,v in pairs(all_heroes) do
			v:RemoveModifierByName("modifier_fallout")
		end
		
		--ParticleManager:DestroyParticle(EffectName, false)
	end)
end