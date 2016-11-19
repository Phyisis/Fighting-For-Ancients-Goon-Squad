ernest_int3 = class({})

LinkLuaModifier("modifier_ernest_int3", "heroes/invoker/modifiers/modifier_ernest_int3.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("generic_thinker", "heroes/invoker/modifiers/generic_thinker.lua", LUA_MODIFIER_MOTION_NONE)

function ernest_int3:OnSpellStart()
	caster = self:GetCaster()
	target = caster:GetCursorPosition()
	duration = self:GetSpecialValueFor("duration")
	radius = self:GetSpecialValueFor("radius")
	slow = self:GetSpecialValueFor("slow")
	one = Vector(radius,0,0)
	num1 = 0
	num2 = 0
		
	local thinker = CreateModifierThinker(caster, self, "generic_thinker", {["duration"] = duration}, target, caster:GetTeamNumber(), false)
	
	local ice_particle = ParticleManager:CreateParticle("particles/ice_sheet.vpcf", PATTACH_WORLDORIGIN, thinker)	
		ParticleManager:SetParticleControl(ice_particle, 0, thinker:GetAbsOrigin() )
	
	if IsServer() then
		Timers:CreateTimer(0, function()
			StartSoundEventFromPosition("Hero_Invoker.IceWall.Slow", target)
			num2 = num2 + 1
		
			if num1 < duration then
				return 1
			end
		end)
	end
	
	Timers:CreateTimer(0.1, function()
			
		local heroes_in_radius = FindUnitsInRadius(caster:GetTeamNumber(), target, nil, self:GetSpecialValueFor("radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, 0, false)
		
			
		for _,v in pairs(heroes_in_radius) do
			v:AddNewModifier(caster, self, "modifier_ernest_int3", {["duration"] = duration})
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
				v:RemoveModifierByName("modifier_ernest_int3")
			end
		end
		
		num1 = num1 + 0.1
		
		if num1 < duration then
			return 0.1
		end
	end)
	
	Timers:CreateTimer(duration + 0.2, function()
		if IsServer() then
			StopSoundEvent("Hero_Invoker.IceWall.Slow", nil)
		end
		
		local all_heroes = HeroList:GetAllHeroes()
		
		for _,v in pairs(all_heroes) do
			v:RemoveModifierByName("modifier_ernest_int3")
		end
		
		ParticleManager:DestroyParticle(ice_particle, false)
	end)
		
end