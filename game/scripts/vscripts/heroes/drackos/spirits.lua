spirits = class({})

LinkLuaModifier("modifier_spirits", "heroes/drackos/modifiers/modifier_spirits.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("generic_thinker", "shared_modifiers/generic_thinker.lua", LUA_MODIFIER_MOTION_NONE)

function spirits:OnAbilityPhaseStart()
	hCaster = self:GetCaster()
	vCaster = self:GetCaster():GetAbsOrigin()
	vPoint = hCaster:GetCursorPosition()
	vForward = hCaster:GetForwardVector()
	vNormal = hCaster:GetUpVector()
	vDirection = vNormal:Cross(vForward)
	sDistance = self:GetSpecialValueFor("sDistance")
	vMidPoint = vCaster + sDistance*vDirection
	sSpeed = self:GetSpecialValueFor("projectile_speed")
	sDuration = ((vPoint-vMidPoint):Length() + (vMidPoint-vCaster):Length())/sSpeed
	duration = self:GetSpecialValueFor("duration")
	radius = self:GetSpecialValueFor("radius")
	num = 0
	t = 0

	-- Q0 = P0+t(P0P1)+t(P1+t(P1P2)−(P0+t(P0P1)))
	
	local thinker = CreateModifierThinker(hCaster, self, "generic_thinker", {["duration"] = sDuration+5}, vCaster, hCaster:GetTeamNumber(), false)
	
	local spirit_particle = ParticleManager:CreateParticle("particles/spirit_projectile.vpcf", PATTACH_ABSORIGIN_FOLLOW, thinker)	
		ParticleManager:SetParticleControl(spirit_particle, 0, thinker:GetAbsOrigin())

	Timers:CreateTimer(0, function()
		num = num + 0.03
		if num < sDuration then
			t = num/sDuration
			next_point = vCaster + t*(vMidPoint-vCaster) + t*(vMidPoint + t*(vPoint-vMidPoint) - (vCaster + t*(vMidPoint-vCaster)))
			thinker:SetAbsOrigin(GetGroundPosition(next_point, nil))
			--Add modifier----------------------------------------------------------------------------------------------------------------
			local heroes_in_radius = FindUnitsInRadius(hCaster:GetTeamNumber(), next_point, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP, 0, 0, false)

			for _,v in pairs(heroes_in_radius) do
				if not v:HasModifier("modifier_spirits") then
					v:AddNewModifier(hCaster, self, "modifier_spirits", {["duration"] = duration})
				end
			end
			------------------------------------------------------------------------------------------------------------------------------
			return 0.03
		else
			thinker:SetAbsOrigin(vPoint:__add(Vector(0,0,-500), nil))
		end
	end)
end

function spirits:OnUpgrade()
	hCaster = self:GetCaster()
	local spirits2_ability = hCaster:FindAbilityByName("spirits2")
	local spirits3_ability = hCaster:FindAbilityByName("spirits3")
	local spirits_level = self:GetLevel()
	
	if spirits2_ability ~= nil and spirits2_ability:GetLevel() ~= spirits_level then
		spirits2_ability:SetLevel(spirits_level)
	end

	if spirits3_ability ~= nil and spirits3_ability:GetLevel() ~= spirits_level then
		spirits3_ability:SetLevel(spirits_level)
	end
end