modifier_misanthrope = class({})

function modifier_misanthrope:DeclareFunctions()
	
	local funcs = {
		MODIFIER_EVENT_ON_DEATH,
	}

	return funcs
end

function modifier_misanthrope:OnCreated()
	if IsServer() then
		print("CREATED")
	end
end

function modifier_misanthrope:IsPurgable()
	return false
end

function modifier_misanthrope:OnDeath(params)
	print("death")

	if IsServer() then
		
		hero = self:GetParent()
		target = params.unit
		caster = self:GetParent()
		player = PlayerResource:GetPlayer(caster:GetPlayerID())
		ability = self:GetAbility()
		distrad = Vector(-9000,-9000,520):__sub(hero:GetAbsOrigin())
		distdire = Vector(8350,8350,520):__sub(hero:GetAbsOrigin())
		--print(distrad:Length2D())
		--print(distdire:Length2D())
		
		killer_index = caster:entindex()
		killed_by = params.attacker

		if params.attacker == hero and params.attacker:GetTeam() ~= params.unit:GetTeam() and not params.unit:IsIllusion() and not params.unit:IsHero() then
			gold_multiplier = self:GetAbility():GetSpecialValueFor("gold_multiplier")
			
			if caster:GetTeam() == DOTA_TEAM_GOODGUYS then 
				x = distrad:Length2D()
			else
				x = distdire:Length2D()
			end
			
			print(x)

			-- Vector 0000000000174650 [-6755.618164 -6503.004883 512.000000] radiant
			-- Vector 00000000001BE060 [7034.102051 6459.533203 520.000000] dire


			-- ((10 + (skill lvl * 10)) * (arctan((x-12000)/5000)+1)) + 100 
			bonus = target:GetMaximumGoldBounty() * (((10+(ability:GetLevel())*gold_multiplier)*(math.atan((x-12730)/5000)+1)))/100
			bonus = math.floor(bonus)
			--bonus = 10

			PlayerResource:ModifyGold(caster:GetPlayerID(), bonus, false, 0)
			print("bonus: " .. bonus)


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