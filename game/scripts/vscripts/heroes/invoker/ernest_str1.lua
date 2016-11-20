ernest_str1 = class({})

LinkLuaModifier("modifier_ernest_str1", "heroes/invoker/modifiers/modifier_ernest_str1.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("generic_thinker", "heroes/invoker/modifiers/generic_thinker.lua", LUA_MODIFIER_MOTION_NONE)

function ernest_str1:OnSpellStart()
	caster = self:GetCaster()
	target = caster:GetAbsOrigin()
	duration = self:GetSpecialValueFor("duration")
	radius = self:GetSpecialValueFor("radius")
	damage = self:GetSpecialValueFor("damage")/10
	num = 0
	
	if IsServer() then	
		local thinker = CreateModifierThinker(caster, self, "generic_thinker", {["duration"] = duration}, target, caster:GetTeamNumber(), false)

		local ash_particle = ParticleManager:CreateParticle("particles/ash_ring.vpcf", PATTACH_WORLDORIGIN, nil)
			ParticleManager:SetParticleControl( ash_particle, 3, thinker:GetAbsOrigin() )
		StartSoundEventFromPosition("Hero_DoomBringer.ScorchedEarthAura", target)
	end
	
	Timers:CreateTimer(0.1, function()
			
		local outer_radius = FindUnitsInRadius(caster:GetTeamNumber(), target, nil, radius+200, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP, 0, 0, false)
		local inner_radius = FindUnitsInRadius(caster:GetTeamNumber(), target, nil, radius-200, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP, 0, 0, false)
		
			
		for _,v in pairs(outer_radius) do
			in_fire = true
			for _,w in pairs(inner_radius) do
				if v == w then 
					in_fire = false
				end
			end
			
			if in_fire == true then
				local damageTable = {
					victim = v,
					attacker = caster,
					damage = self:GetSpecialValueFor("damage")/10,
					damage_type = DAMAGE_TYPE_MAGICAL,
				}
				ApplyDamage(damageTable)
				
				v:AddNewModifier(caster, nil, "modifier_ernest_str1", nil)
			end
		end
		
		local all_heroes = HeroList:GetAllHeroes()
		
		for _,v in pairs(all_heroes) do
			outside_fire = true
			
			for _,w in pairs(outer_radius) do
				if v == w then
					outside_fire = false
				end
				for _,x in pairs(inner_radius) do 
					if w == x then 
						outside_fire = true
					end
				end
			end
			
			if outside_fire == true then
				v:RemoveModifierByName("modifier_ernest_str1")
			end
		end
		
		num = num + 0.1
		
		if num < duration then
			return 0.1
		end
	end)
	
	Timers:CreateTimer(duration + 0.2, function()
		if IsServer() then
			StopSoundEvent("Hero_DoomBringer.ScorchedEarthAura", nil)
		end
		
		local all_heroes = HeroList:GetAllHeroes()
		
		for _,v in pairs(all_heroes) do
			v:RemoveModifierByName("modifier_ernest_str1")
		end

		ParticleManager:DestroyParticle(ash_particle, false)
	end)
		
end