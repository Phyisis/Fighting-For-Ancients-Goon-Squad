modifier_misanthrope_lua = class({})


function modifier_misanthrope_lua:OnCreated()
	if IsServer() then
		print("CREATED")
	end
end

function modifier_misanthrope_lua:OnDeath(params)

	if IsServer() then

		target = params.unit
		caster = self:GetParent()
		player = PlayerResource:GetPlayer(caster:GetPlayerID())

		killer_index = caster:entindex()
		killed_by = params.attacker

		if params.attacker == self:GetParent() and params.attacker:GetTeam() ~= params.unit:GetTeam() and not params.unit:IsIllusion() then

			distance_closest = 15000

			local units = FindUnitsInRadius(
				caster:GetTeam(), 
				caster:GetAbsOrigin(),
				nil,
				999999,
				DOTA_UNIT_TARGET_TEAM_FRIENDLY,
				DOTA_UNIT_TARGET_HERO,
				DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS,
				0,
				false
			)

			for i, unit in pairs(units) do
				if unit:GetName() ~= caster:GetName() then
					local distance = math.floor(CalcDistanceBetweenEntityOBB(caster, unit))
					if distance < distance_closest then
						distance_closest = distance
					end
				end
			end

			print("closest distance: " .. distance_closest)

			distance_level = self:GetAbility():GetSpecialValueFor("distance")
			gold_multiplier = self:GetAbility():GetSpecialValueFor("gold_multiplier")

			print("distance calc: " .. math.floor(distance_closest / distance_level))
			print("gold level: " .. gold_multiplier)

			bonus = math.floor((distance_closest / distance_level) * gold_multiplier)

			print("bonus gold: " .. bonus)

			PlayerResource:ModifyGold(caster:GetPlayerID(), bonus, false, 0)


			-- Show the particles, player only
			local particleName = "particles/units/heroes/hero_alchemist/alchemist_lasthit_coins.vpcf"		
			local particle = ParticleManager:CreateParticleForPlayer( particleName, PATTACH_ABSORIGIN, target, player )
			ParticleManager:SetParticleControl( particle, 0, target:GetAbsOrigin() )
			ParticleManager:SetParticleControl( particle, 1, target:GetAbsOrigin() )

			local symbol = 0 -- "+" presymbol
			local color = Vector(255, 200, 33) -- Gold
			local lifetime = 2
			local digits = string.len(bonus) + 1
			local particleName = "particles/units/heroes/hero_alchemist/alchemist_lasthit_msg_gold.vpcf"
			local particle = ParticleManager:CreateParticleForPlayer( particleName, PATTACH_ABSORIGIN, target, player )
			ParticleManager:SetParticleControl(particle, 1, Vector(symbol, bonus, symbol))
		    ParticleManager:SetParticleControl(particle, 2, Vector(lifetime, digits, 0))
		    ParticleManager:SetParticleControl(particle, 3, color)

		end

	end

end


function modifier_misanthrope_lua:DeclareFunctions()
	
	local funcs = {
		MODIFIER_EVENT_ON_DEATH
	}

	return funcs
end