ernest_int2 = class({})

LinkLuaModifier("modifier_ernest_int2", "heroes/invoker/modifiers/modifier_ernest_int2.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("rain_thinker", "heroes/invoker/modifiers/rain_thinker.lua", LUA_MODIFIER_MOTION_NONE)

function ernest_int2:OnSpellStart()
	caster = self:GetCaster()
	target = caster:GetCursorPosition()
	duration = self:GetSpecialValueFor("duration")
	radius = self:GetSpecialValueFor("radius")
	num = 0
	AddFOWViewer(caster:GetTeamNumber(), target, radius, duration, false)
	local thinker = CreateModifierThinker(caster, self, "rain_thinker", {["duration"] = duration}, target, caster:GetTeamNumber(), false)
	local rain_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_slardar/slardar_amp_damage_rain.vpcf", PATTACH_ABSORIGIN, thinker)	
	ParticleManager:SetParticleControl(rain_particle, 0, Vector(radius,radius,0))
	ParticleManager:SetParticleControl(rain_particle, 2, Vector(0,0,600))
	print(thinker:GetAbsOrigin() + Vector(0,0,200))
	
	Timers:CreateTimer(1, function()
			
		victims = FindUnitsInRadius(caster:GetTeamNumber(), target, nil, self:GetSpecialValueFor("radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, 0, false)
			
		for _,v in pairs(victims) do
			
			local damageTable = {
				victim = v,
				attacker = caster,
				damage = self:GetSpecialValueFor("flat_damage") + v:GetHealth() * self:GetSpecialValueFor("percent_damage")/100 ,
				damage_type = DAMAGE_TYPE_MAGICAL,
			}
			ApplyDamage(damageTable)
		
		end
		
		num = num + 1
		
		if num < duration then
			return 1
		end
						
	end)
	
	ParticleManager:DestroyParticle(rain_particle, false)

end
