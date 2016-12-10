mana_aura = class({})

LinkLuaModifier("modifier_mana_aura", "heroes/gizmo/modifiers/modifier_mana_aura.lua", LUA_MODIFIER_MOTION_NONE)

function mana_aura:OnSpellStart()
	caster = self:GetCaster()
	duration = self:GetSpecialValueFor("duration")
	radius = self:GetSpecialValueFor("radius")
	num = 0

	local nFXIndex = ParticleManager:CreateParticle( "particles/mana_source.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster )
		ParticleManager:SetParticleControl( nFXIndex, 0, caster:GetAbsOrigin() )

	Timers:CreateTimer(0.1, function()
		
		vPos = caster:GetAbsOrigin()
		local in_radius = FindUnitsInRadius(caster:GetTeamNumber(), vPos, nil, radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, 0, 0, false)
		for _,h in pairs(in_radius) do
			if not h:HasModifier("modifier_mana_aura") then
				print("adding mana_regen")
				h:AddNewModifier(caster, self, "modifier_mana_aura", nil)				
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
				a:RemoveModifierByName("modifier_mana_aura")
			end
		end
		
		num = num + 0.03
		
		if num < duration then			
			return 0.03
		else
			ParticleManager:DestroyParticle(nFXIndex, false)			
			for _,a in pairs(all_heroes) do
				if a:HasModifier("modifier_mana_aura") then
					a:RemoveModifierByName("modifier_mana_aura")
					print("removing mana_regen")		
				end			
			end
		end
	end)
end