spirits3 = class({})

LinkLuaModifier("modifier_spirits_tracker", "heroes/drackos/modifiers/modifier_spirits_tracker.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("generic_thinker", "shared_modifiers/generic_thinker.lua", LUA_MODIFIER_MOTION_NONE)

function spirits3:OnAbilityPhaseStart()
	self:StartCooldown(self:GetCooldown(self:GetLevel()))
	hCaster = self:GetCaster()
	vCaster = self:GetCaster():GetAbsOrigin()
	vPoint = hCaster:GetCursorPosition()
	vForward = hCaster:GetForwardVector()
	vNormal = hCaster:GetUpVector()
	vDirection = -vForward
	sDistance = self:GetSpecialValueFor("sDistance")
	vMidPoint = vCaster + sDistance*vDirection
	sSpeed = self:GetSpecialValueFor("projectile_speed")
	sDuration = ((vPoint-vMidPoint):Length() + (vMidPoint-vCaster):Length())/sSpeed
	print("sDuration: " .. sDuration)
	duration = self:GetSpecialValueFor("duration")
	radius = self:GetSpecialValueFor("radius")
	damage = self:GetSpecialValueFor("damage")
	multiplier = self:GetSpecialValueFor("multiplier")
	stacks = 0
	num = 0
	t = 0

	if not self.hit_heroes then
		self.hit_heroes = {}
	end
	self.hit_heroes = {}

	-- Q0 = P0+t(P0P1)+t(P1+t(P1P2)−(P0+t(P0P1)))
	
	local thinker = CreateModifierThinker(hCaster, self, "generic_thinker", {["duration"] = sDuration+3}, vCaster, hCaster:GetTeamNumber(), false)
	
	thinker:EmitSound("Hero_Bane.Nightmare.Loop")
	
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

			for j,v in pairs(heroes_in_radius) do
				hit = false
				for k,w in pairs(self.hit_heroes) do
					if v == w then
						print("projectile already hit")
						hit = true
					end
				end

				if hit == false then
					print("projectile hit")
					table.insert(self.hit_heroes, v)
					if v:HasModifier("modifier_spirits_tracker") then
						print("increment existing modifier_spirits_tracker")
						stacks = v:GetModifierStackCount("modifier_spirits_tracker", hCaster)+1
						v:SetModifierStackCount("modifier_spirits_tracker", hCaster, stacks)
					else
						print("create modifier_spirits_tracker")
						stacks = 1
						v:AddNewModifier(hCaster, self, "modifier_spirits_tracker", nil)
						v:SetModifierStackCount("modifier_spirits_tracker", hCaster, 1)
					end

					Timers:CreateTimer(duration, function()
						stacks = v:GetModifierStackCount("modifier_spirits_tracker", hCaster)-1
						if stacks == 0 then
							print("remove modifier_spirits_tracker")
							v:RemoveModifierByName("modifier_spirits_tracker")
						else
							print("decrement modifier_spirits_tracker")
							v:SetModifierStackCount("modifier_spirits_tracker", hCaster, stacks)
						end
					end)

					i = stacks-1
					modded_damage = damage * multiplier^i
					print("damage: " .. damage)
					print("stacks: " .. stacks)
					print("multiplier: " .. multiplier)
					print("modded_damage: " .. modded_damage)

					local damageTable = {
						victim = v,
						attacker = hCaster,
						damage = damage * multiplier^i,
						damage_type = DAMAGE_TYPE_MAGICAL,
					}
					ApplyDamage(damageTable)
				end
			end
			------------------------------------------------------------------------------------------------------------------------------
			return 0.03
		else
			print("end projectile animation")
			thinker:SetAbsOrigin(vPoint:__add(Vector(0,0,-500), nil))
		end
	end)
end

function spirits3:OnUpgrade()
	hCaster = self:GetCaster()
	local spirits_ability = hCaster:FindAbilityByName("spirits")
	local spirits2_ability = hCaster:FindAbilityByName("spirits2")
	local spirits3_level = self:GetLevel()
	
	if spirits_ability ~= nil and spirits_ability:GetLevel() ~= spirits3_level then
		spirits_ability:SetLevel(spirits3_level)
	end

	if spirits2_ability ~= nil and spirits2_ability:GetLevel() ~= spirits3_level then
		spirits2_ability:SetLevel(spirits3_level)
	end
end