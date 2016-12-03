ernest_int2 = class({})

LinkLuaModifier("modifier_ernest_int2", "heroes/invoker/modifiers/modifier_ernest_int2.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("generic_thinker", "heroes/invoker/modifiers/generic_thinker.lua", LUA_MODIFIER_MOTION_NONE)

function ernest_int2:OnSpellStart()
	caster = self:GetCaster()
	target = caster:GetCursorPosition()
	duration = self:GetSpecialValueFor("duration")
	radius = self:GetSpecialValueFor("radius")
	num1 = 0
	
	AddFOWViewer(caster:GetTeamNumber(), target, radius, duration, false)
	
	local thinker = CreateModifierThinker(caster, self, "generic_thinker", {["duration"] = duration}, target, caster:GetTeamNumber(), false)
	
	local rain_particle = ParticleManager:CreateParticle("particles/acid_ripple.vpcf", PATTACH_WORLDORIGIN, nil)	
		ParticleManager:SetParticleControl(rain_particle, 10, target)
		ParticleManager:SetParticleControl(rain_particle, 11, Vector(radius/100, radius/100, 1))
	
	if IsServer() then
		StartSoundEventFromPosition("lightning.thunder", target)
	end
	
	Timers:CreateTimer(0.1, function()
			
		local heroes_in_radius = FindUnitsInRadius(caster:GetTeamNumber(), target, nil, self:GetSpecialValueFor("radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, 0, false)
		
			
		for _,v in pairs(heroes_in_radius) do
			local damageTable = {
				victim = v,
				attacker = caster,
				damage = self:GetSpecialValueFor("flat_damage")/10 + v:GetMaxHealth() * self:GetSpecialValueFor("percent_damage")/1000 ,
				damage_type = DAMAGE_TYPE_MAGICAL,
			}
			ApplyDamage(damageTable)
			
			v:AddNewModifier(caster, self, "modifier_ernest_int2", nil)
		end
		
		local all_heroes = HeroList:GetAllHeroes()
		
		for _,v in pairs(all_heroes) do
			outside_radius = true
			
			for _,w in pairs(heroes_in_radius) do
				if v == w then
					outside_radius = false
				end
			end
			
			if outside_radius == true then
				v:RemoveModifierByName("modifier_ernest_int2")
			end
		end
		
		num1 = num1 + 0.1
		
		if num1 < duration then
			return 0.1
		end
	end)
	
	Timers:CreateTimer(duration + 0.2, function()
		if IsServer() then
			StopSoundEvent("lightning.thunder", nil)
		end
		
		local all_heroes = HeroList:GetAllHeroes()
		
		for _,v in pairs(all_heroes) do
			v:RemoveModifierByName("modifier_ernest_int2")
		end
		
		ParticleManager:DestroyParticle(rain_particle, false)
	end)
		
end

function ernest_int2:GetAOERadius()
	radius = self:GetSpecialValueFor("radius")
	return radius
end