rainbow_swirl = class({})

LinkLuaModifier("modifier_rainbow_swirl", "heroes/gizmo/modifiers/modifier_rainbow_swirl.lua", LUA_MODIFIER_MOTION_NONE)

function rainbow_swirl:OnSpellStart()
	caster = self:GetCaster()
	duration = self:GetSpecialValueFor("duration")
	radius = self:GetSpecialValueFor("radius")
	num = 0

	caster:EmitSound("rainbow_siren")
	
	local nFXIndex = ParticleManager:CreateParticle( "particles/rainbow_ribbon.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetCaster() )
		ParticleManager:SetParticleControl( nFXIndex, 0, caster:GetAbsOrigin() )
		ParticleManager:SetParticleControl( nFXIndex, 1, Vector(radius,0,0))
	
	Timers:CreateTimer(0, function()
		vPos = caster:GetAbsOrigin()
		local in_radius = FindUnitsInRadius(caster:GetTeamNumber(), vPos, nil, radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, 0, 0, false)
		for _,h in pairs(in_radius) do
			if not h:HasModifier("modifier_rainbow_swirl") then
				h:AddNewModifier(caster, self, "modifier_rainbow_swirl", nil)
			end
		end
		
		local all_heroes = HeroList:GetAllHeroes()
		
		for _,a in pairs(all_heroes) do
			outside_radius = true
			
			for _,h in pairs(in_radius) do
				if a == h then
					outside_radius = false
				end
			end
			
			if outside_radius == true then
				a:RemoveModifierByName("modifier_rainbow_swirl")
			end
		end
		
		num = num + 0.1
		
		if num < duration then			
			return 0.1
		end
	end)
	
	Timers:CreateTimer(duration + 0.2, function()
		ParticleManager:DestroyParticle(nFXIndex, false)
		local all_heroes = HeroList:GetAllHeroes()
		
		for _,e in pairs(all_heroes) do
			e:RemoveModifierByName("modifier_rainbow_swirl")
		end
	end)
end