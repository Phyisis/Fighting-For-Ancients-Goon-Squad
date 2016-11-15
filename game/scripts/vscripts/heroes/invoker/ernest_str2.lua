ernest_str2 = class({})

function ernest_str2:OnSpellStart()
	caster = self:GetCaster()
	duration = self:GetSpecialValueFor("duration")
	num = 0
	
	Timers:CreateTimer(0, function()
		radius = self:GetSpecialValueFor("radius")
		point = caster:GetAbsOrigin()
		targets = FindUnitsInRadius(caster:GetTeamNumber(), point, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, 0, false)
			
		for _,target in pairs(targets) do
			local distance = (target:GetAbsOrigin() - point):Length2D()
			velocity = self:GetSpecialValueFor("velocity")
			direction = (point - target:GetAbsOrigin())/distance
			if distance > 150 then
				target:SetAbsOrigin(target:GetAbsOrigin() + direction * velocity)
				print(velocity)
			end
		end
		
		num = num + .033
		print(num)
		
		if num < duration then
			return .033
		end
	end)
end